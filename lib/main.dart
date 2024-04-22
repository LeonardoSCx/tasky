import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasky/Routes/app_routes.dart';
import 'package:tasky/routes/app_pages.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Tasky",
      getPages: AppPages.routes,
      initialRoute: Routes.HOME,
    );
  }
}


