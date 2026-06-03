import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class RatingStars extends StatelessWidget {
  final int rating;
  final ValueChanged<int>? onChanged;
  final double size;

  const RatingStars({
    super.key,
    required this.rating,
    this.onChanged,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final value = index + 1;
        final selected = value <= rating;

        return InkWell(
          borderRadius: BorderRadius.circular(size),
          onTap: onChanged == null ? null : () => onChanged!(value),
          child: Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Icon(
              selected ? Icons.star : Icons.star_border,
              color: selected ? AppColors.secondary : AppColors.textMuted,
              size: size,
            ),
          ),
        );
      }),
    );
  }
}
