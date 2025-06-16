import 'package:flutter/material.dart';
import 'package:wallix_app/Views/homescreen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WALLIX',
      theme: ThemeData(
        primaryColor: Colors.white
      ),
      home: HomeScreen(),
    );
  }
}
