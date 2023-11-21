import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Ruta.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController cntCorreo = TextEditingController();
  TextEditingController cntPass = TextEditingController();


void _mostrarMensaje(BuildContext context, String msj) {
    Widget okBoton = TextButton(
        onPressed: () {
          Navigator.pop(context);
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


  void _goToSignUp() {
    Navigator.pushNamed(context, '/signup');
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
                colors: [Colors.pinkAccent, Colors.blueAccent],
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: 50.0),
              Text(
                'SHOPe',
                style: TextStyle(fontSize: 24.0, color: Colors.white),
              ),
              Expanded(
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.5, // Ancho del rectángulo (50% del ancho de la pantalla)
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.black, Colors.grey],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              gradient: RadialGradient(
                                colors: [Colors.white, Colors.grey],
                                radius: 0.8,
                              ),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          TextField(
                            controller: cntCorreo,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'E-mail',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.all(12.0),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextField(
                            controller: cntPass,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(),
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
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            obscureText: !_isPasswordVisible,
                          ),
                          SizedBox(height: 24.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _login();
                                },
                                child: Text('Log In'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _goToSignUp();
                                  },
                                child: Text('Sign Up'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

  }

Future _login() async {
     final Uri url = Uri.parse("${Ruta.DIR}/login.php");
    final String apiKey = "e1f602bf73cc96f53c10bb7f7953a438fb7b3c0a";
  
  print(cntCorreo.text);
  print(cntPass.text);
  final response = await http.post(
    url,
    headers: {
      'authorization': apiKey, 
    },
    body: {
      "email": cntCorreo.text,
      "u_password":cntPass.text
    },
  );

 
    final r = json.decode(response.body);
if (r["mensaje"] is int) {
  int mensaje = r["mensaje"];
  _mostrarMensaje(context, mensaje.toString());
} else {
  _mostrarMensaje(context, r["mensaje"]);
}

    
  }
  
}

