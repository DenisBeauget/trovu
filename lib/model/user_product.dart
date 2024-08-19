class UserProduct {
  final String name;
  final int quantity;
  final String? nutriscore;
  final String? date;
  final String? imageUrl;

  UserProduct({
    required this.name,
    required this.nutriscore,
    required this.quantity,
    this.date,
    this.imageUrl,
  });

  factory UserProduct.fromJson(Map<String, dynamic> json) {
    return UserProduct(
      name: json['name'],
      nutriscore: json['nutriscore'],
      quantity: json['quantity'],
      date: json['date'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nutriscore': nutriscore,
      'quantity': quantity,
      'date': date,
      'image_url': imageUrl,
    };
  }
}
