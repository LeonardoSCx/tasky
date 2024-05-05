import 'package:equatable/equatable.dart';

class CustomUser extends Equatable{
  final String id;
  final String name;
  final String lastName;
  final int age;

  // Caracteristicas opcionales
  final String? image;

  const CustomUser(this.id, this.name, this.lastName, this.age, {this.image});

  Map<String, Object?> toFirebaseMap({String? newImage}) {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'age': age,
      // Si la imagen que me pasa es nula, usa la que tenia por defecto
      'image': newImage ?? image,
    };
  }

  // Cargar los datos del usuario
  CustomUser.fromFirebaseMap(Map<String, dynamic> data)
      : id = data['id'] as String,
        name = data['name'] as String,
        lastName = data['lastName'] as String,
        age = data['age'] as int,
        image = data['image'] as String?;

  // Si 2 objetos con el mismo id que no coinciden los mismos parametros
  // puede ser util para la sincronizacion de datos.
  // Caso de uso: El usuario hace cambios en local pero no se actualiza en la
  // bd porque no tiene conexion
  @override
  List<Object?> get props => [id,name,lastName,age,image];
}
