import 'package:flutter/foundation.dart';

import '../core/utils/formatters.dart';
import '../models/booking.dart';
import '../models/service_item.dart';
import '../models/shop.dart';
import 'mock_data.dart';
import 'owner_store.dart';
import 'user_store.dart';

class TimeSlot {
  final DateTime time;
  final bool available;
  const TimeSlot(this.time, this.available);
}

class BookingStore extends ChangeNotifier {
  BookingStore._() {
    _seed();
  }
  static final BookingStore instance = BookingStore._();

  final List<Booking> _bookings = [];
  int _counter = 100;

  List<Booking> get all => List.unmodifiable(_bookings);

  List<Booking> forUser(String uid) =>
      _bookings.where((b) => b.userId == uid).toList();

  List<Booking> forShop(String shopId) =>
      _bookings.where((b) => b.shopId == shopId).toList();

  Booking? byId(String id) {
    for (final b in _bookings) {
      if (b.id == id) return b;
    }
    return null;
  }

  String _code(DateTime dt, int n) =>
      'ZAN-${pad2(dt.year % 100)}${pad2(dt.month)}${pad2(dt.day)}-$n';

  Booking create({
    required Shop shop,
    required ServiceItem service,
    required DateTime dateTime,
    String note = '',
  }) {
    final n = ++_counter;
    final b = Booking(
      id: 'b$n',
      userId: UserStore.uid,
      customerName: UserStore.instance.fullName,
      shopId: shop.id,
      shopName: shop.name,
      shopImageUrl: shop.imageUrl,
      shopAddress: shop.address,
      category: shop.category,
      serviceId: service.id,
      serviceName: service.name,
      dateTime: dateTime,
      durationMinutes: service.durationMinutes,
      price: service.price,
      note: note,
      code: _code(dateTime, n),
      status: BookingStatus.upcoming,
    );
    _bookings.add(b);
    notifyListeners();
    return b;
  }

  void updateStatus(String id, BookingStatus status) {
    final i = _bookings.indexWhere((b) => b.id == id);
    if (i == -1) return;
    _bookings[i] = _bookings[i].copyWith(status: status);
    notifyListeners();
  }

  bool isDayBookable(String shopId, DateTime day) =>
      OwnerStore.instance.hoursFor(shopId, day) != null;

  /// Termini na pola sata; zauzeti i prošli su označeni kao nedostupni.
  List<TimeSlot> slotsFor(Shop shop, ServiceItem service, DateTime day) {
    final hours = OwnerStore.instance.hoursFor(shop.id, day);
    if (hours == null) return [];
    final (open, close) = hours;
    final now = DateTime.now();
    final taken = _bookings
        .where(
          (b) =>
              b.shopId == shop.id && b.isActive && isSameDay(b.dateTime, day),
        )
        .toList();

    final slots = <TimeSlot>[];
    for (var m = open; m + service.durationMinutes <= close; m += 30) {
      final start = DateTime(day.year, day.month, day.day, m ~/ 60, m % 60);
      final end = start.add(Duration(minutes: service.durationMinutes));
      final overlaps = taken.any(
        (b) => start.isBefore(b.endTime) && end.isAfter(b.dateTime),
      );
      slots.add(TimeSlot(start, !overlaps && start.isAfter(now)));
    }
    return slots;
  }

  void _seed() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    Booking mk(
      String uid,
      String customer,
      String shopId,
      String svcId,
      DateTime dt,
      BookingStatus st,
    ) {
      final shop = MockData.shopById(shopId);
      final svc = MockData.services.firstWhere((s) => s.id == svcId);
      final n = ++_counter;
      return Booking(
        id: 'b$n',
        userId: uid,
        customerName: customer,
        shopId: shopId,
        shopName: shop.name,
        shopImageUrl: shop.imageUrl,
        shopAddress: shop.address,
        category: shop.category,
        serviceId: svcId,
        serviceName: svc.name,
        dateTime: dt,
        durationMinutes: svc.durationMinutes,
        price: svc.price,
        code: _code(dt, n),
        status: st,
      );
    }

    DateTime at(int dayOffset, int h, int m) => today
        .add(Duration(days: dayOffset))
        .add(Duration(hours: h, minutes: m));

    _bookings.addAll([
      // Termini prijavljenog korisnika
      mk(
        UserStore.uid,
        'Ana Jovanović',
        's1',
        'sv1',
        at(3, 16, 30),
        BookingStatus.upcoming,
      ),
      mk(
        UserStore.uid,
        'Ana Jovanović',
        's2',
        'sv5',
        at(-21, 12, 0),
        BookingStatus.completed,
      ),
      mk(
        UserStore.uid,
        'Ana Jovanović',
        's3',
        'sv7',
        at(-40, 11, 0),
        BookingStatus.completed,
      ),
      mk(
        UserStore.uid,
        'Ana Jovanović',
        's4',
        'sv9',
        at(-10, 10, 0),
        BookingStatus.cancelled,
      ),
      // Termini kod radnje vlasnika (s1)
      mk(
        'u_jelena',
        'Jelena Marković',
        's1',
        'sv1',
        at(0, 9, 0),
        BookingStatus.upcoming,
      ),
      mk(
        'u_nikola',
        'Nikola Savić',
        's1',
        'sv3',
        at(0, 10, 30),
        BookingStatus.pending,
      ),
      mk(
        'u_ivana',
        'Ivana Ilić',
        's1',
        'sv2',
        at(0, 13, 0),
        BookingStatus.upcoming,
      ),
      mk(
        'u_petar',
        'Petar Đorđević',
        's1',
        'sv4',
        at(1, 11, 0),
        BookingStatus.pending,
      ),
      mk(
        'u_milica',
        'Milica Jovanović',
        's1',
        'sv1',
        at(-2, 15, 0),
        BookingStatus.completed,
      ),
    ]);
  }
}
