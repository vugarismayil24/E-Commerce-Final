import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../models/product.dart';

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final apiService = ref.read(apiProvider);
  final productsData = await apiService.fetchProducts();
  return productsData.map((product) => Product.fromJson(product)).toList();
});
