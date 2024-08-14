import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasker_app/todo.dart';
import 'package:tasker_app/todo_provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await TodoProvider.instance.open();
  runApp(MyApp());
}

String getFormattedDate() {
  final now = DateTime.now();
  final formatter = DateFormat('dd'); // Adjust format as needed
  return formatter.format(now);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> todoList = [];

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDateDay = DateFormat.d().format(now);
    String formattedDateYear = DateFormat.y().format(now);
    String formattedDateMonth = DateFormat.MMM().format(now);
    String formattedDateDayName = DateFormat.EEEE().format(now).toUpperCase();

    return SafeArea(
      child: Scaffold(
        drawer: Drawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () async{
            TextEditingController nameController =TextEditingController();
            DateTime ?selectedDate;
          await  showModalBottomSheet(context: context, builder: (context){
             return Padding(padding: EdgeInsets.all(20),
             child: Column(children: [
               TextField(
                 controller: nameController,
                 decoration: InputDecoration(label: Text("Todo name")),
               ),
               Row(
                 children: [
                   IconButton(onPressed: ()async {
                     selectedDate = await showDatePicker(context: context, firstDate: DateTime(2024), lastDate: DateTime(2026));
                     setState(() {
                     });
                   }, icon: Icon(Icons.calendar_month)),
                   Text(selectedDate.toString()!="null"?selectedDate.toString():"No Date Chosen ")
                 ],
               ),
               SizedBox(height: 20,),
               TextButton(onPressed: (){
                 TodoProvider.instance.insert(Todo(
                   name:nameController.text,
                   date: selectedDate!.millisecondsSinceEpoch,
                   isChecked: false
                 ));
                 Navigator.of(context).pop();
               }, child: Text("Save"))
               

             ],),);
           });
          },
          child: const Icon(
            Icons.add,
            size: 30,
          ),
        ),
        appBar: AppBar(
          leading: IconButton(
            iconSize: 30.0,
            color: Colors.white, // Change the drawer icon size here
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          backgroundColor: Colors.blue,
          title: Text(
            "Tasker",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.blue,
              width: double.infinity,
              height: 100,
              child: Row(
                children: [
                  Text(
                    formattedDateDay,
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        formattedDateMonth,
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        formattedDateYear,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    formattedDateDayName,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Todo>>(
                  future: TodoProvider.instance.getAllTodo(),
                  builder:(context,snapshot) {
                    if(snapshot.hasError){
                      return Center(
                        child: Text(snapshot.hasError.toString()),
                      );
                    }
                    if(snapshot.hasData){
                      todoList=snapshot.data!;
                return ListView.builder(
                  itemCount: todoList.length,
                  itemBuilder: (context, index) {
                    Todo todo = todoList[index];
                    return ListTile(
                      leading: Checkbox(
                        value: todo.isChecked,
                        onChanged: (bool? value) async{
                          setState(() {
                            todoList[index].isChecked = value!;
                          });
                          await TodoProvider.instance.update(Todo(
                            id: todo.id,
                            name: todo.name,
                            date: todo.date,
                            isChecked: value!,
                          ));
                        },
                      ),
                      title: Text(todo.name),
                      subtitle: Text(
                          DateTime.fromMillisecondsSinceEpoch(todo.date)
                              .toString()),
                      trailing: IconButton(
                        onPressed: () async{
                          if(todo.id!= null){
                           await TodoProvider.instance.delete(todo.id!);
                          }

                          setState(() {

                          });
                        },
                        icon: Icon(Icons.delete, color: Colors.red, size: 20),
                      ),
                    );
                  },);}
                return Center(
                  child: Container(width: 100,height: 100,
                      child: CircularProgressIndicator()),
                );
                
              } ),
            ),
          ],
        ),
      ),
    );
  }
}






