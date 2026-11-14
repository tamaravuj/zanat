import 'package:flutter/material.dart';

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
    final h = DateTime.now().hour;
    if (h < 12) return 'Dobro jutro,';
    if (h < 18) return 'Dobar dan,';
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

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          children: [
            Row(
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
                    const Text(
                      'Ana',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.7,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => onTabSelected(4),
                  child: const CircleAvatar(
                    radius: 23,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      'AJ',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
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
            Row(
              children: [
                for (final c in ShopCategory.values) ...[
                  if (c != ShopCategory.values.first) const SizedBox(width: 9),
                  Expanded(
                    child: CategoryTile(
                      category: c,
                      count: MockData.byCategory(c).length,
                      onTap: () =>
                          _openResults(context, SearchFilters(category: c)),
                    ),
                  ),
                ],
              ],
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
                  for (final s in nearby.take(3)) ...[
                    SizedBox(
                      width: 270,
                      child: ShopCard(
                        shop: s,
                        onTap: () => _openShop(context, s),
                      ),
                    ),
                    const SizedBox(width: 13),
                  ],
                ],
              ),
            ),
            const SectionTitle(title: 'Preporučeno za tebe'),
            GestureDetector(
              onTap: () => _openShop(context, featured),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  height: 140,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        featured.imageUrl,
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
                              '${featured.name} · ${featured.district}',
                              style: const TextStyle(
                                color: Color(0xFFD9E0E5),
                                fontSize: 10,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Theme(
                              data: ThemeData(
                                textTheme: const TextTheme(
                                  bodyMedium: TextStyle(color: Colors.white),
                                ),
                              ),
                              child: DefaultTextStyle.merge(
                                style: const TextStyle(color: Colors.white),
                                child: RatingBadge(
                                  value: featured.rating,
                                  suffix: '(${featured.reviewCount})',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
