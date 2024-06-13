// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/locale_keys.g.dart';
import '../../providers/products_provider.dart';
import '../../widgets/bottom_navigation_bar_widget.dart';
import '../../widgets/slider_widget.dart'; // SliderWidget'i SliderOptionsWidget olarak değiştirdik

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends ConsumerState<SearchScreen> {
  late TextEditingController _searchController;
  String _searchQuery = '';

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
                    hintText: LocaleKeys.SearchBarText.tr(),// bura deyisecek
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
            ),
            body: productsAsyncValue.when(
              data: (products) {
                final searchResults = products
                    .where((product) => product.title.toLowerCase().contains(_searchQuery))
                    .toList();

                final discountProducts = products.where((product) => product.price < 50).toList()
                  ..sort((a, b) => a.price.compareTo(b.price));

                return SliderWidget(
                  discountProducts: discountProducts,
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
