import 'package:demo1/Screens/HomeScreen.dart';
import 'package:demo1/Screens/signUpScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyLoginScreen extends StatefulWidget {
  const MyLoginScreen({super.key});

  @override
  State<MyLoginScreen> createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<MyLoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> userLogin(String? email, String? password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text.toString(),
              password: _passwordController.text.toString());

      User user = userCredential.user!;

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomeScreen(
              user: user,
            ),
          ));
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Login Failed !"),
            content: Text(
              "Invalid Email or Password",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    _emailController.clear();
                    _passwordController.clear();
                    Navigator.pop(context);
                  },
                  child: Text("Retry")),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 113, 70, 213),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Positioned(
            right: -50,
            top: 50,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 113, 70, 213),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: 70,
            right: 50,
            child: Text(
              "Welcome Back",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 120,
            left: 40,
            right: 30,
            child: Image(
              image: AssetImage("assets/images/signup.png"),
              height: 300,
              width: 400,
            ),
          ),
          Positioned(
            top: 390,
            left: 40,
            right: 40,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  iconColor: const Color.fromARGB(255, 113, 70, 213),
                  fillColor: Colors.purple[300],
                  icon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 460,
            left: 40,
            right: 40,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  iconColor: const Color.fromARGB(255, 113, 70, 213),
                  fillColor: Colors.purple[300],
                  icon: Icon(Icons.password),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 40,
            right: 40,
            top: 540,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Color.fromARGB(255, 113, 70, 213),
                  ),
                ),
                onPressed: () {
                  userLogin(_emailController.text.toString(),
                      _passwordController.text.toString());
                },
                child: Text(
                  "LOGIN",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned(
            top: 720,
            // left: 10,
            // right: 10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey[300],
              ),
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Container(
                margin: EdgeInsets.only(left: 50, top: 25),
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MySignupScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(color: Colors.purple, fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
