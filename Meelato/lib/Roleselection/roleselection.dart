import 'package:flutter/material.dart';
import 'package:food_app/Dashboardscreen/DashboardScreen.dart';
import 'package:food_app/Dashboardscreen/user_dashboard.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  static const String adminPassword = "admin";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Header Text
            Positioned(
              top: screenHeight * 0.57,
              left: screenWidth * 0.05,
              child: const Text(
                "H e a l t h y   f o o d",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.62,
              left: screenWidth * 0.05,
              child: Row(
                children: const [
                  Text(
                    "i s",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "g o o o o o o d",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: screenHeight * 0.72,
              left: screenWidth * 0.05,
              child: const Text(
                'More than 10,000 recipes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.75,
              left: screenWidth * 0.05,
              child: const Text(
                'For everyday and taste',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),

            // Admin Button
            Positioned(
              top: screenHeight * 0.83,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[600],
                  ),
                  onPressed: () {
                    _showAdminPasswordDialog(context);
                  },
                  child: const Text(
                    "Login as Admin",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            // User Button
            Positioned(
              top: screenHeight * 0.9,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[600],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserDashboardScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Continue as User",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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

  void _showAdminPasswordDialog(BuildContext context) {
    final TextEditingController _passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Admin Login"),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Enter admin password",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_passwordController.text == adminPassword) {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardScreen(),
                    ),
                  );
                } else {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Incorrect password"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }
}
