import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/locale_keys.g.dart';
import '../../providers/products_provider.dart';
import '../../widgets/product_item_widget.dart';
import '../category_products_screen/category_products_screen.dart';
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
        title: Text(LocaleKeys.Products.tr()),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Text(LocaleKeys.Filters.tr()),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildImageSlider(),
            _buildSectionTitle(LocaleKeys.WhatsNew.tr(), 'whatsNew'),
            _buildProductListSection(productsAsyncValue, 'whatsNew'),
            _buildSectionTitle(LocaleKeys.FeaturedGame.tr(), 'featured'),
            _buildFeaturedGameSection(productsAsyncValue, 'featured'),
            _buildSectionTitle(LocaleKeys.PopularGames.tr(), 'popular'),
            _buildProductListSection(productsAsyncValue, 'popular'),
            _buildSectionTitle(LocaleKeys.Recommended.tr(), 'recommended'),
            _buildProductListSection(productsAsyncValue, 'recommended'),
            _buildSectionTitle(LocaleKeys.ComingSoon.tr(), 'comingSoon'),
            _buildProductListSection(productsAsyncValue, 'comingSoon'),
            _buildSectionTitle(LocaleKeys.DiscountedGames.tr(), 'discounted'),
            _buildProductListSection(productsAsyncValue, 'discounted'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String section) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            color: sectionLastItemVisible[section]! ? Colors.green : Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryProductsScreen(section: section),
                ),
              );
            },
          ),
        ],
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
        height: 350.h,
        clipBehavior: Clip.none,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 2.0,
        onPageChanged: (index, reason) {
          setState(() {});
        },
      ),
      items: imgList
          .map((item) => Center(
                child: Image.asset(
                  item,
                  fit: BoxFit.contain,
                  width: 1000.w,
                  height: 500,
                ),
              ))
          .toList(),
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
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                setState(() {
                  sectionLastItemVisible[section] = true;
                });
              } else {
                setState(() {
                  sectionLastItemVisible[section] = false;
                });
              }
              return true;
            },
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: limitedProducts.length,
              itemBuilder: (context, index) {
                final product = limitedProducts[index];
                return ProductItem(product: product, isFeatured: false);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Xetan burdadi: $error')),
      ),
    );
  }

  Widget _buildFeaturedGameSection(AsyncValue productsAsyncValue, String section) {
    return SizedBox(
      height: 300.h,
      child: productsAsyncValue.when(
        data: (products) {
          final product = products.isNotEmpty ? products[0] : null;
          if (product == null) {
            return Center(child: Text(LocaleKeys.NoProductsAvailable.tr()));
          }
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                setState(() {
                  sectionLastItemVisible[section] = true;
                });
              } else {
                setState(() {
                  sectionLastItemVisible[section] = false;
                });
              }
              return true;
            },
            child: ProductItem(product: product, isFeatured: true),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error Message: $error')),
      ),
    );
  }

  List _getSectionProducts(List products, String section) {
    return products;
  }
}

