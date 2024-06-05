import 'dart:async';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  PaymentSuccessScreenState createState() => PaymentSuccessScreenState();
}

class PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  int _counter = 5; // 5 saniyelik geri sayım için başlangıç değeri
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Timer.periodic ile geri sayımı başlatma
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
              'Ödeme Onayı!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff2A9D8F),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Güvenli çevrimiçi ödemenizi aldığımızı onaylıyoruz.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff264653),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$_counter saniye içinde ana ekrana yönlendirileceksiniz...',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xff264653),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


