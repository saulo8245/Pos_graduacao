import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../helpers/db_helper.dart';
import '../models/task.dart';

class TaskListNotifier extends StateNotifier<List<Task>> {
  TaskListNotifier() : super([]) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    final tasks = await DBHelper.getTasks();
    state = tasks;
  }

  Future<void> addTask(Task task) async {
    await DBHelper.insert(task);
    loadTasks();
  }

  Future<void> deleteTask(Task task) async {
    if (task.id != null) {
      await DBHelper.delete(task.id!);
      loadTasks();
    }
  }

  Future<void> updateTask(Task oldTask, Task newTask) async {
    if (oldTask.id != null) {
      final updatedTask = newTask.copyWith(id: oldTask.id);
      await DBHelper.update(updatedTask);
      loadTasks();
    }
  }

  Future<void> toggleTask(Task task) async {
    final updatedTask = task.copyWith(isDone: !task.isDone);
    await DBHelper.update(updatedTask);
    loadTasks();
  }
}

final taskListProvider =
    StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  return TaskListNotifier();
});
