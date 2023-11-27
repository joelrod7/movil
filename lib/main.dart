import 'package:flutter/material.dart';
import 'components/Principal.dart';
import 'components/Registro.dart';
import 'components/Editar.dart';
import 'components/LoginScreen.dart';
import 'components/SignupScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
         '/login': (context) => LoginScreen(),
         '/signup': (context) => SignUpScreen(),
        '/': (context) => admPrograma(),
        '/Registro': (context) => Registrar(),
         '/Editar':(context) => Editar(),
      },
    );
  }
}
