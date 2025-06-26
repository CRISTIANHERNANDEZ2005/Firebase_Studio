// Modelo que representa un producto en el inventario
class Producto {
  final int id; // ID único del producto
  final String nombre; // Nombre del producto (ej: "Laptop")
  final double precio; // Precio de venta (ej: 999.99)
  final String descripcion; // Descripción detallada
  final String nombreCategoria; // Nombre de la categoría a la que pertenece

  // Constructor - todos los campos son obligatorios
  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.descripcion,
    required this.nombreCategoria,
  });

  // Crea un producto desde datos JSON con manejo de tipos seguros
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      // Convierte el precio a double por si viene como entero
      precio:
          (json['precio'] is int)
              ? (json['precio'] as int).toDouble()
              : json['precio'],
      // Si no viene descripción, usa cadena vacía
      descripcion: json['descripcion'] ?? '',
      // Si no viene categoría, usa cadena vacía
      nombreCategoria: json['nombre_categoria'] ?? '',
    );
  }

  // Convierte el producto a JSON para enviar al servidor
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'descripcion': descripcion,
      // Usa el formato snake_case común en APIs
      'nombre_categoria': nombreCategoria,
    };
  }
}
