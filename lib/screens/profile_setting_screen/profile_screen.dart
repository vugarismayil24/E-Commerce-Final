import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences eklendi
import '../../providers/theme_provider.dart';
import '../../widgets/setting_widget.dart';
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

  Future<void> _deleteAccount(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Kullanıcıyı Firestore'dan sil
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
      // Firebase Authentication'dan kullanıcıyı sil
      await user.delete();
      // Oturum açma durumunu güncelle
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);

      // Kullanıcıyı LoginScreen'e yönlendir
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(themeNotifierProvider) == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,

        title: const Text("Profile"),
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
                        "Edit Profile",
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
                            "Bonus: $bonus",
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
                            "Balance: $balance",
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
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SettingWidget(optionsText: "Language"),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () => _confirmDelete(context),
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xffE22323),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          border: Border.all(
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: const Color(0xffE22323))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 27.5),
                        child: Text(
                          "Delete Account",
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () => _logout(context),
                    child: Container(
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
                              "Log Out",
                              style: theme.textTheme.labelLarge?.copyWith(
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
    );
  }
}
