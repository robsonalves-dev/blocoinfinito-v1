import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool somAtivado = true;
  bool efeitosAtivados = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1020),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1020),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Configurações',
          style: TextStyle(
            color: Color(0xFFF8FAFC),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchListTile(
            value: somAtivado,
            onChanged: (valor) {
              setState(() {
                somAtivado = valor;
              });
            },
            title: const Text(
              'Som',
              style: TextStyle(
                color: Color(0xFFF8FAFC),
              ),
            ),
            subtitle: const Text(
              'Ativar sons do jogo',
              style: TextStyle(
                color: Color(0xFF94A3B8),
              ),
            ),
            activeThumbColor: const Color(0xFF7C3AED),
          ),

          SwitchListTile(
            value: efeitosAtivados,
            onChanged: (valor) {
              setState(() {
                efeitosAtivados = valor;
              });
            },
            title: const Text(
              'Efeitos sonoros',
              style: TextStyle(
                color: Color(0xFFF8FAFC),
              ),
            ),
            subtitle: const Text(
              'Ativar efeitos durante a partida',
              style: TextStyle(
                color: Color(0xFF94A3B8),
              ),
            ),
            activeThumbColor: const Color(0xFF7C3AED),
          ),
        ],
      ),
    );
  }
}