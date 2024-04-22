import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tasky",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.purple,
          ),
          onPressed: () {
            Get.toNamed("/login");
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: Colors.blue.shade50,
        ),
      ),
    );
  }
}
