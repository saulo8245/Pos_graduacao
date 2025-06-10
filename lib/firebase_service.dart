import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addTask(Task task) async {
    final doc = await _firestore.collection('tasks').add({
      'uuid': task.uuid,
      'title': task.title,
      'description': task.description,
      'isDone': task.isDone,
      'createdAt': DateTime.now().toIso8601String(),
    });
    return doc.id;
  }

  Future<void> updateTask(String firebaseId, Task task) async {
    await _firestore.collection('tasks').doc(firebaseId).update({
      'uuid': task.uuid,
      'title': task.title,
      'description': task.description,
      'isDone': task.isDone,
    });
  }

  Future<void> deleteTask(String firebaseId) async {
    await _firestore.collection('tasks').doc(firebaseId).delete();
  }

  Future<List<Task>> fetchTasks() async {
    final snapshot =
        await _firestore.collection('tasks').orderBy('createdAt').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Task(
        firebaseId: doc.id,
        uuid: data['uuid'] ?? '', // 👈 precisa existir no Firestore
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        isDone: data['isDone'] ?? false,
        isSynced: true,
      );
    }).toList();
  }
}
