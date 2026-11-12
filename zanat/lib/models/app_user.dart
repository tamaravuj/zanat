enum UserRole { user, owner, admin }

class AppUser {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final UserRole role;
  final List<String> favoriteShopIds;

  const AppUser({
    required this.uid,
    required this.fullName,
    required this.email,
    this.phone = '',
    this.role = UserRole.user,
    this.favoriteShopIds = const [],
  });

  Map<String, dynamic> toMap() => {
    'fullName': fullName,
    'email': email,
    'phone': phone,
    'role': role.name,
    'favoriteShopIds': favoriteShopIds,
  };

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) => AppUser(
    uid: uid,
    fullName: map['fullName'] ?? '',
    email: map['email'] ?? '',
    phone: map['phone'] ?? '',
    role: UserRole.values.firstWhere(
      (r) => r.name == map['role'],
      orElse: () => UserRole.user,
    ),
    favoriteShopIds: List<String>.from(map['favoriteShopIds'] ?? []),
  );
}
