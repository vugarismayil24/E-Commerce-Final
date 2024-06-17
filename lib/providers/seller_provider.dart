import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';

// Kullanıcı rolü için provider
final userRoleProvider = StateProvider<String>((ref) {
  return 'customer'; // Varsayılan olarak 'customer' (müşteri) rolü
});

// Ürün yönetimi için StateNotifier ve StateNotifierProvider
class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  void addProduct(Product product) {
    state = [...state, product];
  }

  void editProduct(int index, Product updatedProduct) {
    final products = [...state];
    products[index] = updatedProduct;
    state = products;
  }

  void removeProduct(int index) {
    final products = [...state];
    products.removeAt(index);
    state = products;
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, List<Product>>((ref) {
  return ProductNotifier();
});
