import 'shop.dart';

enum BookingStatus { pending, upcoming, completed, cancelled }

class Booking {
  final String id;
  final String userId;
  final String customerName;
  final String shopId;
  final String shopName;
  final String shopImageUrl;
  final String shopAddress;
  final ShopCategory category;
  final String serviceId;
  final String serviceName;
  final DateTime dateTime;
  final int durationMinutes;
  final int price;
  final String note;
  final String code;
  final BookingStatus status;

  const Booking({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.shopId,
    required this.shopName,
    required this.shopImageUrl,
    required this.shopAddress,
    required this.category,
    required this.serviceId,
    required this.serviceName,
    required this.dateTime,
    required this.durationMinutes,
    required this.price,
    required this.code,
    this.note = '',
    this.status = BookingStatus.upcoming,
  });

  bool get isActive =>
      status == BookingStatus.pending || status == BookingStatus.upcoming;

  DateTime get endTime => dateTime.add(Duration(minutes: durationMinutes));

  Booking copyWith({BookingStatus? status}) => Booking(
    id: id,
    userId: userId,
    customerName: customerName,
    shopId: shopId,
    shopName: shopName,
    shopImageUrl: shopImageUrl,
    shopAddress: shopAddress,
    category: category,
    serviceId: serviceId,
    serviceName: serviceName,
    dateTime: dateTime,
    durationMinutes: durationMinutes,
    price: price,
    code: code,
    note: note,
    status: status ?? this.status,
  );

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'customerName': customerName,
    'shopId': shopId,
    'shopName': shopName,
    'shopImageUrl': shopImageUrl,
    'shopAddress': shopAddress,
    'category': category.name,
    'serviceId': serviceId,
    'serviceName': serviceName,
    'dateTime': dateTime.toIso8601String(),
    'durationMinutes': durationMinutes,
    'price': price,
    'note': note,
    'code': code,
    'status': status.name,
  };

  factory Booking.fromMap(String id, Map<String, dynamic> map) => Booking(
    id: id,
    userId: map['userId'] ?? '',
    customerName: map['customerName'] ?? '',
    shopId: map['shopId'] ?? '',
    shopName: map['shopName'] ?? '',
    shopImageUrl: map['shopImageUrl'] ?? '',
    shopAddress: map['shopAddress'] ?? '',
    category: ShopCategory.values.firstWhere(
      (c) => c.name == map['category'],
      orElse: () => ShopCategory.krojac,
    ),
    serviceId: map['serviceId'] ?? '',
    serviceName: map['serviceName'] ?? '',
    dateTime: DateTime.parse(map['dateTime']),
    durationMinutes: map['durationMinutes'] ?? 30,
    price: map['price'] ?? 0,
    note: map['note'] ?? '',
    code: map['code'] ?? '',
    status: BookingStatus.values.firstWhere(
      (s) => s.name == map['status'],
      orElse: () => BookingStatus.upcoming,
    ),
  );
}
