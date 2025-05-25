import '../models/task.dart';

class TaskController {
  void toggleTaskDone(Task task) {
    task.isDone = !task.isDone;
  }

  void deleteTask(List<Task> tasks, Task task) {
    tasks.remove(task);
  }

  void updateTask(List<Task> tasks, Task oldTask, Task newTask) {
    final index = tasks.indexOf(oldTask);
    if (index != -1) {
      tasks[index] = newTask;
    }
  }
}
