import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasky/controllers/register_controller.dart';

class EmailRegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  EmailRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final registerController = Get.put(RegisterController());
    return Scaffold(
        appBar: AppBar(
          title: const Text("Crear cuenta"),
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
                    visible: registerController.isLoading.value,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: registerController.error.value?.isNotEmpty == true,
                    child: Text(
                      registerController.error.value ?? '',
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: registerController.emailController,
                  decoration: const InputDecoration(labelText: "Correo"),
                  validator: registerController.emailValidator,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: registerController.passwordController,
                  decoration: const InputDecoration(labelText: "Contraseña"),
                  validator: registerController.passwordValidator,
                  obscureText: true,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: registerController.repeatPasswordController,
                  decoration: const InputDecoration(labelText: "Repite Contraseña"),
                  validator: registerController.passwordValidator,
                  obscureText: true,
                ),
                Center(
                  child: ElevatedButton(
                    child: const Text('Registrarse'),
                    onPressed: (){
                      if(_formKey.currentState?.validate() == true){
                        registerController.createUserWithEmailPassword();
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
