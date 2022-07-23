import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/models/task.dart';
//import 'package:todo_app/ui/home_page.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/ui/widgets/button.dart';
import 'package:todo_app/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = "9:30 PM";
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  int _selectedColor = 0;

  String _selectedRepeat = "None";
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.backgroundColor,
        elevation: 0,
        title: const Text(
          "Add New Task",
          style: TextStyle(
              color: primaryClr, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        leading: const BackButton(color: primaryClr),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
        child: SingleChildScrollView(
            child: Column(children: [
          MyInputField(
            title: "Title",
            hint: "Enter your title",
            controller: _titleController,
          ),
          MyInputField(
            title: "Note",
            hint: "Enter your note",
            controller: _noteController,
          ),
          MyInputField(
            title: "Date",
            hint: DateFormat.yMd().format(_selectedDate),
            widget: IconButton(
                onPressed: () {
                  if (kDebugMode) {
                    print("hello");
                  }
                  _getDateFromUser();
                },
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  color: primaryClr,
                )),
          ),
          Row(
            children: [
              Expanded(
                  child: MyInputField(
                title: "Start Date",
                hint: _startTime,
                widget: IconButton(
                    onPressed: () {
                      _getTimeFromUser2(isStartTime: true);
                    },
                    icon: const Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey,
                    )),
              )),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                  child: MyInputField(
                title: "End Date",
                hint: _endTime,
                widget: IconButton(
                    onPressed: () {
                      _getTimeFromUser2(isStartTime: false);
                    },
                    icon: const Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey,
                    )),
              ))
            ],
          ),
          MyInputField(
              title: "Remind",
              hint: "$_selectedRemind minutes early",
              widget: DropdownButton(
                icon: const Icon(Icons.keyboard_arrow_down),
                iconSize: 32,
                elevation: 4,
                underline: Container(
                  height: 0,
                ),
                items: remindList.map<DropdownMenuItem<String>>((int value) {
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedRemind = int.parse(value!);
                  });
                },
              )),
          MyInputField(
            title: "Repeat",
            hint: _selectedRepeat,
            widget: DropdownButton(
              icon: const Icon(Icons.keyboard_arrow_down),
              iconSize: 32,
              elevation: 4,
              underline: Container(
                height: 0,
              ),
              items: repeatList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedRepeat = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _colorPallete(),
              MyButton(label: "Create task", onTap: () => _validateDate())
            ],
          )
        ])),
      ),
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDB();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", "All fields are required!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          icon: const Icon(Icons.warning_amber_rounded),
          colorText: Colors.red);
    }
  }

  _addTaskToDB() async {
    int value = await _taskController.addTask(
        task: Task(
            note: _noteController.text,
            title: _titleController.text,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            remind: _selectedRemind,
            repeat: _selectedRepeat,
            color: _selectedColor,
            isCompleted: 0));
    if (kDebugMode) {
      print("id is: $value");
    }
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Color"),
        const SizedBox(height: 6),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : yellowClr,
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          size: 16,
                          color: Colors.white,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2122));

    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
        if (kDebugMode) {
          print(pickerDate);
        }
      });
    } else {
      if (kDebugMode) {
        print("its null or somthing is wrong");
      }
    }
  }

  _getTimeFromUser2({required bool isStartTime}) async {
    var pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0])),
      initialEntryMode: TimePickerEntryMode.input,
    );
    // ignore: use_build_context_synchronously
    String? formatedTime = pickedTime?.format(context);

    if (pickedTime == null) {
      if (kDebugMode) {
        print("Time canceled");
      }
    } else if (isStartTime == true) {
      setState(() {
        _startTime = formatedTime ?? _startTime;
      });
    } else {
      setState(() {
        _endTime = formatedTime ?? _endTime;
      });
    }
  }
}
