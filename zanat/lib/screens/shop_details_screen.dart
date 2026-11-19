import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/formatters.dart';
import '../models/shop.dart';
import '../navigation/app_routes.dart';
import '../services/favorites_store.dart';
import '../services/owner_store.dart';
import '../services/review_store.dart';
import '../widgets/primary_button.dart';
import '../widgets/rating_badge.dart';
import '../widgets/review_card.dart';
import '../widgets/section_title.dart';

class ShopDetailsScreen extends StatelessWidget {
  final Shop shop;
  const ShopDetailsScreen({super.key, required this.shop});

  void _book(BuildContext context) =>
      Navigator.pushNamed(context, AppRoutes.booking, arguments: shop);

  @override
  Widget build(BuildContext context) {
    final services = OwnerStore.instance.servicesFor(shop.id);
    final reviews = ReviewStore.instance.forShop(shop.id);
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: _BookingBar(
        price: shop.priceFrom,
        onPressed: () => _book(context),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 280,
                width: double.infinity,
                child: Image.network(
                  shop.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: AppColors.secondary),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 255),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 24),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(height: 7),
                      Text(
                        shop.name,
                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 7),
                      RatingBadge(
                        value: shop.rating,
                        suffix: '${shop.reviewCount} recenzija',
                      ),
                      const SizedBox(height: 14),
                      _InfoLine(
                        icon: Icons.place_outlined,
                        title: shop.address,
                        subtitle: '${formatDistance(shop.distanceKm)} od tebe',
                        onTap: () {
                          // Po želji: otvori mapu ili kopiraj adresu
                        },
                      ),
                      _InfoLine(
                        icon: Icons.access_time,
                        title: 'Radno vreme',
                        subtitle: shop.workingHours,
                      ),
                      const SectionTitle(title: 'O nama'),
                      Text(
                        shop.description,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.65,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SectionTitle(
                        title: 'Usluge',
                        action: 'Pogledaj sve',
                        onAction: () => _book(context),
                      ),
                      if (services.isEmpty)
                        const Text(
                          'Trenutno nema unetih usluga.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        )
                      else
                        for (final s in services.take(2))
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        s.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${s.durationMinutes} min',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  formatPrice(s.price),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      SectionTitle(
                        title: 'Recenzije',
                        action: 'Sve (${shop.reviewCount})',
                        onAction: () => Navigator.pushNamed(
                          context,
                          AppRoutes.shopReviews,
                          arguments: shop,
                        ),
                      ),
                      if (reviews.isEmpty)
                        const Text(
                          'Još nema recenzija.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        )
                      else
                        ReviewCard(review: reviews.first),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: top + 8,
                left: 16,
                child: _RoundButton(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                top: top + 8,
                right: 16,
                child: ListenableBuilder(
                  listenable: FavoritesStore.instance,
                  builder: (context, _) {
                    final fav = FavoritesStore.instance.isFavorite(shop.id);
                    return _RoundButton(
                      icon: fav ? Icons.favorite : Icons.favorite_border,
                      color: fav ? AppColors.error : AppColors.primary,
                      onTap: () => FavoritesStore.instance.toggle(shop.id),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  const _RoundButton({
    required this.icon,
    required this.onTap,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _InfoLine({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFDEDEDB))),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondary),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null) const Icon(Icons.chevron_right, size: 18),
        ],
      ),
    );

    if (onTap == null) return content;

    return InkWell(onTap: onTap, child: content);
  }
}

class _BookingBar extends StatelessWidget {
  final int price;
  final VoidCallback onPressed;
  const _BookingBar({required this.price, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Cena od',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    formatPrice(price),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              PrimaryButton(
                label: 'Zakaži termin',
                expand: false,
                onPressed: onPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
