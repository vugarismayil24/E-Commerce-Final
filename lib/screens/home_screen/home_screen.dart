import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../models/product.dart';
import '../../providers/category_provider.dart';
import '../../widgets/product_item_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this); // Initialize with 0 tabs, will be updated
    _loadCategories();
  }

  void _loadCategories() {
    final categoriesAsyncValue = ref.read(myCategoriesProvider);

    categoriesAsyncValue.when(
      data: (categories) {
        setState(() {
          _tabController = TabController(length: categories.length + 1, vsync: this); // +1 for "All" tab
        });
      },
      loading: () {},
      error: (error, stack) {
        if (kDebugMode) {
          print('Error: $error');
        }
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsyncValue = ref.watch(myProductsProvider);
    final categoriesAsyncValue = ref.watch(myCategoriesProvider);

    return categoriesAsyncValue.when(
      data: (categories) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Products'),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: [
                Tab(text: 'All'),
                ...categories.map((category) => Tab(text: category)).toList(),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildProductsGrid(productsAsyncValue, 'All'),
              ...categories.map((category) => _buildProductsGrid(productsAsyncValue, category)).toList(),
            ],
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(body: Center(child: Text('Error: $error'))),
    );
  }

  Widget _buildProductsGrid(AsyncValue<List<Product>> productsAsyncValue, String category) {
    return productsAsyncValue.when(
      data: (products) {
        final filteredProducts = category == 'All'
            ? products
            : products.where((product) => product.category == category).toList();
        return GridView.builder(
          padding: EdgeInsets.all(10.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 3,
            crossAxisSpacing: 10.h,
            mainAxisSpacing: 10.w,
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
    );
  }
}
