import 'package:flutter/material.dart';
import 'package:duo_leic/model/achievement.dart';
import '../../model/user.dart';

class AchievementsPage extends StatefulWidget {
  final UserModel userA;

  const AchievementsPage({super.key, required this.userA});

  @override
  AchievementsPageState createState() => AchievementsPageState();
}

class AchievementsPageState extends State<AchievementsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Achievements',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
        centerTitle: true, // Center the title
      ),
      body: ListView.builder(
        itemCount: widget.userA.achievements.length,
        itemBuilder: (BuildContext context, int index) {
          Achievement achievement = widget.userA.achievements[index];
          return ListTile(
            title: Text(
              achievement.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(achievement.description),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: achievement.current / achievement.quantity,
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorChange(achievement),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${((achievement.current / achievement.quantity) * 100).toStringAsFixed(2)}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color colorChange(achievement) {
    if ((achievement.current / achievement.quantity) * 100 >= 50) {
      return Color.fromRGBO(
        (255 - 510 * ((achievement.current / achievement.quantity) * 100 -50) / 100).toInt(),
        255,
        0,
        1,
      );
    } else {
      return Color.fromRGBO(
        255,
        (510 * (achievement.current / achievement.quantity)).toInt(),
        0,
        1,
      );
    }
  }
}

