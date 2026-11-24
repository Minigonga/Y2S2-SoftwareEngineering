import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duo_leic/view/pages/profile2_page.dart';
import 'package:flutter/material.dart';
import 'package:duo_leic/model/achievement.dart';
import 'package:duo_leic/model/user.dart'; // Assuming UserModel is defined in a separate file

class UserSearchPage extends StatefulWidget {
    final UserModel user;

  const UserSearchPage({ required this.user});
  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  var searchName= '';
  TextEditingController _searchController = TextEditingController();
  List<UserModel> _searchResults = [];
  @override
  void initState() {
    super.initState();
    _search('');
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value){
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
              builder: (context) => Profile2Page(userV: widget.user,userP: _searchResults[index]),
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

  void _search(searchName) async {
    List<UserModel> results = await searchUsers(searchName);
    setState(() {
      _searchResults = results;
    });
  }

  Future<List<UserModel>> searchUsers(String username) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .orderBy("Username")
        .startAt([searchName])
        .endAt([searchName+ "\uf8ff"])
        .get();
    List<UserModel> results = [];
    querySnapshot.docs.forEach((doc) {
      List<Achievement> achievements = List<Map<String, dynamic>>.from(doc['Achievements'] ?? []).map((data) {
      return Achievement(
        title: data['Title'] ?? 'No Title',
        description: data['Description'] ?? 'No Description',
        quantity: data['Quantity'] ?? 0,
        current: data['Current'] ?? 0,
      ); 
      }).toList();
      if(doc['Email']!=widget.user.email){
      results.add(UserModel(
        username: doc['Username'],
        email: doc['Email'],
        streak: doc['Streak'],
        streakSaver: doc['StreakSaver'],
        levelsCompleted: doc['LevelsCompleted'],
        achievements: achievements,
        ucs: [], 
        follows: List<String>.from(doc['Follows']),
        followers: List<String>.from(doc['Followers']),
        lastLogin: doc['LastLogin'],
      ));
      }
    });

    return results;
  }
}