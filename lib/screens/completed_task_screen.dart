import 'dart:convert';

import 'package:flutter/material.dart';

import '../core/services/preferences_manager.dart' show PreferencesManager;
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
    final finalTask = PreferencesManager().getString('tasks');
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

  _deleteTask(int? id) async {
    List<TaskModel> tasks = [];
    if (id == null) return;

    final finalTask = PreferencesManager().getString('tasks');
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
      tasks =
          taskAfterDecode
              .map((element) => TaskModel.fromJson(element))
              .toList();
      tasks.removeWhere((task) => task.id == id);

      setState(() {
        completedtasks.removeWhere((task) => task.id == id);
      });
      final updatedTask = tasks.map((element) => element.toJson()).toList();
      PreferencesManager().setString("tasks", jsonEncode(updatedTask));
    }
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
            style: Theme.of(context).textTheme.labelSmall,
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
                        final updatedTask =
                            completedtasks
                                .map((element) => element.toJson())
                                .toList();
                        PreferencesManager().setString(
                          "tasks",
                          jsonEncode(updatedTask),
                        );
                        _loadTask();
                      },
                      emptyMessage: 'No Tasks Completed',
                      onDelete: (int? id) {
                        _deleteTask(id);
                      },
                      onEdit: () =>_loadTask(),
                    ),
          ),
        ),
      ],
    );
  }
}
