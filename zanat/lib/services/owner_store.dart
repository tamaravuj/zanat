import 'package:flutter/foundation.dart';

import '../models/service_item.dart';
import 'mock_data.dart';

class DaySchedule {
  final String name;
  bool open;
  int openMin;
  int closeMin;
  DaySchedule(this.name, this.open, this.openMin, this.closeMin);
}

class OwnerStore extends ChangeNotifier {
  OwnerStore._();
  static final OwnerStore instance = OwnerStore._();

  /// Radnja koju "poseduje" demo vlasnik.
  static const String ownerShopId = 's1';
  final String ownerName = 'Marija';

  String shopName = MockData.shopById(ownerShopId).name;
  String description = MockData.shopById(ownerShopId).description;
  String address = MockData.shopById(ownerShopId).address;

  final List<ServiceItem> _services = List.of(
    MockData.servicesFor(ownerShopId),
  );

  final List<DaySchedule> schedule = [
    DaySchedule('Ponedeljak', true, 9 * 60, 19 * 60),
    DaySchedule('Utorak', true, 9 * 60, 19 * 60),
    DaySchedule('Sreda', true, 9 * 60, 19 * 60),
    DaySchedule('Četvrtak', true, 9 * 60, 19 * 60),
    DaySchedule('Petak', true, 9 * 60, 19 * 60),
    DaySchedule('Subota', true, 10 * 60, 15 * 60),
    DaySchedule('Nedelja', false, 9 * 60, 17 * 60),
  ];

  List<ServiceItem> get services => List.unmodifiable(_services);

  List<ServiceItem> servicesFor(String shopId) =>
      shopId == ownerShopId ? services : MockData.servicesFor(shopId);

  /// Radno vreme u minutama od ponoći, ili null ako radnja ne radi tog dana.
  (int, int)? hoursFor(String shopId, DateTime day) {
    if (shopId == ownerShopId) {
      final d = schedule[day.weekday - 1];
      return d.open ? (d.openMin, d.closeMin) : null;
    }
    switch (day.weekday) {
      case DateTime.sunday:
        return null;
      case DateTime.saturday:
        return (10 * 60, 14 * 60);
      default:
        return (9 * 60, 17 * 60);
    }
  }

  void changed() => notifyListeners();

  void updateInfo({
    required String name,
    required String description,
    required String address,
  }) {
    shopName = name;
    this.description = description;
    this.address = address;
    notifyListeners();
  }

  void addService(String name, int price, int minutes) {
    _services.add(
      ServiceItem(
        id: 'sv_${DateTime.now().microsecondsSinceEpoch}',
        shopId: ownerShopId,
        name: name,
        price: price,
        durationMinutes: minutes,
      ),
    );
    notifyListeners();
  }

  void updateService(ServiceItem item) {
    final i = _services.indexWhere((s) => s.id == item.id);
    if (i != -1) _services[i] = item;
    notifyListeners();
  }

  void removeService(String id) {
    _services.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}
