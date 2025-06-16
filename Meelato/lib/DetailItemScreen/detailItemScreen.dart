import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_app/Model/item_model.dart';

class ItemDetailScreen extends StatefulWidget {
  final Item item;
  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double price = double.tryParse(widget.item.price) ?? 0.0;
    double total = price * _quantity;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        elevation: 0,
        title: Text(
          widget.item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: widget.item.imagePath.isNotEmpty &&
                      File(widget.item.imagePath).existsSync()
                  ? Image.file(
                      File(widget.item.imagePath),
                      height: screenHeight * 0.35,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/images/app_icon.jpg",
                      height: screenHeight * 0.35,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 25),

            // Item Name
            Text(
              widget.item.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.065,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),

            // Price
            Text(
              "₹${total.toStringAsFixed(2)} /-",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.amber[600],
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 15),

            // Description
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                widget.item.description,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: screenWidth * 0.042,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 25),

          
          ],
        ),
      ),
    );
  }
}
