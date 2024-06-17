import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';

class FavoritesNotifier extends StateNotifier<List<Product>> {
  FavoritesNotifier() : super([]);

  void addToFavorites(Product product) {
    if (!state.contains(product)) {
      state = [...state, product];
    }
  }

  void removeFromFavorites(Product product) {
    state = state.where((p) => p != product).toList();
  }

  bool isFavorite(Product product) {
    return state.contains(product);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<Product>>((ref) {
  return FavoritesNotifier();
});
