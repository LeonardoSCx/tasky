import 'package:cloud_firestore/cloud_firestore.dart';

class UserTask {
  late String uid;
  late String titulo;
  late String contenido;
  late DateTime fechaCreacion;
  late DateTime fechaFin;
  late bool completado;

  UserTask({
    required this.uid,
    required this.titulo,
    required this.contenido,
    required this.completado,
    required this.fechaCreacion,
    required this.fechaFin,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'titulo': titulo,
      'contenido': contenido,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'fechaFin': Timestamp.fromDate(fechaFin),
      'completado': completado
    };
  }

  factory UserTask.fromFirebaseMap(String taskId, Map<String, dynamic> data) {
    return UserTask(
      uid: taskId,
      titulo: data['titulo'] as String,
      contenido: data['contenido'] as String,
      fechaCreacion: (data['fechaCreacion'] as Timestamp).toDate(),
      fechaFin: (data['fechaFin'] as Timestamp).toDate() ,
      completado: data['completado'] as bool,
    );
  }

  @override
  String toString() {
    return 'UserTask{uid: $uid, titulo: $titulo, contenido: $contenido, fechaCreacion: $fechaCreacion, completado: $completado}';
  }
}
