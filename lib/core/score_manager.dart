class ScoreManager {
  int _pontuacao = 0;
  int _recorde = 0;

  int get pontuacao => _pontuacao;
  int get recorde => _recorde;

  void adicionarPontos(int pontos) {
    _pontuacao += pontos;

    if (_pontuacao > _recorde) {
      _recorde = _pontuacao;
    }
  }

  void adicionarPontosPorLinhas(int quantidade) {
    if (quantidade <= 0) return;

    const pontosPorLinha = 100;

    adicionarPontos(
      quantidade * pontosPorLinha,
    );
  }

  void novaPartida() {
    _pontuacao = 0;
  }

  void resetarTudo() {
    _pontuacao = 0;
    _recorde = 0;
  }
}