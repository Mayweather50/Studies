import 'dart:math';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class IslamicPatternPainter extends CustomPainter {
  final Color color;
  final double opacity;

  IslamicPatternPainter({
    this.color = AppColors.primary,
    this.opacity = 0.08,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const double cellSize = 60;
    final int cols = (size.width / cellSize).ceil() + 1;
    final int rows = (size.height / cellSize).ceil() + 1;

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        final cx = i * cellSize;
        final cy = j * cellSize;
        _drawStarPattern(canvas, Offset(cx, cy), cellSize / 2, paint);
      }
    }
  }

  void _drawStarPattern(
      Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const int points = 8;
    final double innerRadius = radius * 0.4;

    for (int i = 0; i < points * 2; i++) {
      final double angle = (i * pi) / points - pi / 2;
      final double r = i.isEven ? radius : innerRadius;
      final double x = center.dx + r * cos(angle);
      final double y = center.dy + r * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class IslamicPatternBackground extends StatelessWidget {
  final Widget child;
  final Color? patternColor;
  final double opacity;

  const IslamicPatternBackground({
    super.key,
    required this.child,
    this.patternColor,
    this.opacity = 0.08,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: IslamicPatternPainter(
              color: patternColor ?? AppColors.primary,
              opacity: opacity,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
