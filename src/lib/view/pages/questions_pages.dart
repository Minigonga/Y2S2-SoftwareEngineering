import 'dart:math';
import 'package:duo_leic/model/achievement.dart';
import 'package:duo_leic/model/uc.dart';
import 'package:flutter/material.dart';
import 'package:duo_leic/model/quizz.dart';
import 'package:duo_leic/model/user.dart';
import 'package:duo_leic/view/pages/select_class_page.dart';


int correctAnswers = 0;

class QuizPage extends StatefulWidget {

    final Uc uc;
    final Quiz quiz;
    final UserModel userP;

    QuizPage({required this.uc, required this.userP, required this.quiz});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  int currentQuestionIndex = 0; // Tracks the current question
  List<int?> userAnswers = [null, null, null,null, null, null,null, null, null,null];

  @override
  Widget build(BuildContext context) {


    final currentQuestion = widget.quiz.questions[currentQuestionIndex];

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if(!didPop) {
          final nav = Navigator.of(context);
          final result = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Exit Quiz?'),
                content: const Text('Are you sure you want to exit the quiz? All progress will be lost.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Exit'),
                  ),
                ],
              )
          );
          if (result) {
            nav.pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
          widget.uc.name,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),

          backgroundColor: Colors.blueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question ${currentQuestionIndex + 1}: ${currentQuestion.questionText}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ...currentQuestion.choices.asMap().entries.map((entry) {
                int index = entry.key;
                String choice = entry.value;
                return RadioListTile<int>(
                  title: Text(choice),
                  value: index,
                  groupValue: userAnswers[currentQuestionIndex],
                  onChanged: (value) {
                    setState(() {
                      userAnswers[currentQuestionIndex] = value; // Save the answer
                    });
                  },
                );
              }).toList(),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: currentQuestionIndex > 0 ? goToPreviousQuestion : null,
                      child: Text(
                        "Previous",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        if (currentQuestionIndex < widget.quiz.questions.length - 1) {
                          goToNextQuestion();
                        } else {
                          showQuizResult();
                        }
                      },
                      child: Text(
                          currentQuestionIndex < widget.quiz.questions.length - 1 ? 'Next' : 'Finish Quiz',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


showQuizResult() async {
  for (int i = 0; i < widget.quiz.questions.length; i++) {
    if (userAnswers[i] == widget.quiz.questions[i].correctAnswerIndex) {
      correctAnswers++;
    }
  }
  widget.quiz.grade = max(widget.quiz.grade, correctAnswers);
  print(widget.quiz.grade);
  bool correct = correctAnswers / widget.quiz.questions.length >= 0.7;
  updateUcInFirestore(widget.userP);

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('Quiz Results'),
        content: Text('You got $correctAnswers out of ${widget.quiz.questions.length} correct!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Close the "Quiz Results" dialog
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClassDetailPage(userP: widget.userP, uc: widget.uc)),
              );
              if(correct && widget.uc.unlockedLevel == widget.quiz.level){
                setLevelsCompleted(widget.userP, widget.userP.levelsCompleted+1);
                setUnlockedLevels(widget.userP, widget.uc, widget.uc.unlockedLevel+1);
                if(correctAnswers == 10){
                  checkPerfectQuiz(widget.userP,context); //15
                  checkPerfectUC(widget.userP, context); //16
                  checkPerfectAll(widget.userP,context); //17
                }
                checkRookie(widget.userP,context);  //1
                checkVeteran(widget.userP, context); //2
                checkMaster(widget.userP, context); //3
                showAdditionalDialog();
              }
              correctAnswers = 0;
            },
            child: const Text('CLOSE'),
          ),
        ],
      );
    },
  );
}

void checkRookie(UserModel user, BuildContext context){

  int count = 0;

  for(var uc in user.ucs){
    if(uc.unlockedLevel > 1 && (uc.name == 'Desenho de Algoritmos' || uc.name == 'Laboratório de Computadores' || uc.name == 'Linguagens e Tecnologias Web' || uc.name == 'Engenharia de Software' || uc.name == 'Métodos Estatísticos')){
      count++;
    } 
  }

  for(Achievement achievement in user.achievements){
    if(achievement.title == 'Quiz Rookie'){
        if(achievement.current < achievement.quantity){
          achievement.current = count;
          achievementPopUp(user, achievement, context);
        }
    }
    break;
  }
  updateAchievementInFirestore(user);
}

