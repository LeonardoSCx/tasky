import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tasky/repository/abs_auth_repository.dart';

class EmailSignInController extends GetxController{
  final _authRepository = Get.find<AuthRepository>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final error = Rx<String?>(null);
  final isLoading = RxBool(false);

  String? emailValidator(String? value){
    if(value == null || value.isEmpty || !_validEmail(value)){
      return 'No es un correo valido';
    }else {
      return null;
    }
  }

  bool _validEmail(String correo){
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp emailRegex = RegExp(emailPattern);
    if(emailRegex.hasMatch(correo)) return true;
    return false;
  }

  String? emptyValidator(String? value){
    return (value == null || value.isEmpty) ? 'El campo está vacio':null;
  }

  Future<void> signinEmailPassword() async{
    try{
      isLoading.value = true;
      error.value = null;
      await _authRepository.signInWithEmailAndPass(emailController.text, passwordController.text);
    }catch(e){
      error.value = e.toString();
    }
    isLoading.value = false;
  }


}