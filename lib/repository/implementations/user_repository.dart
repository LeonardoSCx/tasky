import 'dart:io';

import 'package:tasky/models/user.dart';
import 'package:tasky/providers/firebase_provider.dart';
import 'package:tasky/repository/abs_user_repository.dart';

/// Clase que nos permite obtener el usuario actual y guardar los datos.
class UserRepositoryImp extends  UserRepository{

  final provider = FirebaseProvider();

  @override
  Future<CustomUser?> getMyUser() => provider.getMyUser();

  @override
  Future<void> saveMyUser(CustomUser user, File? image) => provider.saveUser(user, image);
  
}