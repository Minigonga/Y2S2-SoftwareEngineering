import 'package:duo_leic/model/flashcard.dart';
import 'package:duo_leic/model/uc.dart';
import 'package:duo_leic/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

  testWidgets('Navigation Test: Switching between Class Pages', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: SelectClassPage(userP: createUser()),
      ),
    );

    // Tap on a subject
    await tester.tap(find.text('Test Class'));
    await tester.pumpAndSettle();

    // Expect to find the ClassDetailPage
    expect(find.byType(ClassDetailPage), findsOneWidget);

    // Tap on the back button to trigger navigation
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Expect to find the SelectClassPage
    expect(find.byType(SelectClassPage), findsOneWidget);
    expect(find.text('CLASSES'), findsOneWidget);

    // Tap on a subject
    await tester.tap(find.text('Test Class'));
    await tester.pumpAndSettle(); // Wait for navigation transition

    // Expect to find the ClassDetailPage
    await tester.tap(find.text('Test Class'));
    expect(find.byType(ClassDetailPage), findsOneWidget);
  });
}
