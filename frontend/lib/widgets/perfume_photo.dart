import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PerfumePhoto extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;

  const PerfumePhoto({
    super.key,
    required this.imageUrl,
    this.width = 74,
    this.height = 90,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
        ),
        child: imageUrl.trim().isEmpty
            ? const _PerfumePlaceholder()
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const _PerfumePlaceholder(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _PerfumePlaceholder extends StatelessWidget {
  const _PerfumePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFE7C56D)],
        ),
      ),
      child: Center(child: Icon(Icons.spa, color: AppColors.primary, size: 34)),
    );
  }
}
