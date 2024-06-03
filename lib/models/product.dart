class Product {
  final String title;
  final String imageUrl;
  final double price;
  int quantity;

  Product({
    required this.title,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      imageUrl: json['image'],
      price: json['price'].toDouble(),
      quantity: json['quantity'] ?? 1, 
    );
  }

  Product copyWith({
    String? title,
    String? imageUrl,
    double? price,
    int? quantity,
  }) {
    return Product(
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}
