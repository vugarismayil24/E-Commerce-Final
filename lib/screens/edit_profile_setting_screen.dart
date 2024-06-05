  import 'package:flutter/material.dart';

  class EditProfileScreen extends StatefulWidget {
    const EditProfileScreen({super.key});

    @override
    EditProfileScreenState createState() => EditProfileScreenState();
  }

  class EditProfileScreenState extends State<EditProfileScreen> {
    final _formKey = GlobalKey<FormState>();

    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _phoneNumberController = TextEditingController();
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _dobController = TextEditingController();
    final TextEditingController _address1Controller = TextEditingController();
    final TextEditingController _address2Controller = TextEditingController();
    final TextEditingController _postalCodeController = TextEditingController();
    final TextEditingController _cityController = TextEditingController();
    final TextEditingController _countryController = TextEditingController();

    @override
    void dispose() {
      _emailController.dispose();
      _phoneNumberController.dispose();
      _usernameController.dispose();
      _passwordController.dispose();
      _dobController.dispose();
      _address1Controller.dispose();
      _address2Controller.dispose();
      _postalCodeController.dispose();
      _cityController.dispose();
      _countryController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Edit Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text(
                  'Please complete your profile',
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                buildTextField(_emailController, Icons.email, 'Email'),
                buildTextField(
                    _phoneNumberController, Icons.phone, '+ Phone number'),
                buildTextField(_usernameController, Icons.person, 'Username'),
                buildTextField(_passwordController, Icons.lock, 'Password',
                    obscureText: true),
                buildTextField(
                    _dobController, Icons.calendar_today, 'Birthday'),
                
                buildTextField(_address1Controller, Icons.home, 'Adress 1'),
                buildTextField(_address2Controller, Icons.home, 'Adress 2'),
                buildTextField(_postalCodeController, Icons.mail, 'Code postal'),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                    
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Color(0xffffffff)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget buildTextField(
        TextEditingController controller, IconData icon, String hintText,
        {bool obscureText = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $hintText';
            }
            return null;
          },
        ),
      );
    }
  }
