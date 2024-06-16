import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/products_provider.dart';
import '../../widgets/product_item_widget.dart';

class CategoryProductsScreen extends ConsumerWidget {
  final String section;

  const CategoryProductsScreen({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsyncValue = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: productsAsyncValue.when(
        data: (products) {
          List sectionProducts = products.where((product) => product.category == section).toList();
          if (sectionProducts.isEmpty) {
            return const Center(child: Text('No products available'));
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
            ),
            itemCount: sectionProducts.length,
            itemBuilder: (context, index) {
              final product = sectionProducts[index];
              return ProductItem(product: product, isFeatured: false);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
