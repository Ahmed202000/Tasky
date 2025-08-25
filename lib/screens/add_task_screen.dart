import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final GlobalKey<FormState> _key = GlobalKey();

  //TODO:DISPOSE THIS CONTROLLERS
  final TextEditingController taskNameController = TextEditingController();

  final TextEditingController taskDescriptionController =
      TextEditingController();

  bool isHighPriority = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Task"),
        iconTheme: IconThemeData(color: Color(0xFFFFFCFC)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Form(
            key: _key,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Task Name',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFFFFCFC),
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: taskNameController,

                          validator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Pleas Enter TaskName";
                            }
                            return null;
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Finish UI design for login screen',
                            hintStyle: TextStyle(color: Color(0xFF6D6D6D)),
                            filled: true,
                            fillColor: Color(0xFF282828),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          cursorColor: Colors.white,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Task Description',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFFFFCFC),
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: taskDescriptionController,
                          // validator: (String? value) {
                          //   if (value == null || value.trim().isEmpty) {
                          //     return "Pleas Enter Task Description";
                          //   }
                          //   return null;
                          // },
                          style: TextStyle(color: Colors.white),
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText:
                                'Finish onboarding UI and hand off to devs by Thursday.',
                            hintStyle: TextStyle(color: Color(0xFF6D6D6D)),
                            filled: true,
                            fillColor: Color(0xFF282828),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          cursorColor: Colors.white,
                        ),

                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'High Priority  ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFFFFCFC),
                              ),
                            ),
                            Switch(
                              value: isHighPriority,
                              onChanged: (bool value) {
                                setState(() {
                                  isHighPriority = value;
                                });
                              },
                              activeTrackColor: Color(0xFF15B86C),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton.icon(
                  label: Text('Add Task'),
                  icon: Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF15B86C),
                    foregroundColor: Color(0xFFFFFCFC),
                    fixedSize: Size(MediaQuery.sizeOf(context).width, 40),
                  ),
                  onPressed: () async {
                    if (_key.currentState?.validate() ?? false) {

                      final pref = await SharedPreferences.getInstance();
                      final taskJson = pref.getString("tasks");

                      List<dynamic> listTasks = [];
                      if (taskJson != null) {
                        listTasks = jsonDecode(taskJson);
                      }

                      TaskModel model = TaskModel(
                        id: listTasks.length +1,
                        taskName: taskNameController.text,
                        taskDescription: taskDescriptionController.text,
                        isHighPriority: isHighPriority,
                      );

                      listTasks.add(model.toJson());
                      final taskEncode = jsonEncode(listTasks);
                      await pref.setString('tasks', taskEncode);

                      Navigator.of(context).pop(true);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
