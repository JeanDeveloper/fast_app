// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": {
//         "iDPedidoDetalle": 38520,
//         "iMProducto": 995492,
//         "lCortesia": false,
//         "tObservacion": "OBSERVACION: jfffk",
//         "iTipoConsumo": 1
//     }
// }

// http://apimovil.sistemafast.pe/Restaurante/GetOrdenProductoMesa?iDPedidoDetalle=38520

import 'dart:convert';

MGetOrdenProductoMesa mGetOrdenProductoMesaFromJson(String str) => MGetOrdenProductoMesa.fromJson(json.decode(str));

String mGetOrdenProductoMesaToJson(MGetOrdenProductoMesa data) => json.encode(data.toJson());

class MGetOrdenProductoMesa {
  MGetOrdenProductoMesa({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  Data data;

  factory MGetOrdenProductoMesa.fromJson(Map<String, dynamic> json) => MGetOrdenProductoMesa(
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.iDPedidoDetalle,
    this.iMProducto,
    this.tProducto,
    this.lCortesia,
    this.tObservacion,
    this.iTipoConsumo,
  });

  int? iDPedidoDetalle;
  int? iMProducto;
  String? tProducto;
  bool? lCortesia;
  String? tObservacion;
  int? iTipoConsumo;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        iDPedidoDetalle: json["iDPedidoDetalle"],
        iMProducto: json["iMProducto"],
        tProducto: json["tProducto"],
        lCortesia: json["lCortesia"],
        tObservacion: json["tObservacion"],
        iTipoConsumo: json["iTipoConsumo"],
      );

  Map<String, dynamic> toJson() => {
        "iDPedidoDetalle": iDPedidoDetalle,
        "iMProducto": iMProducto,
        "tProducto": tProducto,
        "lCortesia": lCortesia,
        "tObservacion": tObservacion,
        "iTipoConsumo": iTipoConsumo,
      };
}
