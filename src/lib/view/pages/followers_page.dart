import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duo_leic/view/pages/profile2_page.dart';
import 'package:flutter/material.dart';
import 'package:duo_leic/model/user.dart'; 

class FollowersPage extends StatefulWidget {
    final UserModel user;

  const FollowersPage({ required this.user});
  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  var searchName= '';
  TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  @override
  void initState() {
    super.initState();
    _search('');
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Followers'),
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
                  title: Text(_searchResults[index]),

                          onTap: () {
          /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Profile2Page(userV: widget.user,userP: _searchResults[index]),
            ),
          );*/
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
    List<String> results = await searchUsers(searchName);
    setState(() {
      _searchResults = results;
    });
  }

  Future<List<String>> searchUsers(String username) async {
    List<String> results = [];
    for(String name in widget.user.followers) {
      if(name.contains(username)){
        results.add(name);
      }
      }
    return results;
  }
}