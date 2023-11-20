import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Ruta.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController cntNombre = TextEditingController();
  TextEditingController cntApellido = TextEditingController();
  TextEditingController cntCorreo = TextEditingController();
  TextEditingController cntPass = TextEditingController();


  void _mostrarMensaje(BuildContext context, String msj) {
    Widget okBoton = TextButton(
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
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
        title: Text('Sign Up'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Container(
              // ),
                    
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
                        controller: cntApellido,
                        decoration: InputDecoration(
                          labelText: "Apellido",
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
                      margin: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: cntCorreo,
                        decoration: InputDecoration(
                          labelText: "E-mail",
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
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        controller: cntPass,
                        decoration: InputDecoration(
                          labelText: "Password",
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
  final Uri url = Uri.parse("${Ruta.DIR}/regUsuario.php");
  print("buenas");

  final String apiKey = "e1f602bf73cc96f53c10bb7f7953a438fb7b3c0a";
  String nombre = cntNombre.text;
  String apellido = cntApellido.text;
  String correo = cntCorreo.text;
  String password = cntPass.text;
  
  final respuesta = await http.post(
    url,
    headers: {
      'authorization': apiKey, 
    },
    body: {
      "nombre": cntNombre.text,
      "apellido": cntApellido.text,
      "correo": cntCorreo.text,
      "password":cntPass.text
    },
  );
  final r = json.decode(respuesta.body);
  
      _mostrarMensaje(context, r["mensaje"]);
 
  //
  
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
      content: const Text("Campos no vacios"),
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
