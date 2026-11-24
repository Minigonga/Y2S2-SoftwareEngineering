import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;

  const CustomBottomNavigationBar({super.key, required this.onTap, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        navBarItem(Icons.person, 0),
        navBarItem(Icons.home, 1),
        navBarItem(Icons.info, 2),
      ],
      onTap: onTap,
      currentIndex: currentIndex,
    );
  }

  BottomNavigationBarItem navBarItem(IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: SizedBox(
        height: 60,
        child: Icon(
          icon,
          size: 50,
          color: Colors.grey,
        ),
      ),
      label: ' ',
    );
  }
}