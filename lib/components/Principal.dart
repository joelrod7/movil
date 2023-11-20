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
        title: const Text("Lista Productos"),
      ),
      body: FutureBuilder<List<Programa>>(
          future: listaProgramas,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            return ListView.builder(
  itemCount: snapshot.data.length,
  itemBuilder: (context, index) {
    var data = snapshot.data[index];
    return Card(
      child: ListTile(
        leading: const Icon(Icons.account_tree_rounded),
        title: Text(data.PRO_NOMBRE),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, '/Editar',
                                    arguments: {
                                      "nombre": data.PRO_NOMBRE,
                                      "precio": data.PRO_PRECIO,
                                      "descripcion": data.PRO_DESCRIPCION,
                                      "id": data.PRO_ID,
                                    });
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                eliminarProducto(data.PRO_ID);
              },
            ),
          ],
        ),
      ),
    );
  },
);

          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/Registro');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  

  Future<void> eliminarProducto(int id) async {
  final Uri url = Uri.parse("${Ruta.DIR}/eliProductos.php");
  final String apiKey = "e1f602bf73cc96f53c10bb7f7953a438fb7b3c0a"; 
  
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
    // Hubo un error al eliminar el producto, puedes mostrar un mensaje de error.
    print("Error al eliminar el producto");
  }
}

}

