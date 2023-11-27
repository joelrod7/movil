import 'package:flutter/material.dart';
import 'Programa.dart';
import 'Ruta.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class admPrograma extends StatefulWidget {
  const admPrograma({super.key});

  @override
  State<admPrograma> createState() => _admProgramaState();
}

class _admProgramaState extends State<admPrograma> {
  late Future<List<Programa>> listaProgramas;

  @override
  void initState() {
    super.initState();
    listaProgramas = getProgramas();
  }

  Future<List<Programa>> getProgramas() async {
    final respuesta = await http.get(Uri.parse("${Ruta.DIR}/lisProductos.php"));
    final items = json.decode(respuesta.body).cast<Map<String, dynamic>>();
    List<Programa> pr = items.map<Programa>((json) {
      return Programa.fromJson(json);
    }).toList();
    return pr;
  }

  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    title: const Text("Lista de productos"),
  ),
  backgroundColor: Colors.grey[200], // Fondo gris claro
  body: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Agregar producto',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Registro');
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
      Expanded(
        child: FutureBuilder<List<Programa>>(
          future: listaProgramas,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data.isEmpty) {
              return Center(
                child: Text('Sin mercancía'),
              );
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 18.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data.PRO_NOMBRE,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$ ${data.PRO_PRECIO.toString()}',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/Editar',
                                      arguments: {
                                        "nombre": data.PRO_NOMBRE,
                                        "precio": data.PRO_PRECIO,
                                        "descripcion": data.PRO_DESCRIPCION,
                                        "cantidad": data.PRO_CANTIDAD,
                                        "id": data.PRO_ID,
                                      });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  eliminarProducto(context, data.PRO_ID);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    ],
  ),
);
  }
  

  Future<void> eliminarProducto(BuildContext context, int id) async {
  final Uri url = Uri.parse("${Ruta.DIR}/eliProductos.php");
  final String apiKey = "e1f602bf73cc96f53c10bb7f7953a438fb7b3c0a"; 

  bool confirmacion = await mostrarConfirmacion(context);
  
  if (confirmacion) {
    final respuesta = await http.post(
      url,
      headers: {
        'authorization': apiKey,
      },
      body: {
        "id": id.toString(),
      },
    );

    final r = json.decode(respuesta.body);
    if (r["mensaje"] == "Se elimino un producto") {
      Navigator.pushNamed(context, '/');
      print("Producto eliminado con éxito");
    } else {
      print("Error al eliminar el producto");
    }
  } else {
    print("Eliminación cancelada");
  }
}

Future<bool> mostrarConfirmacion(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que deseas eliminar este producto?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Sí'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('No'),
          ),
        ],
      );
    },
  );
}

}

