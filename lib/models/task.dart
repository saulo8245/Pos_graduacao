class Task {
  final String title;
  final String description;
  bool isDone;

  Task({
    required this.title,
    required this.description,
    this.isDone = false,
  });

  // Método copyWith
  Task copyWith({
    String? title,
    String? description,
    bool? isDone,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }

  // Conversão para Map (útil se quiser salvar em banco futuramente)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }

  // Criação a partir de Map (útil para banco ou API)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isDone: map['isDone'] ?? false,
    );
  }
}
