import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:lista_tarefas/firebase_service.dart';
import '../helpers/db_helper.dart';
import '../models/task.dart';

class TaskListNotifier extends StateNotifier<List<Task>> {
  final FirebaseService _firebaseService = FirebaseService();
  late final StreamSubscription _connectivitySubscription;
  final Uuid _uuid = const Uuid();
  bool _isSyncing = false;
  Timer? _syncTimer;

  TaskListNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    await loadTasks();
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty &&
          results.any((r) => r != ConnectivityResult.none)) {
        _syncTimer?.cancel();
        _syncTimer = Timer(const Duration(seconds: 2), () {
          syncWithFirebase();
        });
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _syncTimer?.cancel();
    super.dispose();
  }

  Future<void> loadTasks() async {
    final tasks = await DBHelper.getTasks();
    state = tasks;
  }

  Future<void> addTask(Task task) async {
    final newTask = task.copyWith(
      isSynced: false,
      uuid: _uuid.v4(),
    );
    final id = await DBHelper.insert(newTask);
    state = await DBHelper.getTasks();

    try {
      final firebaseId = await _firebaseService.addTask(newTask);
      final syncedTask = newTask.copyWith(
        id: id,
        firebaseId: firebaseId,
        isSynced: true,
      );
      await DBHelper.update(syncedTask);
      state = await DBHelper.getTasks();
    } catch (_) {}
  }

  Future<void> deleteTask(Task task) async {
    await DBHelper.delete(task.id!);
    state = await DBHelper.getTasks();

    try {
      if (task.firebaseId != null) {
        await _firebaseService.deleteTask(task.firebaseId!);
      }
    } catch (_) {}
  }

  Future<void> updateTask(Task oldTask, Task newTask) async {
    final updatedTask = newTask.copyWith(
      id: oldTask.id,
      uuid: oldTask.uuid,
      firebaseId: oldTask.firebaseId,
      isSynced: false,
    );
    await DBHelper.update(updatedTask);
    state = await DBHelper.getTasks();

    try {
      if (updatedTask.firebaseId != null) {
        await _firebaseService.updateTask(updatedTask.firebaseId!, updatedTask);
        await DBHelper.update(updatedTask.copyWith(isSynced: true));
        state = await DBHelper.getTasks();
      }
    } catch (_) {}
  }

  Future<void> toggleTask(Task task) async {
    final updatedTask = task.copyWith(isDone: !task.isDone, isSynced: false);
    await DBHelper.update(updatedTask);
    state = await DBHelper.getTasks();

    try {
      if (updatedTask.firebaseId != null) {
        await _firebaseService.updateTask(updatedTask.firebaseId!, updatedTask);
        await DBHelper.update(updatedTask.copyWith(isSynced: true));
        state = await DBHelper.getTasks();
      }
    } catch (_) {}
  }

  Future<void> syncWithFirebase() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final unsyncedTasks = await DBHelper.getUnsyncedTasks();

      for (var task in unsyncedTasks) {
        try {
          if (task.firebaseId == null) {
            final firebaseId = await _firebaseService.addTask(task);
            final syncedTask = task.copyWith(
              firebaseId: firebaseId,
              isSynced: true,
            );
            await DBHelper.update(syncedTask);
          } else {
            await _firebaseService.updateTask(task.firebaseId!, task);
            await DBHelper.update(task.copyWith(isSynced: true));
          }
        } catch (_) {}
      }

      final firebaseTasks = await _firebaseService.fetchTasks();
      final localTasks = await DBHelper.getTasks();

      for (var fTask in firebaseTasks) {
        final exists = localTasks.any((l) => l.uuid == fTask.uuid);
        if (!exists) {
          await DBHelper.insert(fTask);
        }
      }

      state = await DBHelper.getTasks();
    } finally {
      _isSyncing = false;
    }
  }
}

final taskListProvider =
    StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  final link = ref.keepAlive();
  final notifier = TaskListNotifier();

  ref.onDispose(() {
    notifier.dispose();
    link.close();
  });

  return notifier;
});
