import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';
import '../screens/product_details_screen/product_detail_screen.dart';

class ProductItem extends ConsumerWidget {
  final Product product;
  final bool isFeatured;

  const ProductItem({Key? key, required this.product, required this.isFeatured}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Random random = Random();
    double originalPrice = random.nextDouble() * 100 + 100;
    double rating = random.nextDouble() * 5;
    int reviewCount = random.nextInt(1000);

    final favorites = ref.watch(favoritesProvider);
    bool isFavorite = favorites.contains(product);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 180.w,
          height: 400.h,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: 180.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(product.imageUrl),
                        fit: BoxFit.cover,
                        onError: (error, stackTrace) => const NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNHWvM0Gud_EyYvZwsOVyg2w0AFNqeMEJiBQ&s',
                        ),
                      ),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                    ),
                  ),
                  if (isFeatured)
                    Positioned(
                      top: 5.h,
                      left: 5.w,
                      child: Container(
                        color: Colors.orange,
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                        child: Text(
                          'Top Seller',
                          style: TextStyle(color: Colors.white, fontSize: 10.sp),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 5.h,
                    right: 5.w,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        if (isFavorite) {
                          ref.read(favoritesProvider.notifier).removeFromFavorites(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Product removed from favorites!'),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.red,
                              margin: EdgeInsets.only(
                                bottom: 50.h,
                                left: 10.w,
                                right: 10.w,
                              ),
                            ),
                          );
                        } else {
                          ref.read(favoritesProvider.notifier).addToFavorites(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Product added to favorites!'),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.green,
                              margin: EdgeInsets.only(
                                bottom: 50.h,
                                left: 10.w,
                                right: 10.w,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "\$${originalPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 12.sp,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "\$${product.price}",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFE22323),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${((1 - product.price / originalPrice) * 80).toInt()}% OFF",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.orange,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 14.sp),
                              SizedBox(width: 5.w),
                              Text(
                                rating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                "($reviewCount)",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  ref.read(cartProvider.notifier).addToCart(product, quantity: 1);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Product added to cart!'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.green,
                      margin: EdgeInsets.only(
                        bottom: 50.h,
                        left: 10.w,
                        right: 10.w,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(8.w),
                  width: double.infinity,
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.green,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 20.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
