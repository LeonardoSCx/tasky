import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:tasky/Routes/app_routes.dart';
import 'package:tasky/controllers/main_signing_controller.dart';
import 'package:page_indicator/page_indicator.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("¡Bienvenido!"),
      ),
      body: _IntroPager(),
    );
  }
}

class _IntroPager extends HookWidget {
  final String sampleText = "¡Bienvenido a nuestra app de tareas diarias! \n Organiza tu día y alcanza tus metas con facilidad. ¡Comienza a planificar ahora mismo!";

  @override
  Widget build(BuildContext context) {
    // Llamamos al controlador
    final homeSignInController = Get.put(MainSignInController());

    return AbsorbPointer(
      // Si el usuario pulsa un boton, los demás eventos se deshabilitarán
      absorbing: homeSignInController.isLoading.value,
      child: PageIndicatorContainer(
        align: IndicatorAlign.bottom,
        length: 2,
        indicatorSpace: 12,
        indicatorColor: Colors.grey,
        indicatorSelectorColor: Colors.black,
        child: PageView(
          controller: usePageController(),
          children: <Widget>[
            _DescriptionPage(
              text: sampleText,
              imagePath: 'assets/icon_intro.png',
            ),
            const _LoginPage(),
          ],
        ),
      ),
    );
  }
}

class _DescriptionPage extends StatelessWidget {
  final String text;
  final String imagePath;

  const _DescriptionPage(
      {required this.text, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imagePath,
            width: 200,
            height: 200,
          ),
          Expanded(
              child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ))
        ],
      ),
    );
  }
}

class _LoginPage extends StatelessWidget {
  const _LoginPage();

  @override
  Widget build(BuildContext context) {
    final homeSignInController = Get.find<MainSignInController>();
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/icon_intro.png",
            width: 200,
            height: 200,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                "¡Inicia sesion o crea una cuenta!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Observador que permite ver un icono de carga
          Obx(
            () => Visibility(
              visible: homeSignInController.isLoading.value,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          // Widget que muestra el error asociado con el inicio de sesion
          Obx(
            () => Visibility(
              visible: homeSignInController.error.value?.isNotEmpty == true,
              child: const Text("¡Algo salio mal durante la autenticacion!",
                style: TextStyle(color: Colors.red, fontSize: 24),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 8),
                _LoginButton(
                  text: 'Inicia sesion con Google',
                  imagePath: "assets/icon_google.png",
                  color: Colors.white,
                  textColor: Colors.grey,
                  onTap: () => homeSignInController.signInWithGoogle(),
                ),
                const SizedBox(height: 8),
                _LoginButton(
                  text: 'Inicia sesion con correo',
                  imagePath: "assets/icon_email.png",
                  color: Colors.red,
                  textColor: Colors.white,
                  onTap: () => Get.toNamed(Routes.loginEmail),
                ),
                const SizedBox(height: 8),
                _LoginButton(
                  text: 'Inicia sesion anónimamente',
                  imagePath: 'assets/icon_question.png',
                  color: Colors.deepPurpleAccent,
                  textColor: Colors.white,
                  onTap: () => homeSignInController.signInAnonymously(),
                ),
                const SizedBox(height: 48),
                OutlinedButton(
                  onPressed: () => Get.toNamed(Routes.register),
                  child: const Text("Crear cuenta"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final String text;
  final String imagePath;
  final VoidCallback? onTap;
  final Color color;
  final Color textColor;

  const _LoginButton(
      {required this.text,
      required this.imagePath,
      this.onTap,
      required this.color,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      elevation: 3,
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 3),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
