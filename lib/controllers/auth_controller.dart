import 'dart:async';
import 'package:get/get.dart';
import 'package:tasky/Routes/app_routes.dart';
import 'package:tasky/repository/abs_auth_repository.dart';
import '../providers/firebase_provider.dart';

enum AuthState {
  signedOut,
  signedIn,
}

/// Manejamos los eventos relacionados con el registro / inicio de sesion
class AuthController extends GetxController {
  final _authRepository = Get.find<AuthRepository>();
  final provider = FirebaseProvider();

  /// Registramos el Stream del estado de autenticacacion de la clase abstracta AuthRepository
  late StreamSubscription _authSubscription;

  /// Variable que guardará el estado del enum
  final Rx<AuthState> authState = Rx(AuthState.signedOut);
  /// Variable que guardará los datos del usuario actual
  final Rx<AuthUser?> authUser = Rx(null);

  /// Si no se ha iniciado sesion en este dispositivo mostrará la pantalla
  /// de registro y sino la pagina principal.
  /// Si el usuario que se ha autenticado, es nuevo lo llevará a la pantalla
  /// de perfil para guardar sus datos.
  void _authStateChanged(AuthUser? user) async {
    if (user == null) {
      authState.value = AuthState.signedOut;
      Get.offAllNamed(Routes.intro);
    } else {
      authState.value = AuthState.signedIn;
      if (await provider.getUser()) {
        Get.offAllNamed(Routes.home);
      } else {
        Get.offAllNamed(Routes.profile);
      }
    }
    authUser.value = user;
  }

  /// Aseguramos que el listener escuche los cambios de estado referentes
  /// a la autenticacion cuando se instancia.
  @override
  void onInit() async {
    await Future.delayed(const Duration(seconds: 3));
    _authSubscription =
        _authRepository.onAuthStateChanged.listen(_authStateChanged);
    super.onInit();
  }

  /// Metodo de cerrar sesión
  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  /// Deja de escuchar cuando se cierra una instancia.
  @override
  void onClose() {
    _authSubscription.cancel();
    super.onClose();
  }
}
