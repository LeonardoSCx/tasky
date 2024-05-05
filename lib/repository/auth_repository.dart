import 'package:equatable/equatable.dart';

class AuthUser extends Equatable{

  final String uid;
  const AuthUser(this.uid);

  @override
  List<Object?> get props => [uid];

}

abstract class AuthRepository{
  AuthUser? get authUser;

  Stream<AuthUser?> get onAuthStateChanged;

  Future<AuthUser?> signInWithEmailAndPass(String email, String password);

  Future<AuthUser?> createUserWithEmailAndPass(String email, String password);

  Future<AuthUser?> signInWithGoogle();

  Future<AuthUser?> signInAnonymoysly();

  Future<void> signOut();
}