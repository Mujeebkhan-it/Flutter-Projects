import "package:cloud_firestore/cloud_firestore.dart";
import "package:demo1/Screens/LoginScreen.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class MySignupScreen extends StatefulWidget {
  const MySignupScreen({super.key});

  @override
  State<MySignupScreen> createState() => _MySignupScreenState();
}

class _MySignupScreenState extends State<MySignupScreen> {

  String? gender;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String? profilepic = "";

  Future<void> registerUser(
      String? userName, String? email, String? password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);

    User? user = userCredential.user;

    print("---------->>>>${user!.uid}");

    await FirebaseFirestore.instance.collection("Person").doc(user.uid).set({
      "username": userName,
      "email": email,
      "profilepic": profilepic,
      "city": ""
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 113, 70, 213),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Positioned(
            right: -50,
            top: 50,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 113, 70, 213),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Positioned(
            top: 70,
            // left: 10,
            // right: 10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey[300],
              ),
              height: 900,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                    top: 30,
                    left: 110,
                    right: 50,
                    child: Text(
                      "Welcome",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: 50,
                    right: 40,
                    child: Image(
                      image: AssetImage("assets/images/signup.png"),
                      height: 250,
                      width: 400,
                    ),
                  ),
                  Positioned(
                    top: 320,
                    left: 30,
                    right: 30,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: "Name",
                          iconColor: const Color.fromARGB(255, 113, 70, 213),
                          fillColor: Colors.purple[300],
                          icon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 390,
                    left: 30,
                    right: 30,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          iconColor: const Color.fromARGB(255, 113, 70, 213),
                          fillColor: Colors.purple[300],
                          icon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 460,
                    left: 30,
                    right: 30,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          iconColor: const Color.fromARGB(255, 113, 70, 213),
                          fillColor: Colors.purple[300],
                          icon: Icon(Icons.password),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 532,
                    left: 30,
                    child: Icon(
                      Icons.person_3,
                      color: const Color.fromARGB(255, 113, 70, 213),
                    ),
                  ),
                  Positioned(
                    top: 515,
                    left: 50,
                    right: 30,
                    child: RadioListTile(
                        title: Text("Male"),
                        tileColor: Colors.deepPurple[300],
                        value: "Male",
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                            profilepic =
                                "https://img.freepik.com/premium-photo/cute-handsome-anime-boy-wear-yellow-hoodie_675932-371.jpg";
                          });
                        }),
                  ),
                  Positioned(
                    top: 515,
                    left: 150,
                    right: 30,
                    child: RadioListTile(
                        title: Text("Female"),
                        tileColor: Colors.deepPurple[300],
                        value: "Female",
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                            profilepic =
                                "https://imgv3.fotor.com/images/gallery/AI-3D-Female-Profile-Picture.jpg";
                          });
                        }),
                  ),
                  Positioned(
                    left: 45,
                    right: 40,
                    top: 580,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Color.fromARGB(255, 113, 70, 213),
                          ),
                        ),
                        onPressed: () {
                          registerUser(
                              _nameController.text.toString(),
                              _emailController.text.toString(),
                              _passwordController.text.toString());
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green.shade400,
                              content: Text("Signed Up Succesfully"),
                            ),
                          );
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyLoginScreen()));
                        },
                        child: Text(
                          "SIGN UP",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
