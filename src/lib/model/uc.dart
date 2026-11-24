import 'package:duo_leic/model/flashcard.dart';
import 'package:duo_leic/model/quizz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:duo_leic/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Uc {
  String name;
  List<Quiz> quizzes;
  FlashCard flashCards;
  int unlockedLevel;
  bool favorite;

  Uc({required this.name, required this.quizzes, required this.flashCards, required this.unlockedLevel, required this.favorite});

  Map<String, dynamic> toJson() {
    return {
      "Name": name,
      "Quizzes": quizzes.map((q) => q.toJson()).toList(),
      "UnlockedLevel": unlockedLevel,
      "Favorite": favorite,
      "FlashCards": flashCards.toJson(), // Serialize FlashCard to JSON
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "Name": name,
      "Quizzes": quizzes.map((q) => q.toMap()).toList(),
      "UnlockedLevel": unlockedLevel,
      "Favorite": favorite,
      "FlashCards": flashCards.toMap(), // Serialize FlashCard to Map
    };
  }

  factory Uc.fromMap(Map<String, dynamic> map) {
    List<dynamic> quizzesData = map['Quizzes'] ?? [];
    List<Quiz> quizzes = quizzesData.map((q) => Quiz.fromMap(q)).toList();
    return Uc(
      name: map['Name'] ?? '',
      favorite: map['Favorite'],
      quizzes: quizzes,
      unlockedLevel: map['UnlockedLevel'] ?? 0,
      flashCards: FlashCard.fromMap(map['FlashCards']), // Deserialize FlashCard from Map
    );
  }

  void setUnlockedLevels(int a) {
    unlockedLevel = a;
  }
}

int sortUC(Uc a, Uc b) {
  if (a.favorite != b.favorite) {
    // If one is favorite and the other is not, prioritize favorite
    return a.favorite ? -1 : 1;
  } else {
    // If both are either favorite or not, sort alphabetically by name
    return a.name.compareTo(b.name);
  }
}

  void setUnlockedLevels(UserModel user, Uc uc,int a){
    uc.setUnlockedLevels(a);
    updateUcInFirestore(user);
  }

Future<void> updateUcInFirestore(UserModel userModel) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  final querySnapshot = await db.collection("Users").where("Email", isEqualTo: user?.email).get();
  
  if (querySnapshot.docs.isNotEmpty) {
    var userData = querySnapshot.docs.first.data();
    var userDocRef = querySnapshot.docs.first.reference; // referência do user

    if (userData.containsKey('Ucs')) {
      List<dynamic> userUcs = userData['Ucs'];
      
      for (Uc uc in userModel.ucs) {
        var ucToUpdate = userUcs.firstWhere(
          (ucMap) => ucMap['Name'] == uc.name,
          orElse: () => null,
        ); // Uc a atualizar
        
        if (ucToUpdate != null) {
          ucToUpdate['Favorite'] = uc.favorite;
          ucToUpdate['UnlockedLevel'] = uc.unlockedLevel;
          
          for (Quiz quizz in uc.quizzes) {
            var quizToUpdate = (ucToUpdate['Quizzes'] as List<dynamic>).firstWhere(
              (quizMap) => quizMap['Uc'] == quizz.uc && quizMap['Level'] == quizz.level,
              orElse: () => null,
            );
            if (quizToUpdate != null) {
              quizToUpdate['Grade'] = quizz.grade;
            }
          }
        }
      }
      
      await userDocRef.update({
        'Ucs': userUcs,
      });
    } else {
      print('Ucs content not found in the user');
    }
  }
}