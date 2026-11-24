import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/category_ui.dart';
import '../core/utils/formatters.dart';
import '../models/shop.dart';
import '../services/booking_store.dart';
import '../services/mock_data.dart';
import '../services/review_store.dart';
import '../widgets/review_card.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  static const _users = [
    ('Ana Jovanović', 'ana.jovanovic@email.com', 'Korisnik'),
    ('Marija Petrović', 'marija@atelje-mara.rs', 'Vlasnik'),
    ('Jelena Marković', 'jelena@email.com', 'Korisnik'),
    ('Nikola Savić', 'nikola@email.com', 'Korisnik'),
  ];

  final Set<String> _blocked = {};
  final Set<String> _inactiveShops = {};

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin panel'),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'Pregled'),
              Tab(text: 'Korisnici'),
              Tab(text: 'Radnje'),
              Tab(text: 'Kategorije'),
              Tab(text: 'Recenzije'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _overview(),
            _usersTab(),
            _shopsTab(),
            _categoriesTab(),
            _reviewsTab(),
          ],
        ),
      ),
    );
  }

  Widget _overview() {
    final shops = MockData.shops;
    final avg = shops.fold<double>(0, (s, e) => s + e.rating) / shops.length;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _stat(Icons.people_outline, '${_users.length}', 'Korisnika'),
            _stat(
              Icons.work_outline,
              '${shops.length - _inactiveShops.length}',
              'Aktivnih radnji',
            ),
            _stat(
              Icons.calendar_month_outlined,
              '${BookingStore.instance.all.length}',
              'Rezervacija',
            ),
            _stat(Icons.star_border, formatRating(avg), 'Prosečna ocena'),
          ],
        ),
      ],
    );
  }

  Widget _stat(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: AppColors.secondary),
          Text(
            value,
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _usersTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        for (final u in _users)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: SwitchListTile(
              title: Text(
                u.$1,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                '${u.$2} · ${u.$3}',
                style: const TextStyle(fontSize: 10),
              ),
              secondary: CircleAvatar(
                backgroundColor: const Color(0xFFE6EDF3),
                child: Text(
                  initials(u.$1),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              activeColor: AppColors.secondary,
              value: !_blocked.contains(u.$2),
              onChanged: (v) => setState(() {
                v ? _blocked.remove(u.$2) : _blocked.add(u.$2);
              }),
            ),
          ),
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Text(
            'Isključen prekidač znači blokiran nalog.',
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _shopsTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        for (final s in MockData.shops)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: SwitchListTile(
              title: Text(
                s.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                '${s.category.singular} · ${s.district}',
                style: const TextStyle(fontSize: 10),
              ),
              secondary: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  s.imageUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 40,
                    height: 40,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              activeColor: AppColors.secondary,
              value: !_inactiveShops.contains(s.id),
              onChanged: (v) => setState(() {
                v ? _inactiveShops.remove(s.id) : _inactiveShops.add(s.id);
              }),
            ),
          ),
        const Padding(
          padding: EdgeInsets.only(top: 6),
          child: Text(
            'Isključen prekidač znači deaktivirana radnja.',
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _categoriesTab() {
    final total = MockData.shops.length;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        for (final c in ShopCategory.values)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: c.tileColor,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(c.icon, color: c.iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            c.label,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${MockData.byCategory(c).length} radnji',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 9),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: MockData.byCategory(c).length / total,
                          minHeight: 5,
                          color: AppColors.secondary,
                          backgroundColor: const Color(0xFFEDF0F2),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _reviewsTab() {
    return ListenableBuilder(
      listenable: ReviewStore.instance,
      builder: (context, _) {
        final reviews = ReviewStore.instance.all.reversed.toList();
        if (reviews.isEmpty) {
          return const Center(child: Text('Nema recenzija.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: reviews.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, i) {
            final r = reviews[i];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      MockData.shopById(r.shopId).name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => ReviewStore.instance.remove(r.id),
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: AppColors.error,
                      ),
                      label: const Text(
                        'Ukloni',
                        style: TextStyle(fontSize: 11, color: AppColors.error),
                      ),
                    ),
                  ],
                ),
                ReviewCard(review: r),
              ],
            );
          },
        );
      },
    );
  }
}
