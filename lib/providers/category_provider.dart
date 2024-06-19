import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

final myProductsProvider = FutureProvider<List<Product>>((ref) async {
  final apiService = ref.read(apiProvider);
  return apiService.fetchProducts();
});

final myCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final apiService = ref.read(apiProvider);
  return apiService.fetchCategories();
});

