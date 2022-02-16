import 'package:flutter/material.dart';
import 'package:todo_ziyouma/models/todo_models.dart';
import 'package:todo_ziyouma/utils/storage_manager.dart';

class HomeTodoScreen extends StatefulWidget {
  const HomeTodoScreen({Key? key}) : super(key: key);

  @override
  State<HomeTodoScreen> createState() => _HomeTodoScreenState();
}

class _HomeTodoScreenState extends State<HomeTodoScreen> {
  List<TodoModel> all_task = [];

  TextEditingController _nameController = TextEditingController();
  TextEditingController _describeController = TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    StorageManager().readAllTask().then(
          (value) => setState(
            () {
              all_task = value;
            },
          ),
        );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<TodoModel>>(
          future: StorageManager().readAllTask(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.length == 0) {
                return Center(
                  child: Text('You have no task'),
                );
              }

              return ListView.builder(
                itemCount: all_task.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(all_task[index].name),
                    subtitle: Text(all_task[index].describe),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Add new task'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      all_task.add(TodoModel(
                        id: DateTime.now().toString(),
                        name: _nameController.text,
                        describe: _describeController.text,
                      ));
                      StorageManager().writeTask(all_task);
                      _nameController.text = "";
                      _describeController.text = "";
                    });

                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Task name',
                    ),
                  ),
                  TextField(
                    controller: _describeController,
                    decoration: InputDecoration(
                      labelText: 'Task describe',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
