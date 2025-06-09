import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lista_tarefas/firebase_service.dart';
import '../helpers/db_helper.dart';
import '../models/task.dart';

class TaskListNotifier extends StateNotifier<List<Task>> {
  final FirebaseService _firebaseService = FirebaseService();
  late final StreamSubscription _connectivitySubscription;

  TaskListNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    await loadTasks(); // Carrega local
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty &&
          results.any((r) => r != ConnectivityResult.none)) {
        syncWithFirebase();
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> loadTasks() async {
    final tasks = await DBHelper.getTasks();
    state = tasks;
  }

  Future<void> addTask(Task task) async {
    final newTask = task.copyWith(isSynced: false);
    await DBHelper.insert(newTask);
    final tasks = await DBHelper.getTasks();
    state = tasks;
  }

  Future<void> deleteTask(Task task) async {
    if (task.firebaseId != null) {
      await _firebaseService.deleteTask(task.firebaseId!);
    }
    if (task.id != null) {
      await DBHelper.delete(task.id!);
    }
    final tasks = await DBHelper.getTasks();
    state = tasks;
  }

  Future<void> updateTask(Task oldTask, Task newTask) async {
    final updatedTask = newTask.copyWith(
      id: oldTask.id,
      firebaseId: oldTask.firebaseId,
      isSynced: false,
    );
    await DBHelper.update(updatedTask);
    final tasks = await DBHelper.getTasks();
    state = tasks;
  }

  Future<void> toggleTask(Task task) async {
    final updatedTask = task.copyWith(isDone: !task.isDone, isSynced: false);
    await DBHelper.update(updatedTask);
    final tasks = await DBHelper.getTasks();
    state = tasks;
  }

  Future<void> syncWithFirebase() async {
    final unsyncedTasks = await DBHelper.getUnsyncedTasks();

    for (var task in unsyncedTasks) {
      if (task.firebaseId == null) {
        final firebaseId = await _firebaseService.addTask(task);
        final syncedTask = task.copyWith(
          firebaseId: firebaseId,
          isSynced: true,
        );
        await DBHelper.update(syncedTask);
      } else {
        await _firebaseService.updateTask(task.firebaseId!, task);
        final syncedTask = task.copyWith(isSynced: true);
        await DBHelper.update(syncedTask);
      }
    }

    final firebaseTasks = await _firebaseService.fetchTasks();
    final localTasks = await DBHelper.getTasks();

    for (var fTask in firebaseTasks) {
      final exists = localTasks.any((l) => l.firebaseId == fTask.firebaseId);
      if (!exists) {
        await DBHelper.insert(fTask);
      }
    }

    final updatedTasks = await DBHelper.getTasks();
    state = updatedTasks;
  }
}

final taskListProvider =
    StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  return TaskListNotifier();
});
