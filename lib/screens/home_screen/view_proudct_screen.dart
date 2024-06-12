import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/seller_provider.dart';

class ViewProductsScreen extends ConsumerWidget {
  const ViewProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürünlere Bak'),
      ),
      body: products.isEmpty
          ? const Center(child: Text('Gösterilecek ürün yok'))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fiyat: ${product.price}'),
                      Text('Kategori: ${product.category}'),
                      Text('Açıklama: ${product.description}'),
                      Text('Miktar: ${product.quantity}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
