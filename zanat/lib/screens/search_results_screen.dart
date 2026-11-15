import 'package:flutter/material.dart';
import 'package:zanat/models/shop.dart';

import '../core/theme/app_colors.dart';
import '../models/search_filters.dart';
import '../navigation/app_routes.dart';
import '../services/mock_data.dart';
import '../widgets/shop_card.dart';

class SearchResultsScreen extends StatelessWidget {
  final SearchFilters filters;
  const SearchResultsScreen({super.key, required this.filters});

  @override
  Widget build(BuildContext context) {
    final results = filters.apply(MockData.shops);

    return Scaffold(
      appBar: AppBar(
        title: Text(filters.category?.label ?? 'Rezultati pretrage'),
      ),
      body: results.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search_off,
                      size: 36,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Nema rezultata',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Probaj da promeniš ili ukloniš neke filtere.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Rezultata: ${results.length}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                for (final s in results) ...[
                  ShopCard(
                    shop: s,
                    horizontal: true,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.shopDetails,
                      arguments: s,
                    ),
                  ),
                  const SizedBox(height: 13),
                ],
              ],
            ),
    );
  }
}
