class Review {
  final String id;
  final String shopId;
  final String userId;
  final String userName;
  final int rating; // 1-5
  final String comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.shopId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'shopId': shopId,
    'userId': userId,
    'userName': userName,
    'rating': rating,
    'comment': comment,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Review.fromMap(String id, Map<String, dynamic> map) => Review(
    id: id,
    shopId: map['shopId'] ?? '',
    userId: map['userId'] ?? '',
    userName: map['userName'] ?? '',
    rating: map['rating'] ?? 0,
    comment: map['comment'] ?? '',
    createdAt: DateTime.parse(map['createdAt']),
  );
}
