import 'package:tasker_app/todo_provider.dart';

class Todo {
  int? id; // Nullable integer
  String name;
  int date;
  bool isChecked;

  // Constructor with named parameters, making `id` optional
  Todo({
    this.id, // Nullable
    required this.name,
    required this.date,
    required this.isChecked,
  });

  // Named constructor to create an instance from a map
  Todo.fromMap(Map<String, dynamic> map)
      : id = map[columnId],
        name = map[columnName],
        date = map[columnDate],
        isChecked = map[columnIsChecked] == 0 ? false : true;

  // Method to convert the instance to a map
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (id != null) map[columnId] = id; // Only add `id` if it's not null
    map[columnName] = name;
    map[columnDate] = date;
    map[columnIsChecked] = isChecked ? 1 : 0;
    return map;
  }
}
