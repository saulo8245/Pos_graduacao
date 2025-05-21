import 'package:flutter/material.dart';
import 'package:lista_tarefas/models/task.dart';
import 'package:lista_tarefas/screens/add_task_screen.dart';
import 'package:lista_tarefas/widgets/bottom_nav_bar.dart';
import 'package:lista_tarefas/widgets/custom_app_bar.dart';
import 'package:lista_tarefas/widgets/task_bottom_sheet.dart.dart';
import 'package:lista_tarefas/widgets/task_list.dart';
import 'package:lista_tarefas/utils/snackbar_utils.dart';

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
        showSnack(context, 'Tarefa adicionada com sucesso');
      }
    } else if (index == 2) {
      showSnack(context, 'Abrir configurações');
    }
  }

  void _toggleTaskDone(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  void _showTaskBottomSheet(Task task) {
    showTaskBottomSheet(context, task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TaskList(
          tasks: tasks,
          onTapLeft: _toggleTaskDone,
          onTapRight: _showTaskBottomSheet,
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}
