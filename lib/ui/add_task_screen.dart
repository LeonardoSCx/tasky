import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tasky/Routes/app_routes.dart';
import 'package:tasky/controllers/auth_controller.dart';
import 'package:tasky/controllers/task_controller.dart';
import 'package:tasky/models/user_task.dart';
import 'dart:developer';
import 'package:tasky/utils/widgets.dart';

class TaskScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final bool edicion;
  final UserTask? tarea;

  TaskScreen({super.key, required this.edicion, this.tarea});

  @override
  Widget build(BuildContext context) {
    var taskController = Get.find<TaskController>();
    final authController = Get.find<AuthController>();
    // Inidicamos los valores de los controladores al final de la construccion
    // del Widget para evitar posibles conflictos durante su inicializacion.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (tarea != null && edicion) {
        taskController.titleController.text = tarea!.titulo;
        taskController.contentController.text = tarea!.contenido;
        taskController.completado = RxBool(tarea!.completado);
        taskController.fecha = Rx<DateTime>(tarea!.fechaFin);
        taskController.updateSelectedItem(tarea!.prioridad as PriorityTask);
      } else {
        taskController.titleController.text = "";
        taskController.contentController.text = "";
      }
    });
    Map<String, dynamic> campos = {
      'Titulo': [taskController.titleController, taskController.emptyValidator],
      'Detalles': [
        taskController.contentController,
        taskController.emptyValidator
      ],
    };
    List<PriorityTask> prioridades = [
      PriorityTask.bajo,
      PriorityTask.medio,
      PriorityTask.alto,
      PriorityTask.critico
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text(edicion ? "Editar" : "Añade una tarea"),
          backgroundColor: const Color(0xFF008f7a),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...campos.entries.map((entry) {
                  return Widgets.campoFormulario(
                      entry.value[0], entry.value[1], entry.key);
                }),
                Obx(
                  () => Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Fecha fin: ${DateFormat('dd-MM-yyyy').format(taskController.fecha.value)}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton(
                              // onPressed: () => taskController.elegirFecha(),
                              onPressed: () => taskController.elegirFecha(),
                              child: const Icon(Icons.calendar_month))
                        ],
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: taskController.error.value?.isNotEmpty == true,
                    child: Text(
                      taskController.error.value ?? '',
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Nivel de prioridad:"),
                  const SizedBox(
                    width: 10,
                  ),
                  Obx(() {
                    return DropdownButton<PriorityTask>(
                      value: taskController.prioridadElegida.value,
                      onChanged: (nuevaPrioridad) {
                        taskController.updateSelectedItem(nuevaPrioridad!);
                      },
                      items: prioridades.map<DropdownMenuItem<PriorityTask>>(
                          (PriorityTask prioridad) {
                        return DropdownMenuItem<PriorityTask>(
                          value: prioridad,
                          child: Text(prioridad.name),
                        );
                      }).toList(),
                    );
                  }),
                ]),
                Builder(builder: (_) {
                  if (edicion) {
                    return Card(
                      child: Obx(
                        () => CheckboxListTile(
                            title: const Text('Completado'),
                            value: taskController.completado.value,
                            onChanged: (value) {
                              taskController.completado.value =
                                  !taskController.completado.value;
                              tarea!.completado =
                                  taskController.completado.value;
                            }),
                      ),
                    );
                  }
                  return const SizedBox(height: 5);
                }),
                Center(
                  child: ElevatedButton(
                    child: Text(edicion ? 'Actualizar' : 'Añadir'),
                    onPressed: () {
                      log("pulsando boton");
                      log(_formKey.currentState!.validate().toString());
                      if (_formKey.currentState?.validate() == true &&
                          taskController.error.value == null) {
                        if (!edicion) {
                          taskController
                              .addTask(authController.authUser.value!.uid);
                        } else {
                          taskController.updateTask(
                            tarea!.uid,
                            authController.authUser.value!.uid,
                            tarea!.fechaCreacion,
                          );
                        }
                        Get.toNamed(Routes.home);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Tarea añadida correctamente"),
                          ),
                        );
                      } else {
                        log("Algo esta mal");
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
