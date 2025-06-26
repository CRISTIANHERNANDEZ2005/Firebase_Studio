// Modelo que representa un usuario en el sistema
class Usuario {
  final int id; // ID único del usuario
  final String numero; // Número identificador (podría ser documento)
  final String nombre; // Primer nombre del usuario
  final String apellido; // Apellido del usuario

  // Constructor - todos los campos son obligatorios
  Usuario({
    required this.id,
    required this.numero,
    required this.nombre,
    required this.apellido,
  });

  // Crea un usuario desde datos JSON (como los que vienen de una API)
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      numero: json['numero'],
      nombre: json['nombre'],
      apellido: json['apellido'],
    );
  }

  // Convierte el usuario a formato JSON para enviar al servidor
  Map<String, dynamic> toJson() {
    return {'id': id, 'numero': numero, 'nombre': nombre, 'apellido': apellido};
  }
}
