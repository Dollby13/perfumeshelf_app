import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppBrandMark extends StatelessWidget {
  final double size;
  final double iconSize;
  final bool inverted;

  const AppBrandMark({
    super.key,
    this.size = 92,
    this.iconSize = 54,
    this.inverted = false,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = inverted
        ? [
            Colors.white.withValues(alpha: 0.24),
            Colors.white.withValues(alpha: 0.08),
          ]
        : [AppColors.primary, AppColors.primaryDark];

    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        border: Border.all(
          color: inverted
              ? Colors.white.withValues(alpha: 0.24)
              : AppColors.secondary.withValues(alpha: 0.28),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(
              alpha: inverted ? 0.28 : 0.18,
            ),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(
          Icons.spa,
          size: iconSize,
          color: inverted ? Colors.white : Colors.white,
        ),
      ),
    );
  }
}
