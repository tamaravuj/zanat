import 'package:flutter/material.dart';
import 'package:zanat/core/utils/formatters.dart';
import 'package:zanat/services/user_store.dart';

import '../core/theme/app_colors.dart';
import '../models/search_filters.dart';
import '../models/shop.dart';
import '../navigation/app_routes.dart';
import '../services/mock_data.dart';
import '../widgets/category_card.dart';
import '../widgets/rating_badge.dart';
import '../widgets/search_field.dart';
import '../widgets/section_title.dart';
import '../widgets/shop_card.dart';

class HomeScreen extends StatelessWidget {
  /// Prebacuje tab u donjoj navigaciji (1 = Pretraga, 4 = Profil).
  final ValueChanged<int> onTabSelected;

  const HomeScreen({super.key, required this.onTabSelected});

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Dobro jutro,';
    if (hour < 18) return 'Dobar dan,';
    return 'Dobro veče,';
  }

  void _openShop(BuildContext context, Shop shop) =>
      Navigator.pushNamed(context, AppRoutes.shopDetails, arguments: shop);

  void _openResults(BuildContext context, SearchFilters filters) =>
      Navigator.pushNamed(context, AppRoutes.searchResults, arguments: filters);

  @override
  Widget build(BuildContext context) {
    final nearby = [...MockData.shops]
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    final featured = MockData.shopById('s3');
    final categories = ShopCategory.values;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            ListenableBuilder(
              listenable: UserStore.instance,
              builder: (context, _) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _greeting,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        UserStore.instance.firstName,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.7,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => onTabSelected(4),
                    child: CircleAvatar(
                      radius: 23,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        initials(UserStore.instance.fullName),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Row(
              children: [
                Icon(
                  Icons.place_outlined,
                  size: 17,
                  color: AppColors.secondary,
                ),
                SizedBox(width: 5),
                Text(
                  'Beograd, Vračar',
                  style: TextStyle(fontSize: 12, color: AppColors.secondary),
                ),
                Icon(Icons.chevron_right, size: 14, color: AppColors.secondary),
              ],
            ),
            const SizedBox(height: 21),
            SearchBarButton(
              hint: 'Šta ti je potrebno?',
              onTap: () => onTabSelected(1),
            ),
            SectionTitle(
              title: 'Usluge',
              action: 'Sve kategorije',
              onAction: () =>
                  Navigator.pushNamed(context, AppRoutes.categories),
            ),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 9),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return SizedBox(
                    width: 112,
                    child: CategoryTile(
                      category: category,
                      count: MockData.byCategory(category).length,
                      onTap: () => _openResults(
                        context,
                        SearchFilters(category: category),
                      ),
                    ),
                  );
                },
              ),
            ),
            SectionTitle(
              title: 'U blizini',
              action: 'Pogledaj sve',
              onAction: () => _openResults(context, const SearchFilters()),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < nearby.take(3).length; i++) ...[
                    if (i > 0) const SizedBox(width: 13),
                    SizedBox(
                      width: 270,
                      child: ShopCard(
                        shop: nearby[i],
                        onTap: () => _openShop(context, nearby[i]),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (featured != null) ...[
              const SectionTitle(title: 'Preporučeno za tebe'),
              _FeaturedShopBanner(
                shop: featured,
                onTap: () => _openShop(context, featured),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FeaturedShopBanner extends StatelessWidget {
  final Shop shop;
  final VoidCallback onTap;

  const _FeaturedShopBanner({required this.shop, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 140,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                shop.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: AppColors.secondary),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xEB122235), Color(0x1A122235)],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ISTAKNUTO',
                      style: TextStyle(
                        color: Color(0xFFE5BD92),
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Preciznost koja traje',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '${shop.name} · ${shop.district}',
                      style: const TextStyle(
                        color: Color(0xFFD9E0E5),
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DefaultTextStyle.merge(
                      style: const TextStyle(color: Colors.white),
                      child: RatingBadge(
                        value: shop.rating,
                        suffix: '(${shop.reviewCount})',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
