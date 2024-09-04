class UserProduct {
  final String productId;
  final String name;
  int quantity;
  final String? nutriscore;
  final String? date;
  final String? imageUrl;

  UserProduct({
    required this.productId,
    required this.name,
    required this.nutriscore,
    required this.quantity,
    this.date,
    this.imageUrl,
  });

  factory UserProduct.fromJson(Map<String, dynamic> json) {
    return UserProduct(
      productId: json['product_id'],
      name: json['name'],
      nutriscore: json['nutriscore'],
      quantity: json['quantity'],
      date: json['date'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      'name': name,
      'nutriscore': nutriscore,
      'quantity': quantity,
      'date': date,
      'image_url': imageUrl,
    };
  }
}
