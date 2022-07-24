import 'package:get/state_manager.dart';
import 'package:todo_app/models/task.dart';

class TaskController extends GetxController {
  var taskList = <Task>[
    Task(
        id: 0,
        title: "task 0",
        note: "note 0",
        isCompleted: 0,
        endTime: "10:59 PM",
        startTime: "08:17 PM",
        date: "7/24/2022",
        color: 0,
        repeat: 'Daily'),
    Task(
        id: 1,
        title: "task 1",
        note: "note 1",
        isCompleted: 0,
        endTime: "10:59 AM",
        startTime: "9:00 AM",
        date: "7/25/2022",
        color: 0,
        repeat: 'Daily'),
    Task(
        id: 2,
        title: "task 2",
        note: "note 2",
        isCompleted: 1,
        endTime: "10:59AM",
        startTime: "9:00AM",
        date: "7/25/2022",
        color: 1),
    Task(
        id: 3,
        title: "task 3",
        note: "note 3",
        isCompleted: 0,
        endTime: "10:59AM",
        startTime: "9:00AM",
        date: "7/25/2022",
        color: 2)
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
    //getTask();
  }

  void markTaskCompleted(String id) async {
    //make isCompleted to true
    //getTask();
  }
}
