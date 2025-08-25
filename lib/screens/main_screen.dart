import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasky/screens/home_screen.dart';
import 'package:tasky/screens/profile_screen.dart';
import 'package:tasky/screens/to_do_screen.dart';

import 'completed_task_screen.dart';

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
        backgroundColor: Color(0xFF181818),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Color(0xFFC6C6C6),
        selectedItemColor: Color(0xFF15B86C),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/home.svg',
              colorFilter: ColorFilter.mode(
                _currantIndex == 0 ? Color(0xFF15B86C) : Color(0xFFC6C6C6),
                BlendMode.srcIn,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/to_do.svg',
              colorFilter: ColorFilter.mode(
                _currantIndex == 1 ? Color(0xFF15B86C) : Color(0xFFC6C6C6),
                BlendMode.srcIn,
              ),
            ),
            label: 'To Do',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/completed.svg',
              colorFilter: ColorFilter.mode(
                _currantIndex == 2 ? Color(0xFF15B86C) : Color(0xFFC6C6C6),
                BlendMode.srcIn,
              ),
            ),
            label: 'Completed',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/images/profile.svg',
              colorFilter: ColorFilter.mode(
                _currantIndex == 3 ? Color(0xFF15B86C) : Color(0xFFC6C6C6),
                BlendMode.srcIn,
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
      body:SafeArea(child: _screen[_currantIndex]),
    );
  }
}
