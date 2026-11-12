import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Polje koje izgleda kao pretraga, ali samo otvara ekran pretrage.
class SearchBarButton extends StatelessWidget {
  final String hint;
  final VoidCallback onTap;
  const SearchBarButton({super.key, required this.hint, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: AppColors.primary.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 57,
          padding: const EdgeInsets.only(left: 17, right: 10),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  hint,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2F5),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.tune,
                  size: 18,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
