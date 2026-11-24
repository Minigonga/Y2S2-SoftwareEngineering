import 'package:duo_leic/model/achievement.dart';
import 'package:duo_leic/model/uc.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserModel {
  String username;
  String email;
  int streak;
  int streakSaver;
  int levelsCompleted;
  List<Achievement> achievements;
  List<Uc> ucs;
  List<String> follows;
  List<String> followers;
  String lastLogin;

  UserModel({
    required this.username,
    required this.email,
    required this.streak,
    required this.streakSaver,
    required this.levelsCompleted,
    required this.achievements,
    required this.ucs,
    required this.follows,
    required this.followers,
    required this.lastLogin,
  });

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "email": email,
      "streak": streak,
      "streakSaver": streakSaver,
      "levelsCompleted": levelsCompleted,
      "achievements": achievements.map((achievement) => achievement.toMap()).toList(),
      "Ucs": ucs.map((uc) => uc.toMap()).toList(),
      "Follows": follows.toList(),
      "Followers": followers.toList(),
      "lastLogin": lastLogin,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "Username": username,
      "Email": email,
      "Streak": streak,
      "StreakSaver": streakSaver,
      "LevelsCompleted": levelsCompleted,
      "Achievements": achievements.map((achievement) => achievement.toJson()).toList(),
      "Ucs": ucs.map((uc) => uc.toJson()).toList(),
      "Follows": follows.toList(),
      "Followers": followers.toList(),
      "LastLogin": lastLogin,
    };
  }

  void sortUcs() {
    ucs.sort((a, b) => sortUC(a, b));
  }

  void setLevelsCompleted(int a) {
    levelsCompleted = a;
  }
}



class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    await _db.collection("Users").add(user.toJson());
  }
}

  void addFollow(UserModel userN, String username){
    userN.follows.add(username);
    updateFollowsInFirestore(userN);
  }
  void addFollower(UserModel userN, String username){
    userN.followers.add(username);
    updateFollowersInFirestore(userN);
    for(Achievement achievements in userN.achievements){
      if(achievements.title=="Spy" && achievements.current!=achievements.quantity){
        achievements.current=0;
      }
    }
    updateAchievementInFirestore(userN);
  }
  void removeFollow(UserModel userN, String username){
    userN.follows.remove(username);
    updateFollowsInFirestore(userN);
  }
  void removeFollower(UserModel userN, String username){
    userN.followers.remove(username);
    updateFollowersInFirestore(userN);
  }

void setLevelsCompleted(UserModel user, int a){
  user.setLevelsCompleted(a);
  updateLevelsCompletedInFirestore(user);
}

Future<void> updateLevelsCompletedInFirestore(UserModel userModel) async {
FirebaseFirestore db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;
final querySnapshot = await db.collection("Users").where("Email", isEqualTo: user?.email).get();
if (querySnapshot.docs.isNotEmpty) {
  var userData = querySnapshot.docs.first.data();
  var userDocRef = querySnapshot.docs.first.reference; //referencia do user
  if (userData.containsKey('LevelsCompleted')) {
      await userDocRef.update({
      'LevelsCompleted': userModel.levelsCompleted,
      });
    }
    }
  else {
    print('Levels completed content not found in the user');
  }
}

Future<void> updateFollowsInFirestore(UserModel userModel) async {
FirebaseFirestore db = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;
final querySnapshot = await db.collection("Users").where("Email", isEqualTo: user?.email).get();
if (querySnapshot.docs.isNotEmpty) {
  var userData = querySnapshot.docs.first.data();
  var userDocRef = querySnapshot.docs.first.reference; //referencia do user
  if (userData.containsKey('Follows')) {
      await userDocRef.update({
      'Follows': userModel.follows,
      });
    }
    }
  else {
    print('Follows content not found in the user');
  }
}

Future<void> updateFollowersInFirestore(UserModel userModel) async {
FirebaseFirestore db = FirebaseFirestore.instance;
final querySnapshot = await db.collection("Users").where("Email", isEqualTo: userModel?.email).get();
if (querySnapshot.docs.isNotEmpty) {
  var userData = querySnapshot.docs.first.data();
  var userDocRef = querySnapshot.docs.first.reference; //referencia do user
  if (userData.containsKey('Followers')) {
      await userDocRef.update({
      'Followers': userModel.followers,
      });
    }
    }
  else {
    print('Followers content not found in the user');
  }
}

void incrementStreak(UserModel user, BuildContext context){
  for (var achievement in user.achievements) {
      if (achievement.title == 'Baby Steps' ||achievement.title == 'Consistency Club' || achievement.title == 'Perfect Attendance'|| (achievement.title == 'Spy' && user.followers.isEmpty)) {
            if(achievement.current < achievement.quantity){
              achievement.current++;
              achievementPopUp(user, achievement, context);
            }
      }
  }
  updateAchievementInFirestore(user);
}

void resetStreak(UserModel user, BuildContext context) {
  user.achievements.forEach((achievement) {
      if (achievement.title == 'Baby Steps' ||
          achievement.title == 'Consistency Club' ||
          achievement.title == 'Perfect Attendance' ||
          achievement.title == 'Spy') {
            if(achievement.current != achievement.quantity){
              achievement.current = 0;
            }
      }
    });
    updateAchievementInFirestore(user);
}

