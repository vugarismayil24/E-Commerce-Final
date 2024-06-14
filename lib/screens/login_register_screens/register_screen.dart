import 'package:e_com_app/generated/locale_keys.g.dart';
import 'package:e_com_app/services/auth_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/bottom_navigation_bar_widget.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<RegisterScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordVisible = false;
  }

  Future<void> registerUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'userName': _fullNameController.text,
          'email': _emailController.text,
          'balance': 0,
          'bonus': 0,
        });
        
        // Başarılı kayıt işlemi sonrası kullanıcıyı ana ekrana yönlendirme
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavigationBarWidget()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 900.h,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFEE7752), Color(0xFFE73C7E)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 100.h),
                          Text(
                            'GameStore',
                            style: TextStyle(
                              fontSize: 40.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            width: 320.w,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 20.r,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                                        child: Text(
                                          LocaleKeys.SignUp.tr(),
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                                        child: Text(
                                          LocaleKeys.SignIn.tr(),
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black26,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12.h),
                                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 20.r,
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: () async{
                                        AuthService().signInWithGoogle();
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNavigationBarWidget(),));
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                                          SizedBox(width: 10.w),
                                          Text(
                                            'Google',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: _fullNameController,
                                        decoration: InputDecoration(
                                          hintText: LocaleKeys.Name.tr(),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      TextField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          hintText:  LocaleKeys.Email.tr(),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      TextField(
                                        controller: _passwordController,
                                        obscureText: !_passwordVisible,
                                        decoration: InputDecoration(
                                          hintText:  LocaleKeys.Password.tr(),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _passwordVisible = !_passwordVisible;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_fullNameController.text.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Please enter your full name')),
                                      );
                                      return;
                                    }

                                    if (!_emailController.text.contains('@')) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Please enter a valid email')),
                                      );
                                      return;
                                    }

                                    if (_passwordController.text.length < 8) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Password must be at least 8 characters long')),
                                      );
                                      return;
                                    }

                                    await registerUser();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff2A9D8F),
                                    minimumSize: Size(280.w, 50.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                  child:  Text(
                                     LocaleKeys.SignUp.tr(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
