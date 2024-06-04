import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tasky/Routes/app_routes.dart';
import 'package:tasky/controllers/time_controller.dart';
import 'package:tasky/controllers/auth_controller.dart';
import 'package:tasky/controllers/tasks_controller.dart';
import 'package:tasky/controllers/user_controller.dart';
import 'package:tasky/models/user_task.dart';
import 'package:tasky/utils/string_utils.dart';
import 'package:tasky/utils/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    final authController = Get.find<AuthController>();
    final taskController = Get.put<TasksController>(TasksController());

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
          Expanded(
            child: Obx(() {
              taskController.todos.sort();
              Map tareasAGrupadas =
                  UserTask.groupItemsByCategory(taskController.todos);
              return ListView.builder(
                itemCount: tareasAGrupadas.length,
                itemBuilder: (context, index) {
                  String prioridad = tareasAGrupadas.keys.elementAt(index);
                  List tareasPorPrioridad = tareasAGrupadas[prioridad];
                  return Column(
                    children: [
                      PriorityCard(categoria: prioridad),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: tareasPorPrioridad.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            direction: DismissDirection.startToEnd,
                            key: Key(index.toString()),
                            secondaryBackground: Container(
                              color: Colors.green,
                            ),
                            background: Container(
                              color: Colors.red,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(Icons.delete),
                                ),
                              ),
                            ),
                            onDismissed: (direction) {
                              if (direction == DismissDirection.startToEnd) {
                                taskController.crudRepository.deleteTask(tareasPorPrioridad[index].uid,authController.authUser.value!.uid );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Tarea eliminada"),
                                  ),
                                );
                              }
                            },
                            child: TodoCard(
                              uid: authController.authUser.value!.uid,
                              todo: tareasPorPrioridad[index],
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            }),
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
  log("estoy creando la fotito");
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
    final timerController =
        Get.put(TimeController(fechaFin: todo.fechaFin), tag: todo.uid);
    return GestureDetector(
      onTap: () {
        log(todo.prioridad.toString());
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
                      style: TextStyle(
                          color: tareaCaducada && !todo.completado
                              ? Colors.red
                              : null),
                    );
                  })
                ],
              ),
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

class PriorityCard extends StatelessWidget {
  final String categoria;
  Color color = Colors.black;

  PriorityCard({
    super.key,
    required this.categoria,
  });

  @override
  Widget build(BuildContext context) {
    switch (categoria) {
      case "bajo":
        color = Colors.blue;
      case "medio":
        color = Colors.amber;
      case "alto":
        color = Colors.orange;
      case "critico":
        color = Colors.red;
    }
    return GestureDetector(
      onTap: () {},
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  categoria,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
