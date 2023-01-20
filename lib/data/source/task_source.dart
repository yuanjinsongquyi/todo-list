
import 'package:todo_list/data/db/db_helper.dart';
import 'package:todo_list/data/source/source.dart';
import 'package:todo_list/data/source/task.dart';

class TaskDataSource implements DataSource<Task> {
  final DBHelper _dbHelper = DBHelper();
  @override
  Future<Task> createOrUpdate(data) async {
    if (data.id!=null) {
      _dbHelper.update(data.toMap());
    } else {
      data.id = await _dbHelper.insert(data);
    }
    return data;
  }


  @override
  Future<void> deleteAll() async {
    await _dbHelper.deleteAll();
  }

  @override
  Future<void> deleteById(id) async {
   await _dbHelper.delete(id);
  }

  @override
  Future<Task> findById(id) async {
    final tasks =  await _dbHelper.queryById(id);
    return tasks.map((e) => Task.fromMap(e)).first;
  }

  @override
  Future<List<Task>> getAll({String searchKeyword = ''}) async {
    final tasks =  await _dbHelper.query();
    List<Task> taskList= tasks.map((e) => Task.fromMap(e)).toList();
    return taskList
        .where((task) => task.title!.contains(searchKeyword))
        .toList();
  }
}
