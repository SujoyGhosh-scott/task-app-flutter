import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/notification_services.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:todo_app/ui/add_task_bar.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/ui/widgets/button.dart';
import 'package:todo_app/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  NotifyHelper notifyHelper = NotifyHelper();
  final _taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.backgroundColor,
        leading: GestureDetector(
          onTap: () {
            ThemeService().switchTheme();
            notifyHelper.displayNotification(
                title: "Theme Changed",
                body: Get.isDarkMode
                    ? "Activated Light Theme"
                    : "Activated dark theme");
            //notifyHelper.scheduleNotification();
          },
          child: Icon(
            Get.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
            size: 20,
            color: primaryClr,
          ),
        ),
        actions: const [
          Icon(
            Icons.person,
            size: 30,
            color: primaryClr,
          ),
          // Center(
          //   child: const Text(
          //     "Hi sujoy",
          //     style: TextStyle(color: primaryClr, fontSize: 22),
          //   ),
          // ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Column(children: [
        ///top bar with add task button
        Container(
          margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat.yMMMMd().format(DateTime.now()),
                      style: subHeadingStyle),
                  Text(
                    "Today",
                    style: headingStyle,
                  )
                ],
              ),
              MyButton(
                  label: "+ Add task",
                  onTap: () async {
                    if (kDebugMode) {
                      print("presssed");
                    }
                    await Get.to(AddTaskPage());
                    _taskController.getTask();
                  })
            ],
          ),
        ),

        ///List of dates
        Container(
            margin: const EdgeInsets.only(top: 10, left: 10),
            child: DatePicker(
              DateTime.now(),
              height: 100,
              width: 80,
              initialSelectedDate: DateTime.now(),
              selectionColor: primaryClr,
              selectedTextColor: Colors.white,
              onDateChange: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            )),
        const SizedBox(
          height: 16,
        ),

        //next section
        _showTasks()
      ]),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index];
              if (kDebugMode) {
                print(_taskController.taskList.length);
                print(task.toJson());
              }

              if (task.repeat == 'Daily') {
                DateTime date =
                    DateFormat.jm().parse(task.startTime.toString());
                var myTime = DateFormat("HH:mm").format(date);
                if (kDebugMode) {
                  print(myTime);
                }
                notifyHelper.scheduleNotification(
                    int.parse(myTime.toString().split(":")[0]),
                    int.parse(myTime.toString().split(":")[1]),
                    task);

                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                          child: Row(
                        children: [
                          GestureDetector(
                            onTap: (() {
                              _showBottomSheet(context, task);
                            }),
                            child: TaskTile(task),
                          )
                        ],
                      )),
                    ));
              }
              if (task.date == DateFormat.yMd().format(_selectedDate)) {
                return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                          child: Row(
                        children: [
                          GestureDetector(
                            onTap: (() {
                              _showBottomSheet(context, task);
                            }),
                            child: TaskTile(task),
                          )
                        ],
                      )),
                    ));
              } else {
                return Container();
              }
            });
      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * 0.24
          : MediaQuery.of(context).size.height * 0.32,
      color: Get.isDarkMode ? darkGrayClr : Colors.white,
      child: Column(children: [
        Container(
          height: 4,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
          ),
        ),
        const Spacer(),
        task.isCompleted == 1
            ? Container()
            : _bottomSheetButton(
                label: "Task Completed",
                onTap: () {
                  //_taskController.markTaskCompleted(task.id.toString());
                  Get.back();
                },
                clr: primaryClr,
                context: context),
        const SizedBox(
          height: 6,
        ),
        _bottomSheetButton(
            label: "Delete Task",
            onTap: () {
              //_taskController.delete(id);
              Get.back();
            },
            clr: Colors.redAccent,
            context: context),
        const SizedBox(
          height: 16,
        ),
        _bottomSheetButton(
            label: "Close",
            onTap: () {
              Get.back();
            },
            clr: Colors.black26,
            isClose: true,
            context: context),
        const SizedBox(
          height: 20,
        ),
      ]),
    ));
  }

  _bottomSheetButton(
      {required String label,
      required Function onTap,
      required Color clr,
      required BuildContext context,
      bool isClose = false}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: isClose == true ? Colors.black26 : clr,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
            child: Text(
          label,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        )),
      ),
    );
  }
}

TextStyle get subHeadingStyle {
  return const TextStyle(fontSize: 20, fontWeight: FontWeight.w400);
}

TextStyle get headingStyle {
  return const TextStyle(fontSize: 26, fontWeight: FontWeight.w600);
}
