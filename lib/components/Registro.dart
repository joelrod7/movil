import 'package:flutter/material.dart';
import 'Programa.dart';
import 'Ruta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Registrar extends StatefulWidget {
  const Registrar({Key? key});

  @override
  State<Registrar> createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {
  TextEditingController cntNombre = TextEditingController();
  TextEditingController cntPrecio = TextEditingController();
  TextEditingController cntDesc = TextEditingController();
  TextEditingController cntCantidad = TextEditingController();

  int cantidad = 0;

  void _mostrarMensaje(BuildContext context, String msj) {
    Widget okBoton = TextButton(
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
        },
        child: const Text("Aceptar"));
    AlertDialog alerta = AlertDialog(
      title: const Text("Hecho"),
      content: Text(msj),
      actions: [okBoton],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alerta;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    title: const Text("Nuevo Registro"),
  ),
  body: Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white, Colors.purple.shade200],
      ),
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FractionallySizedBox(
          widthFactor: 0.5, // Ancho del rectángulo blanco: mitad de la pantalla
          heightFactor: 0.6, // Altura del rectángulo blanco: un poco más que el ancho
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: cntNombre,
                    decoration: InputDecoration(
                      labelText: "Nombres",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: cntPrecio,
                    decoration: InputDecoration(
                      labelText: "Precio",
                      prefixIcon: Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: cntDesc,
                    decoration: InputDecoration(
                      labelText: "Descripción",
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: cntCantidad,
                    decoration: InputDecoration(
                      labelText: "Cantidad",
                      prefixIcon: Icon(Icons.add_shopping_cart),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                cantidad++;
                                cntCantidad.text = cantidad.toString();
                              });
                            },
                            icon: Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (cantidad > 1) {
                                  cantidad--;
                                  cntCantidad.text = cantidad.toString();
                                }
                              });
                            },
                            icon: Icon(Icons.remove),
                          ),
                        ],
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        registrar(context);
                      },
                      child: const Text("Registrar"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        primary: Colors.purple[200],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  ),
);
  }
Future<void> registrar(context) async {
  final Uri url = Uri.parse("${Ruta.DIR}/regProducto.php");

  final String apiKey = "e1f602bf73cc96f53c10bb7f7953a438fb7b3c0a";
  String nombre = cntNombre.text;
  String descripcion = cntDesc.text;
  String precioString = cntPrecio.text;
  String cantidadString = cntCantidad.text;

  if (nombre.isEmpty || descripcion.isEmpty) {
    mostrarAlerta2("Nombre y descripción son obligatorios");
    return;
  }

  if (precioString.isEmpty || cantidadString.isEmpty) {
    mostrarAlerta2("Precio y cantidad deben ser mayores a cero");
    return;
  }

  double precio;
  try {
    precio = double.parse(precioString);
    if (precio <= 0) {
      mostrarAlerta2("El precio debe ser mayor a cero");
      return;
    }
  } catch (e) {
    mostrarAlerta2("Precio no válido");
    return;
  }

  // Validate that the quantity is a valid integer
  int cantidad;
  try {
    cantidad = int.parse(cantidadString);
    if (cantidad <= 0) {
      mostrarAlerta2("La cantidad debe ser mayor a cero");
      return;
    }
  } catch (e) {
    mostrarAlerta2("Cantidad no válida");
    return;
  }

  final respuesta = await http.post(
    url,
    headers: {
      'authorization': apiKey,
    },
    body: {
      "nombre": nombre,
      "precio": precioString,
      "descripcion": descripcion,
      "cantidad": cantidadString,
    },
  );

  final r = json.decode(respuesta.body);
  _mostrarMensaje(context, r["mensaje"]);
}


mostrarAlerta2(String mensaje) {
    Widget ok = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("Aceptar"),
    );

    AlertDialog al = AlertDialog(
      title: const Text("Error"),
      content: Text(mensaje),
      actions: [ok],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return al;
      },
    );
  }

}
