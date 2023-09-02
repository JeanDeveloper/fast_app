// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iDPedidoDetalle": 44872,
//             "nCantidad": 1.00,
//             "iMProducto": 1388831,
//             "tProducto": "ALITAS A LA BBQ",
//             "nPrecioUnitario": 18.00,
//             "nTotal": 18.00,
//             "tObservacion": "",
//             "nAdicional": 0.00,
//             "lCortesia": false
//         }
//     ]
// }

// http://138.128.247.60/sertechalfa.pe/Restaurante/GetOrdenLlevar?iDPedido=34702&tEmpresaRuc=12345696321

import 'dart:convert';

GetOrdenLlevar getOrdenLlevarFromJson(String str) => GetOrdenLlevar.fromJson(json.decode(str));

String getOrdenLlevarToJson(GetOrdenLlevar data) => json.encode(data.toJson());

class GetOrdenLlevar {
  GetOrdenLlevar({
    this.code,
    this.message,
    this.data,
  });

  int? code;
  String? message;
  List<Datum>? data;

  factory GetOrdenLlevar.fromJson(Map<String, dynamic> json) => GetOrdenLlevar(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.iDPedidoDetalle,
    this.nCantidad,
    this.iMProducto,
    this.tProducto,
    this.nPrecioUnitario,
    this.nTotal,
    this.tObservacion,
    this.nAdicional,
    this.lCortesia,
    this.fRegistro,
    this.tUsuario,
  });

  int? iDPedidoDetalle;
  double? nCantidad;
  int? iMProducto;
  String? tProducto;
  double? nPrecioUnitario;
  double? nTotal;
  String? tObservacion;
  double? nAdicional;
  bool? lCortesia;
  String? fRegistro;
  String? tUsuario;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        iDPedidoDetalle: json["iDPedidoDetalle"],
        nCantidad: json["nCantidad"],
        iMProducto: json["iMProducto"],
        tProducto: json["tProducto"],
        nPrecioUnitario: json["nPrecioUnitario"],
        nTotal: json["nTotal"],
        tObservacion: json["tObservacion"],
        nAdicional: json["nAdicional"],
        lCortesia: json["lCortesia"],
        fRegistro: json["fRegistro"],
        tUsuario: json["tUsuario"],
      );

  Map<String, dynamic> toJson() => {
        "iDPedidoDetalle": iDPedidoDetalle,
        "nCantidad": nCantidad,
        "iMProducto": iMProducto,
        "tProducto": tProducto,
        "nPrecioUnitario": nPrecioUnitario,
        "nTotal": nTotal,
        "tObservacion": tObservacion,
        "nAdicional": nAdicional,
        "lCortesia": lCortesia,
        "fRegistro": fRegistro,
        "tUsuario": tUsuario,
      };
}
