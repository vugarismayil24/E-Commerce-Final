class Product {
  final String? id;
  final String title;
  final String imageUrl;
  final double price;
  final String description;
  final String category;
  final String? gameID; // Yeni eklenen gameID
  int quantity;

  Product({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.category,
    required this.gameID, // gameID'yi constructor'a ekledik
    this.quantity = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['dealID'] ?? '', // API'den gelen ID
      title: json['title'] ?? '',
      imageUrl: json['thumb'] ?? '',
      price: double.tryParse(json['salePrice']) ?? 0.0,
      description: json['dealID'] ?? '',
      category: 'Games',
      gameID: json['gameID'] ?? '', // gameID'yi JSON'dan alıyoruz
      quantity: 1,
    );
  }

  get status => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'price': price,
      'description': description,
      'category': category,
      'gameID': gameID, // gameID'yi JSON'a ekliyoruz
      'quantity': quantity,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String documentId) {
    return Product(
      id: documentId,
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: map['price'] ?? 0.0,
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      gameID: map['gameID'] ?? '', // gameID'yi map'ten alıyoruz
      quantity: map['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'price': price,
      'description': description,
      'category': category,
      'gameID': gameID, // gameID'yi map'e ekliyoruz
      'quantity': quantity,
    };
  }

  Product copyWith({
    String? id,
    String? title,
    String? imageUrl,
    double? price,
    String? description,
    String? category,
    String? gameID,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      gameID: gameID ?? this.gameID, // gameID'yi copyWith için ekledik
      quantity: quantity ?? this.quantity,
    );
  }
}
