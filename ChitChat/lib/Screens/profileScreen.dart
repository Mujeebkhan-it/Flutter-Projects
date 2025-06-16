import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo1/Screens/HomeScreen.dart';
import 'package:demo1/Screens/welcomeScreen.dart';
import 'package:demo1/Widgets/profileWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  User user;
  MyProfileScreen({super.key, required this.user});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  String? profilePic = "";

  Future<void> getUserInfo() async {
    var result = await FirebaseFirestore.instance
        .collection("Person")
        .doc(widget.user.uid)
        .get();

    setState(() {
      _nameController.text = result["username"];
      _emailController.text = result["email"];
      _cityController.text = result["city"];
      profilePic = result["profilepic"];
    });
  }

  Future<void> updateInfo() async {
    await FirebaseFirestore.instance
        .collection("Person")
        .doc(widget.user.uid)
        .update({
      "username": _nameController.text.toString(),
      "city": _cityController.text.toString()
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green.shade400,
        content: Text("Profile Updated Successfully"),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomeScreen(
          user: widget.user,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
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
                color: Colors.deepPurple.withOpacity(0.18),
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
              "Profile",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 1.2,
              ),
            ),
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        // No borderRadius here! This removes the curve gap.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8F8FF),
              Color.fromARGB(255, 113, 70, 213).withOpacity(0.12),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 150, 20, 30), // <-- Top padding for avatar below AppBar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Avatar with edit button
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeIn,
                      child: Material(
                        elevation: 10,
                        shape: CircleBorder(),
                        child: CircleAvatar(
                          radius: 68,
                          backgroundColor: Colors.white,
                          backgroundImage: (profilePic != null && profilePic!.isNotEmpty)
                              ? NetworkImage(profilePic!)
                              : null,
                          child: (profilePic == null || profilePic!.isEmpty)
                              ? Icon(Icons.person, size: 68, color: Colors.deepPurple[200])
                              : null,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Material(
                        color: Colors.deepPurple,
                        shape: CircleBorder(),
                        elevation: 5,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            // Add your edit profile picture logic here
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(Icons.edit, color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 22),
                Text(
                  _nameController.text,
                  style: TextStyle(
                    color: Colors.deepPurple[900],
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  _emailController.text,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 58, 25, 115),
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: 32),
                Divider(
                  color: Colors.deepPurple.withOpacity(0.12),
                  thickness: 1.2,
                  height: 0,
                ),
                SizedBox(height: 18),
                // Glassmorphism Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.09),
                        blurRadius: 18,
                        offset: Offset(0, 10),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.deepPurple.withOpacity(0.08),
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Personal Info",
                            style: TextStyle(
                              color: Colors.deepPurple[400],
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 1.1,
                            )),
                        SizedBox(height: 22),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: "Name",
                            prefixIcon: Icon(Icons.person, color: Colors.deepPurple),
                            filled: true,
                            fillColor: Colors.deepPurple[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 18),
                        TextFormField(
                          controller: _emailController,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
                            filled: true,
                            fillColor: Colors.deepPurple[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 18),
                        TextFormField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            labelText: "City",
                            prefixIcon: Icon(Icons.location_city, color: Colors.deepPurple),
                            filled: true,
                            fillColor: Colors.deepPurple[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 113, 70, 213),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 5,
                              shadowColor: Colors.deepPurple[100],
                            ),
                            onPressed: updateInfo,
                            child: Text(
                              "Update",
                              style: TextStyle(fontSize: 18, color: Colors.white, letterSpacing: 1.1),
                            ),
                          ),
                        ),
                        SizedBox(height: 22),
                        Center(
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.deepPurple,
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 22),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyWelcomeScreen(),
                                ),
                              );
                            },
                            icon: Icon(Icons.logout, color: Colors.deepPurple),
                            label: Text(
                              "Log Out",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                letterSpacing: 1.05,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}