import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/product_model.dart';
import '../screens/product_details_screen/product_detail_screen.dart';
import 'product_item_widget.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({
    super.key,
    required this.discountProducts,
    required this.searchResults,
  });

  final List<Product> discountProducts;
  final List<Product> searchResults;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (discountProducts.isNotEmpty)
            SizedBox(
              height: 180, // Sabit bir yükseklik belirliyoruz
              child: CarouselSlider.builder(
                options: CarouselOptions(
                  height: 150,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  enlargeCenterPage: true,
                  viewportFraction: 0.4,
                  aspectRatio: 2.0,
                  initialPage: 2,
                ),
                itemCount: discountProducts.length,
                itemBuilder: (context, index, realIndex) {
                  final product = discountProducts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    child: Container(
                      width: 140, // Genişlik ayarlandı
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            product.imageUrl,
                            fit: BoxFit.contain,
                            height: 63,
                            width: 140,
                          ),
                          Text(
                            product.title,
                            style: const TextStyle(fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${product.price} AZN',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          if (searchResults.isNotEmpty)
            GridView.builder(
              padding: const EdgeInsets.all(10),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final product = searchResults[index];
                return ProductItem(product: product);
              },
            ),
          if (searchResults.isEmpty)
            const Center(
              child: Text(
                'No products found',
                style: TextStyle(fontSize: 10),
              ),
            ),
        ],
      ),
    );
  }
}
