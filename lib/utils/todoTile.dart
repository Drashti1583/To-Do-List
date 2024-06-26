import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final String taskPriority;
  final bool taskCompleted;
  final DateTime dueDate;
  final Function(bool?)? onChanged;

  ToDoTile({
    super.key,
    required this.taskCompleted,
    required this.taskName,
    required this.taskPriority,
    required this.dueDate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    Color priorityColor;
    switch (taskPriority) {
      case 'High':
        priorityColor = Colors.red;
        break;
      case 'Medium':
        priorityColor = Colors.orange;
        break;
      case 'Low':
        priorityColor = Colors.green;
        break;
      default:
        priorityColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: Container(
        padding: EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            Checkbox(
              value: taskCompleted,
              onChanged: onChanged,
              activeColor: Colors.black,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskName,
                    style: TextStyle(
                      fontSize: 16.0,
                      decoration: taskCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  Text(
                    'Priority: $taskPriority',
                    style: TextStyle(
                      color: priorityColor,
                    ),
                  ),
                  Text(
                    'Due: ${DateFormat.yMMMd().format(dueDate)}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
