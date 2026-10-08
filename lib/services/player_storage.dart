import 'package:shared_preferences/shared_preferences.dart';

class PlayerStorage {
  static const String _nomeJogadorKey = 'nome_jogador';

  static Future<void> salvarNome(String nome) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nomeJogadorKey, nome);
  }

  static Future<String?> carregarNome() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nomeJogadorKey);
  }

  static Future<void> removerNome() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_nomeJogadorKey);
  }
}