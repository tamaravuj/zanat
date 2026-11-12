import '../models/review.dart';
import '../models/service_item.dart';
import '../models/shop.dart';

class MockData {
  MockData._();

  static const String imgTailor =
      'https://images.unsplash.com/photo-1673201229733-69d19c5c4a87?auto=format&fit=crop&w=900&q=85';
  static const String imgTailor2 =
      'https://images.unsplash.com/photo-1554676187-2d8760e5cd33?auto=format&fit=crop&w=900&q=85';
  static const String imgShoe =
      'https://images.unsplash.com/photo-1563433337461-5b65f0834f3a?auto=format&fit=crop&w=900&q=85';
  static const String imgWatch =
      'https://images.unsplash.com/photo-1788125856699-aee0e94d9150?auto=format&fit=crop&w=900&q=85';

  static String categoryImage(ShopCategory c) {
    switch (c) {
      case ShopCategory.krojac:
        return imgTailor;
      case ShopCategory.obucar:
        return imgShoe;
      case ShopCategory.casovnicar:
        return imgWatch;
    }
  }

  static const List<Shop> shops = [
    Shop(
      id: 's1',
      name: 'Atelje Mara',
      description: 'Porodični krojački atelje sa više od 20 godina iskustva. Specijalizovani smo za precizne prepravke i šivenje po meri.',
      address: 'Njegoševa 42, Vračar',
      city: 'Beograd',
      district: 'Vračar',
      category: ShopCategory.krojac,
      ownerId: 'owner1',
      workingHours: 'Pon–Pet 09–19 · Sub 10–15',
      imageUrl: imgTailor,
      distanceKm: 0.8,
      priceFrom: 800,
      rating: 4.9,
      reviewCount: 86,
    ),
    Shop(
      id: 's2',
      name: 'Stari zanat',
      description: 'Tradicionalna obućarska radnja. Zamena đonova, flekica, popravka torbi i kožne galanterije.',
      address: 'Dobračina 25, Dorćol',
      city: 'Beograd',
      district: 'Dorćol',
      category: ShopCategory.obucar,
      ownerId: 'owner2',
      workingHours: 'Pon–Pet 08–18 · Sub 09–14',
      imageUrl: imgShoe,
      distanceKm: 1.2,
      priceFrom: 600,
      rating: 4.8,
      reviewCount: 54,
    ),
    Shop(
      id: 's3',
      name: 'Časovničar Petrović',
      description: 'Servis mehaničkih i kvarcnih satova, zamena baterija i restauracija starih satova.',
      address: 'Knez Mihailova 12, Stari grad',
      city: 'Beograd',
      district: 'Stari grad',
      category: ShopCategory.casovnicar,
      ownerId: 'owner3',
      workingHours: 'Pon–Pet 10–18',
      imageUrl: imgWatch,
      distanceKm: 1.6,
      priceFrom: 1000,
      rating: 4.9,
      reviewCount: 128,
    ),
    Shop(
      id: 's4',
      name: 'Krojač Nikolić',
      description: 'Prepravke odeće i šivenje odela po meri.',
      address: 'Bulevar kralja Aleksandra 120, Zvezdara',
      city: 'Beograd',
      district: 'Zvezdara',
      category: ShopCategory.krojac,
      ownerId: 'owner4',
      workingHours: 'Pon–Pet 09–17',
      imageUrl: imgTailor2,
      distanceKm: 2.1,
      priceFrom: 700,
      rating: 4.7,
      reviewCount: 31,
    ),
    Shop(
      id: 's5',
      name: 'Obućar Pera',
      description: 'Brza popravka obuće, farbanje i impregnacija kože.',
      address: 'Narodnih heroja 8, Novi Beograd',
      city: 'Beograd',
      district: 'Novi Beograd',
      category: ShopCategory.obucar,
      ownerId: 'owner5',
      workingHours: 'Pon–Sub 08–16',
      imageUrl: imgShoe,
      distanceKm: 2.4,
      priceFrom: 500,
      rating: 4.6,
      reviewCount: 22,
    ),
    Shop(
      id: 's6',
      name: 'Krojačka radnja Lux',
      description: 'Zamena rajsferšlusa, skraćivanje i sužavanje.',
      address: 'Takovska 30, Palilula',
      city: 'Beograd',
      district: 'Palilula',
      category: ShopCategory.krojac,
      ownerId: 'owner6',
      workingHours: 'Pon–Pet 10–18',
      imageUrl: imgTailor,
      distanceKm: 2.8,
      priceFrom: 900,
      rating: 4.6,
      reviewCount: 18,
    ),
  ];

