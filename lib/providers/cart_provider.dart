import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<Product>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<Product>> {
  CartNotifier() : super([]) {
    loadCartFromPrefs();
  }

  Future<void> addToCart(Product product, {required int quantity}) async {
    final existingProductIndex = state.indexWhere((item) => item.id == product.id);
    if (existingProductIndex >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingProductIndex)
            state[i].copyWith(quantity: state[i].quantity + quantity)
          else
            state[i]
      ];
    } else {
      state = [...state, product.copyWith(quantity: quantity)];
    }
    await _saveCartToPrefs();
  }

  Future<void> removeFromCart(Product product) async {
    state = state.where((item) => item.id != product.id).toList();
    await _saveCartToPrefs();
  }

  Future<void> loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final cartString = prefs.getString('cart_items_$userId');
      if (cartString != null) {
        final List<dynamic> decodedCart = jsonDecode(cartString);
        state = decodedCart.map((item) => Product.fromJson(item)).toList();
      }
    }
  }

  Future<void> _saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final cartString = jsonEncode(state.map((product) => product.toJson()).toList());
      await prefs.setString('cart_items_$userId', cartString);
    }
  }

  void incrementQuantity(Product productInCart) {
    state = state.map((product) {
      if (product.id == productInCart.id) {
        return product.copyWith(quantity: product.quantity + 1);
      }
      return product;
    }).toList();
    _saveCartToPrefs();
  }

  void decrementQuantity(Product productInCart) {
    state = state.map((product) {
      if (product.id == productInCart.id && product.quantity > 1) {
        return product.copyWith(quantity: product.quantity - 1);
      }
      return product;
    }).toList();
    _saveCartToPrefs();
  }
}
