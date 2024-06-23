import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_com_app/screens/favorites_screen/favorites_screen.dart';
import 'package:e_com_app/screens/order_screen/cart_screen.dart';
import 'package:e_com_app/screens/profile_setting_screen/faq_screen/faq_screen.dart';
import 'package:e_com_app/screens/profile_setting_screen/support_screen/support_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../generated/locale_keys.g.dart';
import '../../providers/theme_provider.dart';
import '../../services/auth_service.dart';
import '../login_register_screens/login_screen.dart';
import '../../widgets/bottom_navigation_bar_widget.dart';
import 'edit_profile_setting_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String userName = "";
  int balance = 0;
  int bonus = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        userName = userDoc['userName'];
        balance = userDoc['balance'];
        bonus = userDoc['bonus'];
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    await AuthService().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(themeNotifierProvider) == ThemeMode.dark;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const BottomNavigationBarWidget()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(LocaleKeys.Profile.tr()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BottomNavigationBarWidget()),
              );
            },
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () =>
                  ref.watch(themeNotifierProvider.notifier).toggleTheme(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  "https://miro.medium.com/v2/resize:fit:1400/1*oRpNYT1pE4yJntC7qAdiYQ.png",
                ),
              ),
              const SizedBox(height: 20),
              Text(
                userName,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                FirebaseAuth.instance.currentUser?.displayName ?? "",
                
              ),
              const SizedBox(height: 5),
              Text(
                FirebaseAuth.instance.currentUser?.email ?? "",
                
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
                child: Text(
                  LocaleKeys.EditProfile.tr(),
                  style: TextStyle(color: theme.primaryColor),
                ),
              ),
              const Divider(height: 40),
              ListTile(
                leading: const Icon(Icons.location_on, size: 30),
                title: Text(LocaleKeys.Address1.tr(),),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite, size: 30),
                title: const Text("Wishlist", ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritesScreen(),));
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_bag, size: 30),
                title: const Text("Səbətim"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen(),));
                },
              ),
              ListTile(
                leading: const Icon(Icons.help, size: 30),
                title: const Text("FAQ",),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FAQScreen(),));
                },
              ),
              ListTile(
                leading: const Icon(Icons.support, size: 30),
                title: const Text("Support", ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportScreen(),));
                },
              ),
              const Divider(height: 40),
              ListTile(
                title: const Center(
                  child: Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Wishlist {
}
