import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tasky/repository/abs_auth_repository.dart';

/// Controlador que recogerá los datos del usuario en la pantalla de inicio de
/// sesion
class EmailSignInController extends GetxController{
  final _authRepository = Get.find<AuthRepository>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final error = Rx<String?>(null);
  final isLoading = RxBool(false);

  /// Comprueba que el campo no esté vacio, no sea nulo y tenga un patron sencillo.
  /// Se usará para validar los campos del formulario.
  String? emailValidator(String? value){
    if(value == null || value.isEmpty || !_validEmail(value)){
      return 'No es un correo valido';
    }else {
      return null;
    }
  }

  /// Comprueba si el correo es valido y se usará en el formulario de inicio de
  /// sesion.
  bool _validEmail(String correo){
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp emailRegex = RegExp(emailPattern);
    if(emailRegex.hasMatch(correo)) return true;
    return false;
  }

  /// Comprueba si el correo no es nulo o está vacio.
  String? emptyValidator(String? value){
    return (value == null || value.isEmpty) ? 'El campo está vacio':null;
  }

  /// Inicio de sesion con los datos recogidos del formulario
  Future<void> signinEmailPassword() async{
    try{
      isLoading.value = true;
      error.value = null;
      await _authRepository.signInWithEmailAndPass(emailController.text, passwordController.text);
    }catch(e){
      log(e.toString());
      error.value = "Algo salio mal";
      if(e.toString().contains("invalid-credential")) error.value = "Las credenciales no son correctas";
      if(e.toString().contains("invalid-email")) error.value = "El email no es válido";
    }
    isLoading.value = false;
  }


}