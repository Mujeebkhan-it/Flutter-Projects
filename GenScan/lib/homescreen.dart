import 'package:flutter/material.dart';
import 'package:gen_scan/qr_generate.dart';
import 'package:gen_scan/qr_scanner.dart';

class MyHomeScreen extends StatelessWidget {
  const MyHomeScreen({super.key});

  void navigateWithFade(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.08,
              vertical: screenHeight * 0.04,
            ),
            child: Column(
              children: [
                const Spacer(),

                Icon(
                  Icons.qr_code_2_rounded,
                  size: screenHeight * 0.18,
                  color: Colors.white,
                ),

                SizedBox(height: screenHeight * 0.05),

                // Generate QR
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.qr_code, size: screenWidth * 0.07),
                    label: Text(
                      "Generate QR Code",
                      style: TextStyle(fontSize: screenWidth * 0.045),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF3F51B5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      navigateWithFade(context, const QrGenerateScreen( ));
                    },
                  ),
                ),

                SizedBox(height: screenHeight * 0.025),

                // Scan QR
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.qr_code_scanner, size: screenWidth * 0.07),
                    label: Text(
                      "Scan QR Code",
                      style: TextStyle(fontSize: screenWidth * 0.045),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      navigateWithFade(context, const QrScannerScreen());
                    },
                  ),
                ),

                const Spacer(),

                // Footer text
                Text(
                  '© 2025 GenScan',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: screenWidth * 0.035,
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
