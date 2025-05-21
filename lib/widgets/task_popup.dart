import 'package:flutter/material.dart';
import '../models/task.dart';
import '../screens/edit_task_screen.dart';

class TaskPopup extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final ValueChanged<Task> onUpdate;
  final VoidCallback onConfirm;

  const TaskPopup({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onUpdate,
    required this.onConfirm,
  });

  Future<void> _editTask(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Detalhes da Tarefa'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            task.description.isNotEmpty ? task.description : 'Sem descrição',
          ),
        ],
      ),
      actions: [
        // Botão Editar
        TextButton.icon(
          onPressed: () => _editTask(context),
          icon: const Icon(Icons.edit, color: Colors.blue),
          label: const Text('Editar'),
        ),

        // Botão Deletar
        TextButton.icon(
          onPressed: onDelete,
          icon: const Icon(Icons.delete, color: Colors.red),
          label: const Text('Deletar'),
        ),

        // Botão Confirmar (apenas para exemplo, pode ser removido)
        TextButton(
          onPressed: onConfirm,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
