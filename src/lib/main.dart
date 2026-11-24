import 'package:flutter/material.dart';
import 'package:duo_leic/view/pages/initial_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await  Firebase.initializeApp( options: const FirebaseOptions( apiKey: "AIzaSyCYksDx4GpE6kzh1QUky5Blv4vGZsD_tys", appId: "1:1010259989912:android:3308d92dd09b4c606bc7ed", messagingSenderId: "1010259989912", projectId: "duo-leic", ), ); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DUO-LEIC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InitialPage(),
    );
  }
}