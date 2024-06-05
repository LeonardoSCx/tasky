import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:tasky/models/user.dart';
import 'dart:developer';


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
    try{
      final snapshot = await firestore.doc('users/${currentUser.uid}').get();
      // '!' -> Indicamos que no va a ser nulo (null safety)
      if(snapshot.exists) return CustomUser.fromFirebaseMap(snapshot.data()!);
      return null;
    }catch(e){
      log(e.toString());
    }
    return null;
  }

  Future<bool> getUser() async{
    final docRef = firestore.collection("users").doc(currentUser.uid);
    bool isRegistered = false;

    try{
      DocumentSnapshot doc = await docRef.get();
      if(doc.exists){
        isRegistered = true;
      }else{
        isRegistered = false;
      }
    }catch(e){
      isRegistered = false;
    }
    return isRegistered;
  }

  /// Metodo que nos permite guardar los datos del usuario y la imagen pasada
  /// tanto en Firestore Databes como en FireStorage
  Future<void> saveUser(CustomUser user, File? image) async{
    final ref = firestore.doc('users/${currentUser.uid}');
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