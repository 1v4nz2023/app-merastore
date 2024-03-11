import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formularios/bd.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});
  static const routeName = '/registro';

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  static List<Usuario> listaUsuarios = [
    Usuario(
        usuario: 'admin',
        nombres: 'admin',
        apellidos: 'admin',
        dni: '70550883',
        telefono: '933298821',
        email: 'admin@hotmail.com',
        password: 'admin123'),
    Usuario(
        usuario: "test",
        nombres: "test",
        apellidos: "test",
        dni: "test",
        telefono: "test",
        email: "test@gmail.com",
        password: "test123")
  ];
  String email = "";
  String password = "";
  String usuario = "";
  String nombres = "";
  String apellidos = "";
  String dni = "";
  String telefono = "";
  String mensajeError = "";
  String mensajeError2 = "";
  String mensajeError3 = "";
  String mensajeError4 = "";
  String mensajeError5 = "";
  String mensajeError6 = "";
  String mensajeError7 = "";
  int errores = 0;
  final TextEditingController dniController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  String errorMessage = '';
  String errorMessage2 = '';

  void registrarUsuario() {
    final nuevoUsuario = Usuario(
      usuario: usuario,
      nombres: nombres,
      apellidos: apellidos,
      dni: dni,
      telefono: telefono,
      email: email,
      password: password,
    );

    bool dniExiste = listaUsuarios.any((usuario) => usuario.dni == dni);
    bool emailExiste = listaUsuarios.any((usuario) => usuario.email == email);

    if (!dniExiste && !emailExiste) {
      setState(() {
        listaUsuarios.add(nuevoUsuario);
        mostrarDialogo(context);
      });
    } else {
      mostrarDialogo3(context);
    }
  }

  validarVacios() {
    String patron = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    if (!RegExp(patron).hasMatch(email)) {
      mensajeError = 'Por favor ingrese un correo electrónico válido';
      errores++;
    }
    if (email.isEmpty) {
      mensajeError = 'Por favor ingrese un correo electrónico';
      errores++;
    }
    if (nombres.isEmpty) {
      mensajeError2 = 'Por favor ingrese los nombres';
      errores++;
    }
    if (apellidos.isEmpty) {
      mensajeError7 = 'Por favor ingrese los apellidos';
      errores++;
    }

    if (usuario.isEmpty) {
      mensajeError3 = 'Por favor ingrese un usuario';
      errores++;
    }
    if (password.isEmpty) {
      mensajeError4 = 'Por favor ingrese una contraseña';
      errores++;
    }
    if (dni.isEmpty) {
      mensajeError5 = 'Por favor ingrese un DNI';
      errores++;
    }

    if (telefono.isEmpty) {
      mensajeError6 = 'Por favor ingrese un número telefónico';
      errores++;
    }

    if (dni.length != 8) {
      errores++;
    }

    if (telefono.length != 9) {
      errores++;
    }

    if (usuario.isNotEmpty &&
        nombres.isNotEmpty &&
        apellidos.isNotEmpty &&
        dni.isNotEmpty &&
        telefono.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty) {
      if (errores == 0) {
        registrarUsuario();
      } else {
        mostrarDialogo4(context);
      }
    } else {
      mostrarDialogo2(context);
    }
  }

  void mostrarDialogo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Usuario registrado con éxito'),
          content: Text("Total de usuarios: ${listaUsuarios.length}"),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/', arguments: listaUsuarios);
              },
            ),
          ],
        );
      },
    );
  }

  void mostrarDialogo2(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error de registro'),
          content: const Text("Por favor complete todos los campos"),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                errores = 0;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void mostrarDialogo3(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Usuario existente'),
          content: const Text("Por favor regístrese con otro DNI y/o email"),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                errores = 0;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void mostrarDialogo4(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error de registro'),
          content: const Text("Por favor verifique los datos ingresados"),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                errores = 0;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/home-bg.jpg"),
                      fit: BoxFit.cover)),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: SizedBox(
                          width: 350,
                          height: 720,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Usuario',
                                    prefixIcon:
                                        Icon(FontAwesomeIcons.user, size: 20),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      usuario = value;
                                      mensajeError3 = "";
                                    });
                                  },
                                ),
                                Text(
                                  mensajeError3,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Nombres',
                                    prefixIcon: Icon(FontAwesomeIcons.circleDot,
                                        size: 20),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      nombres = value;
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
                                TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Apellidos',
                                    prefixIcon: Icon(FontAwesomeIcons.circleDot,
                                        size: 20),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      apellidos = value;
                                      mensajeError7 = "";
                                    });
                                  },
                                ),
                                Text(
                                  mensajeError7,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextField(
                                  controller: dniController,
                                  decoration: InputDecoration(
                                    labelText: 'DNI',
                                    errorText: errorMessage.isNotEmpty
                                        ? errorMessage
                                        : null,
                                    prefixIcon:
                                        const Icon(FontAwesomeIcons.idCard, size: 20),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      dni = value;
                                      if (dni.length != 8) {
                                        errorMessage =
                                            "El DNI debe tener 8 dígitos";
                                        dni = errorMessage;
                                      } else {
                                        errorMessage = '';
                                      }
                                      mensajeError5 = "";
                                    });
                                  },
                                ),
                                Text(
                                  mensajeError5,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextField(
                                  controller: telefonoController,
                                  decoration: InputDecoration(
                                    labelText: 'Teléfono',
                                    errorText: errorMessage2.isNotEmpty
                                        ? errorMessage2
                                        : null,
                                    prefixIcon:
                                        const Icon(FontAwesomeIcons.phone, size: 20),
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      telefono = value;
                                      if (telefono.length != 9) {
                                        errorMessage2 =
                                            "El número telefónico debe tener 9 digitos";
                                        telefono = errorMessage2;
                                      } else {
                                        errorMessage2 = "";
                                      }
                                      mensajeError6 = "";
                                    });
                                  },
                                ),
                                Text(
                                  mensajeError6,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'E-mail',
                                    prefixIcon: Icon(FontAwesomeIcons.envelope,
                                        size: 20),
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
                                  decoration: const InputDecoration(
                                    labelText: 'Contraseña',
                                    prefixIcon:
                                        Icon(FontAwesomeIcons.lock, size: 20),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      password = value;
                                      mensajeError4 = "";
                                    });
                                  },
                                ),
                                Text(
                                  mensajeError4,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            validarVacios();
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.purple),
                                        child: const Text(
                                          'Registrar',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.purple),
                                        child: const Text(
                                          'Volver',
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
            ),
          ],
        ),
      ),
    );
  }
}
