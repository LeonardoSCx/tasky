import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasky/utils/theme.dart';

class Widgets {
  static Widget themeSelector() {
    return IconButton(
        onPressed: () {
          if (Get.isDarkMode) {
            Get.changeTheme(ThemeUtils.lightTheme());
          } else {
            Get.changeTheme(ThemeUtils.darkTheme());
          }
        },
        icon: const Icon(Icons.edit));
  }

  static Widget campoFormulario(TextEditingController controlador,
      String? Function(String?)? validador, String campo) {
    if(campo == "Contraseña"){
      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: TextFormField(
            controller: controlador,
            decoration: InputDecoration(labelText: campo, hintText: "Añade alguno detalles"),
            validator: validador,
            obscureText: true,
          ),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: TextFormField(
          controller: controlador,
          decoration: InputDecoration(labelText: campo, hintText: "Añade alguno detalles"),
          validator: validador,
        ),
      ),
    );
  }
}
