import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';
import '../widgets/task_list_widget.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  String? username;
  List<TaskModel> toDoTasks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTask();
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
        toDoTasks =
            taskAfterDecode
                .map((element) => TaskModel.fromJson(element))
                .where((element) => element.isDone == false)
                .toList();
        // طريقه اخري
        //  tasks = tasks.where((element) => element.isDone == false).toList();
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            'To Do Tasks',
            style: TextStyle(fontSize: 20, color: Color(0xFFFFFCFC)),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : TaskListWidget(
                      tasks: toDoTasks,
                      onTap: (bool? value, int index) async {
                        setState(() {
                          toDoTasks[index!].isDone = value ?? false;
                        });
                        final pref = await SharedPreferences.getInstance();

                        final allData = pref.getString('tasks');
                        if (allData != null) {
                          List<TaskModel> allDataList =
                              (jsonDecode(allData) as List)
                                  .map((element) => TaskModel.fromJson(element))
                                  .toList();

                          final newIndex = allDataList.indexWhere(
                            (e) => e.id == toDoTasks[index].id,
                          );
                          allDataList[newIndex] = toDoTasks[index];
                          pref.setString("tasks", jsonEncode(allDataList));
                          _loadTask();
                        }
                      },
                      emptyMessage: 'No Data Found',
                    ),
          ),
        ),
      ],
    );
  }
}
