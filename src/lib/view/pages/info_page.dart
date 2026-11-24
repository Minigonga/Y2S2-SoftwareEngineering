import 'package:duo_leic/model/user.dart';
import 'package:flutter/material.dart';
import 'package:duo_leic/view/pages/widgets/bottom_navigation_bar.dart';
import 'package:duo_leic/view/pages/home_page.dart';
import 'package:duo_leic/view/pages/profile_page.dart';

class InfoPage extends StatelessWidget {
  final UserModel userS;

  const InfoPage({super.key, required this.userS});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Info Cards',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: 'Achievements',
              content: [
                'List of Objectives You Can Complete',
                '- Quiz Rookie: Complete all level 1 quizzes for all UCs from the second semester of the second year.',
                '- Baby Steps: Reach a 7 days streak.',
                '- Consistency Club: Reach a 30 days streak.',
                '- Perfect Attendance: Reach a 365 days streak.',
                '- Not Alone: Have one follower.',
                '- Popular: Have 5 followers.',
                '- Friendly: Have 10 followers.',
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: 'Streak',
              content: [
                'Consecutive Days You Logged In',
                '- Track your daily activity and maintain a consistent learning habit.',
                '- Earn achievements for hitting milestones such as:',
                '  - 7-day streak',
                '  - 30-day streak',
                '  - 365-day streak',
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: 'Quizzes',
              content: [
                'Test Your Knowledge with a Variety of Questions',
                '- Quizzes are tailored to difficulty levels.',
                '- Each quiz contains a mix of multiple-choice and true/false questions.',
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: 'Flashcards',
              content: [
                'Learn New Topics with Flashcards',
                '- Use flashcards to reinforce your knowledge on various subjects.',
                '- Each flashcard contains content about a subject.',
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: 'StreakSaver',
              content: [
                'Save Your Streaks with StreakSavers',
                '- StreakSavers are tokens that protect your streaks from breaking if you miss a day.',
                '- Earning StreakSavers:',
                '  - Log in for 5 consecutive days to earn 1 StreakSaver.',
                '  - Complete an achievement to earn an additional StreakSaver.',
                '- You can have a maximum of 2 StreakSavers.',
                '- Using StreakSavers: If you miss a day, a StreakSaver will automatically be used to maintain your streak.',
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
            // Navigate to Profile Page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(userP: userS),
                ),
              );
              break;
            case 1:
            // Navigate to Home Page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(userH: userS),
                ),
              );
              break;
            case 2:
            // Stay on Settings Page
              break;
          }
        },
        currentIndex: 2,
      ),
    );
  }

  Widget _buildSectionCard(
      {required String title, required List<String> content}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            ...content.map((text) =>
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 16),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}