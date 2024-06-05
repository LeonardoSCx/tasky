import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';


enum PriorityTask { bajo, medio, alto, critico }

/// Modelo de las tareas
class UserTask implements Comparable<UserTask>{
  late String uid;
  late String titulo;
  late String contenido;
  late DateTime fechaCreacion;
  late DateTime fechaFin;
  late bool completado;
  late Enum prioridad;

  /// Constructor principal de la clase
  UserTask({
    required this.uid,
    required this.titulo,
    required this.contenido,
    required this.completado,
    required this.fechaCreacion,
    required this.fechaFin,
    required this.prioridad,
  });

  /// Metodo que transforma los datos de la clase a formato mapa, aceptado por
  /// Firestore Database
  Map<String, dynamic> toFirestore() {
    return {
      'titulo': titulo,
      'contenido': contenido,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'fechaFin': Timestamp.fromDate(fechaFin),
      'completado': completado,
      'prioridad': prioridad.name
    };
  }

  /// Meotodo que recoge las tareas dado el identificador unico de un usuario
  factory UserTask.fromFirebaseMap(String taskId, Map<String, dynamic> data) {
    return UserTask(
      uid: taskId,
      titulo: data['titulo'] as String,
      contenido: data['contenido'] as String,
      fechaCreacion: (data['fechaCreacion'] as Timestamp).toDate(),
      fechaFin: (data['fechaFin'] as Timestamp).toDate() ,
      completado: data['completado'] as bool,
      prioridad: PriorityTask.values.firstWhere((e) => e.name == data['prioridad'])
    );
  }

  /// Metodo que devuelve un mapa con las tareas agrupadas por el nivel de prioridad
  static Map groupItemsByCategory(List<UserTask> items) {
    return groupBy(items, (item) => item.prioridad.name);
  }

  @override
  String toString() {
    return 'UserTask{uid: $uid, titulo: $titulo, contenido: $contenido, fechaCreacion: $fechaCreacion, completado: $completado}';
  }

  @override
  int compareTo(UserTask other) {
    if (prioridad.index < other.prioridad.index) {
      return 1;
    } else if (prioridad.index == other.prioridad.index) {
      return 0;
    } else {
      return -1;
    }
  }
}
