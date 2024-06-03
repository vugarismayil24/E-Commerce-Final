class Product {
  final String title;
  final String imageUrl;
  final double price;
  final String description;
  final String category;
  int quantity;

  Product({
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.category,
    this.quantity = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      imageUrl: json['image'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      quantity: json['quantity'] ?? 1,
    );
  }

  Product copyWith({
    String? title,
    String? imageUrl,
    double? price,
    String? description,
    String? category,
    int? quantity,
  }) {
    return Product(
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
    );
  }
}
