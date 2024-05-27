import 'package:get/get.dart';
import 'package:tasky/Routes/app_routes.dart';
import 'package:tasky/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:tasky/utils/theme.dart';

class MyApp extends StatelessWidget {
  final authController = Get.put(AuthController());
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: authController,
        builder: (_) {
          return GetMaterialApp(

            title: "Tasky_Auth_Flow",
            onGenerateRoute: Routes.routes,
            theme: ThemeUtils.darkTheme(),
          );
        });
  }
}
