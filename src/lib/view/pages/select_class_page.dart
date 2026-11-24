import 'package:duo_leic/model/uc.dart';
import 'package:duo_leic/view/pages/profile_page.dart';
import 'package:duo_leic/view/pages/questions_pages.dart';
import 'package:duo_leic/view/pages/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:duo_leic/model/user.dart';
import 'package:duo_leic/model/quizz.dart';
import 'flashcards_pages.dart';
import 'home_page.dart';
import 'info_page.dart';

class SelectClassPage extends StatefulWidget {
  final UserModel userP;

  const SelectClassPage({super.key, required this.userP});

  @override
  _SelectClassPageState createState() => _SelectClassPageState();
}

class _SelectClassPageState extends State<SelectClassPage> {
  int _selectedIndex = 0;

  bool toggleIsFavorated(bool isFavorited) {
    return !isFavorited;
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(userP: widget.userP),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(userH: widget.userP),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InfoPage(userS: widget.userP),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Center(
                  child: Text(
                    'CLASSES',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.userP.ucs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClassDetailPage(
                            uc: widget.userP.ucs[index],
                            userP: widget.userP,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.userP.ucs[index].name,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              widget.userP.ucs[index].favorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: widget.userP.ucs[index].favorite
                                  ? Colors.blueAccent
                                  : null,
                            ),
                            onPressed: () {
                              setState(() {
                                widget.userP.ucs[index].favorite =
                                    toggleIsFavorated(widget.userP.ucs[index].favorite);
                                updateUcInFirestore(widget.userP);
                                widget.userP.sortUcs();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClassDetailPage extends StatefulWidget {
  final Uc uc;
  final UserModel userP;

  ClassDetailPage({required this.uc, required this.userP});

  @override
  _ClassDetailPageState createState() => _ClassDetailPageState();
}
class _ClassDetailPageState extends State<ClassDetailPage> {
  int selectedQF = -1;
  List<int> _containerflexQF = [2, 1]; // Initial flex values for Quizzes and Flashcards
  int showList = 1;

  @override
  Widget build(BuildContext context) {

    if(widget.uc.quizzes.isNotEmpty && widget.uc.quizzes[0].questions.isNotEmpty){
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.uc.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              fontFamily: 'Roboto',
            ),
            maxLines: 2, // Limit to two lines
            overflow: TextOverflow.ellipsis, // Use ellipsis if text still overflows
            softWrap: true,
          ),
          centerTitle: true,
          backgroundColor: Colors.white54,
        ),
        body: Column(
          children: [
            Row(
              children: List.generate(
                _containerflexQF.length,
                    (index_) => Expanded(
                  flex: _containerflexQF[index_],
                  child: Container(
                    height: 60,
                    child: FlashQuizzButton(
                      color: _getColorForIndex(index_),
                      title: _getTitleForIndexQF(index_),
                      onPressed: () {
                        setState(() {
                          if (selectedQF != index_) {
                            _containerflexQF = List.filled(_containerflexQF.length, 1);
                            _containerflexQF[index_] = 2;
                            selectedQF = index_;
                          }
                          if (index_ == 0){
                            showList = 1;
                          }
                          else if(index_ == 1){
                            showList = 2;
                          }
                          else {showList = 0;}
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (showList ==2)
              Expanded(
                child: ListView.builder(
                  itemCount: 6, // Example number of items
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          // Handle tapping on list items if needed
                        },
                        child: SizedBox(
                          width: 100,  
                          height: 60,
                          child: levelButton(
                              color: _getColorForLevel(index), 
                              title: (widget.uc.flashCards.themes['${index+1}']),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FlashcardPage(userP: widget.userP, uc: widget.uc, index: index+1),
                                  ),
                                );
                              }
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (showList == 1)
              Expanded(
                child: ListView.builder(
                  itemCount: widget.uc.quizzes.length, // Example number of items
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), 
                      child: GestureDetector(
                        onTap: () {
                          // Handle tapping on list items if needed
                        },
                        child: SizedBox(
                          width: 100,  
                          height: 60,
                          child: levelButton(
                              color: widget.uc.unlockedLevel>index ? _getColorForLevel(index): Colors.grey, 
                              title: widget.uc.unlockedLevel>index ? ("Level ${index+1}"): ("Level Locked"),
                              onPressed: () {
                                if (widget.uc.unlockedLevel>index){
                                  Quiz quiz = widget.uc.quizzes.firstWhere(
                                        (quiz) => quiz.level==index+1,
                                  );
                                  int unlockedLevelold=widget.uc.unlockedLevel;
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuizPage(userP: widget.userP, quiz: quiz, uc: widget.uc),
                                    ),
                                  );
                                  if(unlockedLevelold!=widget.uc.unlockedLevel){

                                  }
                                }
                              }
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      );
    }
    else{
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.uc.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              fontFamily: 'Roboto',
            ),
            maxLines: 2, // Limit to two lines
            overflow: TextOverflow.ellipsis, // Use ellipsis if text still overflows
            softWrap: true,
          ),
          centerTitle: true,
          backgroundColor: Colors.white54,
        ),
        body: const Center(
          child: Text(
              'There is no available content for this class :(',
              style: TextStyle(fontSize: 17),

          ),
        ),
      );
    }
  }
}


 Color _getColorForLevel(int index) {
      if( index < 2){
        return Colors.green;
      }
      else if( index < 4){
        return Colors.amberAccent;
      }
      else if( index < 6){
        return Colors.orangeAccent;
      }
      return Colors.grey;
  }

  Color _getColorForIndex(int index) {
      switch (index%2) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.blue;
      default:
        return Colors.grey;
    }
      
  }


  String _getTitleForIndexQF(int index_) {
    switch (index_ % 2) {
      case 0:
        return "Quizzes";
      case 1:
        return "Flash Cards";
      default:
        return "";
    }
  }



class FlashQuizzButton extends StatelessWidget {
  final Color color;
  final String title;
  final VoidCallback? onPressed;

  const FlashQuizzButton({
    required this.color,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0), 
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color, 
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 2.0, 
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class levelButton extends StatelessWidget {
  final Color color;
  final String title;
  final VoidCallback? onPressed;

  const levelButton({
    required this.color,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0), 
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color, 
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 2.0, 
        ),    
        child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
        
      ),
    );
  }
}
