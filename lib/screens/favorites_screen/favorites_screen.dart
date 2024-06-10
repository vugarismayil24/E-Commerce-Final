import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/favorites_provider.dart';
import '../product_details_screen/product_detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteItems = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoriler'),
      ),
      body: favoriteItems.isEmpty
          ? const Center(
              child: Text('Favori öğe yok'),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ListView.builder(
                itemCount: favoriteItems.length,
                itemBuilder: (context, index) {
                  final product = favoriteItems[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10),
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          strokeAlign: 1,
                          color: const Color(0xff264653),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Image.network(
                          product.imageUrl,
                          fit: BoxFit.contain,
                          width: 50,
                          height: 50,
                        ),
                        title: Text(product.title.substring(0, 12)),
                        subtitle: Text('${product.price} AZN'),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Color(0xff264653),
                          ),
                          onPressed: () {
                            ref
                                .read(favoritesProvider.notifier)
                                .removeFromFavorites(product);
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(product: product),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
