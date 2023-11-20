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

  Future<void> _login() async {
  final Uri url = Uri.parse("${Ruta.DIR}/login.php");
  final String apiKey = "e1f602bf73cc96f53c10bb7f7953a438fb7b3c0a";
 
  String correo = cntCorreo.text;
  String password = cntPass.text;
  
  
    final respuesta = await http.post(
      url,
      headers: {
        'authorization': apiKey,
      },
      body: {
        "correo": correo,
        "password": password,
      },
    );
    final r = json.decode(respuesta.body);
  
      
    if (respuesta.statusCode == 200) {
     Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
      
    
    
  } else{
    _mostrarMensaje(context, r["mensaje"]);
  }
    
    

}
  


  void _goToSignUp() {
    Navigator.pushNamed(context, '/signup');
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: cntCorreo,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            TextField(
              controller: cntPass,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Log In'),
                ),
                ElevatedButton(
                  onPressed: _goToSignUp,
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  
}

