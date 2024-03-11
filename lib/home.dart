import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'registro.dart';
import 'package:formularios/verusuarios.dart';
import 'package:formularios/bd.dart';
import 'package:formularios/tienda.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String email = "";
  String password = "";
  String mensajeError = "";
  String mensajeError2 = "";
  String user = "";
  String name = "";
  String lastname = "";
  String dni = "";
  String telephone = "";
  List<Usuario> usuarios = [
    Usuario(
        usuario: "admin",
        nombres: "admin",
        apellidos: "admin",
        dni: "admin",
        telefono: "admin",
        email: "admin",
        password: "admin123"),
    Usuario(
        usuario: "test",
        nombres: "test",
        apellidos: "test",
        dni: "test",
        telefono: "test",
        email: "test@gmail.com",
        password: "test123")
  ];

  void mostrarDialogo2(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error de inicio de sesión'),
          content: const Text("Por favor ingrese bien sus datos"),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void limpiar() {
    setState(() {
      _emailController.clear(); // Limpia el campo de email
      _passwordController.clear();
      email = "";
      password = ""; // Limpia el campo de contraseña
    });
  }

  @override
  Widget build(BuildContext context) {
    final argumentos = ModalRoute.of(context)?.settings.arguments;
    if (argumentos is List<Usuario>) {
      usuarios = argumentos;
    }
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 60),
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: AppBar(
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.computer,
                    color: Colors.white,
                    size: 50,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'MeraTech',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 50),
                  ),
                ],
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/home-bg.jpg"),
                      fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: SizedBox(
                        width: 350,
                        height: 350,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'E-mail',
                                  prefixIcon:
                                      Icon(FontAwesomeIcons.envelope, size: 20),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                    mensajeError = "";
                                  });
                                },
                              ),
                              Text(
                                mensajeError,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextField(
                                obscureText: true,
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                  labelText: 'Contraseña',
                                  prefixIcon:
                                      Icon(FontAwesomeIcons.lock, size: 20),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                    mensajeError2 = "";
                                  });
                                },
                              ),
                              Text(
                                mensajeError2,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                ),
                                child: const Text(
                                  "¿Olvidaste la contraseña?",
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          bool usuarioEncontrado = false;
                                          String patron =
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                                          if (!RegExp(patron).hasMatch(email)) {
                                            mensajeError =
                                                'Por favor ingrese un correo electrónico válido';
                                          }

                                          if (email.isEmpty) {
                                            mensajeError =
                                                'Por favor ingrese un correo electrónico';
                                          }

                                          if (password.isEmpty) {
                                            mensajeError2 =
                                                "Por favor ingrese su contraseña";
                                          }
                                          if (email == "admin@hotmail.com" &&
                                              password == "admin123") {
                                                limpiar();
                                            Navigator.pushNamed(
                                                context, VerUsuarios.routeName,
                                                arguments: usuarios);
                                          } else {
                                            for (Usuario usuario in usuarios) {
                                              if (usuario.email == email &&
                                                  usuario.password ==
                                                      password) {
                                                usuarioEncontrado = true;
                                                user = usuario.usuario;
                                                name = usuario.nombres;
                                                lastname = usuario.apellidos;
                                                dni = usuario.dni;
                                                telephone = usuario.telefono;
                                                break;
                                              }
                                            }

                                            if (usuarioEncontrado) {
                                              limpiar();
                                              Navigator.pushNamed(
                                                  context, Tienda.routeName,
                                                  arguments: Usuario(
                                                      usuario: user,
                                                      nombres: name,
                                                      apellidos: lastname,
                                                      dni: dni,
                                                      telefono: telephone,
                                                      email: email,
                                                      password: password));
                                            } else {
                                              mostrarDialogo2(context);
                                            }
                                          }
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.purple),
                                      child: const Text(
                                        'Ingresar',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, Registro.routeName);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.purple),
                                      child: const Text(
                                        'Registro',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