void checkPerfectQuiz(UserModel user, BuildContext context){
  for(Achievement achievement in user.achievements){
    if(achievement.title == 'Perfect Score'){
        if(achievement.current < achievement.quantity){
          achievement.current = achievement.quantity;
          achievementPopUp(user, achievement, context);
        }
    }
    break;
  }
  updateAchievementInFirestore(user);
}

void checkPerfectUC(UserModel user, BuildContext context){
  int count = 0;
  int temp = 0;
  for(var uc in user.ucs){
    temp = 0;
    for(var quiz in uc.quizzes){
      if(quiz.grade == 10){
        temp++;
      }
    }
    if(temp == uc.quizzes.length){
      break;
    }
    count = max(temp, count);
  }
  for(Achievement achievement in user.achievements){
    if(achievement.title == 'Top of the Class'){
      if(achievement.current < achievement.quantity){
        achievement.current = count;
        achievementPopUp(user, achievement, context);
      }
    }
    break;
  }
  updateAchievementInFirestore(user);
}

void checkPerfectAll(UserModel user, BuildContext context){
  bool perfect = true;
  int ucs = 0;
  int temp = 0;
  for(var uc in user.ucs){
    temp = 0;
    perfect = true;
    if(uc.name == 'Desenho de Algoritmos' || uc.name == 'Laboratório de Computadores' || uc.name == 'Linguagens e Tecnologias Web' || uc.name == 'Engenharia de Software' || uc.name == 'Métodos Estatísticos'){
      for(var quiz in uc.quizzes){
        if(quiz.grade != 10){
          perfect = false;
        }
      }
      if(perfect){
        temp++;
        break;
      }
      ucs = max(temp, ucs);
    }
  }
  for(Achievement achievement in user.achievements){
    if(achievement.title == 'Quiz Wizard'){
      if(achievement.current < achievement.quantity){
        achievement.current = ucs;
        achievementPopUp(user, achievement, context);
      }
    }
    break;
  }
  updateAchievementInFirestore(user);
}

void checkVeteran(UserModel user, BuildContext context){
  int count = 0;

  for(var uc in user.ucs){
    if(uc.unlockedLevel >= 3 && (uc.name == 'Desenho de Algoritmos' || uc.name == 'Laboratório de Computadores' || uc.name == 'Linguagens e Tecnologias Web' || uc.name == 'Engenharia de Software' || uc.name == 'Métodos Estatísticos')){
      count++;
    } 
  }

  for(Achievement achievement in user.achievements){
    if(achievement.title == 'Quiz Veteran'){
        if(achievement.current < achievement.quantity){
          achievement.current = count;
          achievementPopUp(user, achievement, context);
        }
    }
    break;
  }
  updateAchievementInFirestore(user);
}

void checkMaster(UserModel user, BuildContext context){
  int count = 0;

  for(var uc in user.ucs){
    if(uc.unlockedLevel == 6 && (uc.name == 'Desenho de Algoritmos' || uc.name == 'Laboratório de Computadores' || uc.name == 'Linguagens e Tecnologias Web' || uc.name == 'Engenharia de Software' || uc.name == 'Métodos Estatísticos')){
      count++;
    } 
  }

  for(Achievement achievement in user.achievements){
    if(achievement.title == 'Quiz Master'){
        if(achievement.current < achievement.quantity){
          achievement.current = count;
          achievementPopUp(user, achievement, context);
        }
    }
    break;
  }
  updateAchievementInFirestore(user);
}

void showAdditionalDialog() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('You advanced to the next level'),
        content: Text('Now you can do the quizz ${widget.quiz.level+1}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
               // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void goToNextQuestion() {
  if (currentQuestionIndex < widget.quiz.questions.length - 1) {
    setState(() {
      currentQuestionIndex++;
    });
  } else {
    showQuizResult(); // Show result at the end
  }
}

void goToPreviousQuestion() {
  if (currentQuestionIndex > 0) {
    setState(() {
      currentQuestionIndex--;
    });
  }
}

  Future<bool> showExitWarning() async {
    // Show a confirmation dialog when the user tries to go back
    final bool result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit Quiz?'),
          content: const Text('Are you sure you want to exit the quiz? All progress will be lost.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    );
    return result;
  }
}

