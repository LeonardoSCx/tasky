import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tasky/ui/add_task_screen.dart';
import 'package:tasky/ui/email_signin_screen.dart';
import 'package:tasky/ui/home_screen.dart';
import 'package:tasky/ui/intro_screen.dart';
import 'package:tasky/ui/register_screen.dart';
import 'package:tasky/ui/splash_screen.dart';
import '../ui/profile_screen.dart';

/// Clase donde indicamos las diferentes pantallas
class Routes {
  static const root = '/';
  static const intro = '/intro';
  static const register = '/register';
  static const loginEmail = '/loginEmail';
  static const home = '/home';
  static const profile = '/profile';
  static const addTask = '/addTask';
  static const updateTask = '/updateTask';

  static Route routes(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return _buildRoute(settings, page: const SplashScreen());
      case intro:
        return _buildRoute(settings, page: const IntroScreen());
      case home:
        return _buildRoute(settings, page: const HomeScreen());
      case register:
        return _buildRoute(settings, page: EmailRegisterScreen());
      case loginEmail:
        return _buildRoute(settings, page: EmailSignInScreen());
      case profile:
        return _buildRoute(settings, page: const ProfileScreen());
      case addTask:
        return _buildRoute(settings, page: TaskScreen(edicion: false,));
      case updateTask:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(settings, page: TaskScreen(edicion: true, tarea: args['tarea']));
      default:
        throw Exception('Origen: App_Routes');
    }
  }

  static GetPageRoute _buildRoute(RouteSettings settings, {required Widget page}) => GetPageRoute(settings: settings, page: () => page);

}
