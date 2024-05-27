import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tasky/repository/abs_auth_repository.dart';

class RegisterController extends GetxController{
  final _authRepository = Get.find<AuthRepository>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  final error = Rx<String?>(null);
  final isLoading = RxBool(false);

  String? emailValidator(String? value){
    return (value == null || value.isEmpty) ? 'No es un correo valido':null;
  }
  String? passwordValidator(String? value){
    if (value == null || value.isEmpty) return 'No es una contraseña valida';
    if(value.length < 6) return 'La contraseña debe tener 6 caracteres como minimo';
    if(passwordController.text != repeatPasswordController.text){
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  Future<void> createUserWithEmailPassword() async{
    try{
      isLoading.value = true;
      error.value = null;
      await _authRepository.createUserWithEmailAndPass(emailController.text, passwordController.text);
    }catch(e){
      error.value = e.toString();
    }
    isLoading.value = false;
  }


}