import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/product_model.dart';
import '../../providers/products_provider.dart';
import '../../widgets/bottom_navigation_bar_widget.dart';
import '../../widgets/slider_widget.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends ConsumerState<SearchScreen> {
  late TextEditingController _searchController;
  String _searchQuery = '';
  String _selectedFilter = 'Ucuzdan Pahalıya';
  double? _minPrice;
  double? _maxPrice;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterDialog() {
    TextEditingController minPriceController = TextEditingController();
    TextEditingController maxPriceController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20.h),
          height: 300.h,
          child: Column(
            children: <Widget>[
              ListTile(
                title: const Text('Ucuzdan Pahalıya'),
                onTap: () {
                  setState(() {
                    _selectedFilter = 'Ucuzdan Pahalıya';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Pahalıdan Ucuza'),
                onTap: () {
                  setState(() {
                    _selectedFilter = 'Pahalıdan Ucuza';
                  });
                  Navigator.pop(context);
                },
              ),
              TextField(
                controller: minPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Minimum Fiyat',
                ),
              ),
              TextField(
                controller: maxPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Maksimum Fiyat',
                ),
              ),
              ElevatedButton(
                child: const Text('Uygula'),
                onPressed: () {
                  setState(() {
                    _minPrice = double.tryParse(minPriceController.text);
                    _maxPrice = double.tryParse(maxPriceController.text);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  List<Product> _filterProducts(List<Product> products) {
    List<Product> filteredProducts = products;

    if (_selectedFilter == 'Ucuzdan Pahalıya') {
      filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else {
      filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    }

    if (_minPrice != null) {
      filteredProducts = filteredProducts.where((product) => product.price >= _minPrice!).toList();
    }

    if (_maxPrice != null) {
      filteredProducts = filteredProducts.where((product) => product.price <= _maxPrice!).toList();
    }

    return filteredProducts;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productsAsyncValue = ref.watch(productsProvider);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavigationBarWidget()),
        );
        return false;
      },
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: theme.appBarTheme.backgroundColor,
              title: SizedBox(
                height: 40.h,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.r)),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                    filled: true,
                    fillColor: theme.cardColor,
                  ),
                  style: theme.textTheme.bodyLarge,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilterDialog,
                ),
              ],
            ),
            body: productsAsyncValue.when(
              data: (products) {
                List<Product> filteredProducts = _filterProducts(products);

                final searchResults = filteredProducts
                    .where((product) => product.title.toLowerCase().contains(_searchQuery))
                    .toList();

                return SliderWidget(
                  discountProducts: filteredProducts,
                  searchResults: searchResults,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          );
        },
      ),
    );
  }
}
