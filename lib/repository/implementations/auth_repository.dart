import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../abs_auth_repository.dart';

class AuthRepositoryImp extends AuthRepository{
  final _firebaseAuth = FirebaseAuth.instance;

  AuthUser? _userFromFirebase(User? user) => user == null ? null: AuthUser(user.uid, user.email);

  /// Convierte la clase user de firebase a la nuestra (CustomUser)
  @override
  AuthUser? get authUser => _userFromFirebase(_firebaseAuth.currentUser);

  /// Listener de los cambios de autenticacion.
  @override
  Stream<AuthUser?> get onAuthStateChanged => _firebaseAuth.authStateChanges().asyncMap(_userFromFirebase);

  /// Metodo que crea un usuario en Firebase Authentication y devuelve un usuario
  @override
  Future<AuthUser?> createUserWithEmailAndPass(String email, String password) async{
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  /// Metodo para autenticarse con usuario y contraseña. Devuelve un usuario
  @override
  Future<AuthUser?> signInWithEmailAndPass(String email, String password) async{
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  /// Metodo para iniciar sesion con Google. Devuelve un usuario
  @override
  Future<AuthUser?> signInWithGoogle() async{
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final authResult = await _firebaseAuth.signInWithCredential(credential);
    return _userFromFirebase(authResult.user);
  }

  /// Metodo para iniciar sesion anonimamente. Devuelve un usuario
  @override
  Future<AuthUser?> signInAnonymously() async{
    final user = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(user.user);
  }

  /// Metodo para cerrar sesion.
  @override
  Future<void> signOut() async{
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
  
}