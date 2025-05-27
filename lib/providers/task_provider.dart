import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';

final taskListProvider =
    StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  return TaskListNotifier();
});

class TaskListNotifier extends StateNotifier<List<Task>> {
  TaskListNotifier()
      : super([
          Task(
            title: 'Tarefa 1',
            description: 'Entregar relatório financeiro até sexta-feira.',
          ),
          Task(
            title: 'Tarefa 2',
            description: 'Comprar ingredientes para o jantar de sábado.',
          ),
          Task(
            title: 'Tarefa 3',
            description: 'Estudar para a prova de Flutter e revisar anotações.',
          ),
        ]);

  void addTask(Task task) {
    state = [...state, task];
  }

  void updateTask(Task oldTask, Task updatedTask) {
    state = [
      for (final t in state)
        if (t == oldTask) updatedTask else t
    ];
  }

  void deleteTask(Task task) {
    state = state.where((t) => t != task).toList();
  }

  void toggleTask(Task task) {
    state = [
      for (final t in state)
        if (t == task) t.copyWith(isDone: !t.isDone) else t
    ];
  }
}
