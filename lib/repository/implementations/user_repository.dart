import 'dart:io';

import 'package:tasky/models/user.dart';
import 'package:tasky/providers/firebase_provider.dart';
import 'package:tasky/repository/abs_user_repository.dart';



class UserRepositoryImp extends  UserRepository{

  final provider = FirebaseProvider();

  @override
  Future<CustomUser?> getMyUser() => provider.getMyUser();

  @override
  Future<void> saveMyUser(CustomUser user, File? image) => provider.saveUser(user, image);
  
}