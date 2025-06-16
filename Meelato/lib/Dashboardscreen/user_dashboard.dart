import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_app/CartScreen/cartScreen.dart';
import 'package:food_app/DetailItemScreen/detailItemScreen.dart';
import 'package:food_app/Model/item_model.dart';
import 'package:food_app/dbhelper/dbhelper.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  List<Item> _dashboardItems = [];
  final List<Map<String, dynamic>> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadItemsFromDatabase();
  }

  Future<void> _loadItemsFromDatabase() async {
    final items = await DatabaseHelper().getItems();
    setState(() {
      _dashboardItems = items;
    });
  }

  void _addToCart(Item item) {
    final existing = _cartItems.indexWhere((element) => element['item'].id == item.id);
    setState(() {
      if (existing != -1) {
        _cartItems[existing]['quantity'] += 1;
      } else {
        _cartItems.add({'item': item, 'quantity': 1});
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${item.name} added to cart"),
        backgroundColor: Colors.amber[700],
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(items: _cartItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.amber[600],
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: _goToCart,
          ),
        ],
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color.fromARGB(255, 58, 57, 57)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08,
                vertical: screenHeight * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Hello, Dear!",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text("Browse available items",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          )),
                    ],
                  ),
                  CircleAvatar(
                    radius: screenWidth * 0.08,
                    backgroundImage: const AssetImage("assets/images/img.jpeg"),
                  ),
                ],
              ),
            ),
            // Items List
            Expanded(
              child: _dashboardItems.isEmpty
                  ? const Center(
                      child: Text("No items available!",
                          style: TextStyle(color: Colors.white, fontSize: 18)))
                  : ListView.builder(
                      itemCount: _dashboardItems.length,
                      itemBuilder: (context, index) {
                        final item = _dashboardItems[index];
                        return Card(
                          color: Colors.grey[900],
                          margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.01,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => ItemDetailScreen(item: item),
                              ));
                            },
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: item.imagePath.isNotEmpty &&
                                        File(item.imagePath).existsSync()
                                    ? Image.file(
                                        File(item.imagePath),
                                        width: screenWidth * 0.15,
                                        height: screenWidth * 0.15,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "assets/images/app_icon.jpg",
                                        width: screenWidth * 0.15,
                                        height: screenWidth * 0.15,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              title: Text(
                                item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              subtitle: Text(
                                "₹${item.price}",
                                style: TextStyle(
                                    color: Colors.amber[600], fontSize: 14),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.add_shopping_cart,
                                    color: Colors.white),
                                onPressed: () => _addToCart(item),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
