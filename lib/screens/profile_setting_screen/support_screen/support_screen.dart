import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();
  String _priority = 'Düşük';

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Formu Firestore'a kaydedin
      await FirebaseFirestore.instance.collection('support_tickets').add({
        'name': _nameController.text,
        'email': _emailController.text,
        'issue': _issueController.text,
        'priority': _priority,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Kullanıcıya formun başarıyla gönderildiğini bildirin
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Destek talebiniz başarıyla gönderildi')),
      );

      // Formu temizle
      _formKey.currentState!.reset();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        _nameController.text = user.displayName ?? '';
        _emailController.text = user.email ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Destek Talebi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Destek Talebi Oluşturun',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'İsim'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen isminizi girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-posta Adresiniz'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen e-posta adresinizi girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _issueController,
                decoration: const InputDecoration(labelText: 'Sorununuz'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen sorununuzu girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'Aciliyet Durumu'),
                items: ['Düşük', 'Orta', 'Yüksek']
                    .map((priority) => DropdownMenuItem(
                          value: priority,
                          child: Text(priority),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Gönder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
