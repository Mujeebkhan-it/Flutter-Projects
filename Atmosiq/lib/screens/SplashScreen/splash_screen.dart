import 'package:flutter/material.dart';
import 'package:weather_app/screens/onboardingscreen/onBoardingscreen.dart';
import 'package:lottie/lottie.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Onboardingscreen(),), (route) => false,);
    });

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Lottie.asset("assets/snowfall.json", height: 350, width: 350),
              SizedBox(
                height: 20,
              ),
              Text(
                "W e a t h e r",
                style: TextStyle(
                  color: const Color.fromARGB(255, 7, 38, 213),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "A p p",
                style: TextStyle(
                  color: const Color.fromARGB(255, 7, 38, 213),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
