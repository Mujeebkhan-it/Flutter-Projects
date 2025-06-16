import 'package:flutter/material.dart';
import 'package:food_app/Dashboardscreen/DashboardScreen.dart';
import 'package:food_app/ItemAddingScreen/addItem.dart';
import 'package:food_app/Splashscreen/SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meelato',
      home: Splashscreen(),
    );
  }
}
