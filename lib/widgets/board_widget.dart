
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../core/game_theme.dart';
import '../services/audio_service.dart';

class BoardWidget extends StatefulWidget {
  final void Function(int pontos, int indice)? onPecaColocada;
  final GameTheme tema;

  const BoardWidget({
    super.key,
    this.onPecaColocada,
    required this.tema,
  });

  @override
  BoardWidgetState createState() => BoardWidgetState();
}

class BoardWidgetState extends State<BoardWidget>
    with SingleTickerProviderStateMixin {
  static const int linhas = 10;
  static const int colunas = 10;

  static const Duration duracaoEfeito =
      Duration(milliseconds: 320);

  int comboConsecutivo = 0;
  bool efeitoEliminacaoAtivo = false;
  final Set<String> celulasEmAnimacao = {};

  bool jogadaEmAndamento = false;
  int versaoPartida = 0;

  late final AnimationController _controladorEfeito;

  int _intensidadeEfeito = 1;
  int _sequenciaEfeito = 0;

  final List<List<Color?>> tabuleiro = List.generate(
    linhas,
    (_) => List.generate(colunas, (_) => null),
  );

  @override
  void initState() {
    super.initState();

    _controladorEfeito = AnimationController(
      vsync: this,
      duration: duracaoEfeito,
    );

    // Prepara os efeitos antes da primeira jogada.
    unawaited(AudioService.instance.inicializar());
  }

  @override
  void dispose() {
    _controladorEfeito.dispose();
    super.dispose();
  }

  // Mantido para compatibilidade com possíveis chamadas externas.
  void ativarEfeitoEliminacao() {
    if (!mounted) return;

    _intensidadeEfeito =
        (comboConsecutivo + 1).clamp(1, 3);

    _sequenciaEfeito++;

    setState(() {
      efeitoEliminacaoAtivo = true;
    });

    _controladorEfeito.forward(from: 0).then((_) {
      if (!mounted) return;

      setState(() {
        efeitoEliminacaoAtivo = false;
      });
    });
  }

  void limparTabuleiro() {
    _controladorEfeito.stop();
    _controladorEfeito.reset();

    setState(() {
      comboConsecutivo = 0;
      efeitoEliminacaoAtivo = false;
      celulasEmAnimacao.clear();
      jogadaEmAndamento = false;
      versaoPartida++;
      _intensidadeEfeito = 1;

      for (int i = 0; i < linhas; i++) {
        for (int j = 0; j < colunas; j++) {
          tabuleiro[i][j] = null;
        }
      }
    });
  }

  void fazerBlocosCairem() {
    for (int coluna = 0; coluna < colunas; coluna++) {
      int destino = linhas - 1;

      for (int linha = linhas - 1; linha >= 0; linha--) {
        if (tabuleiro[linha][coluna] != null) {
          tabuleiro[destino][coluna] =
              tabuleiro[linha][coluna];

          if (destino != linha) {
            tabuleiro[linha][coluna] = null;
          }

          destino--;
        }
      }
    }
  }

  Future<int> _limparLinhasEColunasCompletas() async {
    int totalCompletas = 0;
    final partidaAtual = versaoPartida;

    while (true) {
      final Set<String> celulasParaLimpar = {};

      for (int i = 0; i < linhas; i++) {
        bool completa = true;

        for (int j = 0; j < colunas; j++) {
          if (tabuleiro[i][j] == null) {
            completa = false;
            break;
          }
        }

        if (completa) {
          totalCompletas++;

          for (int j = 0; j < colunas; j++) {
            celulasParaLimpar.add('$i-$j');
          }
        }
      }

      for (int j = 0; j < colunas; j++) {
        bool completa = true;

        for (int i = 0; i < linhas; i++) {
          if (tabuleiro[i][j] == null) {
            completa = false;
            break;
          }
        }

        if (completa) {
          totalCompletas++;

          for (int i = 0; i < linhas; i++) {
            celulasParaLimpar.add('$i-$j');
          }
        }
      }

      if (celulasParaLimpar.isEmpty) {
        break;
      }

      // O combo da jogada atual é considerado antes
      // da animação, para sincronizar sua intensidade.
      _intensidadeEfeito =
          (comboConsecutivo + 1).clamp(1, 3);

      _sequenciaEfeito++;

      // Toca junto dos raios, sem atrasar a animação.
      unawaited(AudioService.instance.tocarEliminacao());

      if (comboConsecutivo >= 1) {
        unawaited(AudioService.instance.tocarCombo());
      }

      setState(() {
        celulasEmAnimacao
          ..clear()
          ..addAll(celulasParaLimpar);

        efeitoEliminacaoAtivo = true;
      });

      // Raios, brilho e partículas aparecem enquanto
      // os blocos ainda estão visíveis.
      await _controladorEfeito.forward(from: 0);

      if (!mounted || partidaAtual != versaoPartida) {
        return 0;
      }

      setState(() {
        for (final celula in celulasParaLimpar) {
          final partes = celula.split('-');
          final i = int.parse(partes[0]);
          final j = int.parse(partes[1]);

          tabuleiro[i][j] = null;
        }

        celulasEmAnimacao.clear();
        efeitoEliminacaoAtivo = false;

        fazerBlocosCairem();
      });
    }

    return totalCompletas;
  }

  bool _posicaoValida(
    int linha,
    int coluna,
    List<List<bool>> forma,
  ) {
    final altura = forma.length;
    final largura =
        forma.isNotEmpty ? forma.first.length : 0;

    if (altura == 0 || largura == 0) {
      return false;
    }

    if (linha < 0 ||
        coluna < 0 ||
        linha + altura > linhas ||
        coluna + largura > colunas) {
      return false;
    }

    for (int i = 0; i < altura; i++) {
      for (int j = 0; j < largura; j++) {
        if (forma[i][j] &&
            tabuleiro[linha + i][coluna + j] != null) {
          return false;
        }
      }
    }

    return true;
  }

  bool podeColocarPeca(List<List<bool>> forma) {
    final altura = forma.length;
    final largura =
        forma.isNotEmpty ? forma.first.length : 0;

    if (altura == 0 || largura == 0) {
      return false;
    }

    for (int linha = 0;
        linha <= linhas - altura;
        linha++) {
      for (int coluna = 0;
          coluna <= colunas - largura;
          coluna++) {
        if (_posicaoValida(linha, coluna, forma)) {
          return true;
        }
      }
    }

    return false;
  }

  ({int linha, int coluna})? _encontrarMelhorPosicao(
    int linha,
    int coluna,
    List<List<bool>> forma,
  ) {
    final altura = forma.length;
    final largura =
        forma.isNotEmpty ? forma.first.length : 0;

    if (altura == 0 || largura == 0) {
      return null;
    }

    int linhaBase = linha;
    int colunaBase = coluna;

    linhaBase = linhaBase.clamp(0, linhas - altura);
    colunaBase = colunaBase.clamp(0, colunas - largura);

    if (_posicaoValida(
      linhaBase,
      colunaBase,
      forma,
    )) {
      return (
        linha: linhaBase,
        coluna: colunaBase,
      );
    }

    ({int linha, int coluna})? melhor;
    int menorDistancia = 3;

    for (int i = 0; i <= linhas - altura; i++) {
      for (int j = 0; j <= colunas - largura; j++) {
        if (!_posicaoValida(i, j, forma)) {
          continue;
        }

        final distancia =
            (i - linhaBase).abs() +
            (j - colunaBase).abs();

        if (distancia < menorDistancia) {
          menorDistancia = distancia;

          melhor = (
            linha: i,
            coluna: j,
          );
        }
      }
    }

    return melhor;
  }

  Future<void> colocarPeca(
    int linha,
    int coluna,
    List<List<bool>> forma,
    Color cor,
    int indice,
  ) async {
    if (jogadaEmAndamento) return;

    final posicao = _encontrarMelhorPosicao(
      linha,
      coluna,
      forma,
    );

    if (posicao == null) {
      return;
    }

    jogadaEmAndamento = true;

    final versaoJogada = versaoPartida;
    final linhaAjustada = posicao.linha;
    final colunaAjustada = posicao.coluna;

    final altura = forma.length;
    final largura =
        forma.isNotEmpty ? forma.first.length : 0;

    if (altura == 0 || largura == 0) {
      jogadaEmAndamento = false;
      return;
    }

    int blocosColocados = 0;

    for (final linhaForma in forma) {
      for (final ocupada in linhaForma) {
        if (ocupada) {
          blocosColocados++;
        }
      }
    }

    setState(() {
      for (int i = 0; i < altura; i++) {
        for (int j = 0; j < largura; j++) {
          if (forma[i][j]) {
            tabuleiro[
              linhaAjustada + i
            ][colunaAjustada + j] = cor;
          }
        }
      }
    });

    // Som imediato após um encaixe válido.
    unawaited(AudioService.instance.tocarEncaixe());

    final linhasCompletas =
        await _limparLinhasEColunasCompletas();

    if (!mounted || versaoJogada != versaoPartida) {
      return;
    }

    if (linhasCompletas > 0) {
      comboConsecutivo++;
    } else {
      comboConsecutivo = 0;
    }

    final pontosDosBlocos = blocosColocados * 10;

    int pontosDasLinhas = 0;

    if (linhasCompletas == 1) {
      pontosDasLinhas = 100;
    } else if (linhasCompletas == 2) {
      pontosDasLinhas = 250;
    } else if (linhasCompletas == 3) {
      pontosDasLinhas = 450;
    } else if (linhasCompletas > 3) {
      pontosDasLinhas = linhasCompletas * 150;
    }

    final int bonusCombo = comboConsecutivo >= 2
        ? (comboConsecutivo - 1) * 50
        : 0;

    widget.onPecaColocada?.call(
      pontosDosBlocos +
          pontosDasLinhas +
          bonusCombo,
      indice,
    );

    jogadaEmAndamento = false;
  }

  @override
  Widget build(BuildContext context) {
    final tema = widget.tema;

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controladorEfeito,
              builder: (context, child) {
                final progresso = _controladorEfeito.value;

                final pulso = efeitoEliminacaoAtivo
                    ? math.sin(progresso * math.pi)
                    : 0.0;

                return AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 800,
                  ),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: tema.tabuleiro,
                    borderRadius:
                        BorderRadius.circular(16),
                    border: Border.all(
                      color: Color.lerp(
                        tema.borda,
                        tema.destaque,
                        pulso,
                      )!,
                      width: 1 + pulso * 2,
                    ),
                    boxShadow: pulso > 0
                        ? [
                            BoxShadow(
                              color: tema.destaque
                                  .withValues(
                                    alpha: 0.35 * pulso,
                                  ),
                              blurRadius: 8 + 12 * pulso,
                              spreadRadius: 2 * pulso,
                            ),
                          ]
                        : [],
                  ),
                  child: child,
                );
              },
              child: GridView.builder(
                padding: EdgeInsets.zero,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: linhas * colunas,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: colunas,
                ),
                itemBuilder: (context, index) {
                  final linha = index ~/ colunas;
                  final coluna = index % colunas;

                  return DragTarget<Map<String, dynamic>>(
                    onAcceptWithDetails: (details) {
                      colocarPeca(
                        linha,
                        coluna,
                        details.data['forma'],
                        details.data['cor'],
                        details.data['indice'],
                      );
                    },
                    builder: (
                      context,
                      candidateData,
                      rejectedData,
                    ) {
                      final estaEliminando =
                          celulasEmAnimacao.contains(
                        '$linha-$coluna',
                      );

                      final corOriginal =
                          tabuleiro[linha][coluna];

                      final corCelula = corOriginal ??
                          tema.celulaVazia;

                      return AnimatedContainer(
                        duration: Duration(
                          milliseconds:
                              estaEliminando ? 100 : 800,
                        ),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: corCelula,
                          borderRadius:
                              BorderRadius.circular(4),
                          border: Border.all(
                            color: candidateData.isNotEmpty
                                ? tema.destaque
                                : tema.borda.withValues(
                                    alpha: 0.25,
                                  ),
                            width: 1,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Os efeitos são desenhados acima do tabuleiro,
          // mas não interceptam os gestos do jogador.
          if (efeitoEliminacaoAtivo &&
              celulasEmAnimacao.isNotEmpty)
            Positioned.fill(
              child: IgnorePointer(
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _controladorEfeito,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: EfeitosEliminacaoPainter(
                          cor: tema.destaque,
                          progresso:
                              _controladorEfeito.value,
                          intensidade: _intensidadeEfeito,
                          sequencia: _sequenciaEfeito,
                          celulas: celulasEmAnimacao,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class EfeitosEliminacaoPainter extends CustomPainter {
  final Color cor;
  final double progresso;
  final int intensidade;
  final int sequencia;
  final Set<String> celulas;

  const EfeitosEliminacaoPainter({
    required this.cor,
    required this.progresso,
    required this.intensidade,
    required this.sequencia,
    required this.celulas,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (celulas.isEmpty) return;

    final larguraCelula = size.width / 10;
    final alturaCelula = size.height / 10;

    final fade = (1 - progresso).clamp(0.0, 1.0);
    final pulso = math.sin(progresso * math.pi);

    final random = math.Random(sequencia * 37 + 42);

    final centros = <Offset>[];

    // Brilho localizado nas células eliminadas.
    for (final celula in celulas) {
      final partes = celula.split('-');

      if (partes.length != 2) continue;

      final linha = int.tryParse(partes[0]);
      final coluna = int.tryParse(partes[1]);

      if (linha == null || coluna == null) continue;

      final centro = Offset(
        (coluna + 0.5) * larguraCelula,
        (linha + 0.5) * alturaCelula,
      );

      centros.add(centro);

      final retangulo = Rect.fromCenter(
        center: centro,
        width: larguraCelula * 0.82,
        height: alturaCelula * 0.82,
      );

      final brilho = Paint()
        ..color = cor.withValues(
          alpha: (0.28 * pulso).clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.fill;

      final contorno = Paint()
        ..color = Colors.white.withValues(
          alpha: (0.85 * pulso).clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          retangulo,
          const Radius.circular(4),
        ),
        brilho,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          retangulo,
          const Radius.circular(4),
        ),
        contorno,
      );
    }

    if (centros.isEmpty) return;

    // Partículas leves e limitadas para não sobrecarregar
    // dispositivos Android.
    final quantidadeParticulas =
        math.min(centros.length * (intensidade + 1), 90);

    for (int i = 0; i < quantidadeParticulas; i++) {
      final origem = centros[random.nextInt(centros.length)];

      final angulo = random.nextDouble() * math.pi * 2;
      final distancia =
          (8 + random.nextDouble() * 24) *
          progresso *
          (0.8 + intensidade * 0.2);

      final posicao = Offset(
        origem.dx + math.cos(angulo) * distancia,
        origem.dy + math.sin(angulo) * distancia,
      );

      final raio = 0.8 + random.nextDouble() * 1.8;

      final pincel = Paint()
        ..color = (i % 4 == 0 ? Colors.white : cor)
            .withValues(alpha: 0.85 * fade);

      canvas.drawCircle(
        posicao,
        raio * (0.5 + fade * 0.5),
        pincel,
      );
    }

    // Raios pequenos próximos às células eliminadas,
    // evitando cobrir todo o tabuleiro.
    final quantidadeRaios = math.min(
      2 + intensidade * 2,
      centros.length,
    );

    for (int i = 0; i < quantidadeRaios; i++) {
      final origem =
          centros[random.nextInt(centros.length)];

      final angulo = random.nextDouble() * math.pi * 2;
      final comprimento =
          larguraCelula * (0.8 + intensidade * 0.35);

      final caminho = Path()..moveTo(origem.dx, origem.dy);

      const segmentos = 4;

      for (int s = 1; s <= segmentos; s++) {
        final distancia =
            comprimento * s / segmentos;

        final desvio =
            (random.nextDouble() - 0.5) * 12;

        final x = origem.dx +
            math.cos(angulo) * distancia +
            math.cos(angulo + math.pi / 2) * desvio;

        final y = origem.dy +
            math.sin(angulo) * distancia +
            math.sin(angulo + math.pi / 2) * desvio;

        caminho.lineTo(x, y);
      }

      final brilhoRaio = Paint()
        ..color = cor.withValues(alpha: 0.25 * fade)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final raioPrincipal = Paint()
        ..color = Colors.white.withValues(
          alpha: 0.85 * fade,
        )
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawPath(caminho, brilhoRaio);
      canvas.drawPath(caminho, raioPrincipal);
    }
  }

  @override
  bool shouldRepaint(
    covariant EfeitosEliminacaoPainter oldDelegate,
  ) {
    return oldDelegate.progresso != progresso ||
        oldDelegate.cor != cor ||
        oldDelegate.intensidade != intensidade ||
        oldDelegate.sequencia != sequencia ||
        oldDelegate.celulas != celulas;
  }
}

// Mantido para compatibilidade com o código anterior.
class RaioEletricoPainter extends CustomPainter {
  final Color cor;

  const RaioEletricoPainter({
    required this.cor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42);

    final pincel = Paint()
      ..color = cor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int raio = 0; raio < 4; raio++) {
      final caminho = Path();

      final inicioX = size.width * (0.2 + raio * 0.2);

      caminho.moveTo(inicioX, 0);

      for (double y = 12; y < size.height; y += 12) {
        final deslocamento =
            random.nextDouble() * 24 - 12;

        caminho.lineTo(
          inicioX + deslocamento,
          y,
        );
      }

      canvas.drawPath(caminho, pincel);
    }
  }

  @override
  bool shouldRepaint(
    covariant RaioEletricoPainter oldDelegate,
  ) {
    return oldDelegate.cor != cor;
  }
}
