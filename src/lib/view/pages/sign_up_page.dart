import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duo_leic/model/flashcard.dart';
import 'package:duo_leic/model/uc.dart';
import 'package:duo_leic/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:duo_leic/view/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:duo_leic/model/achievement.dart';
import 'package:duo_leic/model/quizz.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  bool _isSecurePassword = true;
  final userRepo = Get.put(UserRepository());
  final FireBaseAuthService _auth = FireBaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final TextEditingController _userController = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _emailController.dispose();
    _passwordController1.dispose();
    _passwordController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
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
                Text(
                  'Start your Studies',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 18.0),
                Image.asset(
                  'assets/images/minerva_new.png',
                  height: 150,
                ),
                SizedBox(height: 24.0),
                TextField(
                  controller: _userController,
                  decoration: InputDecoration(
                    constraints: BoxConstraints.tightFor(width: 300),
                    filled: true, // Set to true to fill the background
                    fillColor: Colors.blueAccent.withOpacity(0.2),
                    hintText: 'Username',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      // Add border to the box
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                ),
                SizedBox(height: 14.0),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    constraints: BoxConstraints.tightFor(width: 300),
                    filled: true,
                    fillColor: Colors.blueAccent.withOpacity(0.2),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      // Add border to the box
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                ),
                SizedBox(height: 14.0),
                TextField(
                  controller: _passwordController1,
                  obscureText: _isSecurePassword,
                  decoration: InputDecoration(
                    constraints: BoxConstraints.tightFor(width: 300),
                    filled: true,
                    fillColor: Colors.blueAccent.withOpacity(0.2),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      // Add border to the box
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    suffixIcon: togglePassword(),
                  ),
                ),
                SizedBox(height: 14.0),
                TextField(
                  controller: _passwordController2,
                  obscureText: _isSecurePassword,
                  decoration: InputDecoration(
                    constraints: const BoxConstraints.tightFor(width: 300),
                    filled: true,
                    fillColor: Colors.blueAccent.withOpacity(0.2),
                    hintText: 'Confirm password',
                    hintStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      // Add border to the box
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    suffixIcon: togglePassword(),
                  ),
                ),
                SizedBox(height: 18.0),
                ElevatedButton(
                  onPressed: signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  void signUp() async {
    String username = _userController.text;
    String email = _emailController.text;
    String password = _passwordController1.text; 
    String confirmPassword = _passwordController2.text;
    if (checkField(username, email, password, confirmPassword)) {
    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      List<Achievement> achievements = await _auth.fetchAchievements();
      FirebaseFirestore db = FirebaseFirestore.instance;
      var querySnapshot = await db.collection("Quizzes").get();
      List<Question> questions = querySnapshot.docs.map((doc) {
        var data = doc.data();
        return Question(
          uc: data['UC'],
          choices: data['Options'],
          level: data['Level'],
          correctAnswerIndex: data['Correct Answer'] ?? 0,
          questionText: data['Text'],
        );
      }).toList();

      List<Quiz> quizzes = [];
        List<String> classNames = [
        'Matemática Discreta',
        'Álgebra Linear e Geometria Analítica',
        'Análise Matemática I',
        'Fundamentos de Sistemas Computacionais',
        'Fundamentos da Programação',
        'Análise Matemática II',
        'Física I',
        'Teoria da Computação',
        'Arquitetura de Computadores',
        'Programação',
        'Bases de Dados',
        'Algoritmos e Estruturas de Dados',
        'Física II',
        'Sistemas Operativos',
        'Laboratório de Desenho e Teste de Software',
        'Desenho de Algoritmos',
        'Laboratório de Computadores',
        'Linguagens e Tecnologias Web',
        'Engenharia de Software',
        'Métodos Estatísticos',
        'Interação Pessoa Computador',
        'Fundamentos de Segurança Informática',
        'Laboratório de Bases de Dados e Aplicações Web',
        'Redes de Computadores',
        'Programação Funcional e em Lógica',
        'Computação Paralela e Distribuída',
        'Compiladores',
        'Computação Gráfica',
        'Projeto Integrador',
        'Inteligência Artificial',
        ];

        for(int i = 0; i< classNames.length; i++){
          for(int j = 1; j<7; j++){
            quizzes.add(Quiz(uc: classNames[i], level: j , questions: [], grade: 0));
          }
        }
      for (int i = 0; i < quizzes.length; i++) {
        try {
          var matchingQuestions = questions.where(
                (quest) => quest.uc == quizzes[i].uc && quest.level == quizzes[i].level,
          ).toList();
          if (matchingQuestions.isNotEmpty) {
            for(int j = 0; j<matchingQuestions.length; j++){
              quizzes[i].questions.add(matchingQuestions[j]);
            }
          }
        } catch (e) {
        }
      }

      querySnapshot = await db.collection("FlashCards").get();
      List<FlashCard> flashCards = querySnapshot.docs.map((doc) {
        var data = doc.data();
        return FlashCard(
          uc: data['UC'],
          text1: data['1'],
          text2: data['2'],
          text3: data['3'],
          text4: data['4'],
          text5: data['5'],
          text6: data['6'],
          themes: data['Temas'],
          read: false,
        );
      }).toList();

      List<Uc> userUcs = [];
      for(int i = 0; i < classNames.length; i++){
        List<Quiz> newQuizzes = [];
        FlashCard newFlashCard = FlashCard(themes: {}, text1: [], text2: [], text3: [], text4: [], text5: [], text6: [], uc: "", read: false);
        for(int j = 0; j < quizzes.length; j++){
          if(classNames[i] == quizzes[j].uc){
            newQuizzes.add(quizzes[j]);
          }
        }
        for(int j = 0; j < flashCards.length; j++){
          if(classNames[i] == flashCards[j].uc){
            newFlashCard = flashCards[j];
            break;
          }

        }
        userUcs.add(Uc(unlockedLevel: 1,name: classNames[i], quizzes: newQuizzes,flashCards: newFlashCard, favorite: false ));
      }
      final user = UserModel(username: username, email: email, streak: 1, streakSaver: 0,levelsCompleted:0 , achievements: achievements, ucs: userUcs, follows: [], followers: [], lastLogin: "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString()}");
      incrementStreak(user, context);
      user.sortUcs();
      await userRepo.createUser(user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userH: user)),
        );
      } 
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your email already exists or is not valid',
            style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.black,
            ),
          );
        return;
      }
    }
  }

  bool checkField(String username, String email, String password, String confirmPassword){
    switch(checkFieldLogic(username, email, password, confirmPassword)){
      case 1:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You need to fill all the fields',
            style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.black,
            ),
          );
        return false;
      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Your password should have more than 8 letters',
            style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.black,
            
            ),
          );
        return false;
      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match',
            style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.black,
            
            ),
          );
        return false;
      case 0:
        return true;
      default:
        return false;
    }
  }
  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isSecurePassword = !_isSecurePassword;
        });
      },
      icon: _isSecurePassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }

}


class FireBaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print('Error creating user: $e');
      return null;
    }
  }

  Future<List<Achievement>> fetchAchievements() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final querySnapshot = await db.collection("Achievements").get();
    return querySnapshot.docs.map((doc) {
      var data = doc.data();
      return Achievement(
        title: data['Title'] ?? 'No Title',
        description: data['Description'] ?? 'No Description',
        quantity: data['Quantity'] ?? 0,
        current: 0,
      );
    }).toList();
  }

}

/*
return 1- campo vazio
return 2- password.lenght < 8
return 3- password!=confirmPassword
return 0- tudo OK
*/
int checkFieldLogic(String username, String email, String password, String confirmPassword){
  if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty){
    return 1;
  }
  else if(password.length < 8){
    return 2;
  }
  else if(password !=confirmPassword){
    return 3;
  }
  else{
    return 0;
  }
}