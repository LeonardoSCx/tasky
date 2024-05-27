import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tasky/controllers/auth_controller.dart';
import 'package:tasky/models/user.dart';
import 'package:tasky/repository/abs_user_repository.dart';
import 'package:get/get.dart';

class UserController extends GetxController{
  final _userRepository = Get.find<UserRepository>();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();

  Rx<File?> pickedImage = Rx(null);
  Rx<bool> isLoading = Rx(false);
  Rx<bool> isSaving = Rx(false);
  Rx<CustomUser?> user = Rx(null);

  String? emailValidator(String? value){
    return (value == null || value.isEmpty) ? 'El campo no puede estar vacio':null;
  }

  @override
  void onInit() {
    getMyUser();
    super.onInit();
  }

  void setImage(File? imagen) async{
    pickedImage.value = imagen;
  }

  Future<void> getMyUser() async{
    isLoading.value = true;
    user.value = await _userRepository.getMyUser();
    nameController.text = user.value?.name ?? '';
    lastNameController.text = user.value?.lastName ?? '';
    ageController.text = user.value?.age.toString() ?? '';
    isLoading.value = false;
  }

  // Metodo que guarda el usuario en firestore la primera vez
  Future<void> saveMyUser()async{
    isSaving.value = true;
    final uid = Get.find<AuthController>().authUser.value!.uid;
    final name = nameController.text;
    final lastName = lastNameController.text;
    final age = int.tryParse(ageController.text) ?? 0;
    final newUser = CustomUser(uid, name, lastName, age);
    user.value = newUser;

    await _userRepository.saveMyUser(newUser, pickedImage.value);
    isSaving.value = false;
  }

}