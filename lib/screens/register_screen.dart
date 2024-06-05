import 'package:e_com_app/providers/auth_service.dart';
import 'package:e_com_app/screens/login_screen.dart';
import 'package:e_com_app/widgets/bottom_navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<RegisterScreen> {
  bool _acceptedTerms = true;
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  Future<void> register() async {
    await AuthService().registerWithEmailPassword(
      _emailController.text,
      _passwordController.text,
      _fullNameController.text,
    );
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
          body: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 32.h),
                  Center(
                    child: Text(
                      'Welcome MCOM',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  TextField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      hintStyle: TextStyle(
                        color: Colors.black.withAlpha(100),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'E-mail or Name',
                      hintStyle: TextStyle(
                        color: Colors.black.withAlpha(100),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: Colors.black.withAlpha(100),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptedTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptedTerms = value!;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'accept the Terms of Policies conditions.',
                          style: TextStyle(
                            color: Color(0xff264653),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () async {
                      if (_fullNameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter your full name')),
                        );
                        return;
                      }
              
                      if (!_emailController.text
                          .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter a valid email')),
                        );
                        return;
                      }
              
                      if (_passwordController.text.length < 8 ||
                          !_passwordController.text
                              .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'The password must contain at least 8 characters and contain certain symbols ! @ . #')),
                        );
                        return;
                      }
              
                      try {
                        await AuthService().registerWithEmailPassword(
                            _emailController.text,
                            _passwordController.text,
                            _fullNameController.text);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const BottomNavigationBarWidget()),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registter unsucces: $e')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2A9D8F),
                      minimumSize: Size.fromHeight(50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const FaIcon(Icons.warning),
                      ),
                      Text(
                        'Error message...',
                        style: TextStyle(color: Colors.red, fontSize: 14.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: const Color(0xff264653),
                            thickness: 1.h,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: const Text(
                            'OR',
                            style: TextStyle(
                              color: Color(0xff264653),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: const Color(0xff264653),
                            thickness: 1.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Image.network(
                            'https://img.icons8.com/color/48/000000/facebook.png'),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Image.network(
                            'https://img.icons8.com/color/48/000000/google-logo.png'),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Image.network(
                            'https://img.icons8.com/ios-filled/50/000000/mac-os.png'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: '*Already have an account ?',
                          style: TextStyle(
                              fontSize: 14.sp, color: const Color(0xffE22323)),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const LoginScreen()),
                        ),
                        child: RichText(
                          text: const TextSpan(
                            text: ' Log in',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff4971FE)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
