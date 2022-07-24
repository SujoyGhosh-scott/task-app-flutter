import 'package:get/state_manager.dart';
import 'package:todo_app/models/task.dart';

class TaskController extends GetxController {
  var taskList = <Task>[
    Task(id: 1, title: "task 1", note: "note 1", isCompleted: 0),
    Task(id: 2, title: "task 2", note: "note 2", isCompleted: 0),
    Task(id: 3, title: "task 3", note: "note 3", isCompleted: 0)
  ].obs;

  Future<int> addTask({Task? task}) async {
    //add task to database
    //return taskId

    return 5;
  }

  void getTask() async {
    //fetch all the tasks and store them in taskList list
    // List<Map<String, dynamic>> tasks = await DBHelper.query();
    // taskList.assignAll(tasks.map((data) => new Task.formJson(data)));
  }

  void delete(String id) async {
    //delete task having given Id
  }
}
