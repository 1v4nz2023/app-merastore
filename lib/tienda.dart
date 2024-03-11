import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formularios/models/productos.dart';
import 'dart:convert';
import 'bd.dart';

class Tienda extends StatefulWidget {
  const Tienda({super.key});
  static const routeName = '/tienda';

  @override
  State<Tienda> createState() => _TiendaState();
}

class _TiendaState extends State<Tienda> {
  List<Products> productos = [];
  String? selectedCategory = 'Todos';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getProductos();
  }

  Future<void> getProductos() async {
    final response =
        await Dio().get("https://proyectosmera.com/api-merastore/productos");
    setState(() {
      final List<dynamic> jsonResponse = json.decode(response.data);
      productos = jsonResponse
          .map((productoJson) => Products.fromJson(productoJson))
          .toList();
      final Set<String> categories = productos.map((p) => p.categoria).toSet();
      categories.add('Todos');
    });
  }

  Future<bool> actualizarStockProducto(
      Products producto, int cantidadComprada) async {
    final codProd = producto.codProd;
    final url =
        'https://proyectosmera.com/api-merastore/productos/$codProd'; // Asegúrate de que esta es la URL correcta para actualizar productos.
    final nuevoStock = producto.stock - cantidadComprada;
    final data = FormData.fromMap({
      'nombre': producto.nombre, // Incluye el nombre del producto.
      'precio': producto.precio.toString(), // Incluye el precio del producto.
      'url': producto.url, // Incluye la URL de la imagen del producto.
      'stock': nuevoStock.toString(), // Incluye el nuevo stock calculado.
      'categoria': producto.categoria, // Incluye la categoría del producto.
    });

    try {
      final response = await Dio().post(url,
          data: data,
          options: Options(
              contentType: Headers
                  .formUrlEncodedContentType)); // Indica que el contenido es form-urlencoded.
      if (response.statusCode == 200) {
        print('Stock actualizado con éxito');
        return true;
      } else {
        print('Error al actualizar el stock del producto');
        return false;
      }
    } catch (e) {
      print('Error al conectar al servidor: $e');
      return false;
    }
  }

  void _showBackDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('Estás seguro de cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Sí'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  double calcularTotalCompra() {
    return productos.fold(
        0,
        (double total, producto) =>
            total + (producto.precio * producto.cantidad));
  }

  void mostrarTotalCompraDialog() {
    // Calcula el total de la compra.
    final totalCompra = calcularTotalCompra();
    final montoBase = totalCompra / (1.18);
    final igv = montoBase * 0.18;

    // Genera una lista de Widgets que representan cada producto seleccionado y su subtotal.
    List<Widget> listaProductos = productos
        .where((producto) => producto.cantidad > 0)
        .map(
          (producto) => ListTile(
            title: Text(producto.nombre),
            subtitle: Text('Cantidad: ${producto.cantidad}'),
            trailing: Text('S/${producto.precio * producto.cantidad}'),
          ),
        )
        .toList();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resumen de Compra'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ...listaProductos, // Despliega la lista de productos seleccionados.
                Divider(), // Un separador visual.
                Text('Monto Base: S/${montoBase.toStringAsFixed(2)}'),
                Text('IGV 18%: S/${igv.toStringAsFixed(2)}'),
                Text(
                    'Total: S/${totalCompra.toStringAsFixed(2)}'), // Muestra el total de la compra.
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Comprar'),
              onPressed: () {
                if (totalCompra != 0.0) {
                  _showPurchaseConfirmationDialog();
                } else {
                  _showErrorDialog();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showPurchaseConfirmationDialog() {
    Navigator.of(context).pop();
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Compra'),
          content: Text('¿Estás seguro de que quieres realizar la compra?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: Text('Comprar'),
              onPressed: () async {
                bool allUpdatesSuccessful = true;

                for (var producto in productos.where((p) => p.cantidad > 0)) {
                  bool updateSuccess = await actualizarStockProducto(
                      producto, producto.cantidad);
                  if (updateSuccess) {
                    setState(() {
                      producto.stock -=
                          producto.cantidad; // Actualiza el stock local
                      producto.cantidad =
                          0; // Resetea la cantidad seleccionada a 0
                    });
                  } else {
                    allUpdatesSuccessful = false;
                    break; // Si alguna actualización falla, detiene el proceso
                  }
                }

                if (allUpdatesSuccessful) {
                  Navigator.of(context).pop();
                } else {}
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error de Compra'),
          content: Text('Por favor seleccione algún producto'),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
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
    final user = ModalRoute.of(context)!.settings.arguments as Usuario;

    List<String> categories =
        productos.map((p) => p.categoria).toSet().toList();
    categories.insert(0, 'Todos'); // Asegura que 'Todos' es la primera opción

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Bienvenido : ${user.usuario} ",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.powerOff, color: Colors.white),
            onPressed: _showBackDialog,
          )
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            return;
          }
          _showBackDialog();
        },
        child: Column(
          children: [

            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<String>(
                  value: selectedCategory,
                  items:
                      categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
                FloatingActionButton(
                  onPressed: mostrarTotalCompraDialog,
                  child: Icon(Icons.shopping_cart, color: Colors.white),
                  tooltip: 'Mostrar total de la compra',
                  backgroundColor: Colors.purple,
                ),
              ],
            ),
                        Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Buscar',
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (value) => setState(
                    () {}), 
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: productos
                    .where((p) =>
                        (selectedCategory == 'Todos' ||
                            p.categoria == selectedCategory) &&
                        p.nombre
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()))
                    .length,
                itemBuilder: (context, index) {
                  final filteredProducts = productos
                      .where((p) =>
                          (selectedCategory == 'Todos' ||
                              p.categoria == selectedCategory) &&
                          p.nombre
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase()))
                      .toList();
                  final product = filteredProducts[index];

                  return ListTile(
                    title: Text(product.nombre),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Precio: S/${product.precio}'),
                        Text(
                            'Stock disponible: ${product.stock}'), // Muestra el stock del producto
                      ],
                    ),
                    leading: Image.network(product.url, width: 50, height: 50),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: product.cantidad > 0
                              ? () => setState(() {
                                    product.cantidad--;
                                  })
                              : null,
                        ),
                        Text('${product.cantidad}'),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: product.cantidad < product.stock
                              ? () => setState(() {
                                    product.cantidad++;
                                  })
                              : null,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
