class Task {
  final int? id; // ID do SQLite
  final String? firebaseId; // ID do Firestore
  final String title;
  final String description;
  bool isDone;
  bool isSynced; // Controle de sincronização

  Task({
    this.id,
    this.firebaseId,
    required this.title,
    required this.description,
    this.isDone = false,
    this.isSynced = false,
  });

  Task copyWith({
    int? id,
    String? firebaseId,
    String? title,
    String? description,
    bool? isDone,
    bool? isSynced,
  }) {
    return Task(
      id: id ?? this.id,
      firebaseId: firebaseId ?? this.firebaseId,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firebaseId': firebaseId,
      'title': title,
      'description': description,
      'isDone': isDone ? 1 : 0,
      'isSynced': isSynced ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      firebaseId: map['firebaseId'],
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'] == 1,
      isSynced: map['isSynced'] == 1,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  factory Task.fromFirestore(String id, Map<String, dynamic> map) {
    return Task(
      firebaseId: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isDone: map['isDone'] ?? false,
      isSynced: true,
    );
  }
}
