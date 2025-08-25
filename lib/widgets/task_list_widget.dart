import 'package:flutter/material.dart';
import 'package:tasky/models/task_model.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({
    super.key,
    required this.tasks,
    required this.onTap,
    this.emptyMessage,
  });

  final List<TaskModel> tasks;
  final Function(bool?, int) onTap;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(
          child: Text(
            emptyMessage ?? 'No Data',
            style: TextStyle(color: Color(0xFFFFFCFC)),
          ),
        )
        : ListView.builder(
          padding: EdgeInsets.only(bottom: 60),
          itemCount: tasks.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: 56,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFF282828),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    Checkbox(
                      value: tasks[index].isDone,
                      activeColor: Color(0xFF15B86C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (bool? value) {
                        onTap(value, index);
                      },
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tasks[index].taskName,
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  tasks[index].isDone
                                      ? Color(0xFFA0A0A0)
                                      : Color(0xFFFFFCFC),
                              decoration:
                                  tasks[index].isDone
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                              decorationColor: Color(0xFFA0A0A0),
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),

                          if (tasks[index].taskDescription.isNotEmpty)
                            Text(
                              tasks[index].taskDescription,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFC6C6C6),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.more_vert,
                        color:
                            tasks[index].isDone
                                ? Color(0xFFA0A0A0)
                                : Color(0xFFC6C6C6),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
  }
}
