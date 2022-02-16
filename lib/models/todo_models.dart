class TodoModel {
  final String id;
  final String name;
  final String describe;

  TodoModel({required this.name, required this.describe, required this.id});

  TodoModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],id = json['id'],
        describe = json['describe'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'describe': describe,
      };
}
