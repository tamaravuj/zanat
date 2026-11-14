import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/search_filters.dart';
import '../models/shop.dart';
import '../navigation/app_routes.dart';
import '../services/mock_data.dart';
import '../widgets/category_card.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kategorije')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Šta popravljamo danas?',
            style: TextStyle(
              fontSize: 28,
              height: 1.16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.9,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Izaberi kategoriju i pronađi proverenog majstora u blizini.',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          for (final c in ShopCategory.values) ...[
            CategoryCard(
              category: c,
              imageUrl: MockData.categoryImage(c),
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.searchResults,
                arguments: SearchFilters(category: c),
              ),
            ),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}
