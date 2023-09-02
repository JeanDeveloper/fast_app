// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iMCaja": 342,
//             "iDSucursal": 737,
//             "tSucursal": "VILLA 1",
//             "tNombre": "VILLA 1 SOLES"
//         },
//         {
//             "iMCaja": 466,
//             "iDSucursal": 737,
//             "tSucursal": "VILLA 1",
//             "tNombre": "VILLA L MOTOS SOLES"
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Maestro/GetCajaListar?tEmpresaRuc=20515070452

import 'dart:convert';

GetCajaListar getCajaListarFromJson(String str) => GetCajaListar.fromJson(json.decode(str));

String getCajaListarToJson(GetCajaListar data) => json.encode(data.toJson());

class GetCajaListar {
  GetCajaListar({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<CajaData> data;

  factory GetCajaListar.fromJson(Map<String, dynamic> json) => GetCajaListar(
        code: json["code"],
        message: json["message"],
        data: List<CajaData>.from(json["data"].map((x) => CajaData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CajaData {
  CajaData({
    required this.iMCaja,
    required this.iDSucursal,
    required this.tSucursal,
    required this.tNombre,
  });

  int iMCaja;
  int iDSucursal;
  String tSucursal;
  String tNombre;

  factory CajaData.fromJson(Map<String, dynamic> json) => CajaData(
        iMCaja: json["iMCaja"],
        iDSucursal: json["iDSucursal"],
        tSucursal: json["tSucursal"],
        tNombre: json["tNombre"],
      );

  Map<String, dynamic> toJson() => {
        "iMCaja": iMCaja,
        "iDSucursal": iDSucursal,
        "tSucursal": tSucursal,
        "tNombre": tNombre,
      };
}
