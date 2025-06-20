import "package:demo1/Screens/profileScreen.dart";
import "package:demo1/Screens/signUpScreen.dart";
import "package:demo1/Screens/welcomeScreen.dart";
import "package:demo1/firebase_options.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyWelcomeScreen(),
    );
  }
}
