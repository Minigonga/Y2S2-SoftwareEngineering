import 'package:duo_leic/model/user.dart';
import 'package:duo_leic/view/pages/follows_page.dart';
import 'package:duo_leic/view/pages/followers_page.dart';
import 'package:duo_leic/view/pages/initial_page.dart';
import 'package:duo_leic/view/pages/user_search_page.dart';
import 'package:duo_leic/view/pages/widgets/achievement_pop_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:duo_leic/view/pages/achievements_page.dart';
import 'package:duo_leic/view/pages/widgets/bottom_navigation_bar.dart';
import 'package:duo_leic/view/pages/info_page.dart';
import 'package:duo_leic/view/pages/home_page.dart';
import '../../model/achievement.dart';

class ProfilePage extends StatefulWidget {
  final UserModel userP;

  const ProfilePage({super.key, required this.userP});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    checkFollowers(widget.userP, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              alignment: Alignment.center,
              child: const Text(
                'DUO-LEIC',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            _buildProfileHeader(),
            _buildStats(),
            _buildButtons(context),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
            // Stay on Profile Page
              break;
            case 1:
            // Navigate to Home Page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(userH: widget.userP),
                ),
              );
              break;
            case 2:
            // Navigate to Settings Page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => InfoPage(userS: widget.userP),
                ),
              );
              break;
          }
        },
        currentIndex: 0,
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          const CircleAvatar( //meter userP.profileImage
            radius: 50,
            backgroundImage: AssetImage('assets/images/minerva_new.png'),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userP.username,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.userP.email,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stats',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Streak', '${widget.userP.streak} days'),
              _buildStatItem('Savers', '${widget.userP.streakSaver}'),
              _buildStatItem('Levels', '${widget.userP.levelsCompleted}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }


  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AchievementsPage(userA: widget.userP)),
              );
            },
            child: const Text(
              'Achievements',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FollowsPage(user: widget.userP)),
                    );
                  },
                  child: const Text(
                    'Following',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FollowersPage(user: widget.userP)),
                    );
                  },
                  child: const Text(
                    'Followers',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserSearchPage(user: widget.userP),),
              );
            },
            child: const Text(
              'Search Users',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((_) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const InitialPage()),
                      (route) => false,
                );
              });
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> checkFollowers(UserModel user, BuildContext context) async {
  int followers = user.followers.length;
  bool achievementUpdated = false;
  bool popupTriggered = false;

  for (Achievement achievement in user.achievements) {
    switch (achievement.title) {
      case 'Not Alone':
      case 'Friendly':
      case 'Popular':
      case 'Star':
      case 'Super-Star':
        if (followers >= achievement.quantity && achievement.current < achievement.quantity) {
          achievement.current = achievement.quantity;
          achievementUpdated = true;
          if (!popupTriggered) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              AchievementPopup.show(context, achievement, user);
            });
            popupTriggered = true;
          }
        } else if (followers < achievement.quantity) {
          achievement.current = followers;
          achievementUpdated = true;
        }
        break;
    }
  }

  if (achievementUpdated) {
    await updateAchievementInFirestore(user);
  }
}