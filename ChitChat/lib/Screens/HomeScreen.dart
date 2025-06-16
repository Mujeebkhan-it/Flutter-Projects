import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo1/Screens/MyMessageScreen.dart';
import 'package:demo1/Screens/profileScreen.dart';
import 'package:demo1/Screens/welcomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyHomeScreen extends StatefulWidget {
  User? user;
  MyHomeScreen({super.key, required this.user});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  String? userName;

  TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot>? allUsers;
  List<DocumentSnapshot>? filterUser;

  Future<void> getUserInfo() async {
    var document = await FirebaseFirestore.instance
        .collection("Person")
        .doc(widget.user!.uid)
        .get();

    setState(() {
      userName = document["username"];
    });
  }

  void searchUser(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        filterUser = allUsers;
      } else {
        filterUser = allUsers!
            .where((user) =>
                user["username"].toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true, // Removed to fix overlap
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 113, 70, 213),
                Color.fromARGB(255, 140, 100, 230),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.2),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              userName != null ? "Hello, $userName 👋" : "Hello 👋",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 1.1,
              ),
            ),
            actions: [
              PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                onSelected: (value) {
                  if (value == "profile") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyProfileScreen(
                          user: widget.user!,
                        ),
                      ),
                    );
                  } else if (value == "logout") {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyWelcomeScreen()));
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      padding: EdgeInsets.all(10),
                      child: Text("Profile"),
                      value: "profile",
                    ),
                    PopupMenuItem(
                      child: Text("Log Out"),
                      value: "logout",
                    ),
                  ];
                },
              )
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8F8FF),
              Color.fromARGB(255, 113, 70, 213),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(16),
                child: TextField(
                  onChanged: (value) {
                    searchUser(value);
                  },
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search users...",
                    prefixIcon: Icon(Icons.search, color: Colors.deepPurple),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.deepPurple),
                            onPressed: () {
                              _searchController.clear();
                              searchUser('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 18),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Person").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    allUsers = snapshot.data!.docs
                        .where((element) => element.id != widget.user!.uid)
                        .toList();

                    filterUser ??= List.from(allUsers!);

                    if (filterUser!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_off, size: 64, color: Colors.deepPurple[200]),
                            SizedBox(height: 16),
                            Text(
                              "No users found",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.deepPurple[300],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.only(bottom: 24),
                      itemCount: filterUser!.length,
                      separatorBuilder: (context, index) => SizedBox(height: 6),
                      itemBuilder: (context, index) {
                        final user = filterUser![index];
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyMessageScreen(
                                      userSnapshot: user,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                color: Colors.white.withOpacity(0.95),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 28,
                                        backgroundColor: Colors.deepPurple[100],
                                        backgroundImage: user["profilepic"] != null && user["profilepic"].toString().isNotEmpty
                                            ? NetworkImage("${user["profilepic"]}")
                                            : null,
                                        child: user["profilepic"] == null || user["profilepic"].toString().isEmpty
                                            ? Icon(Icons.person, size: 32, color: Colors.deepPurple[300])
                                            : null,
                                      ),
                                      SizedBox(width: 18),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${user["username"]}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 19,
                                                color: Colors.deepPurple[900],
                                              ),
                                            ),
                                            if (user["email"] != null)
                                              Text(
                                                "${user["email"]}",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.deepPurple[300],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios, color: Colors.deepPurple[200], size: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Center(child: Text("Something went wrong"));
                },
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}