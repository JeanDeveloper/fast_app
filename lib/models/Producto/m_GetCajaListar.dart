// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iMProducto": 964686,
//             "tDescripcion": "ENCOMIENDA",
//             "tObservaciones": "",
//             "tUnidad": "NIU",
//             "iPrecioTotal": 20.000000000
//         },
//         {
//             "iMProducto": 1519718,
//             "tDescripcion": "SOBRE MANILA",
//             "tObservaciones": "",
//             "tUnidad": "NIU",
//             "iPrecioTotal": 15.000000000
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Producto/GetProductoPorNombre?tNombre=i&tEmpresaRuc=20000000001

import 'dart:convert';

GetProductoPorNombre getProductoPorNombreFromJson(String str) => GetProductoPorNombre.fromJson(json.decode(str));

String getProductoPorNombreToJson(GetProductoPorNombre data) => json.encode(data.toJson());

class GetProductoPorNombre {
  GetProductoPorNombre({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<Datum> data;

  factory GetProductoPorNombre.fromJson(Map<String, dynamic> json) => GetProductoPorNombre(
        code: json["code"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.iMProducto,
    required this.tDescripcion,
    required this.tObservaciones,
    required this.tUnidad,
    required this.iPrecioTotal,
  });

  int iMProducto;
  String tDescripcion;
  String tObservaciones;
  String tUnidad;
  double iPrecioTotal;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        iMProducto: json["iMProducto"],
        tDescripcion: json["tDescripcion"],
        tObservaciones: json["tObservaciones"],
        tUnidad: json["tUnidad"],
        iPrecioTotal: json["iPrecioTotal"],
      );

  Map<String, dynamic> toJson() => {
        "iMProducto": iMProducto,
        "tDescripcion": tDescripcion,
        "tObservaciones": tObservaciones,
        "tUnidad": tUnidad,
        "iPrecioTotal": iPrecioTotal,
      };
}
