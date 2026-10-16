import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hexwild_rules/hexwild_rules.dart';

class HexBoardView extends StatelessWidget {
  const HexBoardView({super.key, required this.board});

  final BoardLayout board;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1E293B).withOpacity(0.45),
            const Color(0xFF0F172A).withOpacity(0.2),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InteractiveViewer(
          minScale: 0.45,
          maxScale: 2.8,
          boundaryMargin: const EdgeInsets.all(80),
          child: CustomPaint(
            painter: _HexBoardPainter(board: board),
            size: const Size(820, 720),
          ),
        ),
      ),
    );
  }
}

class _HexBoardPainter extends CustomPainter {
  _HexBoardPainter({required this.board});

  final BoardLayout board;
  static const _size = 54.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF134E4A).withOpacity(0.35),
            Colors.transparent,
          ],
        ).createShader(Offset.zero & size),
    );

    for (final tile in board.tiles) {
      final centerPoint = _hexCenter(tile.coord, center);
      _drawHex(canvas, centerPoint, _terrainColor(tile.kind));
      _drawTerrainMark(canvas, centerPoint, tile.kind);
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
    final path = _hexPath(center, _size * 0.96);
    canvas.drawShadow(path, Colors.black.withOpacity(0.4), 8, false);
    canvas.drawPath(
      path,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Color.lerp(fill, Colors.white, 0.12)!,
            fill,
            Color.lerp(fill, Colors.black, 0.18)!,
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: _size))
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
  }

  void _drawTerrainMark(Canvas canvas, Offset center, TerrainKind kind) {
    final label = switch (kind) {
      TerrainKind.timber => 'T',
      TerrainKind.clay => 'C',
      TerrainKind.wool => 'W',
      TerrainKind.grain => 'G',
      TerrainKind.iron => 'I',
      TerrainKind.badlands => '·',
    };
    final text = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.22),
          fontSize: 28,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(canvas, center - Offset(text.width / 2, text.height / 2 + 14));
  }

  Path _hexPath(Offset center, double radius) {
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final angle = (math.pi / 180) * (60 * i - 30);
      final point =
          center + Offset(radius * math.cos(angle), radius * math.sin(angle));
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
    canvas.drawCircle(
      center,
      17,
      Paint()..color = const Color(0xFFF8FAFC),
    );
    canvas.drawCircle(
      center,
      17,
      Paint()
        ..color = Colors.black.withOpacity(0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    final text = TextPainter(
      text: TextSpan(
        text: '${tile.productionDie}',
        style: TextStyle(
          color: _tokenTextColor(tile.productionDie),
          fontSize: 20,
          fontWeight: FontWeight.w800,
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
    canvas.drawCircle(
      center + Offset(0, _size * 0.38),
      14,
      Paint()..color = const Color(0xFF1E293B),
    );
    final icon = TextPainter(
      text: const TextSpan(text: '☠', style: TextStyle(fontSize: 18)),
      textDirection: TextDirection.ltr,
    )..layout();
    icon.paint(
      canvas,
      center + Offset(-icon.width / 2, _size * 0.38 - icon.height / 2),
    );
  }

  Color _terrainColor(TerrainKind kind) => switch (kind) {
        TerrainKind.timber => const Color(0xFF15803D),
        TerrainKind.clay => const Color(0xFFC2410C),
        TerrainKind.wool => const Color(0xFF65A30D),
        TerrainKind.grain => const Color(0xFFCA8A04),
        TerrainKind.iron => const Color(0xFF475569),
        TerrainKind.badlands => const Color(0xFFE7D5B4),
      };

  Color _tokenTextColor(int die) {
    if (die == 6 || die == 8) return const Color(0xFFB91C1C);
    return const Color(0xFF0F172A);
  }

  @override
  bool shouldRepaint(covariant _HexBoardPainter oldDelegate) =>
      oldDelegate.board != board;
}
