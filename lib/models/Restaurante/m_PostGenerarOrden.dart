// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": {
//         "iDPedido": 232
//     }
// }

import 'dart:convert';

MPostGenerarOrden mPostGenerarOrdenFromJson(String str) => MPostGenerarOrden.fromJson(json.decode(str));

String mPostGenerarOrdenToJson(MPostGenerarOrden data) => json.encode(data.toJson());

class MPostGenerarOrden {
  MPostGenerarOrden({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  Data data;

  factory MPostGenerarOrden.fromJson(Map<String, dynamic> json) => MPostGenerarOrden(
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
    this.iDPedido,
  });

  int? iDPedido;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        iDPedido: json["iDPedido"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "iDPedido": iDPedido,
      };
}
