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
    var file_db = File('$path/todo_data.json');
    bool file_exist = await file_db.exists();

    if (!file_exist) file_db.create();

    return file_db;
  }

  Future<List<TodoModel>> readAllTask() async {
    final file = await _localFile;

    // Read the file
    final contents = await file.readAsString();

    List json_task = jsonDecode(contents);

    return json_task.map((e) => TodoModel.fromJson(e)).toList();
  }

  Future<File> writeTask(List<TodoModel> todo_list) async {
    final file = await _localFile;
    final contents = todo_list.map((e) => e.toJson()).toList();

    // Write the file
    return file.writeAsString(jsonEncode(contents));
  }
}
