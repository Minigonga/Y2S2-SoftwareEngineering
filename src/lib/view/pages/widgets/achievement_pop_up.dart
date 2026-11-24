import 'package:duo_leic/model/user.dart';
import 'package:flutter/material.dart';
import 'package:duo_leic/model/achievement.dart';
import 'package:duo_leic/view/pages/achievements_page.dart';

class AchievementPopup {
  
  static void show(BuildContext context, Achievement achievement, UserModel userModel) async {
    OverlayEntry? entry;
    entry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AchievementsPage(userA: userModel),
            ),
          );
          entry?.remove();
          entry = null;
        },
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Achievement unlocked: ${achievement.title}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          achievement.description,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    try {
      Overlay.of(context)!.insert(entry!);
      await Future.delayed(Duration(seconds: 4));
    } catch (e) {
      print('Error showing achievement popup: $e');
    } finally {
      entry?.remove();
      entry = null;
    }
  }
}