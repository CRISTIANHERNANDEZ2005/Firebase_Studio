// Modelo que representa una categoría en la aplicación
class Categoria {
  final int id; // Identificador único de la categoría
  final String nombre; // Nombre de la categoría (ej: "Electrónicos")

  // Constructor - requiere id y nombre
  Categoria({required this.id, required this.nombre});

  // Método para crear una categoría desde datos JSON (que vienen del servidor)
  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'], // Extrae el id del JSON
      nombre: json['nombre'], // Extrae el nombre del JSON
    );
  }

  // Método para convertir la categoría a JSON (para enviar al servidor)
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Convierte id a JSON
      'nombre': nombre, // Convierte nombre a JSON
    };
  }
}
