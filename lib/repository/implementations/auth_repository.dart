import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../abs_auth_repository.dart';

class AuthRepositoryImp extends AuthRepository{
  final _firebaseAuth = FirebaseAuth.instance;

  AuthUser? _userFromFirebase(User? user) => user == null ? null: AuthUser(user.uid, user.email);

  @override
  // Convierte la clase user de firebase a la nuestra
  AuthUser? get authUser => _userFromFirebase(_firebaseAuth.currentUser);

  @override
  Stream<AuthUser?> get onAuthStateChanged => _firebaseAuth.authStateChanges().asyncMap(_userFromFirebase);

  // Devuelve el usuario creado, sino devolverá null
  @override
  Future<AuthUser?> createUserWithEmailAndPass(String email, String password) async{
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<AuthUser?> signInWithEmailAndPass(String email, String password) async{
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }


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

  @override
  Future<AuthUser?> signInAnonymously() async{
    final user = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(user.user);
  }

  @override
  Future<void> signOut() async{
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
  
}