import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:food_app/Model/item_model.dart';
import 'package:food_app/dbhelper/dbhelper.dart';

class AddItemScreen extends StatefulWidget {
  final Item? item;

  const AddItemScreen({super.key, this.item});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _priceController.text = widget.item!.price;
      _descController.text = widget.item!.description;
      if (widget.item!.imagePath.isNotEmpty) {
        _selectedImage = File(widget.item!.imagePath);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitItem() async {
    if (_nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _descController.text.isNotEmpty &&
        _selectedImage != null) {
      final newItem = Item(
        id: widget.item?.id, // Use ID if editing
        name: _nameController.text,
        price: _priceController.text,
        description: _descController.text,
        imagePath: _selectedImage!.path,
      );

      try {
        if (widget.item == null) {
          await DatabaseHelper().insertItem(newItem);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item added successfully!')),
          );
        } else {
          await DatabaseHelper().updateItem(newItem);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item updated successfully!')),
          );
        }
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select an image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.item != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Update Item" : "Add New Item"),
        backgroundColor: Colors.amber[600],
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color.fromARGB(255, 58, 57, 57)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.fastfood, size: 80, color: Colors.amber),
                    const SizedBox(height: 10),
                    Text(
                      isEditing ? "Update Item" : "Add New Item",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: _inputDecoration("Item Name", Icons.fastfood),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration("Item Price", Icons.money),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _descController,
                      maxLines: 3,
                      decoration: _inputDecoration(
                          "Item Description", Icons.description),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.amber, width: 2),
                        ),
                        child: _selectedImage == null
                            ? const Center(
                                child: Text("Tap to select an image",
                                    style: TextStyle(color: Colors.white)))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(_selectedImage!,
                                    fit: BoxFit.cover),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[600],
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        isEditing ? "Update Item" : "Add Item",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color.fromARGB(255, 211, 211, 173)),
      prefixIcon: Icon(icon, color: Colors.amber),
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    );
  }
}
