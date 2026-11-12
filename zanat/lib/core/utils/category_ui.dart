import 'package:flutter/material.dart';

import '../../models/shop.dart';

extension ShopCategoryUi on ShopCategory {
  // Material nema ikonicu cipele, pa je hiking najbliža. Možeš zameniti.
  IconData get icon {
    switch (this) {
      case ShopCategory.krojac:
        return Icons.content_cut;
      case ShopCategory.obucar:
        return Icons.hiking;
      case ShopCategory.casovnicar:
        return Icons.watch_outlined;
    }
  }

  Color get tileColor {
    switch (this) {
      case ShopCategory.krojac:
        return const Color(0xFFF4EBE2);
      case ShopCategory.obucar:
        return const Color(0xFFE9EFF4);
      case ShopCategory.casovnicar:
        return const Color(0xFFEDF0EA);
    }
  }

  Color get iconColor {
    switch (this) {
      case ShopCategory.krojac:
        return const Color(0xFF9D6A38);
      case ShopCategory.obucar:
        return const Color(0xFF426B91);
      case ShopCategory.casovnicar:
        return const Color(0xFF58705B);
    }
  }
}
