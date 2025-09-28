import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/screens/add_task_screen.dart';
import 'package:tasky/widgets/sliver_task_list_widget.dart';
import 'package:tasky/widgets/task_list_widget.dart';

import '../core/services/preferences_manager.dart' show PreferencesManager;
import '../core/widgets/custom_svg_picture.dart';
import '../features/home/components/achieved_tasks_widgets.dart';
import '../widgets/achieved_tasks_widgets.dart';
import '../widgets/high_priority_tasks_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username;
  String? userImage;
  String? motivationQuote;
  List<TaskModel> tasks = [];
  bool isLoading = false;
  int totalTask = 0;
  int totalDoneTask = 0;
  double precent = 0;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadTask();
  }

  void _loadUserName() async {
    setState(() {
      userImage = PreferencesManager().getString("user_image");
      username = PreferencesManager().getString("username");
      motivationQuote =
          PreferencesManager().getString("motivation_quote") ??
          "One task at a time. One step closer.";
    });
  }

  void _loadTask() async {
    setState(() {
      isLoading = true;
    });
    //await Future.delayed(Duration(seconds: 5));
    final finalTask = PreferencesManager().getString('tasks');
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      setState(() {
        tasks =
            taskAfterDecode
                .map((element) => TaskModel.fromJson(element))
                .toList();
        _calculatePercent();
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  _calculatePercent() {
    totalTask = tasks.length;
    totalDoneTask = tasks.where((e) => e.isDone).length;
    precent = totalTask == 0 ? 0 : totalDoneTask / totalTask;
  }

  _deleteTask(int? id) async {
    if (id == null) return;
    setState(() {
      tasks.removeWhere((task) => task.id == id);
      _calculatePercent();
    });
    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString("tasks", jsonEncode(updatedTask));
  }

  _doneTask(bool? value, int? index) async {
    setState(() {
      tasks[index!].isDone = value ?? false;
      _calculatePercent();
    });
    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString("tasks", jsonEncode(updatedTask));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            userImage == null
                                ? AssetImage('assets/images/image_profile.png')
                                : FileImage(File(userImage!)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Good Evening ,$username",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              "$motivationQuote",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      CustomSvgPicture.withoutColor(
                        path: "assets/images/light.svg",
                        width: 34,
                        height: 34,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Yuhuu ,Your work Is ',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Row(
                    children: [
                      Text(
                        'almost done ! ',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      CustomSvgPicture.withoutColor(
                        path: "assets/images/hand.svg",
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  //Achieved Tasks
                  AchievedTasksWidget(
                    totalTask: totalTask,
                    totalDoneTask: totalDoneTask,
                    precent: precent,
                  ),
                  SizedBox(height: 8),
                  HighPriorityTasksWidgets(
                    tasks: tasks,
                    onTap: (bool? value, int? index) {
                      _doneTask(value, index);
                    },
                    refresh: () {
                      _loadTask();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 16),
                    child: Text(
                      'My Tasks',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                )
                : SliverTaskListWidget(
                  tasks: tasks,
                  onTap: (bool? value, int index) async {
                    _doneTask(value, index);
                  },
                  onDelete: (int? id) {
                    _deleteTask(id);
                  },
                  onEdit: () => _loadTask(),
                ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 44,
        child: FloatingActionButton.extended(
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