  static const List<ServiceItem> services = [
    ServiceItem(
      id: 'sv1',
      shopId: 's1',
      name: 'Skraćivanje pantalona',
      price: 800,
      durationMinutes: 30,
    ),
    ServiceItem(
      id: 'sv2',
      shopId: 's1',
      name: 'Sužavanje haljine',
      price: 1800,
      durationMinutes: 60,
    ),
    ServiceItem(
      id: 'sv3',
      shopId: 's1',
      name: 'Zamena rajsferšlusa',
      price: 1200,
      durationMinutes: 45,
    ),
    ServiceItem(
      id: 'sv4',
      shopId: 's1',
      name: 'Šivenje po meri',
      price: 4500,
      durationMinutes: 120,
    ),
    ServiceItem(
      id: 'sv5',
      shopId: 's2',
      name: 'Zamena flekica',
      price: 600,
      durationMinutes: 30,
    ),
    ServiceItem(
      id: 'sv6',
      shopId: 's2',
      name: 'Zamena đona',
      price: 2500,
      durationMinutes: 60,
    ),
    ServiceItem(
      id: 'sv7',
      shopId: 's3',
      name: 'Zamena baterije',
      price: 1000,
      durationMinutes: 15,
    ),
    ServiceItem(
      id: 'sv8',
      shopId: 's3',
      name: 'Servis mehaničkog sata',
      price: 6000,
      durationMinutes: 90,
    ),
    ServiceItem(
      id: 'sv9',
      shopId: 's4',
      name: 'Skraćivanje pantalona',
      price: 700,
      durationMinutes: 30,
    ),
    ServiceItem(
      id: 'sv10',
      shopId: 's4',
      name: 'Prepravka sakoa',
      price: 2500,
      durationMinutes: 60,
    ),
    ServiceItem(
      id: 'sv11',
      shopId: 's5',
      name: 'Zamena flekica',
      price: 500,
      durationMinutes: 30,
    ),
    ServiceItem(
      id: 'sv12',
      shopId: 's5',
      name: 'Popravka torbe',
      price: 1500,
      durationMinutes: 45,
    ),
    ServiceItem(
      id: 'sv13',
      shopId: 's6',
      name: 'Zamena rajsferšlusa',
      price: 900,
      durationMinutes: 45,
    ),
    ServiceItem(
      id: 'sv14',
      shopId: 's6',
      name: 'Sužavanje pantalona',
      price: 1100,
      durationMinutes: 45,
    ),
  ];

  static final List<Review> reviews = [
    Review(
      id: 'r1',
      shopId: 's1',
      userId: 'u2',
      userName: 'Milica J.',
      rating: 5,
      comment: 'Izuzetno ljubazna i precizna usluga. Haljina je gotova čak i pre dogovorenog roka.',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Review(
      id: 'r2',
      shopId: 's1',
      userId: 'u3',
      userName: 'Marko P.',
      rating: 5,
      comment: 'Pantalone savršeno skraćene, preporuka.',
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
  ];

  static List<Shop> byCategory(ShopCategory c) =>
      shops.where((s) => s.category == c).toList();

  static Shop shopById(String id) => shops.firstWhere((s) => s.id == id);

  static List<ServiceItem> servicesFor(String shopId) =>
      services.where((s) => s.shopId == shopId).toList();

  static List<Review> reviewsFor(String shopId) =>
      reviews.where((r) => r.shopId == shopId).toList();
}
