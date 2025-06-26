// Modelo para la entidad Usuario
class Usuario {
  final int id;
  final String numero;
  final String nombre;
  final String apellido;

  Usuario({
    required this.id,
    required this.numero,
    required this.nombre,
    required this.apellido,
  });

  // Crea un usuario desde JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      numero: json['numero'],
      nombre: json['nombre'],
      apellido: json['apellido'],
    );
  }

  // Convierte a JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'numero': numero, 'nombre': nombre, 'apellido': apellido};
  }
}
