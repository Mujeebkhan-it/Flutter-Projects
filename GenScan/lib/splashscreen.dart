import 'package:flutter/material.dart';
import 'package:gen_scan/homescreen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyHomeScreen()),
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 151, 192, 225), Color(0xFF2196F3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Lottie.asset(
                  'assets/images/splash.json',
                  height: screenHeight * 0.45,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 20),

                Text(
                  "GenScan",
                  style: TextStyle(
                    fontSize: screenWidth * 0.09,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),

                Text(
                  "Smart QR Generator",
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontStyle: FontStyle.italic,
                    color: const Color.fromARGB(214, 255, 255, 255),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
