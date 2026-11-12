import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/formatters.dart';

class RatingBadge extends StatelessWidget {
  final double value;
  final String? suffix; // npr. "(86 recenzija)"
  const RatingBadge({super.key, required this.value, this.suffix});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star, size: 14, color: AppColors.accent),
        const SizedBox(width: 3),
        Text(
          formatRating(value),
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        ),
        if (suffix != null) ...[
          const SizedBox(width: 3),
          Text(
            suffix!,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
