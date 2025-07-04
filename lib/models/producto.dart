class Producto {
  final int id;
  final String nombre;
  final double precio;
  final String? descripcion;
  final int? categoriaId;
  final String? nombreCategoria;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    this.descripcion,
    this.categoriaId,
    this.nombreCategoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    // Manejo mejorado de categoría
    dynamic categoriaData = json['categoria'];
    int? categoriaId;
    String? nombreCategoria;

    if (categoriaData != null) {
      if (categoriaData is Map) {
        categoriaId = categoriaData['id'];
        nombreCategoria = categoriaData['nombre'] ?? '';
      } else if (categoriaData is int) {
        categoriaId = categoriaData;
      }
    }

    // También verifica campos directos por compatibilidad
    categoriaId ??= json['categoria_id'];
    nombreCategoria ??= json['nombre_categoria'] ?? '';

    return Producto(
      id: json['id'],
      nombre: json['nombre'],
      precio:
          (json['precio'] is int)
              ? (json['precio'] as int).toDouble()
              : json['precio'],
      descripcion: json['descripcion'],
      categoriaId: categoriaId,
      nombreCategoria: nombreCategoria,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
      'descripcion': descripcion,
      'categoria_id': categoriaId,
      'nombre_categoria': nombreCategoria,
    };
  }
}
