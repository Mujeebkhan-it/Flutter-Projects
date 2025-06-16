import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_app/CheckoutScreen/checkout.dart';
import 'package:food_app/Model/item_model.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> items;

  const CartScreen({super.key, required this.items});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double getTotal() {
    double total = 0;
    for (var entry in widget.items) {
      final Item item = entry['item'];
      final int quantity = entry['quantity'];
      total += (double.tryParse(item.price) ?? 0.0) * quantity;
    }
    return total;
  }

  void _incrementQuantity(int index) {
    setState(() {
      widget.items[index]['quantity']++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (widget.items[index]['quantity'] > 1) {
        widget.items[index]['quantity']--;
      } else {
        widget.items.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.amber[700],
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: widget.items.isEmpty
                  ? const Center(
                      child: Text(
                        '🛒 Cart is empty',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: widget.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final Item item = widget.items[index]['item'];
                        final int quantity = widget.items[index]['quantity'];
                        final double price = double.tryParse(item.price) ?? 0.0;

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: item.imagePath.isNotEmpty &&
                                        File(item.imagePath).existsSync()
                                    ? Image.file(
                                        File(item.imagePath),
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "assets/images/app_icon.jpg",
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "₹${price.toStringAsFixed(2)} each",
                                      style: TextStyle(
                                        color: Colors.amber[400],
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ],
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "₹${(price * quantity).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () => _decrementQuantity(index),
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.amber[600],
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.remove, size: 16, color: Colors.black),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: Text(
                                            quantity.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => _incrementQuantity(index),
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.amber[600],
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.add, size: 16, color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "₹${getTotal().toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.amber[500],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.items.isEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutScreen(
                              items: widget.items,
                            ),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[600],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  "Proceed to Checkout",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
