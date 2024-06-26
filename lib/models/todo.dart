class Todo {
  static int _nextId = 0;
  final int id;
  String name;
  String description; // New field for description
  String priority;
  DateTime dueDate;
  bool isCompleted;

  Todo({
    required this.name,
    required this.description, // Initialize description in constructor
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
  }) : id = _nextId++;

  void toggleCompleted() {
    isCompleted = !isCompleted;
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      name: json['name'],
      description: json['description'],
      priority: json['priority'],
      dueDate: DateTime.parse(json['dueDate']),
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'priority': priority,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}
