import 'dart:async';

import 'package:get/get.dart';
import 'package:tasky/Routes/app_routes.dart';
import 'package:tasky/repository/auth_repository.dart';

enum AuthState {
  signedOut,
  signedIn,
}
// Manejamos los eventos relacionados con el registro / inicio de sesion
class AuthController extends GetxController {
  final _authRepository = Get.find<AuthRepository>();

  // Registramos el Stream del estado de autenticacacion de la clase abstracta AuthRepository
  late StreamSubscription _authSubscription;

  // Variable que guardará el estado del enum
  final Rx<AuthState> authState = Rx(AuthState.signedOut);
  final Rx<AuthUser?> authUser = Rx(null);

  void _authStateChanged(AuthUser? user) {
    if (user == null) {
      authState.value = AuthState.signedOut;
      // TODO: Navegar a la pagina registro
      Get.offAllNamed(Routes.intro);
    }else{
      authState.value = AuthState.signedIn;
      // TODO: Navegar a la home
      Get.offAllNamed(Routes.home);
    }
    authUser.value = user;
  }

  @override
  void onInit() async{
    await Future.delayed(const Duration(seconds: 3));
    _authSubscription = _authRepository.onAuthStateChanged.listen(_authStateChanged);
    super.onInit();
  }

  Future<void> signOut() async{
    await _authRepository.signOut();
  }

  @override
  void onClose() {
    _authSubscription.cancel();
    super.onClose();
  }
}
