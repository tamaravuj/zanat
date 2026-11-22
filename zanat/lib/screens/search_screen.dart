import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/formatters.dart';
import '../models/search_filters.dart';
import '../models/shop.dart';
import '../navigation/app_routes.dart';
import '../services/mock_data.dart';
import '../widgets/primary_button.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  ShopCategory? _category;
  double _maxDistance = 3;
  int _maxPrice = 0; // 0 = sve cene
  double _minRating = 0;
  SortOption _sort = SortOption.recommended;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  SearchFilters get _filters => SearchFilters(
    query: _controller.text,
    category: _category,
    maxDistanceKm: _maxDistance,
    maxPrice: _maxPrice == 0 ? null : _maxPrice,
    minRating: _minRating,
    sort: _sort,
  );

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 10),
    child: Text(
      text,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
    ),
  );

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AppColors.primary,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        fontSize: 12,
        color: selected ? Colors.white : AppColors.textPrimary,
      ),
      side: BorderSide(
        color: selected ? AppColors.primary : const Color(0xFFD8DDE1),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
    );
  }

  Widget _dropdown<T>({
    required T value,
    required List<(T, String)> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDFE2E5)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: value,
          style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
          items: [
            for (final e in items)
              DropdownMenuItem<T>(value: e.$1, child: Text(e.$2)),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final count = _filters.apply(MockData.shops).length;

    const sortLabels = {
      SortOption.recommended: 'Preporučeno',
      SortOption.nearest: 'Najbliže',
      SortOption.topRated: 'Najbolje ocenjeno',
      SortOption.lowestPrice: 'Najniža cena',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Pretraga')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        children: [
          TextField(
            controller: _controller,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Radnja, usluga ili lokacija...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          _label('Kategorija'),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              _chip(
                'Sve',
                _category == null,
                () => setState(() => _category = null),
              ),
              for (final c in ShopCategory.values)
                _chip(
                  c.singular,
                  _category == c,
                  () => setState(() => _category = c),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Udaljenost'),
                    _dropdown<double>(
                      value: _maxDistance,
                      items: const [
                        (1.0, 'Do 1 km'),
                        (3.0, 'Do 3 km'),
                        (5.0, 'Do 5 km'),
                        (double.infinity, 'Bilo koja'),
                      ],
                      onChanged: (v) => setState(() => _maxDistance = v!),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Cena usluge'),
                    _dropdown<int>(
                      value: _maxPrice,
                      items: const [
                        (0, 'Sve cene'),
                        (700, 'Do 700 RSD'),
                        (1000, 'Do 1.000 RSD'),
                        (2000, 'Do 2.000 RSD'),
                      ],
                      onChanged: (v) => setState(() => _maxPrice = v!),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _label('Minimalna ocena'),
          Wrap(
            spacing: 7,
            children: [
              for (final r in const [4.0, 4.5, 4.8])
                _chip(
                  '${formatRating(r)} ★',
                  _minRating == r,
                  () => setState(() => _minRating = _minRating == r ? 0 : r),
                ),
            ],
          ),
          _label('Sortiraj po'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                for (final o in SortOption.values)
                  InkWell(
                    onTap: () => setState(() => _sort = o),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _sort == o
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            size: 20,
                            color: _sort == o
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            sortLabels[o]!,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Prikaži $count rezultata',
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.searchResults,
              arguments: _filters,
            ),
          ),
        ],
      ),
    );
  }
}
