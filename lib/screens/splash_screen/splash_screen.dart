import 'package:flutter/material.dart';
import '../login_register_screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _pageController,
            physics: ClampingScrollPhysics(), // Sayfa kaydırma fizikleri
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: <Widget>[
              _buildPageContent(
                context,
                imagePath: 'assets/images/pngs/iPhone 13 Pro Max - 1.png',
                title: 'Shop Now!',
                description: 'in any Where, at any Time...',
              ),
              _buildPageContent(
                context,
                imagePath: 'assets/images/pngs/iPhone 13 Pro Max - 2.png',
                title: 'Free Shipping!',
                description: 'recive your orders Fast & Free...',
              ),
              _buildPageContent(
                context,
                imagePath: 'assets/images/pngs/iPhone 13 Pro Max - 3.png',
                title: 'Easy & Secure',
                description: 'Payment',
                isLastPage: true,
              ),
            ],
          ),
          Positioned(
            bottom: 80, // Bu değeri ayarlayarak butonları yukarı taşıyabilirsiniz
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (int index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 10,
                      width: (index == _currentPage) ? 30 : 10,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: (index == _currentPage) ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () => _pageController.jumpToPage(2),
                      child: const Text('SKIP'),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20)),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.green)),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage == 2) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                      child: Text(_currentPage == 2 ? 'Join us Now!' : 'NEXT'),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 20)),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(BuildContext context,
      {required String imagePath, required String title, required String description, bool isLastPage = false}) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 100, // Yazının resim üzerinde kalmasını sağlamak için ayarlayın
          left: 20,
          right: 20,
          child: Column(
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
