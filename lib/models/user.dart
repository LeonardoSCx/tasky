/// Modelo del Usuario
class CustomUser {
  final String id;
  final String name;
  final String lastName;
  final int age;

  /// Propiedades opcionales de la clase que pueden no estar presentes
  final String? image;

  CustomUser(this.id, this.name, this.lastName, this.age,
      {this.image});

  Map<String, Object?> toFirebaseMap({String? newImage}) {
    return {
      'id': id,
      'name': name,
      'lastName': lastName,
      'age': age,
      'image': newImage ?? image,
    };
  }

  /// Carga los datos de la coleccion de firebase y lo transforma en un objeto
  /// de tipo CustomUser.
  CustomUser.fromFirebaseMap(Map<String, dynamic> data)
      : id = data['id'] as String,
        name = data['name'] as String,
        lastName = data['lastName'] as String,
        age = data['age'] as int,
        image = data['image'] as String?;


}
