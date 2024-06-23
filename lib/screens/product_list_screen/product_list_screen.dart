import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product_model.dart';
import '../../widgets/product_item_widget.dart';

class ProductListScreen extends ConsumerWidget {
  final String sectionTitle;
  final List<Product> sectionProducts;

  const ProductListScreen({super.key, 
    required this.sectionTitle,
    required this.sectionProducts,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sectionTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.75,
              ),
              itemCount: sectionProducts.length,
              itemBuilder: (context, index) {
                final product = sectionProducts[index];
                return ProductItem(product: product, isFeatured: true);
              },
            ),
          ),
        ],
      ),
    );
  }
}
