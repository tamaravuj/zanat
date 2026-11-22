import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/formatters.dart';
import '../navigation/app_routes.dart';
import '../services/favorites_store.dart';
import '../widgets/empty_state.dart';
import '../widgets/shop_card.dart';

class FavoritesScreen extends StatelessWidget {
  final ValueChanged<int> onTabSelected;
  const FavoritesScreen({super.key, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Omiljene radnje')),
      body: ListenableBuilder(
        listenable: FavoritesStore.instance,
        builder: (context, _) {
          final shops = FavoritesStore.instance.shops;
          if (shops.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_border,
              title: 'Još nema sačuvanih radnji',
              message: 'Dodirni srce na kartici radnje da je sačuvaš.',
              actionLabel: 'Pronađi majstora',
              onAction: () => onTabSelected(1),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              const Text(
                'Sačuvano za kasnije',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.7,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${shops.length} ${pluralize(shops.length, 'radnja', 'radnje', 'radnji')} koje želiš ponovo da posetiš.',
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              for (final s in shops) ...[
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
          );
        },
      ),
    );
  }
}
