import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasky/models/user_task.dart';
import 'package:tasky/repository/abs_crud_repository.dart';

/// Clase que implementa los metodos de la clase CrudRepository
/// Permite realizar operaciones CRUD
class CrudRepositoryImp extends CrudRepository {

  @override
  Future<void> addTask(UserTask tarea, String uid) async {
    await provider.firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .add(tarea.toFirestore());
  }

  @override
  Future<void> updateStatus(
      bool completado, String documentId, String uid) async {
    provider.firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(documentId)
        .update({'completado': completado});
  }

  @override
  Future<void> updateTask(UserTask tarea, String documentId, String uid) async {
    provider.firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(documentId)
        .update(tarea.toFirestore());
  }

  @override
  Future<void> deleteTask(String documentId, String uid) async {
    provider.firestore
        .collection('users')
        .doc(provider.currentUser.uid)
        .collection('tasks')
        .doc(documentId)
        .delete();
  }

  @override
  Stream<List<UserTask>> todoStream(String uid) {
    return provider.firestore
        .collection("users")
        .doc(uid)
        .collection("tasks")
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) {
      return snapshot.docs.map((doc) {
        final taskId = doc.id;
        final taskData = doc.data();
        return UserTask.fromFirebaseMap(taskId, taskData);
      }).toList();
    });
  }
}
