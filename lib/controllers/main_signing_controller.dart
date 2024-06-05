import 'dart:developer';

import 'package:get/get.dart';
import 'package:tasky/repository/abs_auth_repository.dart';

/// Controlador que se encarga del inicio de sesion mediante una cuenta de Google
/// o el inicio de sesion anonimo.
class MainSignInController extends GetxController {
  final _authRepository = Get.find<AuthRepository>();

  final error = Rx<String?>(null);
  final isLoading = RxBool(false);

  Future<void> signInAnonymously() => _signIn(_authRepository.signInAnonymously);
  Future<void> signInWithGoogle() => _signIn(_authRepository.signInWithGoogle);

  Future<void> _signIn(Future<AuthUser?> Function() auxUser) async {
    try {
      isLoading.value = true;
      error.value = null;
      await auxUser();
    } catch (e) {
      log("Error:" + e.toString());
      error.value = e.toString();
    }
    isLoading.value = false;
  }
}