
class CustomUser {
  final String id;
  final String name;
  final String lastName;
  final int age;

  // Caracteristicas opcionales
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

  // Cargar los datos del usuario
  CustomUser.fromFirebaseMap(Map<String, dynamic> data)
      : id = data['id'] as String,
        name = data['name'] as String,
        lastName = data['lastName'] as String,
        age = data['age'] as int,
        image = data['image'] as String?;


}
