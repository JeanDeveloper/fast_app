// http://apimovil.sistemafast.pe/Restaurante/GetOrdenMesa?iMMesa=232&tEmpresaRuc=12345696321
// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iDPedidoDetalle": 38404,
//             "nCantidad": 3.00,
//             "iMProducto": 1388831,
//             "tProducto": "ALITAS A LA BBQ",
//             "nPrecioUnitario": 18.00,
//             "nTotal": 54.00
//         },
//         {
//             "iDPedidoDetalle": 38405,
//             "nCantidad": 2.00,
//             "iMProducto": 1388836,
//             "tProducto": "ALITAS AL MARACUYA",
//             "nPrecioUnitario": 18.00,
//             "nTotal": 36.00
//         }
//     ]
// }

import 'dart:convert';

MGetOrdenMesa mGetOrdenMesaFromJson(String str) => MGetOrdenMesa.fromJson(json.decode(str));

String mGetOrdenMesaToJson(MGetOrdenMesa data) => json.encode(data.toJson());

class MGetOrdenMesa {
  MGetOrdenMesa({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<DatumOrden> data;

  factory MGetOrdenMesa.fromJson(Map<String, dynamic> json) => MGetOrdenMesa(
        code: json["code"],
        message: json["message"],
        data: List<DatumOrden>.from(json["data"].map((x) => DatumOrden.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DatumOrden {
  DatumOrden({
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

  factory DatumOrden.fromJson(Map<String, dynamic> json) => DatumOrden(
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
