import 'package:e_com_app/generated/locale_keys.g.dart';
import 'package:e_com_app/screens/login_register_screens/login_screen.dart';
import 'package:e_com_app/screens/login_register_screens/register_screen.dart';
import 'package:e_com_app/screens/profile_setting_screen/profile_screen.dart';
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
        return const ProfileScreen();
      case 5:
        return const RegisterScreen();
      case 6:
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
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
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
                icon: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedIndex == 0 ? Colors.blue.shade100 : Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.home, color: _selectedIndex == 0 ? Colors.green : Colors.grey),
                ),
                label: LocaleKeys.Home.tr(),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedIndex == 1 ? Colors.blue.shade100 : Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.search, color: _selectedIndex == 1 ? Colors.green : Colors.grey),
                ),
                label: LocaleKeys.Search.tr(),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedIndex == 2 ? Colors.blue.shade100 : Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.favorite, color: _selectedIndex == 2 ? Colors.green : Colors.grey),
                ),
                label: LocaleKeys.Favorites.tr(),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedIndex == 3 ? Colors.blue.shade100 : Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.shopping_cart, color: _selectedIndex == 3 ? Colors.green : Colors.grey),
                ),
                label: LocaleKeys.Cart.tr(),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedIndex == 4 ? Colors.blue.shade100 : Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.person, color: _selectedIndex == 4 ? Colors.green : Colors.grey),
                ),
                label: LocaleKeys.Profile.tr(),
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
