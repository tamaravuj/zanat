class ServiceItem {
  final String id;
  final String shopId;
  final String name;
  final int price; // RSD
  final int durationMinutes;

  const ServiceItem({
    required this.id,
    required this.shopId,
    required this.name,
    required this.price,
    required this.durationMinutes,
  });

  Map<String, dynamic> toMap() => {
    'shopId': shopId,
    'name': name,
    'price': price,
    'durationMinutes': durationMinutes,
  };

  factory ServiceItem.fromMap(String id, Map<String, dynamic> map) =>
      ServiceItem(
        id: id,
        shopId: map['shopId'] ?? '',
        name: map['name'] ?? '',
        price: map['price'] ?? 0,
        durationMinutes: map['durationMinutes'] ?? 30,
      );
}
