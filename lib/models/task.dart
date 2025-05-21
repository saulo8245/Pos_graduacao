class Task {
  final String title;
  final String description;
  //_TypeError (type 'Null' is not a subtype of type 'bool' of 'function result')
  //Arrumar isso mais tarde, to com preguiça agr
  bool isDone;

  Task({
    required this.title,
    required this.description,
    this.isDone = false, // 🟢 Começa como "não concluída"
  });
}
