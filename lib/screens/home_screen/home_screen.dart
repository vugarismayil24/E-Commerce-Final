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
  String sortOption = 'Price: Low to High';
  double maxPrice = 100.0; // Max price filter

  // Kategoriler listesi
  final List<String> categories = ['All', 'Under \$10', 'Free'];
  final List<String> sortOptions = [
    'Price: Low to High',
    'Price: High to Low',
    'A to Z',
    'Z to A'
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
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _showFilterMenu(context);
          },
        ),
        title: const Text('Products'),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      body: productsAsyncValue.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          filteredProducts = _applyFilters(products);

          return Column(
            children: [
              SizedBox(height: 20.h), // 20 piksel mesafe
              // Products Grid
              Expanded(
                child: GridView.builder(
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
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  List _applyFilters(List products) {
    List filteredProducts = products.where((product) {
      if (selectedCategory == 'Under \$10' && product.price >= 10) {
        return false;
      }
      if (selectedCategory == 'Free' && product.price > 0) {
        return false;
      }
      if (product.price > maxPrice) {
        return false;
      }
      return true;
    }).toList();

    filteredProducts.sort((a, b) {
      switch (sortOption) {
        case 'Price: Low to High':
          return a.price.compareTo(b.price);
        case 'Price: High to Low':
          return b.price.compareTo(a.price);
        case 'A to Z':
          return a.name.compareTo(b.name);
        case 'Z to A':
          return b.name.compareTo(a.name);
        default:
          return 0;
      }
    });

    return filteredProducts;
  }

  void _showFilterMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Sort by'),
                  trailing: DropdownButton<String>(
                    value: sortOption,
                    onChanged: (String? newValue) {
                      setState(() {
                        sortOption = newValue!;
                      });
                      _applyFiltersAndSetState();
                    },
                    items: sortOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  title: const Text('Category'),
                  trailing: DropdownButton<String>(
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                      _applyFiltersAndSetState();
                    },
                    items: categories
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  title: const Text('Max Price'),
                  subtitle: Slider(
                    value: maxPrice,
                    min: 1,
                    max: 1000,
                    divisions: 100,
                    label: maxPrice.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        maxPrice = value;
                      });
                      _applyFiltersAndSetState();
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _applyFiltersAndSetState(); // Apply filters when 'Apply Filters' button is pressed
                  },
                  child: const Text('Apply Filters'),
                ),
              ],
            );
          },
        );
      },
    );
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
