import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/formatters.dart';
import '../models/shop.dart';
import '../services/review_store.dart';
import '../widgets/review_card.dart';

class ShopReviewsScreen extends StatelessWidget {
  final Shop shop;
  const ShopReviewsScreen({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recenzije')),
      body: ListenableBuilder(
        listenable: ReviewStore.instance,
        builder: (context, _) {
          final reviews = ReviewStore.instance.forShop(shop.id);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Text(
                shop.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    formatRating(shop.rating),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.star, color: AppColors.accent),
                  const SizedBox(width: 10),
                  Text(
                    '${shop.reviewCount} ${pluralize(shop.reviewCount, 'recenzija', 'recenzije', 'recenzija')}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (reviews.isEmpty)
                const Text(
                  'Još nema recenzija.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              for (final r in reviews) ...[
                ReviewCard(review: r),
                const SizedBox(height: 12),
              ],
            ],
          );
        },
      ),
    );
  }
}
