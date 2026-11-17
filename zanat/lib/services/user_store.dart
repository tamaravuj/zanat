import 'package:flutter/foundation.dart';

class UserStore extends ChangeNotifier {
  UserStore._();
  static final UserStore instance = UserStore._();

  static const String uid = 'me';

  String fullName = 'Ana Jovanović';
  String email = 'ana.jovanovic@email.com';
  String phone = '+381 64 123 4567';

  bool pushEnabled = true;
  bool bookingReminders = true;
  bool newsAndOffers = false;

  String get firstName => fullName.trim().split(RegExp(r'\s+')).first;

  void updateProfile({required String fullName, required String phone}) {
    this.fullName = fullName;
    this.phone = phone;
    notifyListeners();
  }

  void setPush(bool v) {
    pushEnabled = v;
    notifyListeners();
  }

  void setReminders(bool v) {
    bookingReminders = v;
    notifyListeners();
  }

  void setNews(bool v) {
    newsAndOffers = v;
    notifyListeners();
  }
}
