import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:tasky/repository/auth_repository.dart';
import 'package:tasky/repository/implementations/auth_repository.dart';

import 'app.dart';

void main() async{
  // Nos aseguramos de que se inicia firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Modelo con los metodos de inicio de sesion
  Get.put<AuthRepository>(AuthRepositoryImp());

  runApp(MyApp());
}




