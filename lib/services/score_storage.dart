import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreStorage {
  static const String _rankingKey = 'ranking_jogadores';

  static Future<List<Map<String, dynamic>>> carregarRanking() async {
    final prefs = await SharedPreferences.getInstance();

    final dados = prefs.getString(_rankingKey);

    if (dados == null || dados.isEmpty) {
      return [];
    }

    final lista = jsonDecode(dados);

    return List<Map<String, dynamic>>.from(
      (lista as List).map(
        (item) => Map<String, dynamic>.from(item),
      ),
    );
  }

  static Future<void> salvarRanking(
    List<Map<String, dynamic>> ranking,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _rankingKey,
      jsonEncode(ranking),
    );
  }

  static Future<void> adicionarPontuacao(
    String nome,
    int pontuacao,
  ) async {
    final ranking = await carregarRanking();

    final indiceExistente = ranking.indexWhere(
      (jogador) => jogador['nome'] == nome,
    );

    if (indiceExistente >= 0) {
      final pontuacaoAtual =
          ranking[indiceExistente]['pontuacao'] as int;

      if (pontuacao > pontuacaoAtual) {
        ranking[indiceExistente]['pontuacao'] = pontuacao;
      }
    } else {
      ranking.add({
        'nome': nome,
        'pontuacao': pontuacao,
      });
    }

    ranking.sort(
      (a, b) =>
          (b['pontuacao'] as int).compareTo(
        a['pontuacao'] as int,
      ),
    );

    if (ranking.length > 5) {
      ranking.removeRange(5, ranking.length);
    }

    await salvarRanking(ranking);
  }
}