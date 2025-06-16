import 'package:demo1/Screens/LoginScreen.dart';
import 'package:flutter/material.dart';

class MyWelcomeScreen extends StatelessWidget {
  const MyWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 113, 70, 213),
            ],
          ),
          //   image: DecorationImage(
          //     opacity: 0.7,
          //     image: AssetImage("assets/images/bg.png"),
          //     fit: BoxFit.cover
          //   ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 50,
              left: 10,
              child: Image.asset(
                "assets/images/bg.png",
                height: MediaQuery.of(context).size.height - 300,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Positioned(
              top: 540,
              left: 25,
              child: Text(
                "H e a l t h y   C h a t t i n g ",
                style: TextStyle(
                  color: const Color.fromARGB(255, 88, 29, 171),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: 570,
              left: 25,
              child: Row(
                children: [
                  Text(
                    "i s",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 129, 89, 204),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "g o o o o o o d",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 141, 84, 222),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 620,
              left: 25,
              child: Text(
                'More than 10,000 users',
                style: TextStyle(
                  color: const Color.fromARGB(255, 117, 12, 173),
                  fontSize: 18,
                ),
              ),
            ),
            Positioned(
              top: 640,
              left: 25,
              child: Text(
                'From everywhere and everytime',
                style: TextStyle(
                  color: const Color.fromARGB(255, 119, 12, 177),
                  fontSize: 18,
                ),
              ),
            ),
            Positioned(
              top: 700,
              left: 25,
              right: 25,
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                // width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      const Color.fromARGB(255, 92, 22, 191),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyLoginScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Let's get started",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
