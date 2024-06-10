import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../providers/category_provider.dart';
import '../../widgets/product_item_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
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
          error: (error, stack) {
            if (kDebugMode) {
              print('Error: $error');
            }
            print('Stack: $stack');
            return Center(child: Text('Error: $error'));
          },
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
          SizedBox(height: 10.h),
          productsAsyncValue.when(
            data: (products) {
              final filteredProducts = selectedCategory == 'All'
                  ? products
                  : products.where((product) => product.category == selectedCategory).toList();
              return CarouselSlider(
                options: CarouselOptions(
                  height: 150.h,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 1.5,
                  viewportFraction: 0.3, 
                  onPageChanged: (index, reason) {
                    setState(() {
                    });
                  },
                ),
                items: filteredProducts.map((product) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.0.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: Image.network(
                                product.imageUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Flexible(
                              child: Text(
                                product.title.substring(0, 10),
                                style: TextStyle(fontSize: 12.sp), 
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Flexible(
                              child: Text(
                                '${product.price} \$',
                                style: TextStyle(fontSize: 12.sp), 
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
          Expanded(
            child: productsAsyncValue.when(
              data: (products) {
                final filteredProducts = selectedCategory == 'All'
                    ? products
                    : products.where((product) => product.category == selectedCategory).toList();
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
            ),
          ),
        ],
      ),
    );
  }
}