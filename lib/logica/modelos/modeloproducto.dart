import 'dart:convert';

class Producto {
  int? idMarca;
  int? idCategoria;
  String nombre;
  String proveedor;
  String contenido;
  int medida;
  int presentacion;
  int lineaProducto;
  int precioCompra;
  bool activo;
  int? sysId;

  Producto({
    this.idMarca,
    this.idCategoria,
    required this.nombre,
    required this.proveedor,
    required this.contenido,
    required this.medida,
    required this.presentacion,
    required this.lineaProducto,
    required this.precioCompra,
    required this.activo,
    this.sysId,
  });

  // Método para convertir de JSON a Producto
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idMarca: json['id_marca'],
      idCategoria: json['id_categoria'],
      nombre: json['nombre'],
      proveedor: json['proveedor'],
      contenido: json['contenido'],
      medida: json['medida'],
      presentacion: json['presentacion'],
      lineaProducto: json['linea_producto'],
      precioCompra: json['precio_compra'],
      activo: json['activo'],
      sysId: json['sys_id'],
    );
  }

  // Método para convertir de Producto a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_marca': idMarca,
      'id_categoria': idCategoria,
      'nombre': nombre,
      'proveedor': proveedor,
      'contenido': contenido,
      'medida': medida,
      'presentacion': presentacion,
      'linea_producto': lineaProducto,
      'precio_compra': precioCompra,
      'activo': activo,
      'sys_id': sysId,
    };
  }

  // Método para convertir de JSON a una lista de productos
  static List<Producto> fromJsonList(String jsonString) {
    final data = jsonDecode(jsonString) as List;
    return data.map((item) => Producto.fromJson(item)).toList();
  }

  // Método para convertir una lista de productos a JSON
  static String toJsonList(List<Producto> productos) {
    final data = productos.map((item) => item.toJson()).toList();
    return jsonEncode(data);
  }
}
