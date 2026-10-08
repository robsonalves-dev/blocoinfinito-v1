class GameLogic {
  static const int linhas = 10;
  static const int colunas = 10;

  final List<List<int?>> tabuleiro = List.generate(
    linhas,
    (_) => List<int?>.filled(colunas, null),
  );

  bool estaDentroDoTabuleiro(int linha, int coluna) {
    return linha >= 0 &&
        linha < linhas &&
        coluna >= 0 &&
        coluna < colunas;
  }

  bool celulaLivre(int linha, int coluna) {
    if (!estaDentroDoTabuleiro(linha, coluna)) {
      return false;
    }

    return tabuleiro[linha][coluna] == null;
  }

  bool podeColocarBloco(List<BlockCell> bloco) {
    for (final celula in bloco) {
      if (!estaDentroDoTabuleiro(celula.linha, celula.coluna)) {
        return false;
      }

      if (!celulaLivre(celula.linha, celula.coluna)) {
        return false;
      }
    }

    return true;
  }

  bool colocarBloco(
    List<BlockCell> bloco, {
    int tipoBloco = 1,
  }) {
    if (!podeColocarBloco(bloco)) {
      return false;
    }

    for (final celula in bloco) {
      tabuleiro[celula.linha][celula.coluna] = tipoBloco;
    }

    return true;
  }

  void limparTabuleiro() {
    for (int linha = 0; linha < linhas; linha++) {
      for (int coluna = 0; coluna < colunas; coluna++) {
        tabuleiro[linha][coluna] = null;
      }
    }
  }

  // Formatos de peças disponíveis no jogo.
  static const List<List<List<bool>>> pecas = [
    [
      [true],
    ],
    [
      [true, true],
    ],
    [
      [true],
      [true],
    ],
    [
      [true, true],
      [true, true],
    ],
    [
      [true, true, true],
    ],
    [
      [true],
      [true],
      [true],
    ],
    [
      [true, true, true],
      [false, true, false],
    ],
    [
      [true, false],
      [true, true],
      [false, true],
    ],
  ];
}

class BlockCell {
  final int linha;
  final int coluna;

  const BlockCell({
    required this.linha,
    required this.coluna,
  });
}