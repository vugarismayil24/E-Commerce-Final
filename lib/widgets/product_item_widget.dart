import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../screens/product_details_screen/product_detail_screen.dart';

class ProductItem extends ConsumerWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        width: 200.w,
        height: 300.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r), 
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2.w, 
              blurRadius: 5.w, 
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 120.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    product.imageUrl,
                    scale: 1,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              product.title.length > 12 ? product.title.substring(0, 10) : product.title,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.h),
            Text(
              "${product.price.toDouble().toString()} AZN",
              style: TextStyle(
                fontSize: 18.sp, 
                fontWeight: FontWeight.bold,
                color: const Color(0xFFE22323),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15.h), 
            Padding(
              padding: EdgeInsets.only(left: 120.w, top: 7.4.h),
              child: GestureDetector(
                onTap: () {
                  ref.read(cartProvider.notifier).addToCart(product);
                },
                child: Container(
                  padding: EdgeInsets.only(right: 8.w, left: 12.w, bottom: 3.h),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), topLeft: Radius.circular(10)),
                    color: Color(0xff2A9D8F),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 25.w, 
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
