import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hexwild_rules/hexwild_rules.dart';

class HexBoardView extends StatelessWidget {
  const HexBoardView({super.key, required this.board});

  final BoardLayout board;

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.6,
      maxScale: 2.5,
      boundaryMargin: const EdgeInsets.all(120),
      child: CustomPaint(
        painter: _HexBoardPainter(board: board),
        size: const Size(800, 700),
      ),
    );
  }
}

class _HexBoardPainter extends CustomPainter {
  _HexBoardPainter({required this.board});

  final BoardLayout board;
  static const _size = 52.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (final tile in board.tiles) {
      final centerPoint = _hexCenter(tile.coord, center);
      _drawHex(canvas, centerPoint, _terrainColor(tile.kind));
      _drawToken(canvas, centerPoint, tile);
      if (tile.coord == board.raiderAt) {
        _drawRaider(canvas, centerPoint);
      }
    }
  }

  Offset _hexCenter(HexCoord coord, Offset origin) {
    final x = _size * (3 / 2 * coord.q);
    final y = _size * (math.sqrt(3) / 2 * coord.q + math.sqrt(3) * coord.r);
    return origin + Offset(x, y);
  }

  void _drawHex(Canvas canvas, Offset center, Color fill) {
    final path = _hexPath(center, _size * 0.95);
    canvas.drawShadow(path, Colors.black.withOpacity( 0.35), 6, false);
    canvas.drawPath(
      path,
      Paint()
        ..color = fill
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withOpacity( 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  Path _hexPath(Offset center, double radius) {
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final angle = (math.pi / 180) * (60 * i - 30);
      final point = center + Offset(radius * math.cos(angle), radius * math.sin(angle));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  void _drawToken(Canvas canvas, Offset center, TerrainTile tile) {
    if (tile.productionDie <= 0) return;
    final text = TextPainter(
      text: TextSpan(
        text: '${tile.productionDie}',
        style: TextStyle(
          color: _tokenTextColor(tile.productionDie),
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(
      canvas,
      center - Offset(text.width / 2, text.height / 2),
    );
  }

  void _drawRaider(Canvas canvas, Offset center) {
    final icon = TextPainter(
      text: const TextSpan(text: '☠', style: TextStyle(fontSize: 26)),
      textDirection: TextDirection.ltr,
    )..layout();
    icon.paint(canvas, center + Offset(-icon.width / 2, _size * 0.35));
  }

  Color _terrainColor(TerrainKind kind) => switch (kind) {
        TerrainKind.timber => const Color(0xFF166534),
        TerrainKind.clay => const Color(0xFFB45309),
        TerrainKind.wool => const Color(0xFF84CC16),
        TerrainKind.grain => const Color(0xFFEAB308),
        TerrainKind.iron => const Color(0xFF64748B),
        TerrainKind.badlands => const Color(0xFFD6C4A1),
      };

  Color _tokenTextColor(int die) {
    if (die == 6 || die == 8) return const Color(0xFFB91C1C);
    return const Color(0xFF1E293B);
  }

  @override
  bool shouldRepaint(covariant _HexBoardPainter oldDelegate) =>
      oldDelegate.board != board;
}
