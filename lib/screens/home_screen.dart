import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee/marquee.dart';
import '../providers/category_provider.dart';
import '../widgets/product_item_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ProductListScreenState createState() => ProductListScreenState();
}

class ProductListScreenState extends ConsumerState<HomeScreen> {
  String selectedCategory = 'All';

  void _showCategoriesModal(BuildContext context) {
    final categoriesAsyncValue = ref.watch(myCategoriesProvider);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return categoriesAsyncValue.when(
          data: (categories) {
            return ListView.builder(
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                final category = index == 0 ? 'All' : categories[index - 1];
                return ListTile(
                  title: Text(category),
                  selected: selectedCategory == category,
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                    Navigator.pop(context); 
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
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () => _showCategoriesModal(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xff2A9D8F),
            height: 30.h, // Responsive height
            child: Marquee(
              text: 'Ürün detay sayfasındasınız. Ürüne dair bilgileri aşağıda bulabilirsiniz.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff),
                fontSize: 14.sp, // Responsive font size
              ),
              scrollAxis: Axis.horizontal,
              blankSpace: 20.0.w, // Responsive blank space
              velocity: 100.0.w, // Responsive velocity
              pauseAfterRound: const Duration(seconds: 1),
              startPadding: 10.0.w, // Responsive start padding
              accelerationDuration: const Duration(seconds: 1),
              accelerationCurve: Curves.linear,
              decelerationDuration: const Duration(milliseconds: 1200),
              decelerationCurve: Curves.easeOut,
            ),
          ),
          Expanded(
            child: productsAsyncValue.when(
              data: (products) {
                final filteredProducts = selectedCategory == 'All'
                    ? products
                    : products.where((product) => product.category == selectedCategory).toList();
                return GridView.builder(
                  padding: EdgeInsets.all(10.w), // Responsive padding
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 10.h, // Responsive cross axis spacing
                    mainAxisSpacing: 10.w, // Responsive main axis spacing
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
          ),
        ],
      ),
    );
  }
}
