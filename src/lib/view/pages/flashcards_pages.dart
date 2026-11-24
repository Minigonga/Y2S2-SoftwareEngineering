import 'package:duo_leic/model/uc.dart';
import 'package:duo_leic/view/pages/select_class_page.dart';
import 'package:flutter/material.dart';

import '../../model/user.dart';

class FlashcardPage extends StatefulWidget {

  final Uc uc;
  final int index;
  final UserModel userP;

  FlashcardPage({required this.uc, required this.index, required this.userP});



  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  int _currentIndex = 0;

  void _nextFlashcard() {
    setState(() {
      if (_currentIndex < 10 - 1) {
        _currentIndex++;
      }
    });
  }

  void _previousFlashcard() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      }
    });
  }

  void _closeFlashcard(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassDetailPage(userP: widget.userP, uc: widget.uc,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    List<dynamic> flashcards = [];
    switch (widget.index){
      case 1:
        flashcards = widget.uc.flashCards.text1;
        break;
      case 2:
        flashcards = widget.uc.flashCards.text2;
        break;
      case 3:
        flashcards = widget.uc.flashCards.text3;
        break;
      case 4:
        flashcards = widget.uc.flashCards.text4;
        break;
      case 5:
        flashcards = widget.uc.flashCards.text5;
        break;
      case 6:
        flashcards = widget.uc.flashCards.text6;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.uc.name,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClassDetailPage(uc: widget.uc, userP: widget.userP),
              ),
            );
          },
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.uc.flashCards.themes['${widget.index}'],
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    flashcards[_currentIndex],
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Spacer(), // Use Spacer to push buttons to the bottom
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
                  onPressed: _currentIndex > 0 ? _previousFlashcard : null,
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
                  onPressed: _currentIndex == flashcards.length - 1
                      ? () => _closeFlashcard(context)
                      : _nextFlashcard,
                  child: Text(
                    _currentIndex == flashcards.length - 1 ? "Close" : "Next",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}