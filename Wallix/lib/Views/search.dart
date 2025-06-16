import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallix_app/Data/data.dart';
import 'package:wallix_app/Model/wallpaper_model.dart';
import 'package:wallix_app/Widgets/widgtet.dart';

class SearchScreen extends StatefulWidget {
  final String searchQuery;
  SearchScreen({super.key, required this.searchQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<WallpaperModel> wallpapers = [];

  getSearchWallpaper(String? query) async {
    wallpapers.clear(); 
    var response = await http.get(
      Uri.parse(
        "https://api.pexels.com/v1/search?query=$query&per_page=25&page=1",
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
    getSearchWallpaper(widget.searchQuery);
    searchController.text = widget.searchQuery;
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 230, 228, 228),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24),
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        getSearchWallpaper(searchController.text);
                      },
                      child: Icon(Icons.search),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Made By ", style: TextStyle(color: Colors.black)),
                  Text("Mujeeb Khan", style: TextStyle(color: Colors.amber)),
                ],
              ),
              SizedBox(height: 10),
              wallpaperList(wallpapers: wallpapers, context: context),
            ],
          ),
        ),
      ),
    );
  }
}
