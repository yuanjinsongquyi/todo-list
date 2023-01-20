import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/widget/widgets.dart';

import '../data/source/task.dart';
import '../main.dart';
import '../views/edit.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    Key? key,
    required this.task,
  }) : super(key: key);
  static const double taskItemHeight = 70;
  final Task task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  late  DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final Color priorityColor;

    switch (widget.task.priority) {
      case Priority.low:
        priorityColor = lowPriorityColor;
        break;
      case Priority.normal:
        priorityColor = normalPriorityColor;
        break;
      case Priority.high:
        priorityColor = highPriorityColor;
        break;
      default:
        priorityColor = lowPriorityColor;
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TaskEditScreen(task: widget.task)));
      },
      //onLongPress: () => widget.task.delete(),
      child: Container(
        height: TaskItem.taskItemHeight,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: themeData.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.01),
            ),
          ],
        ),
        child: Row(
          children: [
            MyCheckBox(
              value: widget.task.isCompleted==1,
              onTap: () {
                setState(() {
                  widget.task.isCompleted = widget.task.isCompleted==1?0:1;
                });
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "title: ${widget.task.title}",
                        style: TextStyle(
                            decoration: widget.task.isCompleted==1
                                ? TextDecoration.lineThrough
                                : null),
                      ),
                      Text(
                        "note: ${widget.task.note}",
                        style: TextStyle(
                            decoration: widget.task.isCompleted==1
                                ? TextDecoration.lineThrough
                                : null),
                      ),
                    ],
                  ),
                  Text(
                    widget.task.date??DateFormat.yMd().format(today),
                    style: TextStyle(
                        decoration: widget.task.isCompleted==1
                            ? TextDecoration.lineThrough
                            : null),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 5,
              height: TaskItem.taskItemHeight,
              decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}