import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class QuantityControl extends ConsumerStatefulWidget {
  final Product product;

  const QuantityControl({super.key, required this.product});

  @override
  QuantityControlState createState() => QuantityControlState();
}

class QuantityControlState extends ConsumerState<QuantityControl> {
  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final productInCart = cartItems.firstWhere(
      (item) => item.title == widget.product.title,
      orElse: () => widget.product,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: () {
            ref.watch(cartProvider.notifier).decrementQuantity(productInCart);
          },
        ),
        Text('${productInCart.quantity}'),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            ref.watch(cartProvider.notifier).addToCart(productInCart);
          },
        ),
      ],
    );
  }
}
