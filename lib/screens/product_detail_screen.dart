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
        title: Text(widget.product.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.product.imageUrl),
              const SizedBox(height: 10),
              Text(
                widget.product.title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Price: ${widget.product.price} AZN',
                style: const TextStyle(fontSize: 20, color: Colors.red),
              ),
              const SizedBox(height: 10),
              Text(widget.product.title),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: (){
                      _updateProductInCart();
                      _incrementQuantity;
                      ref.watch(cartProvider.notifier).addToCart(widget.product);
                    }
                  ),
                  Text('${productInCart.quantity}'),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: _decrementQuantity,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).addToCart(widget.product);
                  _updateProductInCart();
                },
                child: const Text('Add to Cart'),
              ),
              ElevatedButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).removeFromCart(widget.product);
                  Navigator.of(context).pop();
                },
                child: const Text('Remove from Cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
