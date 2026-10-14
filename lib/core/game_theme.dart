
import 'package:flutter/material.dart';

class GameTheme {
  final String nome;
  final Color fundo;
  final Color tabuleiro;
  final Color celulaVazia;
  final Color borda;
  final Color destaque;

  const GameTheme({
    required this.nome,
    required this.fundo,
    required this.tabuleiro,
    required this.celulaVazia,
    required this.borda,
    required this.destaque,
  });
}

class GameThemeManager {
  static const GameTheme roxoNeon = GameTheme(
    nome: 'Roxo Neon',
    fundo: Color(0xFF100A20),
    tabuleiro: Color(0xFF24163F),
    celulaVazia: Color(0xFF342450),
    borda: Color(0xFF7C3AED),
    destaque: Color(0xFFA78BFA),
  );

  static const GameTheme azulEletrico = GameTheme(
    nome: 'Azul Elétrico',
    fundo: Color(0xFF071525),
    tabuleiro: Color(0xFF102B49),
    celulaVazia: Color(0xFF1B3C5D),
    borda: Color(0xFF2563EB),
    destaque: Color(0xFF38BDF8),
  );

  static const GameTheme verdeNeon = GameTheme(
    nome: 'Verde Neon',
    fundo: Color(0xFF071B16),
    tabuleiro: Color(0xFF12392D),
    celulaVazia: Color(0xFF205044),
    borda: Color(0xFF10B981),
    destaque: Color(0xFF34D399),
  );

  static const GameTheme dourado = GameTheme(
    nome: 'Dourado',
    fundo: Color(0xFF1C1608),
    tabuleiro: Color(0xFF3A2B12),
    celulaVazia: Color(0xFF51401F),
    borda: Color(0xFFF59E0B),
    destaque: Color(0xFFFBBF24),
  );

  static GameTheme obterTema(int pontuacao) {
    if (pontuacao >= 6000) {
      return dourado;
    }

    if (pontuacao >= 3000) {
      return verdeNeon;
    }

    if (pontuacao >= 1000) {
      return azulEletrico;
    }

    return roxoNeon;
  }
}
