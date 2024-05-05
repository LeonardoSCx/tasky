import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tasky/ui/home_screen.dart';
import 'package:tasky/ui/intro_screen.dart';
import 'package:tasky/ui/splash_screen.dart';

class Routes{
  static const splash = '/';
  static const intro = '/intro';
  static const register = '/register';
  static const loginEmail = '/loginEmail';
  static const home = '/home';
  static const taskDetails = '/taskDetails';
  static const addTask = '/addTask';

  static Route routes(RouteSettings settings){
    switch (settings.name){
      case splash:
        return _buildRoute(settings, page: const SplashScreen());
      case intro:
        return _buildRoute(settings, page: const IntroScreen());
      case home:
        return _buildRoute(settings, page: const AppHome());
      case register:
        return _buildRoute(settings, page: const Placeholder());
      default:
        throw Exception('Origen: App_Routes');
    }
  }

  static GetPageRoute _buildRoute(RouteSettings settings, {required Widget page}) => GetPageRoute(settings: settings, page: () => page);
}