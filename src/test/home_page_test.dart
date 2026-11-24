import 'package:duo_leic/model/flashcard.dart';
import 'package:duo_leic/model/uc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duo_leic/model/user.dart';
import 'package:duo_leic/view/pages/select_class_page.dart';

void main() {

  UserModel createUser() {
    return UserModel(
      username: 'TestUser',
      email: 'test@example.com',
      streak: 0,
      streakSaver: 0,
      levelsCompleted: 0,
      achievements: [],
      ucs: [
        Uc(
          name: 'Test Class',
          quizzes: [],
          //flashCards: [],
          unlockedLevel: 0,
          favorite: false, flashCards: FlashCard(themes: {}, text1: [], text2: [], text3: [], text4: [], text5: [], text6: [], uc: "uc", read: false),
        ),
      ],
      follows: [],
      followers: [],
      lastLogin: '',
    );
  }

  testWidgets('SelectClassPage navigates to ClassDetailPage', (WidgetTester tester) async {
    // Build the SelectClassPage
    await tester.pumpWidget(
      MaterialApp(
        home: SelectClassPage(userP: createUser()),
      ),
    );

    // Tap on the ListTile to navigate to ClassDetailPage
    await tester.tap(find.text('Test Class'));
    await tester.pumpAndSettle();

    // Verify if navigation to ClassDetailPage occurred
    expect(find.byType(ClassDetailPage), findsOneWidget);
  });
}