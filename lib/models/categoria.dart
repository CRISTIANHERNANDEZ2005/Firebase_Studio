// Modelo para la entidad Categoría
class Categoria {
  final int id;
  final String nombre;

  Categoria({
    required this.id,
    required this.nombre,
  });

  // Crea una categoría desde JSON
  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nombre: json['nombre'],
    );
  }

  // Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
}