class LocalProduct {
  final String name;
  final String barcode;
  final String? nutriscore;
  final String? imageUrl;

  LocalProduct({
    required this.name,
    required this.barcode,
    required this.nutriscore,
    this.imageUrl,
  });

  factory LocalProduct.fromJson(Map<String, dynamic> json) {
    return LocalProduct(
      name: json['name'],
      barcode: json['barcode'],
      nutriscore: json['nutriscore'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name ?? '',
      'barcode': barcode ?? '',
      'nutriscore': nutriscore ?? '',
      'image_url': imageUrl ?? '',
    };
  }
}
