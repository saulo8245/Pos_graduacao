import 'package:flutter/material.dart';
import '../models/task.dart';
import '../screens/edit_task_screen.dart';

Future<void> navigateToEditTask({
  required BuildContext context,
  required Task task,
  required Function(Task) onUpdate,
}) async {
  final updatedTask = await Navigator.push<Task>(
    context,
    MaterialPageRoute(
      builder: (_) => EditTaskScreen(task: task),
    ),
  );

  if (updatedTask != null) {
    onUpdate(updatedTask);
  }
}
