import 'package:flutter/material.dart';
import '../models/task.dart';
import '../screens/edit_task_screen.dart';
import '../utils/show_confirmation_dialog.dart';
import '../widgets/task_popup.dart';

void showTaskDetails({
  required BuildContext context,
  required Task task,
  required Function() onToggleStatus,
  required Function() onDelete,
  required Function() onUpdate,
}) {
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
          onToggleStatus();
          Navigator.pop(context);
        },
        onDelete: () {
          onDelete();
          Navigator.pop(context);
          showConfirmationDialog(
            context,
            title: 'Tarefa deletada',
            message: 'Sua tarefa foi excluída com sucesso.',
          );
        },
        onUpdate: () {
          Navigator.pop(context);
          onUpdate();
        },
      );
    },
  );
}
