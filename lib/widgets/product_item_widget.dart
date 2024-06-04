import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends ConsumerWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        width: 200.w, // Responsive width
        height: 300.h, // Responsive height
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r), // Responsive border radius
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2.w, // Responsive spread radius
              blurRadius: 5.w, // Responsive blur radius
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w, // Responsive width
              height: 150.h, // Responsive height
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    product.imageUrl,
                    scale: 1.01,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 10.h), // Responsive height
            Text(
              product.title.length > 12 ? product.title.substring(0, 12) : product.title,
              style: TextStyle(
                fontSize: 12.sp, // Responsive font size
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.h), // Responsive height
            Text(
              "${product.price.toDouble().toString()} AZN",
              style: TextStyle(
                fontSize: 18.sp, // Responsive font size
                fontWeight: FontWeight.bold,
                color: Color(0xFFE22323),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15.h), // Responsive height
            Padding(
              padding: EdgeInsets.only(left: 127.w, top: 6.h), // Responsive padding
              child: GestureDetector(
                onTap: () {
                  ref.read(cartProvider.notifier).addToCart(product);
                },
                child: Container(
                  padding: EdgeInsets.only(right: 8.w, left: 12.w, bottom: 3.h), // Responsive padding
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), topLeft: Radius.circular(10)),
                    color: Color(0xff2A9D8F),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 25.w, // Responsive icon size
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
