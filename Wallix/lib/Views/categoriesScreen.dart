import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallix_app/Data/data.dart';
import 'package:wallix_app/Model/wallpaper_model.dart';
import 'package:wallix_app/Widgets/widgtet.dart';

class CategoriesScreen extends StatefulWidget {

  final String? categorieName;
  const CategoriesScreen({super.key, required this.categorieName});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<WallpaperModel> wallpapers = [];

  getSearchWallpaper(String? query) async {
    var response = await http.get(
      Uri.parse(
        "https://api.pexels.com/v1/search?query=$query+query&per_page=25&page=1",
      ),
      headers: {"Authorization": apiKey},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      jsonData['photos'].forEach((element) {
        wallpapers.add(WallpaperModel.fromMap(element));
      });
      setState(() {});
    } else {
      print("Failed to fetch wallpapers. Status code: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    getSearchWallpaper(widget.categorieName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: brandName(), elevation: 0.0),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 16,),
              wallpaperList(wallpapers: wallpapers, context: context),
            ],
          ),
        ),
      ),
    
    );
  }
}
