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

  String get singular {
    switch (this) {
      case ShopCategory.krojac:
        return 'Krojač';
      case ShopCategory.obucar:
        return 'Obućar';
      case ShopCategory.casovnicar:
        return 'Časovničar';
    }
  }

  String get description {
    switch (this) {
      case ShopCategory.krojac:
        return 'Prepravke, šivenje po meri i popravke';
      case ShopCategory.obucar:
        return 'Popravka obuće, torbi i kožne galanterije';
      case ShopCategory.casovnicar:
        return 'Servis, baterije i restauracija satova';
    }
  }
}

class Shop {
  final String id;
  final String name;
  final String description;
  final String address;
  final String city;
  final String district;
  final ShopCategory category;
  final String ownerId;
  final String workingHours;
  final String imageUrl;
  final double distanceKm; // u Firestore verziji se računa iz lokacije
  final int priceFrom; // RSD
  final double rating;
  final int reviewCount;

  const Shop({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.city,
    required this.district,
    required this.category,
    required this.ownerId,
    required this.workingHours,
    required this.imageUrl,
    required this.priceFrom,
    this.distanceKm = 0,
    this.rating = 0,
    this.reviewCount = 0,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'description': description,
    'address': address,
    'city': city,
    'district': district,
    'category': category.name,
    'ownerId': ownerId,
    'workingHours': workingHours,
    'imageUrl': imageUrl,
    'priceFrom': priceFrom,
    'rating': rating,
    'reviewCount': reviewCount,
  };

  factory Shop.fromMap(String id, Map<String, dynamic> map) => Shop(
    id: id,
    name: map['name'] ?? '',
    description: map['description'] ?? '',
    address: map['address'] ?? '',
    city: map['city'] ?? '',
    district: map['district'] ?? '',
    category: ShopCategory.values.firstWhere(
      (c) => c.name == map['category'],
      orElse: () => ShopCategory.krojac,
    ),
    ownerId: map['ownerId'] ?? '',
    workingHours: map['workingHours'] ?? '',
    imageUrl: map['imageUrl'] ?? '',
    priceFrom: map['priceFrom'] ?? 0,
    rating: (map['rating'] ?? 0).toDouble(),
    reviewCount: map['reviewCount'] ?? 0,
  );
}
