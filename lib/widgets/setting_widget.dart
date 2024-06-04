import 'package:flutter/material.dart';

class SettingWidget extends StatelessWidget {
  final String optionsText;
  const SettingWidget({
    super.key, required this.optionsText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            color: Color(0xff264653),
            borderRadius: BorderRadius.all(
              Radius.circular(40),
            ),
          ),
          child: const Icon(
            Icons.earbuds,
            color: Colors.white,
          ),
        ),
         Text(
          optionsText,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 120,
        ),
        Container(
          height: 30,
          width: 30,
          decoration: const BoxDecoration(
              color: Color(0xff264653),
              borderRadius: BorderRadius.all(Radius.circular(50))),
          child: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
