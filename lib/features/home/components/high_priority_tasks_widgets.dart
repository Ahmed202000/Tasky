import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/core/theme/theme-controller.dart';
import 'package:tasky/models/task_model.dart';

import '../../../core/widgets/custom_check_box.dart';
import '../../../core/widgets/custom_svg_picture.dart';
import '../../tasks/high_priority_screen.dart';

class HighPriorityTasksWidgets extends StatelessWidget {
  const HighPriorityTasksWidgets({
    super.key,
    required this.tasks,
    required this.onTap,
    required this.refresh,
  });

  final List<TaskModel> tasks;

  // final List<TaskModel> highPriorityTasks;
  final Function(bool?, int) onTap;
  final Function refresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'High Priority Tasks',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF15B86C),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      tasks.reversed
                                  .where((element) => element.isHighPriority)
                                  .length >
                              4
                          ? 4
                          : tasks.reversed
                              .where((element) => element.isHighPriority)
                              .length,
                  itemBuilder: (BuildContext context, int index) {
                    final task =
                        tasks.reversed
                            .where((element) => element.isHighPriority)
                            .toList()[index];
                    return Row(
                      children: [
                        CustomCheckBox(
                          value: task.isDone,
                          onChanged: (bool? value) {
                            final index = tasks.indexWhere(
                              (e) => e.id == task.id,
                            );
                            onTap(value, index);
                          },
                        ),
                        Expanded(
                          child: Text(
                            task.taskName,
                            style:
                                task.isDone
                                    ? Theme.of(context).textTheme.titleLarge
                                    : Theme.of(context).textTheme.titleMedium,

                            maxLines: 1,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return HighPriorityScreen();
                  },
                ),
              );

              refresh();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 40,
                width: 40,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,

                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        ThemeController.isDark()
                            ? Color(0xFF6E6E6E)
                            : Color(0xFFD1DAD6),
                  ),
                ),
                child: CustomSvgPicture(
                  path: "assets/images/arrow_up_right.svg",
                  height: 24,
                  width: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
