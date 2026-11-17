import 'package:flutter/foundation.dart';

import '../models/review.dart';
import 'mock_data.dart';
import 'user_store.dart';

class ReviewStore extends ChangeNotifier {
  ReviewStore._();
  static final ReviewStore instance = ReviewStore._();

  final List<Review> _reviews = [
    ...MockData.reviews,
    Review(
      id: 'rm1',
      shopId: 's2',
      userId: UserStore.uid,
      userName: 'Ana Jovanović',
      rating: 5,
      comment: 'Brzo i povoljno, preporuka.',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Review(
      id: 'rm2',
      shopId: 's3',
      userId: UserStore.uid,
      userName: 'Ana Jovanović',
      rating: 4,
      comment: 'Sat radi odlično, malo se čekalo.',
      createdAt: DateTime.now().subtract(const Duration(days: 38)),
    ),
  ];
  final Set<String> _reviewedBookings = {};

  List<Review> get all => List.unmodifiable(_reviews);

  List<Review> forShop(String shopId) =>
      _reviews.where((r) => r.shopId == shopId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<Review> byUser(String uid) =>
      _reviews.where((r) => r.userId == uid).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  bool isBookingReviewed(String bookingId) =>
      _reviewedBookings.contains(bookingId);

  void add(Review review, {String? bookingId}) {
    _reviews.add(review);
    if (bookingId != null) _reviewedBookings.add(bookingId);
    notifyListeners();
  }

  void remove(String id) {
    _reviews.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}
