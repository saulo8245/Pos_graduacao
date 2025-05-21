import 'package:flutter/material.dart';
import 'package:lista_tarefas/models/task.dart';
import 'package:lista_tarefas/widgets/task_tile.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final void Function(int) onTapLeft;
  final void Function(Task) onTapRight;

  const TaskList({
    required this.tasks,
    required this.onTapLeft,
    required this.onTapRight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskTile(
          task: task,
          onTapLeft: () => onTapLeft(index),
          onTapRight: () => onTapRight(task),
        );
      },
    );
  }
}
