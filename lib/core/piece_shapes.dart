import 'dart:math';

class PieceShapes {
  static final List<List<List<bool>>> formas = [
    // 1 bloco
    [
      [true],
    ],

    // 2 blocos horizontal
    [
      [true, true],
    ],

    // 2 blocos vertical
    [
      [true],
      [true],
    ],

    // 3 blocos horizontal
    [
      [true, true, true],
    ],

    // 3 blocos vertical
    [
      [true],
      [true],
      [true],
    ],

    // 4 blocos horizontal
    [
      [true, true, true, true],
    ],

    // 4 blocos vertical
    [
      [true],
      [true],
      [true],
      [true],
    ],

    // Quadrado 2x2
    [
      [true, true],
      [true, true],
    ],

    // L pequeno
    [
      [true, false],
      [true, true],
    ],

    // L invertido
    [
      [false, true],
      [true, true],
    ],

    // L grande
    [
      [true, false],
      [true, false],
      [true, true],
    ],

    // L grande invertido
    [
      [false, true],
      [false, true],
      [true, true],
    ],

    // T
    [
      [true, true, true],
      [false, true, false],
    ],

    // T vertical
    [
      [true, false],
      [true, true],
      [true, false],
    ],

    // Z
    [
      [true, true, false],
      [false, true, true],
    ],

    // S
    [
      [false, true, true],
      [true, true, false],
    ],

    // Cruz
    [
      [false, true, false],
      [true, true, true],
      [false, true, false],
    ],

    // Quadrado 3x3
    [
      [true, true, true],
      [true, true, true],
      [true, true, true],
    ],
  ];

  static List<List<bool>> gerarFormaAleatoria() {
    final random = Random();
    return formas[random.nextInt(formas.length)];
  }
}