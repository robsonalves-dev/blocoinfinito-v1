
import 'dart:math';

class PieceShapes {
  static final Random _random = Random();

  static final List<List<List<bool>>> formas = [
    // 0 - 1 bloco
    [
      [true],
    ],

    // 1 - 2 blocos horizontal
    [
      [true, true],
    ],

    // 2 - 2 blocos vertical
    [
      [true],
      [true],
    ],

    // 3 - 3 blocos horizontal
    [
      [true, true, true],
    ],

    // 4 - 3 blocos vertical
    [
      [true],
      [true],
      [true],
    ],

    // 5 - 4 blocos horizontal
    [
      [true, true, true, true],
    ],

    // 6 - 4 blocos vertical
    [
      [true],
      [true],
      [true],
      [true],
    ],

    // 7 - Quadrado 2x2
    [
      [true, true],
      [true, true],
    ],

    // 8 - L pequeno
    [
      [true, false],
      [true, true],
    ],

    // 9 - L invertido
    [
      [false, true],
      [true, true],
    ],

    // 10 - L grande
    [
      [true, false],
      [true, false],
      [true, true],
    ],

    // 11 - L grande invertido
    [
      [false, true],
      [false, true],
      [true, true],
    ],

    // 12 - T
    [
      [true, true, true],
      [false, true, false],
    ],

    // 13 - T vertical
    [
      [true, false],
      [true, true],
      [true, false],
    ],

    // 14 - Z
    [
      [true, true, false],
      [false, true, true],
    ],

    // 15 - S
    [
      [false, true, true],
      [true, true, false],
    ],

    // 16 - Cruz
    [
      [false, true, false],
      [true, true, true],
      [false, true, false],
    ],

    // 17 - Quadrado 3x3
    [
      [true, true, true],
      [true, true, true],
      [true, true, true],
    ],

    // NOVAS PEÇAS DO NÍVEL 3

    // 18 - Barra horizontal de 5
    [
      [true, true, true, true, true],
    ],

    // 19 - Barra vertical de 5
    [
      [true],
      [true],
      [true],
      [true],
      [true],
    ],

    // 20 - L grande de 6 blocos
    [
      [true, false],
      [true, false],
      [true, false],
      [true, false],
      [true, true],
    ],

    // 21 - L grande invertido de 6 blocos
    [
      [false, true],
      [false, true],
      [false, true],
      [false, true],
      [true, true],
    ],

    // 22 - T grande de 6 blocos
    [
      [true, true, true, true],
      [false, true, false, false],
      [false, true, false, false],
    ],

    // 23 - Z grande de 6 blocos
    [
      [true, true, true, false],
      [false, false, true, true],
    ],

    // 24 - Retângulo 2x3
    [
      [true, true, true],
      [true, true, true],
    ],

    // 25 - Retângulo 3x2
    [
      [true, true],
      [true, true],
      [true, true],
    ],

    // 26 - Escada de 6 blocos
    [
      [true, true, false, false],
      [false, true, true, false],
      [false, false, true, true],
    ],

    // 27 - U de 5 blocos
    [
      [true, false, true],
      [true, true, true],
    ],
  ];

  // NÍVEL 1 - FÁCIL
  static const List<int> pecasFaceis = [
    0, 1, 2, 3, 4, 7, 8, 9,
  ];

  // NÍVEL 2 - MÉDIO
  static const List<int> pecasMedias = [
    5, 6, 10, 11, 12, 13, 14, 15,
  ];

  // NÍVEL 3 - DIFÍCIL
  static const List<int> pecasDificeis = [
    16, 17, 18, 19, 20, 21, 22,
    23, 24, 25, 26, 27,
  ];

  static List<List<bool>> gerarFormaAleatoria({
    int nivel = 1,
  }) {
    late final List<int> opcoes;

    if (nivel <= 1) {
      // Mantém o nível 1 original.
      opcoes = pecasFaceis;
    } else if (nivel == 2) {
      // Mantém o nível 2 original.
      opcoes = [
        ...pecasFaceis,
        ...pecasMedias,
      ];
    } else {
      // Nível 3:
      // 25% de chance de peças fáceis.
      // 75% de chance de peças médias ou difíceis.
      final sorteio = _random.nextInt(100);

      if (sorteio < 25) {
        opcoes = pecasFaceis;
      } else {
        opcoes = [
          ...pecasMedias,
          ...pecasDificeis,
        ];
      }
    }

    final indice = opcoes[
      _random.nextInt(opcoes.length)
    ];

    return formas[indice];
  }
}
