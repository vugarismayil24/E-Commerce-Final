import 'package:e_com_app/screens/home_screen/view_proudct_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../models/product_model.dart';
import '../../providers/seller_provider.dart';
import '../../widgets/product_item_widget.dart';
import '../seller_screens/add_product_screen.dart';
import '../seller_screens/edit_product_screen.dart';
import '../seller_screens/remove_products_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  String selectedCategory = 'All';

  // Kategoriler listesi
  final List<String> categories = ['All', 'Under \$10', 'Free'];

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);
    final userRole = ref.watch(userRoleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        automaticallyImplyLeading: false,
        actions: [
          if (userRole == 'seller')
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return MenuDrawer(products: products);
                  },
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Carousel Slider for Categories
          CarouselSlider(
            options: CarouselOptions(
              height: 30.h,
              autoPlay: true,
              enlargeCenterPage: false,
              viewportFraction: 0.5,
            ),
            items: categories.map((category) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = category;
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0.w),
                  decoration: BoxDecoration(
                    color: selectedCategory == category
                        ? Colors.blueAccent
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Center(
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: selectedCategory == category
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20.h), // 20 piksel mesafe
          // Products Grid
          Expanded(
            child: products.isEmpty
                ? const Center(child: Text('No products available'))
                : GridView.builder(
                    padding: EdgeInsets.all(10.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: 10.h,
                      mainAxisSpacing: 10.w,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductItem(product: product);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class MenuDrawer extends StatelessWidget {
  final List<Product> products;

  MenuDrawer({required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text('Menü'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: const Text('Ürün Ekle'),
              onTap: () {
                Navigator.pop(context); // Menü kapat
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Ürün Düzenle'),
              onTap: () {
                Navigator.pop(context); // Menü kapat
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ListTile(
                          title: Text(product.title),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProductScreen(
                                  index: index,
                                  product: product,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
            ListTile(
              title: const Text('Ürün Sil'),
              onTap: () {
                Navigator.pop(context); // Menü kapat
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeleteProductScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Ürünlere Bak'),
              onTap: () {
                Navigator.pop(context); // Menü kapat
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewProductsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
