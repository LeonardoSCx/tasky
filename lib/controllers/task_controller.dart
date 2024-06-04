import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:tasky/models/user_task.dart';
import 'package:tasky/repository/abs_crud_repository.dart';

class TaskController extends GetxController {
  final _crudRepository = Get.find<CrudRepository>();

  var titleController = TextEditingController();
  var contentController = TextEditingController();

  RxBool completado = RxBool(false);
  Rx<DateTime> fecha = Rx<DateTime>(DateTime.now());
  Rx<PriorityTask> prioridadElegida = Rx<PriorityTask>(PriorityTask.bajo);

  void updateSelectedItem(PriorityTask value) {
    prioridadElegida.value = value;
  }

  final error = Rx<String?>(null);

  String? emptyValidator(String? value) {
    return (value == null || value.isEmpty) ? 'El campo está vacio' : null;
  }

  Future<void> addTask(String uid) async {
    UserTask tarea = UserTask(
        titulo: titleController.text,
        contenido: contentController.text,
        completado: false,
        uid: '',
        fechaFin: fecha.value,
        fechaCreacion: DateTime.now(),
        prioridad: prioridadElegida.value);
    _crudRepository.addTask(tarea, uid);
  }

  Future<void> updateTask(
      String documentId, String uid, DateTime fechaCreacion) async {
    UserTask tarea = UserTask(
        titulo: titleController.text,
        contenido: contentController.text,
        completado: completado.value,
        uid: documentId,
        fechaFin: fecha.value,
        fechaCreacion: fechaCreacion,
        prioridad: prioridadElegida.value);
    _crudRepository.updateTask(
      tarea,
      tarea.uid,
      uid,
    );
  }

  elegirFecha() async {
    DateTime? fechaElegida = await showDatePicker(
        context: Get.context!,
        initialDate: fecha.value,
        firstDate: DateTime(2000),
        initialEntryMode: DatePickerEntryMode.calendar,
        lastDate: DateTime(DateTime.now().year + 50));
    if (fechaElegida != null) {
      TimeOfDay? horaElegida = await elegirHora();
      if (horaElegida == null) {
        error.value = 'No has elegido una hora';
      } else {
        fecha.value = DateTime(fechaElegida.year, fechaElegida.month,
            fechaElegida.day, horaElegida.hour, horaElegida.minute);
        error.value = null;
        if (fecha.value.isAtSameMomentAs(DateTime.now())) {
          error.value =
              'La hora debe ser al menos una hora después de la hora actual';
          fecha.value = DateTime.now();
        }
      }
    } else {
      error.value = "Fecha invalida";
    }

    log("fecha actual: ${fecha.value}");
  }

  Future<TimeOfDay?> elegirHora() async {
    TimeOfDay? horaElegida = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );
    return horaElegida;
  }
}
