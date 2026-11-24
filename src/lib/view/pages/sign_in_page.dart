import 'package:firebase_auth/firebase_auth.dart';
import 'package:duo_leic/user_auth/fire_base_auth.dart';
import 'package:duo_leic/view/pages/home_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:duo_leic/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/achievement.dart';
import 'package:duo_leic/model/uc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  bool _isSecurePassword = true;

  final FireBaseAuthService _auth = FireBaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'DUO-LEIC',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Text(
                  'Start your Studies',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 18.0),
                Image.asset(
                  'assets/images/minerva_new.png',
                  height: 150,
                ),
                const SizedBox(height: 24.0),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    constraints: const BoxConstraints.tightFor(width: 300),
                    filled: true, // Set to true to fill the background
                    fillColor: Colors.blueAccent.withOpacity(0.2),
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      // Add border to the box
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                ),
                const SizedBox(height: 14.0),
                TextField(
                  obscureText: _isSecurePassword,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    constraints: const BoxConstraints.tightFor(width: 300),
                    filled: true, // Set to true to fill the background
                    fillColor: Colors.blueAccent.withOpacity(0.2),
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      // Add border to the box
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    suffixIcon: togglePassword(),
                  ),
                ),
                const SizedBox(height: 18.0),
                ElevatedButton(
                  onPressed: signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    minimumSize: const Size(150, 35),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    if(checkField(email, password)){
    User? firebaseUser =
        await _auth.signInWithEmailAndPassword(email, password);

    if (firebaseUser != null) {
        FirebaseFirestore db = FirebaseFirestore.instance;
        final querySnapshot = await db.collection("Users").where("Email", isEqualTo: email).get();

        if (querySnapshot.docs.isNotEmpty) {
          final docSnapshot = querySnapshot.docs.first;
          var userData = docSnapshot.data();

          List<Achievement> achievements = List<Map<String, dynamic>>.from(userData['Achievements'] ?? []).map((data) {
            return Achievement(
              title: data['Title'] ?? 'No Title',
              description: data['Description'] ?? 'No Description',
              quantity: data['Quantity'] ?? 0,
              current: data['Current'] ?? 0,
            );
          }).toList();
          List<Uc> userUcs = List<Map<String, dynamic>>.from(userData['Ucs'] ?? []).map((data) {
            return Uc.fromMap(data);
          }).toList();
        UserModel userM = UserModel(
          username: userData['Username'],
          email: userData['Email'],
          streak: userData['Streak'],
          streakSaver: userData['StreakSaver'],
          levelsCompleted: userData['LevelsCompleted'],
          achievements: achievements,
          ucs: userUcs,
          follows: List<String>.from(userData['Follows']),
          followers: List<String>.from(userData['Followers']),  
          lastLogin: userData['LastLogin'],
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(userH: userM)),
        );
    } 
    }
    else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your email or password does not match',
            style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.black,
            
            ),
          );
        return;
    }
    }
  }

  bool checkField(String email, String password){
      if (email.isEmpty || password.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You need to fill all the fields',
            style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.black,
            
            ),
          );
        return false;
      }
      return true;
  }

  Widget togglePassword() {
      return IconButton(
        onPressed: () {
          setState(() {
            _isSecurePassword = !_isSecurePassword;
          });
        },
        icon: _isSecurePassword
            ? Icon(Icons.visibility)
            : Icon(Icons.visibility_off),
        color: Colors.grey,
      );
    }
}