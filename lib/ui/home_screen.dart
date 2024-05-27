import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:intl/intl.dart';
import 'package:tasky/Routes/app_routes.dart';
import 'package:tasky/controllers/TimeController.dart';
import 'package:tasky/controllers/auth_controller.dart';
import 'package:tasky/controllers/tasks_controller.dart';
import 'package:tasky/controllers/user_controller.dart';
import 'package:tasky/models/user_task.dart';
import 'package:tasky/utils/StringUtils.dart';
import 'package:tasky/utils/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    final authController = Get.put(AuthController());
    Get.put(TasksController());
    return Scaffold(
      drawer: const MenuLateral(),
      appBar: AppBar(
        title: const Text("Tasky"),
        backgroundColor: const Color(0xFF008f7a),
        actions: [
          Widgets.themeSelector(),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Tus Tareas",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          GetX<TasksController>(
            init: Get.put<TasksController>(TasksController()),
            builder: (TasksController todoController) {
              return Expanded(
                child: ListView.builder(
                  itemCount: todoController.todos.length,
                  itemBuilder: (_, index) {
                    return TodoCard(
                      todo: todoController.todos[index],
                      uid: authController.authUser.value!.uid,
                    );
                  },
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF008f7a),
              onPressed: () => Get.toNamed(Routes.addTask),
              child: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final authController = Get.find<AuthController>();
    return Drawer(
      child: ListView(children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(userController.user.value!.name),
          accountEmail: Text(authController.authUser.value!.email ?? ''),
          currentAccountPicture: _buildUserImage(),
          decoration: const BoxDecoration(
            color: Color(0xFF008f7a),
          ),
        ),
        ListTile(
            title: const Text("Perfil"),
            leading: const Icon(Icons.supervised_user_circle),
            onTap: () => Get.toNamed(Routes.profile)),
        ListTile(
          title: const Text("Crear una tarea"),
          leading: const Icon(Icons.note_add),
          onTap: () => Get.toNamed(Routes.addTask),
        ),
        ListTile(
          title: const Text("Cerrar sesion"),
          leading: const Icon(Icons.logout),
          onTap: () => {Get.find<AuthController>().signOut()},
        )
      ]),
    );
  }
}

Widget _buildUserImage() {
  final userController = Get.find<UserController>();
  if (userController.user.value!.image != null) {
    return CircleAvatar(
      backgroundImage: NetworkImage(userController.user.value!.image!),
    );
  } else {
    return const CircleAvatar(
      backgroundImage: AssetImage(
          'assets/icon_question.png'), // Agrega la ruta de la imagen genérica
    );
  }
}

class TodoCard extends StatelessWidget {
  final String uid;
  final UserTask todo;

  const TodoCard({super.key, required this.uid, required this.todo});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TasksController>();
    final timerController = Get.put(TimeController(fechaFin: todo.fechaFin), tag: todo.uid);
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.updateTask, arguments: {'tarea': todo});
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    taskController.crudRepository.deleteTask(todo.uid, uid);
                  },
                  icon: const Icon(Icons.delete)),
              Column(
                children: [
                  Text(
                    todo.titulo,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(() {
                    final tareaCaducada = timerController.estaCaducado.value;
                    final tiempoRestante = timerController.tiempoRestante.value;
                    return Text(
                      "Tiempo restante: ${StringUtils.printDuration(tiempoRestante)}",
                      style: TextStyle(color: tareaCaducada && !todo.completado ? Colors.red : Colors.white),
                    );
                  })
                ],
              ),
              // Expanded(
              //   child: Text(
              //     todo.titulo,
              //     style: const TextStyle(
              //       fontSize: 15,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              Checkbox(
                value: todo.completado,
                onChanged: (newValue) {
                  taskController.crudRepository
                      .updateStatus(!todo.completado, todo.uid, uid);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
