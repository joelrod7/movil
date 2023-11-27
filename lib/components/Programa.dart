class Programa {
  final int PRO_ID;
  final double PRO_PRECIO;
  final String PRO_NOMBRE;
  final String PRO_DESCRIPCION;
  final int PRO_CANTIDAD;

  Programa(
      {required this.PRO_ID,
      required this.PRO_NOMBRE,
      required this.PRO_PRECIO,
      required this.PRO_DESCRIPCION,
      required this.PRO_CANTIDAD});

  factory Programa.fromJson(Map<String, dynamic> json) {
    return Programa(
      PRO_ID: int.parse(json['PRO_ID']),
      PRO_NOMBRE: json['PRO_NOMBRE'] as String,
      PRO_PRECIO: double.parse(json['PRO_PRECIO']),
      PRO_DESCRIPCION: json['PRO_DESCRIPCION'] as String,
      PRO_CANTIDAD: int.parse(json['PRO_CANTIDAD']),
    );
  }
}
