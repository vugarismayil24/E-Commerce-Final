import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';

final apiProvider = Provider((ref) => ApiService());

class ApiService {
  final Dio _dio = Dio();

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _dio.get('https://www.cheapshark.com/api/1.0/deals?storeID=2');
      if (kDebugMode) {
        print('Veri başarıyla alındı: ${response.data}');
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
      final products = await fetchProducts();
      final categories = products.map((product) => product.category).toSet().toList();
      if (kDebugMode) {
        print('Kategoriler başarıyla alındı: $categories');
      }
      return categories;
    } catch (e) {
      if (kDebugMode) {
        print('Kategori alımı başarısız: $e');
      }
      return [];
    }
  }
}




// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../models/product.dart';

// final apiProvider = Provider((ref) => ApiService());

// class ApiService {
//   final Dio _dio = Dio();

//   Future<List<Product>> fetchProducts() async {
//     try {
//       final response = await _dio.get('https://fakestoreapi.com/products');
//       if (kDebugMode) {
//       }
//       return (response.data as List).map((json) => Product.fromJson(json)).toList();
//     } catch (e) {
//       if (kDebugMode) {
//         print('Veri alımı başarısız: $e');
//       }
//       return [];
//     }
//   }

//   Future<List<String>> fetchCategories() async {
//     try {
//       final response = await _dio.get('https://fakestoreapi.com/products/categories');
//       if (kDebugMode) {
//         print('Kategoriler başarıyla alındı: ${response.data}');
//       }
//       return (response.data as List).map((category) => category.toString()).toList();
//     } catch (e) {
//       if (kDebugMode) {
//         print('Kategori alımı başarısız: $e');
//       }
//       return [];
//     }
//   }
//   Future<List<Product>> fetchProducts() async {
//     try {
//       final response = await _dio.get('https://www.cheapshark.com/api/1.0/deals?storeID=2');
//       if (kDebugMode) {
//         print('Veriler başarıyla alındı: ${response.data}');
//       }
//       return (response.data as List).map((json) => Product.fromJson(json)).toList();
//     } catch (e) {
//       if (kDebugMode) {
//         print('Veri alımı başarısız: $e');
//       }
//       return [];
//     }
//   }

//   Future<List<String>> fetchCategories() async {
//     // Bu metod boş bırakılabilir veya gereksinimlerine göre güncellenebilir
//     return [];
//   }
  
// }


