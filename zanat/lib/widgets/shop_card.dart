import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/formatters.dart';
import '../models/shop.dart';
import '../services/favorites_store.dart';
import 'rating_badge.dart';

class ShopCard extends StatelessWidget {
  final Shop shop;
  final VoidCallback onTap;
  final bool horizontal;
  const ShopCard({
    super.key,
    required this.shop,
    required this.onTap,
    this.horizontal = false,
  });

  Widget _image() {
    return ListenableBuilder(
      listenable: FavoritesStore.instance,
      builder: (context, _) {
        final fav = FavoritesStore.instance.isFavorite(shop.id);
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              shop.imageUrl,
              fit: BoxFit.cover,
              // ignore: unnecessary_underscores
              errorBuilder: (_, __, ___) =>
                  Container(color: const Color(0xFFE6EDF3)),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: GestureDetector(
                onTap: () => FavoritesStore.instance.toggle(shop.id),
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.white.withValues(alpha: 0.9),
                  child: Icon(
                    fav ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: fav ? AppColors.error : AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _info() {
    final gap = horizontal ? 9.0 : 12.0;
    return Padding(
      padding: EdgeInsets.all(horizontal ? 12 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            shop.category.singular.toUpperCase(),
            style: const TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.w700,
              fontSize: 10,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            shop.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: horizontal ? 14 : 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              RatingBadge(value: shop.rating),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.place_outlined,
                    size: 13,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '${shop.district} · ${formatDistance(shop.distanceKm)}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: gap),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          SizedBox(height: gap),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'od ${formatPrice(shop.priceFrom)}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pogledaj',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 15,
                    color: AppColors.secondary,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: horizontal
            ? SizedBox(
                height: 148,
                child: Row(
                  children: [
                    SizedBox(width: 105, child: _image()),
                    Expanded(child: _info()),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 136, child: _image()),
                  _info(),
                ],
              ),
      ),
    );
  }
}
