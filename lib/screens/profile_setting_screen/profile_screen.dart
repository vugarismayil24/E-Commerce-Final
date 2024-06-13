// ignore_for_file: deprecated_member_use

import 'package:e_com_app/widgets/bottom_navigation_bar_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../generated/locale_keys.g.dart';
import '../../providers/theme_provider.dart';
import 'edit_profile_setting_screen.dart';
import '../login_register_screens/login_screen.dart';
import '../../services/auth_service.dart';

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
          MaterialPageRoute(builder: (context) => const BottomNavigationBarWidget()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title:  Text(LocaleKeys.Profile.tr()),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      "https://miro.medium.com/v2/resize:fit:1400/1*oRpNYT1pE4yJntC7qAdiYQ.png"),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  userName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const EditProfileScreen()),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 150,
                        height: 40,
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Text(
                          LocaleKeys.EditProfile.tr(),
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 155,
                            height: 42,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Text(
                              "${LocaleKeys.Bonus.tr()}: $bonus",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 155,
                            height: 42,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Text(
                              "${LocaleKeys.Balance.tr()}: $balance",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () => _logout(context),
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            border: Border.all(
                                color: theme.dividerColor,
                                strokeAlign: BorderSide.strokeAlignOutside)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 27.5),
                          child: Row(
                            children: [
                              Text(
                                LocaleKeys.LogOut.tr(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Icon(
                                Icons.exit_to_app,
                                color: theme.iconTheme.color,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
