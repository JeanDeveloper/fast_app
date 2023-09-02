// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iTipo": 0,
//             "inivel": 1,
//             "iColumna": 0,
//             "iFila": 0,
//             "iAsiento": 0,
//             "iEstado": 0
//         },
//         {
//             "iTipo": 0,
//             "inivel": 2,
//             "iColumna": 0,
//             "iFila": 0,
//             "iAsiento": 0,
//             "iEstado": 0
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Transporte/GetNiveles?iMModeloTransporte=58

import 'dart:convert';

GetNiveles getNivelesFromJson(String str) => GetNiveles.fromJson(json.decode(str));

String getNivelesToJson(GetNiveles data) => json.encode(data.toJson());

class GetNiveles {
  GetNiveles({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<NivelesData> data;

  factory GetNiveles.fromJson(Map<String, dynamic> json) => GetNiveles(
        code: json["code"],
        message: json["message"],
        data: List<NivelesData>.from(json["data"].map((x) => NivelesData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class NivelesData {
  NivelesData({
    required this.iTipo,
    required this.inivel,
    required this.iColumna,
    required this.iFila,
    required this.iAsiento,
    required this.iEstado,
  });

  int iTipo;
  int inivel;
  int iColumna;
  int iFila;
  int iAsiento;
  int iEstado;

  factory NivelesData.fromJson(Map<String, dynamic> json) => NivelesData(
        iTipo: json["iTipo"],
        inivel: json["inivel"],
        iColumna: json["iColumna"],
        iFila: json["iFila"],
        iAsiento: json["iAsiento"],
        iEstado: json["iEstado"],
      );

  Map<String, dynamic> toJson() => {
        "iTipo": iTipo,
        "inivel": inivel,
        "iColumna": iColumna,
        "iFila": iFila,
        "iAsiento": iAsiento,
        "iEstado": iEstado,
      };
}
