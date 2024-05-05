import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasky/controllers/auth_controller.dart';

class AppHome extends StatelessWidget {
  const AppHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tasky",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () => Get.find<AuthController>().signOut(),
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          onPressed: () {
            Get.toNamed("/login");
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          backgroundColor: Colors.blue.shade50,
          child: const Icon(
            Icons.add,
            color: Colors.purple,
          ),
        ),
      ),
    );
  }
}
