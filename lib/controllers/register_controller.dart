import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tasky/repository/abs_auth_repository.dart';

/// Controlador que se encarga de recoger los datos del formulario de la pantalla
/// de registro.
class RegisterController extends GetxController{
  final _authRepository = Get.find<AuthRepository>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  final error = Rx<String?>(null);
  final isLoading = RxBool(false);

  /// Comprueba que el correo no está vacio o sea nulo
  String? emailValidator(String? value){
    return (value == null || value.isEmpty) ? 'No es un correo valido':null;
  }
  /// Comprueba que la contraseña no esté vacia o sea nula. Ademas verifica que
  /// tiene una longitud minima de 6 caracteres. Y comprueba que las contraseñas
  /// de ambos campos coincidan.
  String? passwordValidator(String? value){
    if (value == null || value.isEmpty) return 'No es una contraseña valida';
    if(value.length < 6) return 'La contraseña debe tener 6 caracteres como minimo';
    if(passwordController.text != repeatPasswordController.text){
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  /// Crea una cuenta con los datos recogidos de la interfaz.
  Future<void> createUserWithEmailPassword() async{
    try{
      isLoading.value = true;
      error.value = null;
      await _authRepository.createUserWithEmailAndPass(emailController.text, passwordController.text);
    }catch(e){
      log(e.toString());
      error.value = "Algo salio mal";
      if(e.toString().contains("invalid-credential")) error.value = "Las credenciales no son correctas";
      if(e.toString().contains("invalid-email")) error.value = "El email no es válido";
    }
    isLoading.value = false;
  }


}