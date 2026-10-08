import 'package:flutter/material.dart';
import '../services/score_storage.dart';

class RecordePage extends StatefulWidget {
  const RecordePage({super.key});

  @override
  State<RecordePage> createState() => _RecordePageState();
}

class _RecordePageState extends State<RecordePage> {
  List<Map<String, dynamic>> ranking = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarRanking();
  }

  Future<void> carregarRanking() async {
    final dados = await ScoreStorage.carregarRanking();

    if (!mounted) return;

    setState(() {
      ranking = dados;
      carregando = false;
    });
  }

  Color corPosicao(int posicao) {
    switch (posicao) {
      case 1:
        return const Color(0xFFF59E0B);
      case 2:
        return const Color(0xFF94A3B8);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return const Color(0xFF7C3AED);
    }
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
          'Recordes',
          style: TextStyle(
            color: Color(0xFFF8FAFC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: carregando
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF22D3EE),
              ),
            )
          : ranking.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum recorde registrado ainda.',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text(
                      'TOP 5 JOGADORES',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF22D3EE),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (int i = 0; i < ranking.length; i++)
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF151D33),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF334155),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: corPosicao(i + 1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${i + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ranking[i]['nome']?.toString() ??
                                        'Jogador',
                                    style: const TextStyle(
                                      color: Color(0xFFF8FAFC),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Posição ${i + 1}',
                                    style: const TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'PONTOS',
                                  style: TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${ranking[i]['pontuacao'] ?? 0}',
                                  style: const TextStyle(
                                    color: Color(0xFF22D3EE),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
    );
  }
}