import 'package:flutter/material.dart';
import 'pages/game_page.dart';
import 'pages/recorde_page.dart';
import 'pages/settings_page.dart';
import 'services/player_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) { await MobileAds.instance.initialize(); }
  runApp(const BlocoInfinitoApp());
}

class BlocoInfinitoApp extends StatelessWidget {
  const BlocoInfinitoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bloco Infinito',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFF0B1020),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.dark,
        ),
      ),
      home: const TelaInicial(),
    );
  }
}

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  String nomeJogador = 'Jogador';

  @override
  void initState() {
    super.initState();
    carregarNome();
  }

  Future<void> carregarNome() async {
    final nome = await PlayerStorage.carregarNome();

    if (!mounted) return;

    setState(() {
      if (nome != null && nome.trim().isNotEmpty) {
        nomeJogador = nome.trim();
      }
    });
  }

  void abrirTela(BuildContext context, Widget tela) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => tela),
    );
  }

  Future<void> trocarNome() async {
    final controladorNome = TextEditingController(
      text: nomeJogador == 'Jogador' ? '' : nomeJogador,
    );

    final nome = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151D33),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Trocar nome',
            style: TextStyle(
              color: Color(0xFFF8FAFC),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: controladorNome,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(
              color: Color(0xFFF8FAFC),
            ),
            decoration: InputDecoration(
              hintText: 'Digite seu nome',
              hintStyle: const TextStyle(
                color: Color(0xFF94A3B8),
              ),
              filled: true,
              fillColor: const Color(0xFF0B1020),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'CANCELAR',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final nomeDigitado =
                    controladorNome.text.trim();

                if (nomeDigitado.isEmpty) {
                  return;
                }

                Navigator.of(context).pop(nomeDigitado);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
              ),
              child: const Text('SALVAR'),
            ),
          ],
        );
      },
    );

    controladorNome.dispose();

    if (!mounted) return;

    if (nome == null || nome.trim().isEmpty) {
      return;
    }

    await PlayerStorage.salvarNome(nome.trim());

    if (!mounted) return;

    setState(() {
      nomeJogador = nome.trim();
    });
  }

  Future<void> iniciarJogo(BuildContext context) async {
    final nomeSalvo = await PlayerStorage.carregarNome();

    if (!context.mounted) return;

    if (nomeSalvo != null && nomeSalvo.trim().isNotEmpty) {
      abrirTela(context, const GamePage());
      return;
    }

    final controladorNome = TextEditingController();

    final nome = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF151D33),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Quem está jogando?',
            style: TextStyle(
              color: Color(0xFFF8FAFC),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: controladorNome,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(
              color: Color(0xFFF8FAFC),
            ),
            decoration: InputDecoration(
              hintText: 'Digite seu nome',
              hintStyle: const TextStyle(
                color: Color(0xFF94A3B8),
              ),
              filled: true,
              fillColor: const Color(0xFF0B1020),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'CANCELAR',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final nomeDigitado =
                    controladorNome.text.trim();

                if (nomeDigitado.isEmpty) {
                  return;
                }

                Navigator.of(context).pop(nomeDigitado);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
              ),
              child: const Text('CONTINUAR'),
            ),
          ],
        );
      },
    );

    controladorNome.dispose();

    if (!context.mounted) return;

    if (nome == null || nome.trim().isEmpty) {
      return;
    }

    await PlayerStorage.salvarNome(nome.trim());

    if (!context.mounted) return;

    abrirTela(context, const GamePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'BLOCO INFINITO',
                  style: TextStyle(
                    color: Color(0xFFF8FAFC),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                const Text(
                  'Jogue e tente bater seu recorde!',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 28),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151D33),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF334155),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Color(0xFF22D3EE),
                        size: 28,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'JOGADOR',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              nomeJogador,
                              style: const TextStyle(
                                color: Color(0xFFF8FAFC),
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      TextButton(
                        onPressed: trocarNome,
                        child: const Text(
                          'TROCAR NOME',
                          style: TextStyle(
                            color: Color(0xFF22D3EE),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      iniciarJogo(context);
                    },
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
                      'JOGAR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      abrirTela(
                        context,
                        const RecordePage(),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          const Color(0xFF22D3EE),
                      side: const BorderSide(
                        color: Color(0xFF22D3EE),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'RECORDE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {
                      abrirTela(
                        context,
                        const SettingsPage(),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          const Color(0xFFF8FAFC),
                      side: const BorderSide(
                        color: Color(0xFF334155),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'CONFIGURAÇÕES',
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
      ),
    );
  }
}