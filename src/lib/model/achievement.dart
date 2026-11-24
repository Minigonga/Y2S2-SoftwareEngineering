import 'package:duo_leic/model/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duo_leic/view/pages/widgets/achievement_pop_up.dart';

class Achievement {
  String title;
  String description;
  int quantity;
  int current;

  Achievement({
    required this.title,
    required this.description,
    required this.quantity,
    required this.current
  });

  toJson() {
    return {
      "Title": title,
      "Description": description,
      "Quantity": quantity,
      "Current": current,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "quantity": quantity,
      "current": current,
    };
  }
}

Future<void> updateAchievementInFirestore(UserModel userModel) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  final querySnapshot = await db.collection("Users").where("Email", isEqualTo: userModel?.email).get();
  if (querySnapshot.docs.isNotEmpty) {
    var userData = querySnapshot.docs.first.data();
    var userDocRef = querySnapshot.docs.first.reference; //referencia do user
    if (userData.containsKey('Achievements')) {
      var userAchievements = userData['Achievements'];
      for(Achievement achievementt in userModel.achievements){
          var achievementToUpdate = userAchievements.firstWhere((achievement) => achievement['Title'] == achievementt.title,orElse: () => null,);  //achievement a atualizar
          if (achievementToUpdate != null) {
          achievementToUpdate['Current'] = achievementt.current;
            await userDocRef.update({
            'Achievements': userAchievements,
          });
      }
      }
    }
    else {
      print('Achievements content not found in the user');
    }
  }
}

Future<void> updateStreakSaver(UserModel user) async { //still testing
  FirebaseFirestore db = FirebaseFirestore.instance;
  final querySnapshot = await db.collection("Users").where("Email", isEqualTo: user.email).get();
  DocumentReference userDocRef = querySnapshot.docs.first.reference;
  if (user.streakSaver < 3) {
    await userDocRef.update({
      'StreakSaver': FieldValue.increment(1),
    });
    user.streakSaver++;
  }
}

void achievementPopUp(UserModel user, Achievement achievement, BuildContext context) async {
    if(achievement.current == achievement.quantity){
      AchievementPopup.show(context, achievement, user);
      updateStreakSaver(user);
    }
}
