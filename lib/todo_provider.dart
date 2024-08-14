import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasker_app/todo.dart';


final String columnId='id';
final String columnName='name';
final String columnDate='date';
final String columnIsChecked='isChecked';
final String tableTodo='TableTodo';

class TodoProvider{
late Database db;
static final TodoProvider instance = TodoProvider._internal();

factory TodoProvider() {
  return instance;
}

TodoProvider._internal();
    Future open() async {
  db = await openDatabase(join (await getDatabasesPath(),'todos.db'), version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
create table $tableTodo ( 
  $columnId integer primary key autoincrement, 
  $columnName text not null,
  $columnDate integer not null,
  $columnIsChecked integer not null)
''');
      });
}
Future<Todo> insert(Todo todo) async {
  todo.id = await db.insert(tableTodo, todo.toMap());
  return todo;
}
Future<int> delete(int id) async {
  return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
}
Future<List<Todo>> getAllTodo() async {
  List<Map<String,dynamic>>  todoMaps = await db.query(tableTodo);
  if (todoMaps.length > 0) {
  List<Todo> todos=[];
  todoMaps.forEach((element){
todos.add(Todo.fromMap(element));
  });
  return todos;
  }
  return [];
}
Future<int> update(Todo todo) async {
  return await db.update(tableTodo, todo.toMap(),
      where: '$columnId = ?', whereArgs: [todo.id]);
}
Future close() async => db.close();
}