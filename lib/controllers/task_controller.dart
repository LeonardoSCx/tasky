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
        fechaCreacion: DateTime.now());
    _crudRepository.addTask(tarea, uid);
  }

  Future<void> updateTask(String documentId, String uid,
      DateTime fechaCreacion) async {
    UserTask tarea = UserTask(
        titulo: titleController.text,
        contenido: contentController.text,
        completado: completado.value,
        uid: documentId,
        fechaFin: fecha.value,
        fechaCreacion: fechaCreacion);
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
        lastDate: DateTime(DateTime
            .now()
            .year + 50));
    if (fechaElegida != null && fechaElegida != fecha.value &&
        fechaElegida.isAfter(DateTime.now())) {
      TimeOfDay? horaElegida = await elegirHora();
      if(horaElegida == null){
        error.value = 'No has elegido una hora';
      }else{
        fecha.value = DateTime(fechaElegida.year, fechaElegida.month, fechaElegida.day, horaElegida.hour,horaElegida.minute);
        error.value = null;
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
