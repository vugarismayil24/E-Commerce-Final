import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';

import 'payment_succes_screen.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  void _submitPayment() {
    if (_cardNumberController.text.isEmpty ||
        _expiryDateController.text.isEmpty ||
        _cvvController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields are required!'),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PaymentSuccessScreen(),
        ),
      );
    }
  }

  void _formatExpiryDate(String value) {
    final newValue = value.replaceAll('/', '');
    String formattedValue = '';

    if (newValue.isEmpty) {
      formattedValue = '';
    } else if (newValue.length <= 2) {
      formattedValue = newValue;
    } else if (newValue.length <= 4) {
      formattedValue = '${newValue.substring(0, 2)}/${newValue.substring(2)}';
    }

    // Kontrol edilmesi gereken uzunluğu 5'e kadar sınırlama
    if (newValue.length > 4) {
      formattedValue = '${newValue.substring(0, 2)}/${newValue.substring(2, 4)}';
    }

    _expiryDateController.value = TextEditingValue(
      text: formattedValue,
      selection: TextSelection.fromPosition(
        TextPosition(offset: formattedValue.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your payment details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _cardNumberController,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryDateController,
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date (MM/YY)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(5),
                    ],
                    onChanged: _formatExpiryDate,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _cvvController,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    obscureText: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPayment,
              child: const Text('Submit Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
