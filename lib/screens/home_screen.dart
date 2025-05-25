import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../screens/add_task_screen.dart';
import '../utils/navigation_helpers.dart';
import '../utils/show_confirmation_dialog.dart';
import '../utils/show_task_details.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> tasks = [
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
  ];

  final TaskController taskController = TaskController();

  int _selectedIndex = 0;

  /// Navegação pelo bottom
  Future<void> _onNavTapped(int index) async {
    setState(() => _selectedIndex = index);

    if (index == 1) {
      final newTask = await Navigator.push<Task>(
        context,
        MaterialPageRoute(builder: (_) => const AddTaskScreen()),
      );

      if (newTask != null) {
        setState(() {
          tasks.add(newTask);
        });

        showConfirmationDialog(
          context,
          title: 'Tarefa adicionada',
          message: 'Sua tarefa foi adicionada com sucesso.',
        );
      }
    } else if (index == 2) {
      showConfirmationDialog(
        context,
        title: 'Configurações',
        message: 'Tela de configurações em desenvolvimento.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    onTapLeft: () {
                      setState(() {
                        taskController.toggleTaskDone(task);
                      });
                    },
                    onTapRight: () {
                      showTaskDetails(
                        context: context,
                        task: task,
                        onToggleStatus: () {
                          setState(() {
                            taskController.toggleTaskDone(task);
                          });
                        },
                        onDelete: () {
                          setState(() {
                            taskController.deleteTask(tasks, task);
                          });
                        },
                        onUpdate: () {
                          navigateToEditTask(
                            context: context,
                            task: task,
                            onUpdate: (updatedTask) {
                              setState(() {
                                taskController.updateTask(
                                    tasks, task, updatedTask);
                              });
                              showConfirmationDialog(
                                context,
                                title: 'Tarefa atualizada',
                                message:
                                    'Sua tarefa foi atualizada com sucesso.',
                              );
                            },
                          );
                        },
                      );
                    },
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
