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




  void _mostrarMensaje(BuildContext context, String msj) {
    Widget okBoton = TextButton(
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil("/", (route) => false);
        },
        child: const Text("Aceptar"));
    AlertDialog alerta = AlertDialog(
      title: const Text("Notificación"),
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
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [Color(0xFF63B8FF), Color(0xFF3A7BD5)],
            // ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   colors: [Colors.purple, Colors.indigo],
                    // ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage('images/brazo.png'),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '¡Registra tu información!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
                    
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10), // Margen inferior para "Nombres"
                      child: TextFormField(
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
                    ),
                    
                    Container(
                      margin: const EdgeInsets.only(bottom: 10), // Margen inferior para "Precio"
                      child: TextFormField(
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
                    ),

                    Container(
                      margin: const EdgeInsets.only(bottom: 10), // Margen inferior para "Descripción"
                      child: TextFormField(
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
                    ),
                    
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        registrar(context);
                      },
                      child: const Text("Registrar"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
      double precio = double.parse(cntPrecio.text);
  if (precio<=0) {
    mostrarAlerta2();
  }else{
    final respuesta = await http.post(
    url,
    headers: {
      'authorization': apiKey, 
    },
    body: {
      "nombre": cntNombre.text,
      "precio": cntPrecio.text,
      "descripcion": cntDesc.text,
    },
  );

  final r = json.decode(respuesta.body);
  _mostrarMensaje(context, r["mensaje"]);

  }


  
}


mostrarAlerta2() {
    Widget ok = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("Aceptar"),
    );

    AlertDialog al = AlertDialog(
      title: const Text("Error"),
      content: const Text("El precio debe ser un número mayor que 0"),
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
