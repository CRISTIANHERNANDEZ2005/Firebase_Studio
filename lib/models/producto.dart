// Modelo para la entidad Producto
class Producto {
  final int id;
  final String nombre;
  final double precio;
  final String descripcion;
  final String nombreCategoria;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.descripcion,
    required this.nombreCategoria,
  });

  // Crea un producto desde JSON
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      precio:
          (json['precio'] is int)
              ? (json['precio'] as int).toDouble()
              : json['precio'],
      descripcion: json['descripcion'] ?? '',
      nombreCategoria: json['nombre_categoria'] ?? '',
    );
  }

  // Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'descripcion': descripcion,
      'nombre_categoria': nombreCategoria,
    };
  }
}
