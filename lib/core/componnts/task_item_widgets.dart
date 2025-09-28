import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/theme/theme-controller.dart';

import '../enums/task_item_actions_enum.dart';
import '../services/preferences_manager.dart';
import '../widgets/custom_check_box.dart';
import '../widgets/custom_text_form_field.dart';
import '../../models/task_model.dart';

class TaskItemWidgets extends StatelessWidget {
  const TaskItemWidgets({
    super.key,
    required this.model,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit,
  });

  final TaskModel model;
  final Function(bool?) onChanged;
  final Function(int) onDelete;
  final Function onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // color: Color(0xFF282828),
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              ThemeController.isDark() ? Colors.transparent : Color(0xFFD1DAD6),
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 8),
          CustomCheckBox(
            value: model.isDone,
            onChanged: (bool? value) {
              onChanged(value);
            },
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.taskName,
                  style:
                      model.isDone
                          ? Theme.of(context).textTheme.titleLarge
                          : Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                ),

                if (model.taskDescription.isNotEmpty)
                  Text(
                    model.taskDescription,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFC6C6C6),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          PopupMenuButton<TaskItemActionsEnum>(
            icon: Icon(
              Icons.more_vert,
              color:
                  ThemeController.isDark()
                      ? (model.isDone ? Color(0xFFA0A0A0) : Color(0xFFC6C6C6))
                      : (model.isDone ? Color(0xFF6A6A6A) : Color(0xFF3A4640)),
            ),
            onSelected: (value) async {
              switch (value) {
                case TaskItemActionsEnum.marAsDone:
                  onChanged(!model.isDone);
                case TaskItemActionsEnum.edit:
                  final result = await _showBottomSheet(context, model);
                  if(result==true){
                    onEdit();
                  }
                case TaskItemActionsEnum.delete:
                  //AlertDialog
                  _showAlertDialog(context);
              }
            },
            itemBuilder:
                (context) =>
                    TaskItemActionsEnum.values.map((e) {
                      return PopupMenuItem(value: e, child: Text(e.name));
                    }).toList(),
          ),
        ],
      ),
    );
  }

  _showAlertDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Task"),
          content: Text("Are you sure want o delete task "),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                onDelete(model.id);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

 Future<bool?> _showBottomSheet(BuildContext context, TaskModel model) {
    final GlobalKey<FormState> _key = GlobalKey();
    final TextEditingController taskNameController = TextEditingController(
      text: model.taskName,
    );
    final TextEditingController taskDescriptionController =
        TextEditingController(text: model.taskDescription);
    bool isHighPriority = model.isHighPriority;

   return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return StatefulBuilder(
          builder: (
            BuildContext context,
            void Function(void Function()) setState,
          ) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Form(
                  key: _key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              CustomTextFormField(
                                controller: taskNameController,
                                title: 'Task Name',
                                hintText: 'Finish UI design for login screen',
                                validator: (String? value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Pleas Enter Task Name";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              CustomTextFormField(
                                controller: taskDescriptionController,
                                title: 'Task Description',
                                maxLines: 5,
                                hintText:
                                    'Finish onboarding UI and hand off to devs by Thursday.',
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'High Priority  ',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Switch(
                                    value: isHighPriority,
                                    onChanged: (bool value) {
                                      setState(() {
                                        isHighPriority = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        label: Text('Edit Task'),
                        icon: Icon(Icons.edit),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(MediaQuery.sizeOf(context).width, 40),
                        ),
                        onPressed: () async {
                          if (_key.currentState?.validate() ?? false) {
                            final taskJson = PreferencesManager().getString(
                              "tasks",
                            );
                            List<dynamic> listTasks = [];
                            if (taskJson != null) {
                              listTasks = jsonDecode(taskJson);
                            }

                            TaskModel newModel = TaskModel(
                              id: model.id,
                              taskName: taskNameController.text,
                              taskDescription: taskDescriptionController.text,
                              isHighPriority: isHighPriority,
                              isDone: model.isDone,
                            );

                            final item = listTasks.firstWhere(
                              (e) => e['id'] == model.id,
                            );
                            final index = listTasks.indexOf(item);
                            listTasks[index] = newModel;
                            final taskEncode = jsonEncode(listTasks);
                            await PreferencesManager().setString(
                              "tasks",
                              taskEncode,
                            );
                            Navigator.of(context).pop(true);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
