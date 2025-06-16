import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController scannerController = MobileScannerController();
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    final status = await [
      Permission.camera,
      Permission.photos,
      Permission.storage,
    ].request();

    if (status[Permission.camera] != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission is required to scan QR codes.')),
      );
    }
  }

  void _onDetect(BarcodeCapture capture) async {
    final String? code = capture.barcodes.first.rawValue;
    if (!isProcessing && code != null) {
      isProcessing = true;
      await scannerController.stop();
      await _launchURL(code);
      isProcessing = false;
      scannerController.start();
    }
  }

  Future<void> _scanFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final result = await scannerController.analyzeImage(pickedFile.path);
      final String? code = result?.barcodes.first.rawValue;

      if (code != null) {
        await _launchURL(code);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No valid QR code found in the image.")),
        );
      }
    }
  }

  Future<void> _launchURL(String url) async {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    try {
      final success = await launchUrlString(url, mode: LaunchMode.externalApplication);
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not launch URL: $url")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Launch error: $e")),
      );
    }
  }

  @override
  void dispose() {
    scannerController.dispose();
    super.dispose();
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                  horizontal: screenWidth * 0.06,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Text(
                      "Scan QR Code",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: MobileScanner(
                      controller: scannerController,
                      onDetect: _onDetect,
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _scanFromGallery,
                    icon: Icon(Icons.image, size: screenWidth * 0.065),
                    label: Text(
                      "Scan from Gallery",
                      style: TextStyle(fontSize: screenWidth * 0.045),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green[700],
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),
              Text(
                'Point the camera to a QR code',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: screenWidth * 0.035,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
