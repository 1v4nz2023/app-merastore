
class Products {
  final String codProd;
  final String nombre;
  final double precio;
  final String url;
   int stock;
  final String categoria;
  int cantidad;

  Products({
    required this.codProd,
    required this.nombre,
    required this.precio,
    required this.url,
    required this.stock,
    required this.categoria,
    this.cantidad=0,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        codProd: json["cod_prod"],
        nombre: json["nombre"],
        precio: json["precio"].toDouble(),
        url: json["url"],
        stock: json["stock"],
        categoria: json["categoria"],
      );

  Map<String, dynamic> toJson() => {
        "cod_prod": codProd,
        "nombre": nombre,
        "precio": precio,
        "url": url,
        "stock": stock,
        "categoria": categoria,
      };
}
