import 'package:flutter/material.dart';
import '../models/task.dart';
import '../screens/add_task_screen.dart';
import '../screens/edit_task_screen.dart';
import '../screens/home_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.addTask:
        return MaterialPageRoute(builder: (_) => const AddTaskScreen());

      case AppRoutes.editTask:
        final task = settings.arguments as Task;
        return MaterialPageRoute(
          builder: (_) => EditTaskScreen(task: task),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Rota não encontrada')),
          ),
        );
    }
  }
}
