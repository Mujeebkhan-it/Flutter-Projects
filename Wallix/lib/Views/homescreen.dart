  import 'dart:convert';
  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
  import 'package:wallix_app/Data/data.dart';
  import 'package:wallix_app/Model/categories_model.dart';
  import 'package:wallix_app/Model/wallpaper_model.dart';
  import 'package:wallix_app/Views/categoriesScreen.dart';
  import 'package:wallix_app/Views/search.dart';
  import 'package:wallix_app/Widgets/widgtet.dart';

  class HomeScreen extends StatefulWidget {
    const HomeScreen({super.key});

    @override
    State<HomeScreen> createState() => _HomeScreenState();
  }

  class _HomeScreenState extends State<HomeScreen> {
    TextEditingController searchController = TextEditingController();
    List<CategoriesModel> categories = [];
    List<WallpaperModel> wallpapers = [];

    getTrendingWallpaper() async {
      wallpapers.clear(); // Clear previous wallpapers to avoid duplication

      var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/curated?per_page=25&page=1"),
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
      getTrendingWallpaper();  // Fetch trending wallpapers on initialization
      categories = getCategories();  // Load categories from data.dart
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(centerTitle: true, title: brandName(), elevation: 0.0),
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
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => SearchScreen(
                                    searchQuery: searchController.text,
                                  ),
                            ),
                          );
                        },
                        child: Icon(Icons.search),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Made By ", style: TextStyle(color: Colors.black)),
                    Text("Mujeeb Khan", style: TextStyle(color: Colors.amber)),
                  ],
                ),
                SizedBox(height: 20),

                Container(
                  height: 80,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoriesTile(
                        imgUrl: categories[index].imgUrl!,
                        title: categories[index].categoriesName!,
                      );
                    },
                  ),
                ),
                SizedBox(height: 15),
                wallpaperList(wallpapers: wallpapers, context: context),
              ],
            ),
          ),
        ),
      );
    }
  }

  class CategoriesTile extends StatelessWidget {
    final String imgUrl, title;
    CategoriesTile({super.key, required this.imgUrl, required this.title});

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      CategoriesScreen(categorieName: title.toLowerCase()),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(right: 10),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imgUrl,
                  height: 50,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black26,
                ),

                height: 50,
                width: 100,
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
