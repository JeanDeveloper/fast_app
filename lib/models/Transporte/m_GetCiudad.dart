// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iMCiudad": 176,
//             "tDescripcion": "CHIMBOTE"
//         },
//         {
//             "iMCiudad": 177,
//             "tDescripcion": "LIMA"
//         },
//         {
//             "iMCiudad": 178,
//             "tDescripcion": "TRUJILLO"
//         },
//         {
//             "iMCiudad": 179,
//             "tDescripcion": "RETAMA"
//         },
//         {
//             "iMCiudad": 180,
//             "tDescripcion": "ARICAPAMPA"
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Transporte/GetCiudad?tEmpresaRuc=20000000001

import 'dart:convert';

GetCiudad getCiudadFromJson(String str) => GetCiudad.fromJson(json.decode(str));

String getCiudadToJson(GetCiudad data) => json.encode(data.toJson());

class GetCiudad {
  GetCiudad({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<CiudadData> data;

  factory GetCiudad.fromJson(Map<String, dynamic> json) => GetCiudad(
        code: json["code"],
        message: json["message"],
        data: List<CiudadData>.from(json["data"].map((x) => CiudadData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CiudadData {
  CiudadData({
    required this.iMCiudad,
    required this.tDescripcion,
  });

  int iMCiudad;
  String tDescripcion;

  factory CiudadData.fromJson(Map<String, dynamic> json) => CiudadData(
        iMCiudad: json["iMCiudad"],
        tDescripcion: json["tDescripcion"],
      );

  Map<String, dynamic> toJson() => {
        "iMCiudad": iMCiudad,
        "tDescripcion": tDescripcion,
      };
}
