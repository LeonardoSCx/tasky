import 'dart:io';

import 'package:tasky/models/user.dart';


abstract class UserRepository {
  Future<CustomUser?> getMyUser();

  Future<void> saveMyUser(CustomUser user, File? image);
}