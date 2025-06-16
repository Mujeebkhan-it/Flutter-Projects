import 'package:flutter/material.dart';
import 'dart:io';
import 'package:food_app/Model/item_model.dart';
import 'package:food_app/Payment/paymentScreen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;

  const CheckoutScreen({super.key, required this.items});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _addressController = TextEditingController();

  double getTotal() {
    double total = 0;
    for (var entry in widget.items) {
      final Item item = entry['item'];
      final int quantity = entry['quantity'];
      total += (double.tryParse(item.price) ?? 0.0) * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Colors.amber[600],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Summary",
                style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 20),
            ...widget.items.map((entry) {
              final Item item = entry['item'];
              final int quantity = entry['quantity'];
              final double price = double.tryParse(item.price) ?? 0.0;
              final double total = price * quantity;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: item.imagePath.isNotEmpty &&
                                File(item.imagePath).existsSync()
                            ? Image.file(File(item.imagePath),
                                width: 70, height: 70, fit: BoxFit.cover)
                            : Image.asset("assets/images/app_icon.jpg",
                                width: 70, height: 70),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name,
                                style: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text("₹${price.toStringAsFixed(2)} x $quantity",
                                style: TextStyle(
                                    color: Colors.amber[600],
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Text("₹${total.toStringAsFixed(2)}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 25),
            Text("Shipping Address",
                style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Enter Address',
                labelStyle: const TextStyle(color: Colors.white70),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber.shade600),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text("Payment Method: UPI Only",
                style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total",
                    style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                Text("₹${getTotal().toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.amber[600],
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_addressController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter your shipping address."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                          items: widget.items,
                          address: _addressController.text.trim(),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[600],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("Place Order",
                    style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
