import 'package:duo_leic/view/pages/profile_page.dart';
import 'package:duo_leic/view/pages/info_page.dart';
import 'package:duo_leic/view/pages/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:duo_leic/model/user.dart';
import 'package:duo_leic/view/pages/achievements_page.dart';
import 'home_page.dart';

class Profile2Page extends StatefulWidget {
  final UserModel userV, userP;

  const Profile2Page({super.key, required this.userV, required this.userP});

  @override
  _Profile2PageState createState() => _Profile2PageState();
}

class _Profile2PageState extends State<Profile2Page> {
  late bool following;

  @override
  void initState() {
    super.initState();
    following = _checkIfUserFollows();
  }

  bool _checkIfUserFollows() {
    for (String name in widget.userV.follows) {
      if (widget.userP.username == name) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            _buildProfileHeader(),
            _buildButtons(context),
            _buildStats(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(userP: widget.userV),
                ),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(userH: widget.userV),
                ),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => InfoPage(userS: widget.userV),
                ),
              );
              break;
          }
        },
        currentIndex: 2,
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: AssetImage('assets/images/minerva_new.png'),
          ),
          SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.userP.username,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                widget.userP.email,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Adjust vertical padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stats',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Streak', '${widget.userP.streak} days'),
              _buildStatItem('Savers', '${widget.userP.streakSaver}'),
              _buildStatItem('Levels', '${widget.userP.levelsCompleted}'),
              _buildStatItem('Followers', '${widget.userP.followers.length}')
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    String buttonText = following ? 'Unfollow' : 'Follow';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // Adjust vertical padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                    setState(() {
                      following = !following;
                      buttonText = following ? 'Unfollow' : 'Follow'; // Update button text
                    });
                    setState(() {
                      if (following) {
                        addFollow(widget.userV, widget.userP.username);
                        addFollower(widget.userP, widget.userV.username);
                      } else {
                        removeFollow(widget.userV, widget.userP.username);
                        removeFollower(widget.userP, widget.userV.username);
                      }
                    });
                  },
                  child: Text( // Use buttonText here
                    buttonText,
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
            style: TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}