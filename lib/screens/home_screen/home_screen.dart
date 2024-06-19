import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/locale_keys.g.dart';
import '../../providers/products_provider.dart';
import '../../widgets/product_item_widget.dart';
import '../category_products_screen/category_products_screen.dart';
import '../discount_screen/discount_screen.dart';
import '../profile_setting_screen/profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  final Map<String, bool> sectionLastItemVisible = {
    'whatsNew': false,
    'featured': false,
    'popular': false,
    'recommended': false,
    'comingSoon': false,
    'discounted': false,
  };

  @override
  Widget build(BuildContext context) {
    final productsAsyncValue = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("MCOM STORE"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildImageSlider(),
            _buildMinOffBanner(),
            _buildSectionTitle('Deal of the day'),
            _buildProductListSection(productsAsyncValue, 'dealOfTheDay'),
            _buildSectionTitle('Hot Selling Footwear'),
            _buildProductListSection(productsAsyncValue, 'hotSellingFootwear'),
            _buildSectionTitle('Recommended for you'),
            _buildProductListSection(productsAsyncValue, 'recommendedForYou'),
          ],
        ),
      ),
    );
  }

  

  Widget _buildCategoryRow() {
  final categories = [
    {'name': 'PC', 'icon': Icons.laptop},
    {'name': 'Xbox', 'icon': Icons.tablet},
    {'name': 'Nintendo', 'icon': Icons.nature_sharp},
  ];

  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: categories.map((category) {
        return Column(
          children: [
            CircleAvatar(
              child: Icon(category['icon'] as IconData),
            ),
            SizedBox(height: 5.h),
            Text(category['name'] as String),
          ],
        );
      }).toList(),
    ),
  );
}

  Widget _buildImageSlider() {
    final List<String> imgList = [
      'assets/images/jpgs/cover-180-0ff6d5.jpg',
      'assets/images/jpgs/cover-180-91231d.jpg',
      'assets/images/jpgs/cover-180-b73919.jpg',
      'assets/images/jpgs/cover-180-debfed.jpg',
      'assets/images/jpgs/cover-180-e1de87.jpg',
    ];
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.h,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 2.0,
      ),
      items: imgList
          .map((item) => Center(
                child: Image.asset(
                  item,
                  fit: BoxFit.contain,
                  width: 1000.w,
                  height: 200.h,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildMinOffBanner() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
        color: Colors.orange[100],
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Center(
          child: Column(
            children: [
              Text(
                'MIN 15% OFF',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              ElevatedButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => DiscountProductScreen(),));
                },
                child: Text('SHOP NOW'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () {},
            child: Text('View All', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildProductListSection(AsyncValue productsAsyncValue, String section) {
    return SizedBox(
      height: 250.h,
      child: productsAsyncValue.when(
        data: (products) {
          List sectionProducts = _getSectionProducts(products, section);
          if (sectionProducts.isEmpty) {
            return Center(child: Text(LocaleKeys.NoProductsAvailable.tr()));
          }
          final limitedProducts = sectionProducts.take(5).toList();
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: limitedProducts.length,
            itemBuilder: (context, index) {
              final product = limitedProducts[index];
              return ProductItem(product: product, isFeatured: false);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  List _getSectionProducts(List products, String section) {
    // Placeholder function, should filter products based on section
    return products;
  }
}
