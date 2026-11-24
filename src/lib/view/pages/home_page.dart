import 'package:duo_leic/view/pages/select_class_page.dart';
import 'package:duo_leic/model/user.dart';
import 'package:flutter/material.dart';
import 'package:duo_leic/view/pages/profile_page.dart';
import 'package:duo_leic/view/pages/info_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:duo_leic/view/pages/widgets/bottom_navigation_bar.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/uc.dart';


DateTime dateTime = DateTime.now();

class HomePage extends StatefulWidget {
  final UserModel userH;

  const HomePage({super.key, required this.userH});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late String currentDate = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchCurrentDate();
    checkStreakAchievement(widget.userH, context);
  }

  Future<void> updateUser() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final querySnapshot = await db.collection("Users").where(
        "Email", isEqualTo: widget.userH.email).get();
    if (querySnapshot.docs.isNotEmpty) {
      var userData = querySnapshot.docs.first.data();
      setState(() {
        widget.userH.streak = userData['Streak'];
        widget.userH.streakSaver = userData['StreakSaver'];
        widget.userH.lastLogin = userData['LastLogin'];
      });
    }
  }

  Future<void> fetchCurrentDate() async {
    try {
      final response = await http.get(
          Uri.parse('https://worldtimeapi.org/api/timezone/Europe/Lisbon'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        dateTime = DateTime.parse(data['datetime']);
        dateTime = dateTime.add(const Duration(hours: 1));
        setState(() {
          currentDate =
          "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month
              .toString().padLeft(2, '0')}/${dateTime.year.toString()}";
        });
      } else {
        print('Failed to load current date: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load current date: $e');
    }
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
      // Navigate to Profile Page
        await updateUser();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(userP: widget.userH),
          ),
        );
        break;
      case 1:
      //Stay on Home Page
        break;
      case 2:
      // Navigate to Settings Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InfoPage(userS: widget.userH),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    List<Uc> favoriteUcs = widget.userH.ucs.where((uc) => uc.favorite).toList();
    favoriteUcs.sort(sortUC);
    widget.userH.sortUcs();

    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20.0),
              alignment: Alignment.center,
              child: const Text(
                'DUO-LEIC',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/minerva_new.png',
                width: size.width * 0.3,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: SizedBox(
                height: 50.0,
                width: size.width,
                child: ElevatedButton(
                  onPressed: () {
                    widget.userH.sortUcs();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SelectClassPage(userP: widget.userH),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    elevation: 2.0,
                  ),
                  child: const Text(
                    'Select a UC',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 16, bottom: 20, top: 20),
              child: Text(
                'Favorite UCs',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            SizedBox(
              height: size.height * .3,
              child: ListView.builder(
                itemCount: favoriteUcs.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClassDetailPage(
                            uc: widget.userH.ucs[index],
                            userP: widget.userH,
                          ),
                        ),
                      );
                    },
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 10,
                              right: 20,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    favoriteUcs[index].favorite = false;
                                    updateUcInFirestore(widget.userH);
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.blueAccent,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        widget.userH.ucs[index].favorite =
                                        false;
                                        updateUcInFirestore(widget.userH);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              right: 20,
                              top: 20,
                              bottom: 20,
                              child: Center(
                                child: Text(
                                  favoriteUcs[index].name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  class ClassesButton extends StatelessWidget {
  final Color color;
  final String title;
  final VoidCallback? onPressed;

  const ClassesButton({super.key,
    required this.color,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 0,
      child: SizedBox(
        height: 50,
        width: 50,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            elevation: 2.0,
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> checkStreakAchievement(UserModel user,BuildContext context) async{
  FirebaseFirestore db = FirebaseFirestore.instance;
  final querySnapshot = await db.collection("Users").where("Email", isEqualTo: user.email).get();
  DocumentReference userDocRef = querySnapshot.docs.first.reference;

  DateTime? lastLoginDate;
  lastLoginDate = DateFormat("dd/MM/yyyy").parse(user.lastLogin);
  int differenceInDays = dateTime.difference(lastLoginDate).inDays;

  if (differenceInDays == 1) {
    await userDocRef.update({
        'LastLogin': "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString()}",
        'Streak': FieldValue.increment(1),
    });
    incrementStreak(user, context);
    if ((user.streak + 1) % 5 == 0 && user.streakSaver < 3) {
      await userDocRef.update({
        'StreakSaver': FieldValue.increment(1),
      });
    }
    return true;
  }
  else if(user.streakSaver > 0 && differenceInDays > 1){
    await userDocRef.update({
        'LastLogin': "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString()}",
        'StreakSaver': FieldValue.increment(-1),
        'Streak': FieldValue.increment(1),
      });
    incrementStreak(user, context);
    if ((user.streak + 1) % 5 == 0 && user.streakSaver < 3) {
      await userDocRef.update({
        'StreakSaver': FieldValue.increment(1),
      });
    }
    return true;
  }
  else if(differenceInDays == 0){
    await userDocRef.update({
        'LastLogin': "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString()}",
      });
    return false;
  }
  else{
    await userDocRef.update({
        'LastLogin': "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString()}",
        'Streak': 0,
        });
      resetStreak(user, context);
      return false;
  }
}