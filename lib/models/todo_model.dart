
class TodoModel {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  const TodoModel({required this.userId, required this.id, required this.title, required this.completed});

  @override
  List<Object?> get props => [userId, id, title, completed];

  TodoModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        id = json['id'],
        title = json['title'],
        completed = json['completed'];
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed ? 1 : 0, // Convert boolean to integer
    };
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'userId': userId,
  //     'id': id,
  //     'title': title,
  //     'completed': completed,
  //   };
  // }
}
