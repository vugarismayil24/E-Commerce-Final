import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

class CartNotifier extends StateNotifier<List<Product>> {
  CartNotifier() : super([]);

  void addToCart(Product product) {
    if (state.any((item) => item.title == product.title)) {
      state = [
        for (final item in state)
          if (item.title == product.title) item.copyWith(quantity: item.quantity + 1) else item
      ];
    } else {
      state = [...state, product.copyWith(quantity: 1)];
    }
  }

  void removeFromCart(Product product) {
    state = state.where((item) => item.title != product.title).toList();
  }

  void clearCart() {
    state = [];
  }

  void incrementQuantity(Product product) {
    state = [
      for (final item in state)
        if (item.title == product.title) item.copyWith(quantity: item.quantity + 1) else item
    ];
  }

  void decrementQuantity(Product product) {
    state = [
      for (final item in state)
        if (item.title == product.title && item.quantity > 1)
          item.copyWith(quantity: item.quantity - 1)
        else
          item
    ];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<Product>>((ref) {
  return CartNotifier();
});
