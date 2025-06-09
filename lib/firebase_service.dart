import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Adiciona uma tarefa no Firebase
  Future<String> addTask(Task task) async {
    final doc = await _firestore.collection('tasks').add({
      'title': task.title,
      'description': task.description,
      'isDone': task.isDone,
      'createdAt': DateTime.now().toIso8601String(),
    });
    return doc.id;
  }

  /// Atualiza uma tarefa no Firebase
  Future<void> updateTask(String firebaseId, Task task) async {
    await _firestore.collection('tasks').doc(firebaseId).update({
      'title': task.title,
      'description': task.description,
      'isDone': task.isDone,
    });
  }

  /// Deleta uma tarefa no Firebase
  Future<void> deleteTask(String firebaseId) async {
    await _firestore.collection('tasks').doc(firebaseId).delete();
  }

  /// Busca todas as tarefas do Firebase
  Future<List<Task>> fetchTasks() async {
    final snapshot =
        await _firestore.collection('tasks').orderBy('createdAt').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Task(
        firebaseId: doc.id,
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        isDone: data['isDone'] ?? false,
        isSynced: true,
      );
    }).toList();
  }
}
