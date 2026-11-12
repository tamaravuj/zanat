import 'package:flutter/foundation.dart';

import '../models/shop.dart';
import 'mock_data.dart';

class FavoritesStore extends ChangeNotifier {
  FavoritesStore._();
  static final FavoritesStore instance = FavoritesStore._();

  final Set<String> _ids = {'s1', 's2', 's3'};

  bool isFavorite(String shopId) => _ids.contains(shopId);

  void toggle(String shopId) {
    if (!_ids.remove(shopId)) _ids.add(shopId);
    notifyListeners();
  }

  List<Shop> get shops =>
      MockData.shops.where((s) => _ids.contains(s.id)).toList();
}
