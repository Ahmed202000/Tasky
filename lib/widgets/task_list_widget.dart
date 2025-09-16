import 'package:flutter/material.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/widgets/task_item_widgets.dart';

import '../core/widgets/custom_check_box.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({
    super.key,
    required this.tasks,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
    this.emptyMessage,
  });

  final List<TaskModel> tasks;
  final Function(bool?, int) onTap;
  final Function(int?) onDelete;
  final Function onEdit;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(
          child: Text(
            emptyMessage ?? 'No Data',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        )
        : ListView.builder(
          padding: EdgeInsets.only(bottom: 60),
          itemCount: tasks.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TaskItemWidgets(
                model: tasks[index],
                onChanged: (bool? value) => onTap(value, index),
                onDelete: (int id) {
                  onDelete(id);
                },
                onEdit: () =>onEdit(),
              ),
            );
          },
        );
  }
}
