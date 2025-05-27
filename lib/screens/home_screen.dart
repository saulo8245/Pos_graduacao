import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../routes/app_routes.dart';
import '../screens/edit_task_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/task_popup.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  void _onNavTapped(int index) async {
    setState(() => _selectedIndex = index);

    if (index == 1) {
      final newTask = await Navigator.pushNamed(
        context,
        AppRoutes.addTask,
      ) as Task?;

      if (newTask != null) {
        ref.read(taskListProvider.notifier).addTask(newTask);
      }
    } else if (index == 2) {
      // Ação de configurações (futura)
    }
  }

  void _showTaskDetails(Task task) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TaskPopup(
          task: task,
          onToggleStatus: () {
            ref.read(taskListProvider.notifier).toggleTask(task);
            Navigator.pop(context);
          },
          onDelete: () {
            ref.read(taskListProvider.notifier).deleteTask(task);
            Navigator.pop(context);
          },
          onUpdate: () async {
            Navigator.pop(context);
            final updatedTask = await Navigator.pushNamed(
              context,
              AppRoutes.editTask,
              arguments: task,
            ) as Task?;

            if (updatedTask != null) {
              ref.read(taskListProvider.notifier).updateTask(task, updatedTask);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskListProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: tasks.isEmpty
            ? const Center(
                child: Text(
                  'Nenhuma tarefa cadastrada',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskTile(
                    task: task,
                    onTapLeft: () =>
                        ref.read(taskListProvider.notifier).toggleTask(task),
                    onTapRight: () => _showTaskDetails(task),
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}
