import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user.dart';
import 'package:path/path.dart' as path;


class FirebaseProvider{
  User get currentUser{
    final user = FirebaseAuth.instance.currentUser;
    if(user == null){
      throw Exception("No has iniciado sesion");
    }
    return user;
  }

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  FirebaseStorage get storage => FirebaseStorage.instance;

  // Leemos si el usuario está registrado
  Future<CustomUser?> getMyUser() async{
    final snapshot = await firestore.doc('user/${currentUser.uid}').get();
    // '!' -> Indicamos que no va a ser nulo (null safety)
    if(snapshot.exists) return CustomUser.fromFirebaseMap(snapshot.data()!);
    return null;
  }

  // Guardamos usuario
  Future<void> saveUser(CustomUser user, File? image) async{
    // ruta donde guardaremos el usuario
    final ref = firestore.doc('user/${currentUser.uid}');

    if(image != null){
      final imagePath = '${currentUser.uid}/profile/${path.basename(image.path)}';
      final storageRef = storage.ref(imagePath);
      await storageRef.putFile(image);
      final url = await storageRef.getDownloadURL();
      await ref.set(user.toFirebaseMap(newImage: url), SetOptions(merge: true));
    }else{
      await ref.set(user.toFirebaseMap(),SetOptions(merge: true));
    }
  }
}