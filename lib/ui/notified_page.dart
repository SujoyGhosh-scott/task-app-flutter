import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifiedPage extends StatelessWidget {
  final String label;
  const NotifiedPage({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Get.isDarkMode ? Colors.grey[600] : Colors.white,
        leading: IconButton(
          onPressed: () => Get.back,
          icon: const Icon(Icons.arrow_back_ios),
          color: Get.isDarkMode ? Colors.white : Colors.grey,
        ),
        title: Text(
          label.toString().split("|")[0],
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Container(
          height: 400,
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Get.isDarkMode ? Colors.white : Colors.grey[400]),
          child: Center(
            child: Text(
              label.toString().split("|")[1],
              style: const TextStyle(color: Colors.black, fontSize: 30),
            ),
          ),
        ),
      ),
    );
  }
}
