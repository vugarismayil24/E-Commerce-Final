import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/locale_keys.g.dart';
import '../../providers/products_provider.dart';
import '../../widgets/product_item_widget.dart';
import '../notification_screen/notfications_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  String selectedCategory = 'All';
  String sortOption = LocaleKeys.PriceHighToLow.tr();
  double maxPrice = 25.0; // Max price filter

  // Kategoriler listesi
  final List<String> categories = [
    'All',
    'PC',
    'Playstation',
    'Xbox',
    'Nintendo'
  ];
  final List<String> sortOptions = [
    LocaleKeys.PriceLowToHigh.tr(),
    LocaleKeys.PriceHighToLow.tr(),
  ];

  List filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _applyFiltersAndSetState(); // Initial filter application
  }

  @override
  Widget build(BuildContext context) {
    final productsAsyncValue = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.Products.tr()),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationScreen()));
            },
            icon: const Icon(Icons.notifications),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(LocaleKeys.Filters.tr()),
            ),
            ListTile(
              title: Text(LocaleKeys.SortBy.tr()),
              trailing: DropdownButton<String>(
                value: sortOption,
                onChanged: (String? newValue) {
                  setState(() {
                    sortOption = newValue!;
                  });
                  _applyFiltersAndSetState();
                },
                items:
                    sortOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              title: Text(LocaleKeys.MaxPrice.tr()),
              subtitle: Slider(
                value: maxPrice,
                min: 1,
                max: 50,
                divisions: 50,
                label: maxPrice.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    maxPrice = value;
                  });
                  _applyFiltersAndSetState();
                },
              ),
            ),
            ListTile(
              title: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _applyFiltersAndSetState(); // Apply filters when 'Apply Filters' button is pressed
                },
                child: Text(LocaleKeys.ApplyFilters.tr()),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCategorySection(),
            SizedBox(height: 10.h), // Kategori ve slider arasındaki boşluk
            _buildImageSlider(), // Yeni eklenen slider
            SizedBox(height: 10.h), // Slider ve WhatsNew arasındaki boşluk
            _buildSectionTitle(LocaleKeys.WhatsNew.tr()),
            _buildProductListSection(productsAsyncValue, 'whatsNew'),
            _buildSectionTitle(LocaleKeys.FeaturedGame.tr()),
            _buildFeaturedGameSection(productsAsyncValue),
            _buildSectionTitle(LocaleKeys.PopularGames.tr()),
            _buildProductListSection(productsAsyncValue, 'popular'),
            _buildSectionTitle(LocaleKeys.Recommended.tr()),
            _buildProductListSection(productsAsyncValue, 'recommended'),
            _buildSectionTitle(LocaleKeys.ComingSoon.tr()),
            _buildProductListSection(productsAsyncValue, 'comingSoon'),
            _buildSectionTitle(LocaleKeys.Genres.tr()),
            _buildGenresSection(),
            _buildSectionTitle(LocaleKeys.DiscountedGames.tr()),
            _buildProductListSection(productsAsyncValue, 'discounted'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      height: 60.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: categories
            .map((category) => _buildCategoryButton(category))
            .toList(),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCategory = category;
            _applyFiltersAndSetState(); // Kategori değiştiğinde filtreleri uygula
          });
        },
        child: Text(category),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              // Bu bölümün tüm ürünlerini göster
            },
          )
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
        height: 200.h, // Yüksekliği küçülttük
        clipBehavior: Clip.none,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 2.0,
        onPageChanged: (index, reason) {
          setState(() {
            // Eğer slider'da herhangi bir aksiyon yapmak isterseniz
          });
        },
      ),
      items: imgList
          .map((item) => Container(
                child: Center(
                  child: Image.asset(
                    item,
                    fit: BoxFit.cover,
                    width: 1000.w,
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildProductListSection(AsyncValue productsAsyncValue, String section) {
    return Container(
      height: 280.h, // Yüksekliği optimize ettik
      child: productsAsyncValue.when(
        data: (products) {
          List sectionProducts = _getSectionProducts(products, section);
          if (sectionProducts.isEmpty) {
            return Center(child: Text(LocaleKeys.NoProductsAvailable.tr()));
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sectionProducts.length,
            itemBuilder: (context, index) {
              final product = sectionProducts[index];
              return ProductItem(product: product, isFeatured: false);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Xetan burdadi: $error')),
      ),
    );
  }

  Widget _buildFeaturedGameSection(AsyncValue productsAsyncValue) {
    return Container(
      height: 300.h,
      child: productsAsyncValue.when(
        data: (products) {
          // Öne çıkan oyunu al (örneğin, ilk ürün)
          final product = products.isNotEmpty ? products[0] : null;
          if (product == null) {
            return Center(child: Text(LocaleKeys.NoProductsAvailable.tr()));
          }
          return ProductItem(product: product, isFeatured: true);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Xetan burdadi: $error')),
      ),
    );
  }

  Widget _buildGenresSection() {
    return Container(
      height: 100.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildGenreCard('Action'),
          _buildGenreCard('Adventure'),
          _buildGenreCard('Role-Playing'),
          // Diğer türler...
        ],
      ),
    );
  }

  Widget _buildGenreCard(String genre) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Center(
          child: Text(genre),
        ),
      ),
    );
  }

  List _getSectionProducts(List products, String section) {
    // Bu fonksiyon, bölüm adıyla uyumlu ürünleri döner
    // Örneğin, 'whatsNew', 'popular', 'recommended' vb.
    List sectionProducts = products.where((product) {
      switch (selectedCategory) {
        case 'PC':
          return product.category == 'PC' && product.price <= 5.0;
        case 'Playstation':
          return product.category == 'Playstation' && product.price <= 10.0;
        case 'Xbox':
          return product.category == 'Xbox' && product.price <= 15.0;
        case 'Nintendo':
          return product.category == 'Nintendo' && product.price > 15.0;
        default:
          return true;
      }
    }).toList();

    return sectionProducts;
  }

  List _applyFilters(List products) {
    List filteredProducts = products.where((product) {
      if (selectedCategory == 'PC' && (product.price > 5.0 || product.price > maxPrice)) {
        return false;
      } else if (selectedCategory == 'Playstation' && (product.price > 10.0 || product.price > maxPrice)) {
        return false;
      } else if (selectedCategory == 'Xbox' && (product.price > 15.0 || product.price > maxPrice)) {
        return false;
      } else if (selectedCategory == 'Nintendo' && (product.price <= 15.0 || product.price > maxPrice)) {
        return false;
      } else if (product.price > maxPrice) {
        return false;
      }
      return true;
    }).toList();

    filteredProducts.sort((a, b) {
      if (sortOption == LocaleKeys.PriceLowToHigh.tr()) {
        return a.price.compareTo(b.price);
      } else if (sortOption == LocaleKeys.PriceHighToLow.tr()) {
        return b.price.compareTo(a.price);
      }
      return 0;
    });

    return filteredProducts;
  }

  void _applyFiltersAndSetState() {
    final productsAsyncValue = ref.read(productsProvider);

    productsAsyncValue.whenData((products) {
      setState(() {
        filteredProducts = _applyFilters(products);
      });
    });
  }
}
