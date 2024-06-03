import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/category_provider.dart';
import '../widgets/product_item_widget.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends ConsumerState<ProductListScreen> {
  String selectedCategory = 'All';

  void _showCategoriesModal(BuildContext context) {
    final categoriesAsyncValue = ref.watch(myCategoriesProvider);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return categoriesAsyncValue.when(
          data: (categories) {
            return ListView.builder(
              itemCount: categories.length + 1, // "All" kategorisi için ekstra bir alan
              itemBuilder: (context, index) {
                final category = index == 0 ? 'All' : categories[index - 1];
                return ListTile(
                  title: Text(category),
                  selected: selectedCategory == category,
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                    Navigator.pop(context); // Modal'ı kapat
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsAsyncValue = ref.watch(myProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürünler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () => _showCategoriesModal(context),
          ),
        ],
      ),
      body: productsAsyncValue.when(
        data: (products) {
          final filteredProducts = selectedCategory == 'All'
              ? products
              : products.where((product) => product.category == selectedCategory).toList();
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return ProductItem(product: product);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
