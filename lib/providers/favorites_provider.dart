import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

class FavoritesNotifier extends StateNotifier<List<Product>> {
  FavoritesNotifier() : super([]);

  void addToFavorites(Product product) {
    if (!state.contains(product)) {
      state = [...state, product];
    }
  }

  void removeFromFavorites(Product product) {
    state = state.where((item) => item != product).toList();
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Product>>((ref) {
  return FavoritesNotifier();
});
