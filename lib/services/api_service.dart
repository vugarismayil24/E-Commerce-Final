import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';

final apiProvider = Provider((ref) => ApiService());

class ApiService {
  final Dio _dio = Dio();

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _dio.get('https://fakestoreapi.com/products');
      if (kDebugMode) {
      }
      return (response.data as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Veri alımı başarısız: $e');
      }
      return [];
    }
  }

  Future<List<String>> fetchCategories() async {
    try {
      final response = await _dio.get('https://fakestoreapi.com/products/categories');
      if (kDebugMode) {
        print('Kategoriler başarıyla alındı: ${response.data}');
      }
      return (response.data as List).map((category) => category.toString()).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Kategori alımı başarısız: $e');
      }
      return [];
    }
  }
}
