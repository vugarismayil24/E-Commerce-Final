import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiProvider = Provider((ref) => ApiService());

class ApiService {
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await _dio.get('https://fakestoreapi.com/products');
      if (kDebugMode) {
        print('Data fetched successfully: ${response.data}');
      }
      return response.data;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch data: $e');
      }
      return [];
    }
  }
}
