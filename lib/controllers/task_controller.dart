import 'package:get/get.dart';
import 'package:to_do_app/db/db_helper.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  DBHelper mydbHelper = DBHelper();
  final RxList<Task> taskList = <Task>[].obs;

  Future<int> addTask(Task task) async {
    int response = await mydbHelper.insertDate('''
        INSERT INTO 'tasks'
        ('title','note','date','startTime','endTime','remind','repeat','color','isCompleted')
            VALUES (
          '${task.title}',
          '${task.note}',
          '${task.date}',
          '${task.startTime}',
          '${task.endTime}',
          '${task.remind}',
          '${task.repeat}',
          '${task.color}',
          '${task.isCompleted}')
          ''');
    return response;
  }

  Future<void> getTasks() async {
    List<Map> tasks = await mydbHelper.readDate("SELECT * FROM tasks");

    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    print(tasks);
  }

  Future<void> deleteTasks(Task task) async {
    await mydbHelper.deletetDate('DELETE FROM tasks WHERE id = ${task.id}');

    await getTasks();
  }

  Future<void> deletAllTasks() async {
    await mydbHelper.deletetAllDate('DELETE  FROM tasks');

    await getTasks();
  }

  Future<void> markTaskCompleted(Task task) async {
    await mydbHelper
        .updateDate("UPDATE tasks SET 'isCompleted'= 1 WHERE id =${task.id}");
    getTasks();
  }
}
