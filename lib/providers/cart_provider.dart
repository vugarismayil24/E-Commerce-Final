import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

class CartNotifier extends StateNotifier<List<Product>> {
  CartNotifier() : super([]);

  void addToCart(Product product, {int quantity = 1}) {
    final existingProduct = state.firstWhere(
      (item) => item.title == product.title,
      orElse: () => Product(title: '', imageUrl: '', price: 0, quantity: 0, description: '', category: ''),
    );

    if (existingProduct.title.isNotEmpty) {
      state = [
        for (final item in state)
          if (item.title == product.title)
            item.copyWith(quantity: item.quantity + quantity)
          else
            item
      ];
    } else {
      state = [...state, product.copyWith(quantity: quantity)];
    }
  }

  void removeFromCart(Product product) {
    state = state.where((item) => item.title != product.title).toList();
  }

  void clearCart() {
    state = [];
  }

  void updateQuantity(Product product, int change) {
    state = state.map((item) {
      if (item.title == product.title) {
        final newQuantity = item.quantity + change;
        return item.copyWith(quantity: newQuantity > 0 ? newQuantity : 1);
      }
      return item;
    }).toList();
  }

  void incrementQuantity(Product product) => updateQuantity(product, 1);
  void decrementQuantity(Product product) => updateQuantity(product, -1);
}

final cartProvider = StateNotifierProvider<CartNotifier, List<Product>>((ref) {
  return CartNotifier();
});
