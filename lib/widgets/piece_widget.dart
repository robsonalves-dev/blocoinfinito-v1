import 'package:flutter/material.dart';

class PieceWidget extends StatefulWidget {
  final List<List<bool>> forma;
  final Color cor;
  final int indice;

  const PieceWidget({
    super.key,
    required this.forma,
    this.cor = const Color(0xFF7C3AED),
    required this.indice,
  });

  @override
  State<PieceWidget> createState() => _PieceWidgetState();
}

class _PieceWidgetState extends State<PieceWidget> {
  @override
  Widget build(BuildContext context) {
    final colunas =
        widget.forma.isNotEmpty ? widget.forma.first.length : 1;

    return Draggable<Map<String, dynamic>>(
      data: {
        'forma': widget.forma,
        'cor': widget.cor,
        'indice': widget.indice,
      },
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Material(
        color: Colors.transparent,
        child: _buildPiece(),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildPiece(),
      ),
      child: SizedBox(
        width: colunas * 32,
        child: _buildPiece(),
      ),
    );
  }

  Widget _buildPiece() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.forma.map((linha) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: linha.map((ocupada) {
            return Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: ocupada
                    ? widget.cor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}