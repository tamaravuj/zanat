import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class TimeSlotChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  const TimeSlotChip({
    super.key,
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? AppColors.primary
        : enabled
        ? Colors.white
        : const Color(0xFFEFEFED);
    final fg = selected
        ? Colors.white
        : enabled
        ? AppColors.textPrimary
        : const Color(0xFFBDC2C6);
    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(11),
        side: BorderSide(
          color: selected ? AppColors.primary : const Color(0xFFDCE0E3),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: enabled ? onTap : null,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg,
              decoration: enabled ? null : TextDecoration.lineThrough,
            ),
          ),
        ),
      ),
    );
  }
}
