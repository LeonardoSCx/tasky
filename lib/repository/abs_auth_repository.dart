
class AuthUser {
  final String uid;
  final String? email;
  const AuthUser(this.uid,this.email);

}

abstract class AuthRepository {

  AuthUser? get authUser;

  Stream<AuthUser?> get onAuthStateChanged;

  Future<AuthUser?> signInWithEmailAndPass(String email, String password);

  Future<AuthUser?> createUserWithEmailAndPass(String email, String password);

  Future<AuthUser?> signInWithGoogle();

  Future<AuthUser?> signInAnonymously();

  Future<void> signOut();
}