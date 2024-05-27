import 'package:tasky/models/user_task.dart';
import 'package:tasky/providers/firebase_provider.dart';

abstract class CrudRepository {
  final provider = FirebaseProvider();

  Future<void> addTask(UserTask tarea, String uid);
  Future<void> updateStatus(bool completado, String documentId, String uid);
  Future<void> updateTask(UserTask tarea, String documentId, String uid);
  Future<void> deleteTask(String documentId, String uid);
  Stream<List<UserTask>> todoStream(String uid);
}