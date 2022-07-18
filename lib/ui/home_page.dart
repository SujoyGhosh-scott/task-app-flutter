import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/services/notification_services.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:todo_app/ui/add_task_bar.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/ui/widgets/button.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  NotifyHelper notifyHelper = NotifyHelper();

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
            notifyHelper.scheduleNotification();
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
                  onTap: () {
                    if (kDebugMode) {
                      print("presssed");
                    }
                    Get.to(AddTaskPage());
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
                _selectedDate = date;
              },
            )),

        //next section
      ]),
    );
  }
}

TextStyle get subHeadingStyle {
  return const TextStyle(fontSize: 20, fontWeight: FontWeight.w400);
}

TextStyle get headingStyle {
  return const TextStyle(fontSize: 26, fontWeight: FontWeight.w600);
}
