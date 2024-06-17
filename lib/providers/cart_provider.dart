import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class CartNotifier extends StateNotifier<List<Product>> {
  CartNotifier() : super([]) {
    loadCart();
  }

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
    saveCart();
  }

  void removeFromCart(Product product) {
    state = state.where((item) => item.title != product.title).toList();
    saveCart();
  }

  void clearCart() {
    state = [];
    saveCart();
  }

  void updateQuantity(Product product, int change) {
    state = state.map((item) {
      if (item.title == product.title) {
        final newQuantity = item.quantity + change;
        return item.copyWith(quantity: newQuantity > 0 ? newQuantity : 1);
      }
      return item;
    }).toList();
    saveCart();
  }

  void incrementQuantity(Product product) => updateQuantity(product, 1);
  void decrementQuantity(Product product) => updateQuantity(product, -1);

  Future<void> loadCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartRef = FirebaseFirestore.instance.collection('carts').doc(user.email);
      final cartDoc = await cartRef.get();
      if (cartDoc.exists) {
        final List<dynamic> cartJson = cartDoc.data()?['items'] ?? [];
        state = cartJson.map((json) => Product.fromJson(json)).toList();
        if (kDebugMode) {
          print("Loaded cart from Firestore: $state");
        }
      } else {
        if (kDebugMode) {
          print("No cart data found in Firestore for user: ${user.email}");
        }
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString('cart') ?? '[]';
      final List<dynamic> cartJson = jsonDecode(cartString);
      state = cartJson.map((json) => Product.fromJson(json)).toList();
      if (kDebugMode) {
        print("Loaded cart from SharedPreferences: $state");
      }
    }
  }

  Future<void> saveCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartRef = FirebaseFirestore.instance.collection('carts').doc(user.email);
      await cartRef.set({
        'items': state.map((product) => product.toJson()).toList(),
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      final cartString = jsonEncode(state.map((product) => product.toJson()).toList());
      await prefs.setString('cart', cartString);
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<Product>>((ref) {
  return CartNotifier();
});
