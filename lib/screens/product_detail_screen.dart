import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  late Product productInCart;

  @override
  void initState() {
    super.initState();
    productInCart = widget.product;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartItems = ref.watch(cartProvider);
      setState(() {
        productInCart = cartItems.firstWhere(
          (item) => item.title == widget.product.title,
          orElse: () => widget.product,
        );
      });
    });
  }

  void _updateProductInCart() {
    final cartItems = ref.watch(cartProvider);
    setState(() {
      productInCart = cartItems.firstWhere(
        (item) => item.title == widget.product.title,
        orElse: () => widget.product,
      );
    });
  }

  void _incrementQuantity() {
    ref.watch(cartProvider.notifier).incrementQuantity(productInCart);
    _updateProductInCart();
  }

  void _decrementQuantity() {
    ref.watch(cartProvider.notifier).decrementQuantity(productInCart);
    _updateProductInCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MCOM"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.product.imageUrl,
                width: 400,
                height: 300,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product.title.substring(0, 18),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    ' ${widget.product.price} AZN',
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.product.title,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff264653),
                    ),
                    child: IconButton(
                        icon: const Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _updateProductInCart();
                          _decrementQuantity;
                          ref
                              .watch(cartProvider.notifier)
                              .addToCart(widget.product);
                        }),
                  ),
                  Text(
                    '${productInCart.quantity}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff264653),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: _incrementQuantity,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff2A9D8F),
                    ),
                    child: const Text(
                      "Add to cart",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff264653),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                      onPressed: _decrementQuantity,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Soin avec rinçage renforçant la fibre capillaire et apportant volume et densité aux cheveux les plus fins. Les cheveux paraissent plus denses et sont hydratés.\n\ncontenance : 200ml',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
