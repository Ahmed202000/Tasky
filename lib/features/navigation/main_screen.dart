import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky/features/home/home_screen.dart';
import 'package:tasky/features/profile/profile_screen.dart';
import 'package:tasky/features/tasks/to_do_screen.dart';

import '../tasks/completed_task_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

List<Widget> _screen = [
  HomeScreen(),
  ToDoScreen(),
  CompletedTaskScreen(),
  ProfileScreen(),
];
Widget screen = HomeScreen();
int _currantIndex = 0;

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currantIndex,
        onTap: (int? index) {
          setState(() {
            _currantIndex = index ?? 0;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: _buildSvgPicture('assets/images/home.svg', 0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildSvgPicture('assets/images/to_do.svg', 1),
            label: 'To Do',
          ),
          BottomNavigationBarItem(
            icon: _buildSvgPicture('assets/images/completed.svg', 2),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: _buildSvgPicture('assets/images/profile.svg', 3),
            label: 'Profile',
          ),
        ],
      ),
      body: SafeArea(child: _screen[_currantIndex]),
    );
  }

  SvgPicture _buildSvgPicture(String path, int index) => SvgPicture.asset(
    path,
    colorFilter: ColorFilter.mode(
      _currantIndex == index ? Color(0xFF15B86C) : Color(0xFFC6C6C6),
      BlendMode.srcIn,
    ),
  );
}
//PopupMenu
//AlertDialog
//Custom Dialog
//ModelBottomSheet ->BottomSheet
//DatePicker
//Full Screen Dialog
