import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/product_model.dart';
import '../../providers/products_provider.dart';
import '../../widgets/product_item_widget.dart';
import '../product_list_screen/product_list_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  final Map<String, bool> sectionLastItemVisible = {
    'dealOfTheDay': false,
    'hotSellingFootwear': false,
    'recommendedForYou': false,
  };

  @override
  Widget build(BuildContext context) {
    final productsAsyncValue = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("MCOM STORE"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            _buildCategoryCarousel(productsAsyncValue),
            
            
            _buildInfoSection(),
            _buildSectionTitle('Deal of the day', 'dealOfTheDay', productsAsyncValue),
            _buildProductCarousel(productsAsyncValue, 'dealOfTheDay'),
            _buildSectionTitle('Hot Selling Footwear', 'hotSellingFootwear', productsAsyncValue),
            _buildProductCarousel(productsAsyncValue, 'hotSellingFootwear'),
            _buildSectionTitle('Recommended for you', 'recommendedForYou', productsAsyncValue),
            _buildProductCarousel(productsAsyncValue, 'recommendedForYou'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      color: const Color(0xFFFCECDD),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 30.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.local_shipping, size: 24),
                  const SizedBox(width: 5),
                  Text('Ücretsiz kargo', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                ],
              ),
              Text('Sınırlı süreli teklif', style: TextStyle(fontSize: 14.sp)),
            ],
          ),
          const VerticalDivider(color: Colors.black),
          Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.assignment_return, size: 24),
                  const SizedBox(width: 5),
                  Text('Ücretsiz iade', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                ],
              ),
              Text('90 gün içinde', style: TextStyle(fontSize: 14.sp)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCarousel(AsyncValue<List<Product>> productsAsyncValue) {
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'Deal of the day',
        'icon': Icons.local_offer,
        'section': 'dealOfTheDay',
      },
      {
        'title': 'Hot Selling',
        'icon': Icons.local_fire_department,
        'section': 'hotSellingFootwear',
      },
      {
        'title': 'Recommended',
        'icon': Icons.thumb_up,
        'section': 'recommendedForYou',
      },
    ];

    return CarouselSlider.builder(
      options: CarouselOptions(
        height: 120.h,
        autoPlay: false,
        enlargeCenterPage: true,
        viewportFraction: 0.3,
        aspectRatio: 2.0,
        scrollDirection: Axis.horizontal,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index, realIndex) {
        final category = categories[index];
        return _buildCategoryIcon(productsAsyncValue, category['section'], category['icon'], category['title']);
      },
    );
  }

  Widget _buildCategoryIcon(AsyncValue<List<Product>> productsAsyncValue, String section, IconData icon, String title) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            productsAsyncValue.whenData((products) {
              List<Product> sectionProducts = _getSectionProducts(products, section);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListScreen(
                    sectionTitle: title,
                    sectionProducts: sectionProducts,
                  ),
                ),
              );
            });
          },
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green,
            child: Icon(icon, size: 30, color: Colors.white),
          ),
        ),
        const SizedBox(height: 5),
        Text(title, style: TextStyle(fontSize: 14.sp)),
      ],
    );
  }

  Widget _buildSectionTitle(String title, String section, AsyncValue<List<Product>> productsAsyncValue) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () {
              productsAsyncValue.whenData((products) {
                List<Product> sectionProducts = _getSectionProducts(products, section);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductListScreen(
                      sectionTitle: title,
                      sectionProducts: sectionProducts,
                    ),
                  ),
                );
              });
            },
            child: const Icon(Icons.arrow_forward_sharp),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCarousel(AsyncValue<List<Product>> productsAsyncValue, String section) {
    return SizedBox(
      height: 250.h,
      child: productsAsyncValue.when(
        data: (products) {
          List<Product> sectionProducts = _getSectionProducts(products, section);
          if (sectionProducts.isEmpty) {
            return const Center(child: Text('No Products Available'));
          }
          return CarouselSlider.builder(
            options: CarouselOptions(
              height: 250.h,
              autoPlay: false,
              enlargeCenterPage: false,
              viewportFraction: 0.5,
              scrollDirection: Axis.horizontal,
              enableInfiniteScroll: true,
            ),
            itemCount: sectionProducts.length,
            itemBuilder: (context, index, realIndex) {
              final product = sectionProducts[index];
              return ProductItem(product: product, isFeatured: true);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  List<Product> _getSectionProducts(List<Product> products, String section) {
    return products;
  }
}
