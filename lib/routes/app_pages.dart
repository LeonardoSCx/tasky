import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tasky/Routes/app_routes.dart';
import 'package:tasky/tasks/pages/app_home.dart';

class AppPages{
  static final routes = [
    GetPage(name: Routes.LOGIN, page: ()=> const Placeholder()),
    GetPage(name: Routes.REGISTER, page: ()=> const Placeholder()),
    GetPage(name: Routes.HOME, page: ()=> const AppHome()),
    GetPage(name: Routes.ADD, page: ()=> const Placeholder()),
    GetPage(name: Routes.DETAILS, page: ()=> const Placeholder()),
  ];
}