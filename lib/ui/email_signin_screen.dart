import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasky/controllers/email_signin_controller.dart';
import 'package:tasky/utils/widgets.dart';

class EmailSignInScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  EmailSignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signinController = Get.put(EmailSignInController());
    Map<String, dynamic> campos = {
      'Correo': [
        signinController.emailController,
        signinController.emptyValidator,
      ],
      'Contraseña': [
        signinController.passwordController,
        signinController.emptyValidator
      ],
    };
    return Scaffold(
        appBar: AppBar(
          title: const Text("Iniciar sesion con cuenta"),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Visibility(
                    visible: signinController.isLoading.value,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: signinController.error.value?.isNotEmpty == true,
                    child: Text(
                      signinController.error.value ?? '',
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ...campos.entries.map((entry) {
                  return Widgets.campoFormulario(
                      entry.value[0], entry.value[1], entry.key);
                }),
                const SizedBox(height: 8),
                Center(
                  child: ElevatedButton(
                    child: const Text('Iniciar Sesion'),
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        signinController.signinEmailPassword();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
