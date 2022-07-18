import 'package:flutter/material.dart';
import 'package:todo_app/ui/theme.dart';

class MyInputField extends StatefulWidget {
  final String title, hint;
  final Widget? widget;
  final TextEditingController? controller;

  MyInputField(
      {required this.title, required this.hint, this.controller, this.widget});

  @override
  State<MyInputField> createState() => _MyInputFieldState();
}

class _MyInputFieldState extends State<MyInputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
          ),
          Container(
            height: 52,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                // border: Border.all(
                //     color: const Color.fromARGB(255, 228, 228, 228), width: 1),
                border: Border.all(width: 0)),
            child: Row(children: [
              Expanded(
                  child: TextFormField(
                readOnly: widget.widget == null ? false : true,
                autofocus: false,
                cursorColor: primaryClr,
                controller: widget.controller,
                decoration: InputDecoration(
                    hintText: widget.hint,
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(width: 0))),
              )),
              widget.widget == null
                  ? Container()
                  : Container(
                      margin: const EdgeInsets.only(right: 6),
                      child: widget.widget,
                    ),
            ]),
          )
        ],
      ),
    );
  }
}
