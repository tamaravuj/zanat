enum BookingStatus { upcoming, completed, cancelled }

class Booking {
  final String id;
  final String userId;
  final String shopId;
  final String shopName;
  final String serviceId;
  final String serviceName;
  final DateTime dateTime;
  final int price;
  final BookingStatus status;

  const Booking({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.shopName,
    required this.serviceId,
    required this.serviceName,
    required this.dateTime,
    required this.price,
    this.status = BookingStatus.upcoming,
  });

  Booking copyWith({BookingStatus? status}) => Booking(
    id: id,
    userId: userId,
    shopId: shopId,
    shopName: shopName,
    serviceId: serviceId,
    serviceName: serviceName,
    dateTime: dateTime,
    price: price,
    status: status ?? this.status,
  );

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'shopId': shopId,
    'shopName': shopName,
    'serviceId': serviceId,
    'serviceName': serviceName,
    'dateTime': dateTime.toIso8601String(),
    'price': price,
    'status': status.name,
  };

  factory Booking.fromMap(String id, Map<String, dynamic> map) => Booking(
    id: id,
    userId: map['userId'] ?? '',
    shopId: map['shopId'] ?? '',
    shopName: map['shopName'] ?? '',
    serviceId: map['serviceId'] ?? '',
    serviceName: map['serviceName'] ?? '',
    dateTime: DateTime.parse(map['dateTime']),
    price: map['price'] ?? 0,
    status: BookingStatus.values.firstWhere(
      (s) => s.name == map['status'],
      orElse: () => BookingStatus.upcoming,
    ),
  );
}
