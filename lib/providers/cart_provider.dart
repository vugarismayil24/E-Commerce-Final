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
    state = [...state, product];
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

  void decrementQuantity(Product productInCart) {}
}
