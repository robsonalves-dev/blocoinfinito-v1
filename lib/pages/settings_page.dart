
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool somAtivado = true;
  bool efeitosAtivados = true;
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      somAtivado = prefs.getBool('som_ativado') ?? true;
      efeitosAtivados =
          prefs.getBool('efeitos_ativados') ?? true;
      carregando = false;
    });
  }

  Future<void> _alterarSom(bool valor) async {
    setState(() {
      somAtivado = valor;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('som_ativado', valor);
  }

  Future<void> _alterarEfeitos(bool valor) async {
    setState(() {
      efeitosAtivados = valor;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('efeitos_ativados', valor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1020),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color(0xFFF8FAFC),
        ),
        title: const Text(
          'Configurações',
          style: TextStyle(
            color: Color(0xFFF8FAFC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: carregando
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF7C3AED),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Áudio',
                  style: TextStyle(
                    color: Color(0xFFF8FAFC),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                SwitchListTile(
                  value: somAtivado,
                  onChanged: _alterarSom,
                  title: const Text(
                    'Som',
                    style: TextStyle(
                      color: Color(0xFFF8FAFC),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: const Text(
                    'Ativar música de fundo durante as partidas',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  secondary: const Icon(
                    Icons.music_note,
                    color: Color(0xFF22D3EE),
                  ),
                  activeThumbColor: const Color(0xFF7C3AED),
                ),

                const Divider(
                  color: Color(0xFF151D33),
                ),

                SwitchListTile(
                  value: efeitosAtivados,
                  onChanged: _alterarEfeitos,
                  title: const Text(
                    'Efeitos sonoros',
                    style: TextStyle(
                      color: Color(0xFFF8FAFC),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: const Text(
                    'Ativar sons de encaixe, eliminação e combos',
                    style: TextStyle(
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  secondary: const Icon(
                    Icons.volume_up,
                    color: Color(0xFF22D3EE),
                  ),
                  activeThumbColor: const Color(0xFF7C3AED),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Suas preferências são salvas automaticamente neste dispositivo.',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
    );
  }
}
