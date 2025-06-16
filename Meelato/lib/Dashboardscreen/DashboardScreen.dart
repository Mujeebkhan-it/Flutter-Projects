import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_app/DetailItemScreen/detailItemScreen.dart';
import 'package:food_app/Model/item_model.dart';
import 'package:food_app/dbhelper/dbhelper.dart';
import 'package:food_app/ItemAddingScreen/addItem.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  List<Item> _dashboardItems = []; // List to store items from the database

  @override
  void initState() {
    super.initState();
    _loadItemsFromDatabase(); // Load items when the screen initializes
  }

  Future<void> _loadItemsFromDatabase() async {
    print("Loading items from database...");
    final items = await DatabaseHelper().getItems(); // Fetch items from SQLite
    setState(() {
      _dashboardItems = items; // Update the list with fetched items
    });
    print("Loaded ${_dashboardItems.length} items from database");
    if (_dashboardItems.isEmpty) {
      print("No items found in the database.");
    } else {
      for (var item in _dashboardItems) {
        print("Item loaded: ${item.name}, ${item.price}, ${item.description}");
      }
    }
  }

  // Function to delete an item
  Future<void> _deleteItem(int id) async {
    await DatabaseHelper().deleteItem(id);
    _loadItemsFromDatabase(); // Reload the list after deletion
  }

  // Function to navigate to update screen with item details pre-filled
  void _updateItem(Item item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddItemScreen(item: item), // Pass item to the AddItemScreen
      ),
    );
    if (result == true) {
      _loadItemsFromDatabase(); // Reload items after updating
    }
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
            // Header Section
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
                      Text(
                        "Hello, Admin!!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "What do you want to add today?",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: screenWidth * 0.08,
                    backgroundImage: const AssetImage("assets/images/img.jpeg"),
                  ),
                ],
              ),
            ),
            // Items List Section
            Expanded(
              child: _dashboardItems.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.fastfood,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "No items available!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            print("Navigating to AddItemScreen");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddItemScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[600],
                          ),
                          child: const Text("Add Your First Item"),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: _dashboardItems.length,
                      itemBuilder: (context, index) {
                        final item = _dashboardItems[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.01,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
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
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.045,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Price: ${item.price} /-",
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              // Navigate to ItemDetailScreen on item tap
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemDetailScreen(item: item),
                                ),
                              );
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Update Button
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.amber[600]),
                                  onPressed: () {
                                    _updateItem(item);
                                  },
                                ),
                                // Delete Button
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _deleteItem(item.id!); // Pass item ID to delete
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print("Navigating to AddItemScreen");
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddItemScreen(),
            ),
          );
          if (result == true) {
            print("Reloading items from database");
            _loadItemsFromDatabase(); // Reload items after adding a new one
          } else {
            print("No result received.");
          }
        },
        backgroundColor: Colors.amber[600],
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
