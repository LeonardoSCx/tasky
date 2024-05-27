import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tasky/Routes/app_routes.dart';
import 'package:tasky/controllers/user_controller.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF008f7a),
      ),
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.blueAccent,
          ));
        }
        return _ProfileSection();
      }),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
    final imageObx = Obx(() {
      Widget image = Image.asset(
        'assets/icon_question.png',
        fit: BoxFit.fill,
      );
      if (userController.pickedImage.value != null) {
        image = Image.file(userController.pickedImage.value!, fit: BoxFit.fill);
      } else if (userController.user.value?.image?.isNotEmpty == true) {
        image = CachedNetworkImage(
          imageUrl: userController.user.value!.image!,
          progressIndicatorBuilder: (_, __, progress) =>
              CircularProgressIndicator(value: progress.progress),
          errorWidget: (_, __, ___) => const Icon(Icons.error),
          fit: BoxFit.fill,
        );
      }
      return image;
    });
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                final image =
                    await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  Get.find<UserController>().setImage(File(image.path));
                }
              },
              child: Center(
                child: ClipOval(
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: imageObx,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            // Obx(() {
            //   if (Get.find<AuthController>().authState.value ==
            //       AuthState.signedIn) {
            //     return Center(
            //       child: Text(
            //           "UID: ${Get.find<AuthController>().authUser.value!.uid}"),
            //     );
            //   }
            //   return const SizedBox.shrink();
            // }),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: userController.nameController,
                    decoration: const InputDecoration(labelText: "Nombre"),
                    validator: userController.emailValidator,
                  ),
                  TextFormField(
                    controller: userController.lastNameController,
                    decoration: const InputDecoration(labelText: "Apellido"),
                    validator: userController.emailValidator,
                  ),
                  TextFormField(
                    controller: userController.ageController,
                    decoration: const InputDecoration(labelText: "Edad"),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Obx(() {
                    final isSaving = userController.isSaving.value;
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: isSaving
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ==
                                      true) {
                                    userController.saveMyUser();
                                    //TODO: Mostrar una notificacion de que se ha guardado
                                    Get.offAllNamed(Routes.home);
                                  }
                                },
                          child: const Text("Guardar"),
                        ),
                        if (isSaving) const CircularProgressIndicator(),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
