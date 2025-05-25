import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskPopup extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const TaskPopup({
    super.key,
    required this.task,
    required this.onToggleStatus,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicador visual
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Título
          Text(
            task.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Descrição
          Text(
            task.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 24),

          // Botões de ação
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: onToggleStatus,
                icon: Icon(
                  task.isDone ? Icons.close : Icons.check,
                  color: Colors.white,
                ),
                label: Text(
                  task.isDone
                      ? 'Marcar como Pendente'
                      : 'Marcar como Concluída',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: task.isDone ? Colors.orange : Colors.green,
                ),
              ),
              IconButton(
                onPressed: onUpdate,
                icon: const Icon(Icons.edit, color: Colors.blue),
                tooltip: 'Editar',
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Deletar',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
