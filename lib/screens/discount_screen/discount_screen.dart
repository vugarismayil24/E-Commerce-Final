import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiscountProductScreen extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      'image': 'assets/images/product1.png',
      'title': 'Holographic Nail Glitter',
      'price': '1.79',
      'oldPrice': '5.99'
    },
    {
      'image': 'assets/images/product2.png',
      'title': 'No Show Socks',
      'price': '1.97',
      'oldPrice': '3.99'
    },
    {
      'image': 'assets/images/product3.png',
      'title': 'Mirror for Women',
      'price': '1.47',
      'oldPrice': '4.99'
    },
    {
      'image': 'assets/images/product4.png',
      'title': 'Mesh Strainers',
      'price': '1.51',
      'oldPrice': '6.99'
    },
    // Add more products as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Grid'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.75,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return _buildProductItem(product);
          },
        ),
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.asset(
              product['image'],
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product['title'],
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '\$${product['price']}',
              style: TextStyle(fontSize: 16.0, color: Colors.green),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '\$${product['oldPrice']}',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.red,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
