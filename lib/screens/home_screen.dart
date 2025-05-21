import 'package:flutter/material.dart';
import 'package:lista_tarefas/models/task.dart';
import 'package:lista_tarefas/screens/add_task_screen.dart';
import 'package:lista_tarefas/screens/edit_task_screen.dart';
import 'package:lista_tarefas/widgets/bottom_nav_bar.dart';
import 'package:lista_tarefas/widgets/task_tile.dart';
import 'package:lista_tarefas/widgets/task_popup.dart';

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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tarefa adicionada com sucesso')),
        );
      }
    } else if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Abrir configurações')),
      );
    }
  }

  void _toggleTaskDone(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  void _showTaskPopup(Task task) {
    showDialog(
      context: context,
      builder: (_) => TaskPopup(
        task: task,
        onDelete: () {
          Navigator.pop(context);
          setState(() {
            tasks.remove(task);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarefa deletada')),
          );
        },
        onUpdate: (updatedTask) {
          Navigator.pop(context);
          setState(() {
            final index = tasks.indexOf(task);
            if (index != -1) {
              tasks[index] = updatedTask;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarefa atualizada')),
          );
        },
        onConfirm: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tarefa confirmada')),
          );
        },
      ),
    );
  }

  void _showTaskBottomSheet(Task task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Descrição',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                task.description.isNotEmpty
                    ? task.description
                    : 'Sem descrição',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(
                    task.isDone ? Icons.check_circle : Icons.circle_outlined,
                    color: task.isDone ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    task.isDone ? 'Concluída' : 'Pendente',
                    style: TextStyle(
                      color: task.isDone ? Colors.green : Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
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
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TaskTile(
              task: task,
              onTapLeft: () => _toggleTaskDone(index),
              onTapRight: () => _showTaskBottomSheet(task),
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
