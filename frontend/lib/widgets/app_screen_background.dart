import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppScreenBackground extends StatelessWidget {
  final Widget child;

  const AppScreenBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: CustomPaint(
        painter: _PerfumeShelfBackgroundPainter(),
        child: child,
      ),
    );
  }
}

class _PerfumeShelfBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _drawBaseWash(canvas, size);
    _drawSoftLights(canvas, size);
    _drawBands(canvas, size);
    _drawShelves(canvas, size);
    _drawFineTexture(canvas, size);
  }

  void _drawBaseWash(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF9FBF7), Color(0xFFF3F8F4), Color(0xFFF8F5EF)],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, basePaint);
  }

  void _drawSoftLights(Canvas canvas, Size size) {
    final tealGlow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.13),
              AppColors.primary.withValues(alpha: 0.00),
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.15, size.height * 0.05),
              radius: size.width * 0.42,
            ),
          );

    final roseGlow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.accent.withValues(alpha: 0.08),
              AppColors.accent.withValues(alpha: 0.00),
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.92, size.height * 0.20),
              radius: size.width * 0.34,
            ),
          );

    final goldGlow = Paint()
      ..shader =
          RadialGradient(
            colors: [
              AppColors.secondary.withValues(alpha: 0.12),
              AppColors.secondary.withValues(alpha: 0.00),
            ],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * 0.68, size.height * 0.88),
              radius: size.width * 0.50,
            ),
          );

    canvas.drawRect(Offset.zero & size, tealGlow);
    canvas.drawRect(Offset.zero & size, roseGlow);
    canvas.drawRect(Offset.zero & size, goldGlow);
  }

  void _drawBands(Canvas canvas, Size size) {
    final bandPaint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.075)
      ..style = PaintingStyle.fill;
    final bandPath = Path()
      ..moveTo(size.width * 0.70, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.42)
      ..lineTo(size.width * 0.84, size.height * 0.36)
      ..close();
    canvas.drawPath(bandPath, bandPaint);

    final accentBandPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.04)
      ..style = PaintingStyle.fill;
    final accentBandPath = Path()
      ..moveTo(0, size.height * 0.18)
      ..lineTo(size.width * 0.22, size.height * 0.09)
      ..lineTo(size.width * 0.42, size.height * 0.13)
      ..lineTo(0, size.height * 0.33)
      ..close();
    canvas.drawPath(accentBandPath, accentBandPaint);
  }

  void _drawShelves(Canvas canvas, Size size) {
    final shelfPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.050)
      ..strokeWidth = 1;
    final shelfShadowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.62)
      ..strokeWidth = 1;

    for (double y = 92; y < size.height + 120; y += 132) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), shelfPaint);
      canvas.drawLine(
        Offset(0, y + 1),
        Offset(size.width, y + 1),
        shelfShadowPaint,
      );
      _drawShelfBottles(canvas, size, y);
    }
  }

  void _drawFineTexture(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryDark.withValues(alpha: 0.018)
      ..strokeWidth = 1;

    for (double x = 24; x < size.width; x += 96) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height * 0.12, size.height),
        paint,
      );
    }
  }

  void _drawShelfBottles(Canvas canvas, Size size, double shelfY) {
    final bottlePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.040)
      ..style = PaintingStyle.fill;
    final accentPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.035)
      ..style = PaintingStyle.fill;
    final capPaint = Paint()
      ..color = AppColors.secondary.withValues(alpha: 0.060)
      ..style = PaintingStyle.fill;

    for (double x = 36; x < size.width + 160; x += 210) {
      final offset = ((shelfY / 132).round().isEven) ? 0.0 : 94.0;
      final left = x + offset;
      final top = shelfY - 42;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top + 12, 24, 30),
          const Radius.circular(6),
        ),
        bottlePaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left + 7, top + 5, 10, 9),
          const Radius.circular(3),
        ),
        capPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left + 34, top + 18, 18, 24),
          const Radius.circular(999),
        ),
        accentPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
