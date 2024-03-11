import 'package:flutter/material.dart';
import 'package:formularios/bd.dart'; // Asegúrate de importar correctamente tu archivo bd.dart

class VerUsuarios extends StatelessWidget {
  static const routeName = '/verUsuarios';

  const VerUsuarios({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Usuario> usuarios =
        ModalRoute.of(context)!.settings.arguments as List<Usuario>;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Admin: Lista de Usuarios',
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.purple,
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/images/home-bg.jpg"), // Asegúrate de tener esta imagen en tu carpeta de assets
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 80.0), // Espacio para el botón
              child: ListView.builder(
                itemCount: usuarios.length,
                itemBuilder: (context, index) {
                  final usuario = usuarios[index];
                  return Card(
                    child: ListTile(
                      title: Text('${usuario.nombres} ${usuario.apellidos}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${usuario.email}'),
                          Text('DNI: ${usuario.dni}'),
                          Text('Teléfono: ${usuario.telefono}'),
                          Text('Usuario: ${usuario.usuario}'),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                backgroundColor: Colors.purple,
                child: const Icon(Icons.home, color: Colors.white,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
