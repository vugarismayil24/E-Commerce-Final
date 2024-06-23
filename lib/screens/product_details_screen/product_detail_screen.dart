// ignore_for_file: unused_element, unused_local_variable

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../widgets/bottom_navigation_bar_widget.dart';

List<String> gameGenres = [
  'Aksiyon', 'Macera', 'Rol Yapma', 'Strateji', 'Simülasyon', 'Yarış', 'Spor', 'Korku'
];

List<String> gameFeatures = [
  'çok oyunculu', 'açık dünya', 'hikaye odaklı', 'grafiksel olarak zengin', 'bağımlılık yapan', 'yenilikçi oyun mekanikleri'
];

List<String> gameObjectives = [
  'düşmanları alt etmek', 'bulmacaları çözmek', 'dünyayı kurtarmak', 'yeni bölgeleri keşfetmek', 'takımınızı yönetmek', 'yarışları kazanmak'
];

String generateRandomGameDescription() {
  final genre = gameGenres[Random().nextInt(gameGenres.length)];
  final feature = gameFeatures[Random().nextInt(gameFeatures.length)];
  final objective = gameObjectives[Random().nextInt(gameObjectives.length)];

  return "Bu $genre oyununda, $feature oyun mekanikleri ile $objective amacına ulaşmanız gerekiyor.";
}


List<String> generateRandomNames(int count) {
  final names = [
    'Ahmet', 'Mehmet', 'Ayşe', 'Fatma', 'Ali', 'Veli', 'Osman', 'Hüseyin', 'Yusuf', 'Zeynep'
  ];
  return List<String>.generate(count, (_) => names[Random().nextInt(names.length)]);
}

List<String> generateRandomComments(int count, double rating) {
  final goodComments = [
    'Harika!', 'Çok iyi', 'Beğendim', 'Mükemmel!', 'Kesinlikle öneririm', 'Bir daha alırım'
  ];
  final badComments = [
    'İdare eder', 'Kötü', 'Memnun kalmadım', 'Hayal kırıklığı', 'Berbat', 'Asla önermem'
  ];
  
  return List<String>.generate(
    count, 
    (_) => rating > 2.5 
      ? goodComments[Random().nextInt(goodComments.length)] 
      : badComments[Random().nextInt(badComments.length)]
  );
}

double generateRandomRating() {
  return Random().nextDouble() * 5;
}

int generateStarRating(double rating) {
  if (rating > 4.5) {
    return 5;
  } else if (rating > 3.5) {
    return 4;
  } else if (rating > 2.5) {
    return 3;
  } else if (rating > 1.5) {
    return 2;
  } else {
    return 1;
  }
}

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int quantity = 1;

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _addToCart() {
    ref.read(cartProvider.notifier).addToCart(widget.product, quantity: quantity);
  }

  void _toggleFavorite() {
    if (ref.read(favoritesProvider.notifier).isFavorite(widget.product)) {
      ref.read(favoritesProvider.notifier).removeFromFavorites(widget.product);
    } else {
      ref.read(favoritesProvider.notifier).addToFavorites(widget.product);
    }
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const BottomNavigationBarWidget(),
      ),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(favoritesProvider).contains(widget.product);

    final randomRating = generateRandomRating();
    final commentCount = Random().nextInt(13) + 3; 
    final randomNames = generateRandomNames(commentCount);
    final randomComments = generateRandomComments(commentCount, randomRating);
    final starRating = generateStarRating(randomRating);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Details"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const BottomNavigationBarWidget()),
              );
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 300,
                        child: PhotoView(
                          imageProvider: NetworkImage(widget.product.imageUrl),
                          backgroundDecoration: BoxDecoration(
                            color: Theme.of(context).canvasColor,
                          ),
                          minScale: PhotoViewComputedScale.contained,
                          maxScale: PhotoViewComputedScale.covered * 2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.product.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            ' ${widget.product.price} AZN',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xFFE22323),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        generateRandomGameDescription(),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xff2A9D8F),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                              onPressed: _decrementQuantity,
                            ),
                          ),
                          Text(
                            '$quantity',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xff2A9D8F),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              onPressed: _incrementQuantity,
                            ),
                          ),
                          GestureDetector(
                            onTap: _addToCart,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xff2A9D8F),
                              ),
                              child: const Text(
                                "Add to cart",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ...List.generate(
                                starRating,
                                (index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              ),
                              ...List.generate(
                                5 - starRating,
                                (index) => const Icon(
                                  Icons.star_border,
                                  color: Colors.amber,
                                ),
                              ),
                              Text(
                                randomRating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$commentCount yorum',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: List.generate(commentCount, (index) {
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(randomNames[index][0]),
                            ),
                            title: Text(randomNames[index]),
                            subtitle: Text(randomComments[index]),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
