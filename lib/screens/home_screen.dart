import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/screens/add_task_screen.dart';
import 'package:tasky/widgets/task_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username;
  List<TaskModel> tasks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadTask();
  }

  void _loadUserName() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("username");
    });
  }

  void _loadTask() async {
    setState(() {
      isLoading = true;
    });
    //await Future.delayed(Duration(seconds: 5));
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final finalTask = pref.getString('tasks');
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
      setState(() {
        tasks =
            taskAfterDecode
                .map((element) => TaskModel.fromJson(element))
                .toList();
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(
                    "assets/images/image_profile.png",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good Evening ,$username",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Color(0xFFFFFCFC),
                        ),
                      ),
                      Text(
                        "One task at a time.One step\ncloser. ",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xFFC6C6C6),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                SvgPicture.asset(
                  "assets/images/light.svg",
                  width: 34,
                  height: 34,
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Yuhuu ,Your work Is ',
              style: TextStyle(fontSize: 32, color: Color(0xFFFFFCFC)),
            ),
            Row(
              children: [
                Text(
                  'almost done ! ',
                  style: TextStyle(fontSize: 32, color: Color(0xFFFFFCFC)),
                ),
                SvgPicture.asset("assets/images/hand.svg"),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 16),
              child: Text(
                'My Tasks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFFFFCFC),
                ),
              ),
            ),
            Expanded(
              child:
                  isLoading
                      ? Center(
                        child: CircularProgressIndicator(),
                      )
                      : TaskListWidget(
                        tasks: tasks,
                        onTap: (bool? value, int index) async {
                          setState(() {
                            tasks[index!].isDone = value ?? false;
                          });
                          final pref = await SharedPreferences.getInstance();
                          final updatedTask =
                              tasks
                                  .map((element) => element.toJson())
                                  .toList();
                          pref.setString("tasks", jsonEncode(updatedTask));
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 44,
        child: FloatingActionButton.extended(
          backgroundColor: Color(0xFF15B86C),
          foregroundColor: Color(0xFFFFFCFC),
          label: Text("Add New Task"),
          icon: Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () async {
            final bool? result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return AddTaskScreen();
                },
              ),
            );
            if (result != null && result == true) {
              _loadTask();
            }
          },
        ),
      ),
    );
  }
}
