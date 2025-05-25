import 'package:flutter/material.dart';
import '../models/task.dart';
import '../screens/add_task_screen.dart';
import '../screens/edit_task_screen.dart';
import '../utils/show_confirmation_dialog.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/task_popup.dart';
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

  int _selectedIndex = 0;

  /// Navegar para adicionar tarefa
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

        await showConfirmationDialog(
          context,
          title: 'Sucesso',
          message: 'Tarefa adicionada com sucesso!',
        );
      }
    } else if (index == 2) {
      await showConfirmationDialog(
        context,
        title: 'Configurações',
        message: 'Tela de configurações em desenvolvimento.',
      );
    }
  }

  /// Alternar concluído/pendente
  void _toggleTaskDone(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  /// Navegar para editar
  Future<void> _navigateToEditTask(Task task) async {
    final updatedTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (_) => EditTaskScreen(task: task),
      ),
    );

    if (updatedTask != null) {
      setState(() {
        final index = tasks.indexOf(task);
        if (index != -1) {
          tasks[index] = updatedTask;
        }
      });

      await showConfirmationDialog(
        context,
        title: 'Tarefa Atualizada',
        message: 'A tarefa foi atualizada com sucesso!',
      );
    }
  }

  /// Abrir detalhes da tarefa
  void _showTaskDetails(Task task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return TaskPopup(
          task: task,
          onToggleStatus: () {
            setState(() {
              task.isDone = !task.isDone;
            });
            Navigator.pop(context);
          },
          onDelete: () async {
            setState(() {
              tasks.remove(task);
            });
            Navigator.pop(context);

            await showConfirmationDialog(
              context,
              title: 'Tarefa Deletada',
              message: 'A tarefa foi deletada com sucesso!',
            );
          },
          onUpdate: () {
            Navigator.pop(context);
            _navigateToEditTask(task);
          },
        );
      },
    );
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
                    onTapLeft: () => _toggleTaskDone(index),
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
