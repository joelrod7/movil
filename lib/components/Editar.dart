import 'package:flutter/material.dart';
import 'Programa.dart';
import 'Ruta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Editar extends StatefulWidget {
  const Editar({Key? key});

  @override
  State<Editar> createState() => _EditarState();
}

class _EditarState extends State<Editar> {
  TextEditingController cntNombre = TextEditingController();
  TextEditingController cntPrecio = TextEditingController();
  TextEditingController cntDesc = TextEditingController();
  TextEditingController cntCantidad = TextEditingController();
  String idUsuario = "";
  int a =0;
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


void cargarInfo(
       String nombre, String precio, String descripcion, String id, String cantidad) {
    setState(() {
      cntNombre.text = nombre;
      cntPrecio.text = precio;
      cntDesc.text = descripcion;
      cntCantidad.text = cantidad;
      idUsuario = id;
      
      
    });
  }



  @override
  Widget build(BuildContext context) {
    Map arg = ModalRoute.of(context)?.settings.arguments as Map;
    
    if (a==0) {
      cargarInfo(arg["nombre"], arg["precio"].toString(), arg["descripcion"],arg["id"].toString(), arg["cantidad"].toString());
         a=a+1;
    }
    return Scaffold(
  appBar: AppBar(
    title: const Text("Editar registro"),
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
                      child: const Text("Actualizar"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        primary: Colors.purple[200], // Color amarillo claro
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
  final Uri url = Uri.parse("${Ruta.DIR}/edtProducto.php");

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
      "id": idUsuario,
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
