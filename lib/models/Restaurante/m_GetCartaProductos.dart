import 'dart:convert';

MGetCartaProductos mGetCartaProductosFromJson(String str) => MGetCartaProductos.fromJson(json.decode(str));

String mGetCartaProductosToJson(MGetCartaProductos data) => json.encode(data.toJson());

class MGetCartaProductos {
  MGetCartaProductos({
    this.code,
    this.message,
    this.data,
  });

  int? code;
  String? message;
  List<CartaProductoData>? data;

  factory MGetCartaProductos.fromJson(Map<String, dynamic> json) => MGetCartaProductos(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? [] : List<CartaProductoData>.from(json["data"]!.map((x) => CartaProductoData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CartaProductoData {
  CartaProductoData({
    this.iMProducto,
    this.tProducto,
    this.tImagenProducto,
    this.nPrecioUnitario,
    this.iMCategoria,
    this.iMSubCategoria,
    this.tSubCategoria,
    this.operadores,
  });

  int? iMProducto;
  String? tProducto;
  String? tImagenProducto;
  double? nPrecioUnitario;
  int? iMCategoria;
  int? iMSubCategoria;
  String? tSubCategoria;
  List<Operadore>? operadores;

  factory CartaProductoData.fromJson(Map<String, dynamic> json) => CartaProductoData(
        iMProducto: json["iMProducto"],
        tProducto: json["tProducto"],
        tImagenProducto: json["tImagenProducto"],
        nPrecioUnitario: json["nPrecioUnitario"],
        iMCategoria: json["iMCategoria"],
        iMSubCategoria: json["iMSubCategoria"],
        tSubCategoria: json["tSubCategoria"],
        operadores: json["operadores"] == null ? [] : List<Operadore>.from(json["operadores"]!.map((x) => Operadore.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "iMProducto": iMProducto,
        "tProducto": tProducto,
        "tImagenProducto": tImagenProducto,
        "nPrecioUnitario": nPrecioUnitario,
        "iMCategoria": iMCategoria,
        "iMSubCategoria": iMSubCategoria,
        "tSubCategoria": tSubCategoria,
        "operadores": operadores == null ? [] : List<dynamic>.from(operadores!.map((x) => x.toJson())),
      };
}

class Operadore {
  Operadore({
    this.iMOperador,
    this.tOperador,
    this.iSeleccion,
    this.propiedades,
  });

  int? iMOperador;
  String? tOperador;
  int? iSeleccion;
  List<Propiedade>? propiedades;

  factory Operadore.fromJson(Map<String, dynamic> json) => Operadore(
        iMOperador: json["iMOperador"],
        tOperador: json["tOperador"],
        iSeleccion: json["iSeleccion"],
        propiedades: json["propiedades"] == null ? [] : List<Propiedade>.from(json["propiedades"]!.map((x) => Propiedade.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "iMOperador": iMOperador,
        "tOperador": tOperador,
        "iSeleccion": iSeleccion,
        "propiedades": propiedades == null ? [] : List<dynamic>.from(propiedades!.map((x) => x.toJson())),
      };
}

class Propiedade {
  Propiedade({
    this.iMPropiedad,
    this.tPropiedad,
    this.lPorDefecto,
    this.nPrecioAdicional,
  });

  int? iMPropiedad;
  String? tPropiedad;
  bool? lPorDefecto;
  double? nPrecioAdicional;

  factory Propiedade.fromJson(Map<String, dynamic> json) => Propiedade(
        iMPropiedad: json["iMPropiedad"],
        tPropiedad: json["tPropiedad"],
        lPorDefecto: json["lPorDefecto"],
        nPrecioAdicional: json["nPrecioAdicional"],
      );

  Map<String, dynamic> toJson() => {
        "iMPropiedad": iMPropiedad,
        "tPropiedad": tPropiedad,
        "lPorDefecto": lPorDefecto,
        "nPrecioAdicional": nPrecioAdicional,
      };
}
