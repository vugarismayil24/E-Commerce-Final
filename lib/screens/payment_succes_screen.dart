import 'dart:async';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  PaymentSuccessScreenState createState() => PaymentSuccessScreenState();
}

class PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  int _counter = 50;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 1) {
          _counter--;
        } else {
          _timer.cancel();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset(
                "assets/images/pngs/succes.png",
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Payment Confirmation!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff2A9D8F),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
          'We confirm we have received your secure online payment.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff264653),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'You will be directed to the  home screen within \n$_counter seconds...',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff264653),
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


