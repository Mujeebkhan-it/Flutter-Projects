import 'package:flutter/material.dart';
import 'package:food_app/Model/item_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class PaymentScreen extends StatelessWidget {
  
  final List<Map<String, dynamic>> items;
  final String address;

  const PaymentScreen({
    super.key,
    required this.items,
    required this.address,
  });

  final String whatsappNumber = "918866231098";

  double getTotal() {
    double total = 0;
    for (var entry in items) {
      final Item item = entry['item'];
      final int quantity = entry['quantity'];
      total += (double.tryParse(item.price) ?? 0.0) * quantity;
    }
    return total;
  }

  String buildProductMessage() {
    String message = "🛒*Order Summary*:\n";
    for (var entry in items) {
      final Item item = entry['item'];
      final int quantity = entry['quantity'];
      final double price = double.tryParse(item.price) ?? 0.0;
      final double itemTotal = price * quantity;

      message += "• ${item.name} x $quantity = ₹${itemTotal.toStringAsFixed(2)}\n";
    }

    message += "\n💰*Total Amount*: ₹${getTotal().toStringAsFixed(2)}\n";
    message += "\n📍*Shipping Address*:\n$address\n";
    message += "\nPlease confirm my order.";
    return message;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment & Confirmation"),
        backgroundColor: Colors.amber[700],
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.qr_code_scanner, size: 40, color: Colors.amber),
                  const SizedBox(height: 10),
                  const Text(
                    "Scan to Pay",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      "assets/images/Qr.jpg",
                      width: screenWidth * 0.65,
                      height: screenWidth * 0.65,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "PhonePe | GPay | Paytm",
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please share a screenshot of your payment via WhatsApp",
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 97, 97),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final Uri whatsappUri = Uri.parse(
                    "https://wa.me/$whatsappNumber?text=${Uri.encodeComponent(buildProductMessage())}",
                  );

                  if (await canLaunchUrl(whatsappUri)) {
                    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Could not open WhatsApp")),
                    );
                  }
                },
                icon: const Icon(Icons.chat_bubble, color: Colors.white),
                label: const Text(
                  "Confirm Order on WhatsApp",
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
