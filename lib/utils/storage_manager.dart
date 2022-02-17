import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:todo_ziyouma/models/todo_models.dart';

class StorageManager {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    // check if file not exist create file
    var fileDb = File('$path/todo_data.json');
    bool fileExist = await fileDb.exists();

    if (!fileExist) fileDb.create();

    return fileDb;
  }

  Future<List<TodoModel>> readAllTask() async {
    final file = await _localFile;

    // Read the file
    final contents = await file.readAsString();

    List jsonTask = jsonDecode(contents);

    return jsonTask.map((e) => TodoModel.fromJson(e)).toList();
  }

  Future<File> writeTask(List<TodoModel> todoList) async {
    final file = await _localFile;
    final contents = todoList.map((e) => e.toJson()).toList();

    // Write the file
    return file.writeAsString(jsonEncode(contents));
  }
}
