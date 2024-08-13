class UserStock {
  final String? userId;
  final String productId;
  final String quantity;
  final String date;

  UserStock(
      {required this.userId,
      required this.productId,
      required this.quantity,
      required this.date});

  factory UserStock.fromJson(Map<String, dynamic> json) {
    return UserStock(
      userId: json['user_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      date: json['expiration_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
      'expiration_date': date,
    };
  }
}
