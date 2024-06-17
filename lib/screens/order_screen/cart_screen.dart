import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/locale_keys.g.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/bottom_navigation_bar_widget.dart';
import '../../widgets/quantity_control_widget.dart';
import '../delivery_options_screen/delivery_options_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends ConsumerState<CartScreen> {
  bool _isCouponApplied = false;
  bool _isCouponValid = false;
  double _discountAmount = 0.0;
  late TextEditingController _couponController;

  @override
  void initState() {
    super.initState();
    _couponController = TextEditingController();
    _loadCart();
  }

  Future<void> _loadCart() async {
    await ref.read(cartProvider.notifier).loadCart();
  }

  void _applyCoupon() {
    if (_couponController.text == 'NEWUSER') {
      setState(() {
        _isCouponApplied = true;
        _isCouponValid = true;
        _discountAmount = 1.0; 
      });
    } else {
      setState(() {
        _isCouponApplied = true;
        _isCouponValid = false;
        _discountAmount = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(LocaleKeys.InvalidCouponCode.tr(),)),
      );
    }
  }

  void _showCheckoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(LocaleKeys.Checkout.tr(),),
          content:  Text(LocaleKeys.AreYouSureYouWantToCheckout.tr(),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:  Text(LocaleKeys.Cancel.tr()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const DeliveryScreen(),
                  ),
                );
              },
              child:  Text(LocaleKeys.Confirm.tr()),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveDialog(BuildContext context, WidgetRef ref, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(LocaleKeys.RemoveItem.tr(),),
          content:  Text(LocaleKeys.AreYouSureYouWantToRemoveThisItem.tr(),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:  Text(LocaleKeys.Cancel.tr()),
            ),
            TextButton(
              onPressed: () {
                ref.read(cartProvider.notifier).removeFromCart(product);
                Navigator.of(context).pop();
              },
              child:  Text(LocaleKeys.Confirm.tr()),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);

    double totalPrice =
        cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
    double taxesAndCharges =
        totalPrice * 0.05; 
    double finalTotal = totalPrice + taxesAndCharges - _discountAmount;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const BottomNavigationBarWidget()),
          (Route<dynamic> route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:  Text(LocaleKeys.OrderDetails.tr()),
          automaticallyImplyLeading: false,
        ),
        body: cartItems.isEmpty
            ?  Center(
                child: Text(
                  LocaleKeys.YourCartIsEmpty.tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.all(16.0.w),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final product = cartItems[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            margin: EdgeInsets.symmetric(vertical: 8.h),
                            child: Padding(
                              padding: EdgeInsets.all(8.0.w),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Image.network(
                                      product.imageUrl,
                                      fit: BoxFit.cover,
                                      width: 80.w,
                                      height: 80.h,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.title,
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Row(
                                          children: [
                                            QuantityControl(product: product),
                                            const Spacer(),
                                            Text(
                                              '${product.price * product.quantity} ₼',
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _showRemoveDialog(
                                        context, ref, product),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.h, horizontal: 16.w),
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
                          children: [
                            GestureDetector(
                              onTap: _applyCoupon,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.card_giftcard,
                                          color: Colors.purple, size: 20.w),
                                      SizedBox(width: 8.w),
                                      Text(
                                       LocaleKeys.ApplyCoupon.tr(),
                                        style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      if (_isCouponApplied)
                                        Icon(
                                          _isCouponValid
                                              ? Icons.check_circle
                                              : Icons.cancel,
                                          color: _isCouponValid
                                              ? Colors.green
                                              : Colors.red,
                                          size: 24.w,
                                        ),
                                      Icon(Icons.arrow_forward_ios,
                                          size: 16.sp),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            if (!_isCouponApplied)
                              TextField(
                                controller: _couponController,
                                decoration: InputDecoration(
                                  hintText: LocaleKeys.EnterCouponCode.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                              ),
                            SizedBox(height: 16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocaleKeys.SubTotal.tr(),
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${totalPrice.toStringAsFixed(2)} ₼',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocaleKeys.TaxedAndCharges.tr(),
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${taxesAndCharges.toStringAsFixed(2)} ₼',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocaleKeys.Discount.tr(),
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${_discountAmount.toStringAsFixed(2)} ₼',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocaleKeys.Total.tr(),
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${finalTotal.toStringAsFixed(2)} ₼',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${finalTotal.toStringAsFixed(2)} ₼',
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () => _showCheckoutDialog(context, ref),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow[700],
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32.w, vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              LocaleKeys.MakePayment.tr(),
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
      ),
    );
  }
}
