import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<DocumentSnapshot> getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userInfo = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userInfo;
    }
    throw Exception('Kullanıcı oturumu açmamış');
  }

  Future<void> _loadUserInfo() async {
    try {
      DocumentSnapshot userInfo = await getUserInfo();
      Map<String, dynamic> data = userInfo.data() as Map<String, dynamic>;
      setState(() {
        _emailController.text = data['email'] ?? '';
        _phoneNumberController.text = data['phoneNumber'] ?? '';
        _usernameController.text = data['displayName'] ?? '';
        _dobController.text = data['dob'] ?? '';
        _address1Controller.text = data['address1'] ?? '';
        _address2Controller.text = data['address2'] ?? '';
        _postalCodeController.text = data['postalCode'] ?? '';
        _cityController.text = data['city'] ?? '';
        _countryController.text = data['country'] ?? '';
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error loading user info: $e");
      }
    }
  }

  Future<void> updateUserInfo(Map<String, dynamic> data) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   // icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     // Navigator.pushReplacement(context, BottomNavigationBarWidget())
        //   },
        // ),
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
              buildTextField(_dobController, Icons.calendar_today, 'Birthday'),
              buildTextField(_address1Controller, Icons.home, 'Address 1'),
              buildTextField(_address2Controller, Icons.home, 'Address 2'),
              buildTextField(_postalCodeController, Icons.mail, 'Postal Code'),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> updatedData = {
                      'email': _emailController.text,
                      'phoneNumber': _phoneNumberController.text,
                      'displayName': _usernameController.text,
                      'dob': _dobController.text,
                      'address1': _address1Controller.text,
                      'address2': _address2Controller.text,
                      'postalCode': _postalCodeController.text,
                      'city': _cityController.text,
                      'country': _countryController.text,
                    };
                    updateUserInfo(updatedData).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile updated successfully')),
                      );
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Failed to update profile: $error')),
                      );
                    });
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
