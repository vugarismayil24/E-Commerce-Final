import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_provider.dart';

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
          : ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final product = favoriteItems[index];
                return ListTile(
                  leading: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(product.title),
                  subtitle: Text('${product.price} AZN'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      ref
                          .read(favoritesProvider.notifier)
                          .removeFromFavorites(product);
                    },
                  ),
                );
              },
            ),
    );
  }
}
