import 'package:flutter/material.dart';
import 'home.dart';
import 'registro.dart';
import 'tienda.dart';
import 'verUsuarios.dart';

void main() {
  runApp(MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: '/', routes: {
      '/': (context) => Home(),
      Tienda.routeName: (context) => Tienda(),
      Registro.routeName: (context) => Registro(),
      VerUsuarios.routeName: (context)=> VerUsuarios()
    });
  }
}
