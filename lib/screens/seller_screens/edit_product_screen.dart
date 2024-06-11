import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/product_model.dart';
import '../../providers/seller_provider.dart';

class EditProductScreen extends ConsumerStatefulWidget {
  final int index;
  final Product product;

  const EditProductScreen({required this.index, required this.product, Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _imageUrlController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _imageUrlController = TextEditingController(text: widget.product.imageUrl);
    _priceController = TextEditingController(text: widget.product.price.toString());
    _descriptionController = TextEditingController(text: widget.product.description);
    _categoryController = TextEditingController(text: widget.product.category);
    _quantityController = TextEditingController(text: widget.product.quantity.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _editProduct() {
    if (_formKey.currentState?.validate() ?? false) {
      final title = _titleController.text;
      final imageUrl = _imageUrlController.text;
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final description = _descriptionController.text;
      final category = _categoryController.text;
      final quantity = int.tryParse(_quantityController.text) ?? 1;

      final updatedProduct = widget.product.copyWith(
        title: title,
        imageUrl: imageUrl,
        price: price,
        description: description,
        category: category,
        quantity: quantity,
      );

      ref.read(productProvider.notifier).editProduct(widget.index, updatedProduct);

      // Düzenleme işlemi tamamlandıktan sonra önceki sayfaya dön
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürünü Düzenle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Ürün Başlığı'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün başlığını giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Ürün Resim URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün resim URL\'sini giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Ürün Fiyatı'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün fiyatını giriniz';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Geçerli bir fiyat giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Ürün Açıklaması'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün açıklamasını giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Ürün Kategorisi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün kategorisini giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Ürün Miktarı'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün miktarını giriniz';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Geçerli bir miktar giriniz';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editProduct,
                child: const Text('Ürünü Düzenle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
