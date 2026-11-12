enum ShopCategory { krojac, obucar, casovnicar }

extension ShopCategoryX on ShopCategory {
  String get label {
    switch (this) {
      case ShopCategory.krojac:
        return 'Krojači';
      case ShopCategory.obucar:
        return 'Obućari';
      case ShopCategory.casovnicar:
        return 'Časovničari';
    }
  }
}

class Shop {
  final String id;
  final String name;
  final String description;
  final String address;
  final String city;
  final ShopCategory category;
  final String ownerId;
  final String workingHours; // npr. "Pon-Pet 08:00-16:00"
  final double rating;
  final int reviewCount;

  const Shop({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.category,
    required this.ownerId,
    required this.workingHours,
    this.rating = 0,
    this.reviewCount = 0,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'description': description,
    'address': address,
    'city': city,
    'category': category.name,
    'ownerId': ownerId,
    'workingHours': workingHours,
    'rating': rating,
    'reviewCount': reviewCount,
  };

  factory Shop.fromMap(String id, Map<String, dynamic> map) => Shop(
    id: id,
    name: map['name'] ?? '',
    description: map['description'] ?? '',
    address: map['address'] ?? '',
    city: map['city'] ?? '',
    category: ShopCategory.values.firstWhere(
      (c) => c.name == map['category'],
      orElse: () => ShopCategory.krojac,
    ),
    ownerId: map['ownerId'] ?? '',
    workingHours: map['workingHours'] ?? '',
    rating: (map['rating'] ?? 0).toDouble(),
    reviewCount: map['reviewCount'] ?? 0,
  );
}
