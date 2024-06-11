import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product_model.dart';
import '../../providers/seller_provider.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _quantityController = TextEditingController();

  void _addProduct() {
    if (_formKey.currentState?.validate() ?? false) {
      final title = _titleController.text;
      final imageUrl = _imageUrlController.text;
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final description = _descriptionController.text;
      final category = _categoryController.text;
      final quantity = int.tryParse(_quantityController.text) ?? 1;

      final newProduct = Product(
        title: title,
        imageUrl: imageUrl,
        price: price,
        description: description,
        category: category,
        quantity: quantity,
      );

      ref.read(productProvider.notifier).addProduct(newProduct);

      // Ekleme işlemi tamamlandıktan sonra önceki sayfaya dön
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ürün Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Ürün Başlığı'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün başlığını giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Ürün Resim URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün resim URL\'sini giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Ürün Fiyatı'),
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
                decoration: InputDecoration(labelText: 'Ürün Açıklaması'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün açıklamasını giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Ürün Kategorisi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen ürün kategorisini giriniz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Ürün Miktarı'),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addProduct,
                child: Text('Ürün Ekle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
