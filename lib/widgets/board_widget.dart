import 'package:flutter/material.dart';

class BoardWidget extends StatefulWidget {
  final void Function(int pontos, int indice)? onPecaColocada;

  const BoardWidget({
    super.key,
    this.onPecaColocada,
  });

  @override
  BoardWidgetState createState() => BoardWidgetState();
}

class BoardWidgetState extends State<BoardWidget> {
  static const int linhas = 10;
  static const int colunas = 10;

  final List<List<Color?>> tabuleiro = List.generate(
    linhas,
    (_) => List.generate(colunas, (_) => null),
  );

  void limparTabuleiro() {
    setState(() {
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
          tabuleiro[destino][coluna] = tabuleiro[linha][coluna];

          if (destino != linha) {
            tabuleiro[linha][coluna] = null;
          }

          destino--;
        }
      }
    }
  }

  int _limparLinhasEColunasCompletas() {
    int totalCompletas = 0;

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

      for (final celula in celulasParaLimpar) {
        final partes = celula.split('-');
        final i = int.parse(partes[0]);
        final j = int.parse(partes[1]);

        tabuleiro[i][j] = null;
      }

      fazerBlocosCairem();
    }

    return totalCompletas;
  }

  bool _posicaoValida(
    int linha,
    int coluna,
    List<List<bool>> forma,
  ) {
    final altura = forma.length;
    final largura = forma.isNotEmpty ? forma.first.length : 0;

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
    final largura = forma.isNotEmpty ? forma.first.length : 0;

    if (altura == 0 || largura == 0) {
      return false;
    }

    for (int linha = 0; linha <= linhas - altura; linha++) {
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
    final largura = forma.isNotEmpty ? forma.first.length : 0;

    if (altura == 0 || largura == 0) {
      return null;
    }

    // Mantém o ponto escolhido pelo jogador como referência.
    int linhaBase = linha;
    int colunaBase = coluna;

    // Ajusta apenas quando a peça ultrapassa o tabuleiro.
    linhaBase = linhaBase.clamp(0, linhas - altura);
    colunaBase = colunaBase.clamp(0, colunas - largura);

    // Primeiro: tenta exatamente o ponto escolhido.
    if (_posicaoValida(linhaBase, colunaBase, forma)) {
      return (
        linha: linhaBase,
        coluna: colunaBase,
      );
    }

    // Procura a posição válida mais próxima.
    ({int linha, int coluna})? melhor;
    int menorDistancia = 3;

    for (int i = 0; i <= linhas - altura; i++) {
      for (int j = 0; j <= colunas - largura; j++) {
        if (!_posicaoValida(i, j, forma)) {
          continue;
        }

        final distancia =
            (i - linhaBase).abs() + (j - colunaBase).abs();

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

  void colocarPeca(
    int linha,
    int coluna,
    List<List<bool>> forma,
    Color cor,
    int indice,
  ) {
    final posicao = _encontrarMelhorPosicao(
      linha,
      coluna,
      forma,
    );

    if (posicao == null) {
      return;
    }

    final linhaAjustada = posicao.linha;
    final colunaAjustada = posicao.coluna;

    final altura = forma.length;
    final largura =
        forma.isNotEmpty ? forma.first.length : 0;

    if (altura == 0 || largura == 0) {
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

    int linhasCompletas = 0;

    setState(() {
      for (int i = 0; i < altura; i++) {
        for (int j = 0; j < largura; j++) {
          if (forma[i][j]) {
            tabuleiro[
                linhaAjustada + i][colunaAjustada + j] = cor;
          }
        }
      }

      linhasCompletas =
          _limparLinhasEColunasCompletas();
    });

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

    widget.onPecaColocada?.call(
      pontosDosBlocos + pontosDasLinhas,
      indice,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF151D33),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF334155),
            width: 1,
          ),
        ),
        child: GridView.builder(
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

            return DragTarget<
                Map<String, dynamic>>(
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
                return Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: tabuleiro[linha][coluna] ??
                        const Color(0xFF0B1020),
                    borderRadius:
                        BorderRadius.circular(4),
                    border: Border.all(
                      color: candidateData.isNotEmpty
                          ? const Color(0xFF22D3EE)
                          : const Color(0xFF1E293B),
                      width: 1,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}