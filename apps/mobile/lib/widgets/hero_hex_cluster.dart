import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Decorative hex cluster for the home hero.
class HeroHexCluster extends StatelessWidget {
  const HeroHexCluster({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: CustomPaint(
        painter: _HeroHexPainter(),
        size: const Size(double.infinity, 120),
      ),
    );
  }
}

class _HeroHexPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(size.width * 0.5, size.height * 0.55);
    const r = 26.0;
    final colors = [
      const Color(0xFF166534),
      const Color(0xFFB45309),
      const Color(0xFF84CC16),
      const Color(0xFFEAB308),
      const Color(0xFF64748B),
      const Color(0xFFD6C4A1),
    ];
    final coords = [
      const Offset(0, 0),
      Offset(r * 1.5, -r * 0.2),
      Offset(-r * 1.5, -r * 0.2),
      Offset(r * 0.75, r * 1.2),
      Offset(-r * 0.75, r * 1.2),
    ];
    for (var i = 0; i < coords.length; i++) {
      _drawHex(canvas, origin + coords[i], r * 0.92, colors[i % colors.length]);
    }
  }

  void _drawHex(Canvas canvas, Offset center, double radius, Color fill) {
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final angle = (math.pi / 180) * (60 * i - 30);
      final p = center + Offset(radius * math.cos(angle), radius * math.sin(angle));
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    canvas.drawShadow(path, Colors.black.withOpacity(0.35), 8, false);
    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withOpacity(0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
