class Programa {
  final int PRO_ID;
  final double PRO_PRECIO;
  final String PRO_NOMBRE;
  final String PRO_DESCRIPCION;

  Programa(
      {required this.PRO_ID,
      required this.PRO_NOMBRE,
      required this.PRO_PRECIO,
      required this.PRO_DESCRIPCION});

  factory Programa.fromJson(Map<String, dynamic> json) {
    return Programa(
      PRO_ID: json["PRO_ID"],
      PRO_NOMBRE: json["PRO_NOMBRE"],
      PRO_PRECIO: json["PRO_PRECIO"],
      PRO_DESCRIPCION: json["PRO_DESCRIPCION"],
    );
  }
}
