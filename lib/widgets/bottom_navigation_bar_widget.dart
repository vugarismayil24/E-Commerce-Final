import 'package:e_com_app/generated/locale_keys.g.dart';
import 'package:e_com_app/screens/login_register_screens/login_screen.dart';
import 'package:e_com_app/screens/login_register_screens/register_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/home_screen/home_screen.dart';
import '../screens/order_screen/cart_screen.dart';
import '../screens/favorites_screen/favorites_screen.dart';
import '../screens/search_screen/search_screen.dart';

class BottomNavigationBarWidget extends ConsumerStatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  BottomNavigationBarWidgetState createState() => BottomNavigationBarWidgetState();
}

class BottomNavigationBarWidgetState extends ConsumerState<BottomNavigationBarWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedWidget() {
    switch (_selectedIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const SearchScreen();
      case 2:
        return const FavoritesScreen();
      case 3:
        return const CartScreen();
      case 4:
        return const RegisterScreen();
      case 5:
        return const LoginScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedWidget(),
      bottomNavigationBar: Container(
        clipBehavior: Clip.none,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 120,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: LocaleKeys.Home.tr(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.search),
                label: LocaleKeys.Search.tr(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite),
                label: LocaleKeys.Favorites.tr(),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.shopping_cart),
                label: LocaleKeys.Cart.tr(),
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFF2A9D8F),
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: false,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
