import 'shop.dart';

enum SortOption { recommended, nearest, topRated, lowestPrice }

class SearchFilters {
  final String query;
  final ShopCategory? category;
  final double maxDistanceKm;
  final int? maxPrice;
  final double minRating;
  final SortOption sort;

  const SearchFilters({
    this.query = '',
    this.category,
    this.maxDistanceKm = double.infinity,
    this.maxPrice,
    this.minRating = 0,
    this.sort = SortOption.recommended,
  });

  List<Shop> apply(List<Shop> shops) {
    final q = query.trim().toLowerCase();
    final result = shops.where((s) {
      if (category != null && s.category != category) return false;
      if (s.distanceKm > maxDistanceKm) return false;
      if (maxPrice != null && s.priceFrom > maxPrice!) return false;
      if (s.rating < minRating) return false;
      if (q.isNotEmpty) {
        final haystack =
            '${s.name} ${s.district} ${s.city} ${s.category.singular}'
                .toLowerCase();
        if (!haystack.contains(q)) return false;
      }
      return true;
    }).toList();

    switch (sort) {
      case SortOption.recommended:
      case SortOption.topRated:
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.nearest:
        result.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
        break;
      case SortOption.lowestPrice:
        result.sort((a, b) => a.priceFrom.compareTo(b.priceFrom));
        break;
    }
    return result;
  }
}
