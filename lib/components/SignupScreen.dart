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

   bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.white, Colors.purple.shade200],
          ),
        ),
      ),
      Center(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blueAccent, Colors.lightBlueAccent],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [Colors.white, Colors.purple.shade200],
                            radius: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: cntNombre,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: EdgeInsets.all(12.0),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          controller: cntApellido,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Apellido',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: EdgeInsets.all(12.0),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          controller: cntCorreo,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: EdgeInsets.all(12.0),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          controller: cntPass,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            contentPadding: EdgeInsets.all(12.0),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          obscureText: !_isPasswordVisible,
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            registrar(context);
                          },
                          child: Text('Sign Up'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green.shade200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
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
      "email": cntCorreo.text,
      "u_password":cntPass.text
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
