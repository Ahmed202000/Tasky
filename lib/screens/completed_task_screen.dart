import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';
import '../widgets/task_list_widget.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  String? username;
  List<TaskModel> completedtasks = [];
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
        completedtasks =
            taskAfterDecode
                .map((element) => TaskModel.fromJson(element))
                .where((element) => element.isDone == true)
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
            'Completed Tasks',
            style: TextStyle(fontSize: 20, color: Color(0xFFFFFCFC)),
          ),
        ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : TaskListWidget(
            tasks: completedtasks,
            onTap: (bool? value, int index) async {
              setState(() {
                completedtasks[index!].isDone = value ?? false;
              });
              final pref = await SharedPreferences.getInstance();
              final updatedTask =
              completedtasks.map((element) => element.toJson()).toList();
              pref.setString("tasks", jsonEncode(updatedTask));
              _loadTask();
            }, emptyMessage: 'No Tasks Completed',
          ),
        ),
      ),


    ],);
  }
}
