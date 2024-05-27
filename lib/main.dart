import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tasky/repository/abs_crud_repository.dart';
import 'package:tasky/repository/abs_user_repository.dart';
import 'package:tasky/repository/implementations/auth_repository.dart';
import 'package:tasky/repository/implementations/crud_repository.dart';
import 'package:tasky/repository/implementations/user_repository.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:tasky/repository/abs_auth_repository.dart';

import 'app.dart';

void main() async{
  debugPaintLayerBordersEnabled=false;
  // Nos aseguramos de que se inicia firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put<AuthRepository>(AuthRepositoryImp());
  Get.put<UserRepository>(UserRepositoryImp());
  Get.put<CrudRepository>(CrudRepositoryImp());
  runApp(MyApp());
}




