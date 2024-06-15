import 'package:e_com_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  // Kategoriler listesi (sadece 'All' kaldı)
  final String category = 'All';
  final List<String> sortOptions = [
    LocaleKeys.PriceLowToHigh.tr(),
    LocaleKeys.PriceHighToLow.tr(),
  ];

  List filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _applyFilters(filteredProducts); // Initial filter application
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
      body: Column(
        children: [
          Expanded(
            child: productsAsyncValue.when(
              data: (products) {
                if (products.isEmpty) {
                  return Center(
                      child: Text(LocaleKeys.NoProductsAvailable.tr()));
                }

                filteredProducts = _applyFilters(products);

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
              error: (error, stack) => Center(child: Text('Xetan burdadi: $error')),
            ),
          ),
        ],
      ),
    );
  }

  List _applyFilters(List products) {
    List filteredProducts = products.where((product) {
      if (product.price > maxPrice) {
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