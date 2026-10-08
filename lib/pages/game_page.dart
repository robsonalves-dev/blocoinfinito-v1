import 'package:flutter/material.dart';
import '../core/piece_shapes.dart';
import '../core/score_manager.dart';
import '../services/player_storage.dart';
import '../services/score_storage.dart';
import '../widgets/board_widget.dart';
import '../widgets/piece_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final ScoreManager scoreManager = ScoreManager();

  final GlobalKey<BoardWidgetState> boardKey =
      GlobalKey<BoardWidgetState>();

  late List<List<List<bool>>> pecasDisponiveis;
  late List<bool> pecasUsadas;

  String nomeJogador = 'Jogador';

  bool gameOverDetectado = false;
  int partidasConcluidas = 0;
  InterstitialAd? interstitialAd;

  void carregarAnuncio() {
  InterstitialAd.load(
    adUnitId: 'ca-app-pub-7540081483916932/6335934865',
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) {
        interstitialAd = ad;
      },
      onAdFailedToLoad: (error) {
        interstitialAd = null;
      },
    ),
  );
}

void mostrarAnuncio() {
  if (interstitialAd != null) {
    interstitialAd!.show();
    interstitialAd = null;
  }
}

  final List<Color> cores = const [
    Color(0xFF7C3AED),
    Color(0xFF22D3EE),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFFEF4444),
    Color(0xFFEC4899),
  ];

  @override
  void initState() {
    super.initState();

    gerarNovasPecas();
    carregarNomeJogador();
    carregarAnuncio();
  }

  Future<void> carregarNomeJogador() async {
    final nome = await PlayerStorage.carregarNome();

    if (!mounted) return;

    setState(() {
      if (nome != null && nome.trim().isNotEmpty) {
        nomeJogador = nome.trim();
      }
    });
  }

  void gerarNovasPecas() {
    pecasDisponiveis = List.generate(
      3,
      (_) => PieceShapes.gerarFormaAleatoria(),
    );

    pecasUsadas = [false, false, false];
  }

  bool verificarGameOver() {
    final board = boardKey.currentState;

    if (board == null) {
      return false;
    }

    for (int i = 0; i < pecasDisponiveis.length; i++) {
      if (pecasUsadas[i]) {
        continue;
      }

      final podeEncaixar = board.podeColocarPeca(
        pecasDisponiveis[i],
      );

      if (podeEncaixar) {
        return false;
      }
    }

    return true;
  }

  Future<void> salvarPontuacaoNoRanking() async {
    await ScoreStorage.adicionarPontuacao(
      nomeJogador,
      scoreManager.pontuacao,
    );
  }

  Future<void> mostrarGameOver() async {
    if (!mounted || gameOverDetectado) {
      return;
    }

    partidasConcluidas++;

    if (partidasConcluidas % 2 == 0) {
  mostrarAnuncio();
}

    setState(() {
      gameOverDetectado = true;
    });

    await salvarPontuacaoNoRanking();

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151D33),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Center(
            child: Text(
              'GAME OVER',
              style: TextStyle(
                color: Color(0xFFF8FAFC),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                nomeJogador,
                style: const TextStyle(
                  color: Color(0xFF22D3EE),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Não há mais movimentos possíveis.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'SUA PONTUAÇÃO',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                '${scoreManager.pontuacao}',
                style: const TextStyle(
                  color: Color(0xFF22D3EE),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            20,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  novaPartida();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'NOVA PARTIDA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void verificarGameOverDepoisDaJogada() {
    final terminou = verificarGameOver();

    if (terminou) {
      mostrarGameOver();
    }
  }

  void quandoPecaForColocada(
    int pontos,
    int indice,
  ) {
    if (gameOverDetectado) {
      return;
    }

    setState(() {
      scoreManager.adicionarPontos(pontos);

      if (indice >= 0 && indice < pecasUsadas.length) {
        pecasUsadas[indice] = true;
      }

      if (pecasUsadas.every((usada) => usada)) {
        gerarNovasPecas();
      }
    });

    verificarGameOverDepoisDaJogada();
  }

  void novaPartida() {
    boardKey.currentState?.limparTabuleiro();

    setState(() {
      scoreManager.novaPartida();
      gameOverDetectado = false;
      gerarNovasPecas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1020),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Bloco Infinito',
          style: TextStyle(
            color: Color(0xFFF8FAFC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Jogador: $nomeJogador',
                style: const TextStyle(
                  color: Color(0xFF22D3EE),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'PONTOS: ${scoreManager.pontuacao}',
                style: const TextStyle(
                  color: Color(0xFFF8FAFC),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Center(
                  child: BoardWidget(
                    key: boardKey,
                    onPecaColocada:
                        quandoPecaForColocada,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Escolha uma peça para começar',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  for (
                    int i = 0;
                    i < pecasDisponiveis.length;
                    i++
                  )
                    if (!pecasUsadas[i])
                      PieceWidget(
                        forma: pecasDisponiveis[i],
                        cor: cores[i % cores.length],
                        indice: i,
                      ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: novaPartida,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF7C3AED),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'NOVA PARTIDA',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}