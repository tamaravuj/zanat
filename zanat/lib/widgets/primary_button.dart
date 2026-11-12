import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

enum AppButtonVariant { primary, secondary, ghost, danger }

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool expand;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, BorderSide side) = switch (variant) {
      AppButtonVariant.primary => (
        AppColors.primary,
        Colors.white,
        BorderSide.none,
      ),
      AppButtonVariant.secondary => (
        Colors.white,
        AppColors.primary,
        const BorderSide(color: Color(0xFFCBD3DB)),
      ),
      AppButtonVariant.ghost => (
        Colors.transparent,
        AppColors.secondary,
        BorderSide.none,
      ),
      AppButtonVariant.danger => (
        const Color(0xFFFFF1EF),
        AppColors.error,
        BorderSide.none,
      ),
    };

    return SizedBox(
      height: 54,
      width: expand ? double.infinity : null,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: side,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            if (icon != null) ...[
              const SizedBox(width: 12),
              Icon(icon, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}
