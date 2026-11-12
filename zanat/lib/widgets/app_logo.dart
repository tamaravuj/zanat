import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  final bool light;
  final double scale;
  const AppLogo({super.key, this.light = false, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    final box = 34 * scale;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: box,
          height: box,
          decoration: BoxDecoration(
            color: light
                ? Colors.white.withValues(alpha: 0.12)
                : AppColors.primary,
            borderRadius: BorderRadius.circular(10 * scale),
            border: light
                ? Border.all(color: Colors.white.withValues(alpha: 0.16))
                : null,
          ),
          child: Icon(
            Icons.calendar_month,
            size: 19 * scale,
            color: light ? AppColors.accent : Colors.white,
          ),
        ),
        SizedBox(width: 10 * scale),
        Text(
          AppStrings.appName,
          style: TextStyle(
            fontSize: 18 * scale,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.2 * scale,
            color: light ? Colors.white : AppColors.primary,
          ),
        ),
      ],
    );
  }
}
