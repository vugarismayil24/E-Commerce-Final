import 'dart:async';
import 'package:flutter/material.dart';
import '../login_register_screens/login_screen.dart';
import '../../widgets/bottom_navigation_bar_widget.dart';
import '../../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      checkLoginStatus();
    });
  }

  Future<void> checkLoginStatus() async {
    bool isLoggedIn = await _authService.checkLoginStatus();

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavigationBarWidget()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/pngs/splashscreen.png",
        ),
      ),
    );
  }
}
