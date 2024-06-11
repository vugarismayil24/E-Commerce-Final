class Product {
  final String title;
  final String imageUrl;
  final double price;
  final String description;  // Description field might not be directly available; you can set it to a default value or another appropriate field.
  final String category;  // You might want to set this to a default value since CheapShark API might not provide categories.
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
      imageUrl: json['thumb'],
      price: double.parse(json['salePrice']),
      description: json['dealID'], // This can be changed to another field or default value.
      category: 'Games',  // This is a default value. You can change it if needed.
      quantity: 1,
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
