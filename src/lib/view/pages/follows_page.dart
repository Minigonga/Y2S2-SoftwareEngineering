import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duo_leic/view/pages/profile2_page.dart';
import 'package:flutter/material.dart';
import 'package:duo_leic/model/user.dart';

import '../../model/achievement.dart';

class FollowsPage extends StatefulWidget {
  final UserModel user;

  const FollowsPage({required this.user});
  @override
  _FollowsPageState createState() => _FollowsPageState();
}

class _FollowsPageState extends State<FollowsPage> {
  var searchName = '';
  TextEditingController _searchController = TextEditingController();
  List<UserModel> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Follows'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchName = value;
                });
                _search(searchName);
              },
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Username',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index].username),
                  subtitle: Text(_searchResults[index].email),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile2Page(
                          userV: widget.user,
                          userP: _searchResults[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _search(String searchName) async {
    List<UserModel> results = await searchUsers(searchName);
    setState(() {
      _searchResults = results;
    });
  }

  Future<List<UserModel>> searchUsers(String searchName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .orderBy("Username")
        .startAt([searchName])
        .endAt([searchName + "\uf8ff"])
        .get();

    List<UserModel> results = [];
    querySnapshot.docs.forEach((doc) {
      var data = doc.data() as Map<String, dynamic>;

      if (widget.user.follows.contains(data['Username'])) {
        List<Achievement> achievements = List<Map<String, dynamic>>.from(data['Achievements'] ?? []).map((achievementData) {
          return Achievement(
            title: achievementData['Title'] ?? 'No Title',
            description: achievementData['Description'] ?? 'No Description',
            quantity: achievementData['Quantity'] ?? 0,
            current: achievementData['Current'] ?? 0,
          );
        }).toList();

        results.add(UserModel(
          username: data['Username'],
          email: data['Email'],
          streak: data['Streak'],
          streakSaver: data['StreakSaver'],
          levelsCompleted: data['LevelsCompleted'],
          achievements: achievements,
          ucs: [],
          follows: List<String>.from(data['Follows']),
          followers: List<String>.from(data['Followers']),
          lastLogin: data['LastLogin'],
        ));
      }
    });

    return results;
  }
}
