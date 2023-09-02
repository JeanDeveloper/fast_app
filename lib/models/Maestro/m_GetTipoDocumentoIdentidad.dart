// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iMTipoDocumentoIdentidad": "0",
//             "tDescripcion": "OTROS"
//         },
//         {
//             "iMTipoDocumentoIdentidad": "1",
//             "tDescripcion": "DNI"
//         },
//         {
//             "iMTipoDocumentoIdentidad": "4",
//             "tDescripcion": "CARNET DE EXTRANJERIA"
//         },
//         {
//             "iMTipoDocumentoIdentidad": "6",
//             "tDescripcion": "REG. UNICO DE CONTRIBUYENTES"
//         },
//         {
//             "iMTipoDocumentoIdentidad": "7",
//             "tDescripcion": "\r\nPASAPORTE"
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Maestro/GetTipoDocumentoIdentidad

import 'dart:convert';

GetTipoDocumentoIdentidad getTipoDocumentoIdentidadFromJson(String str) => GetTipoDocumentoIdentidad.fromJson(json.decode(str));

String getTipoDocumentoIdentidadToJson(GetTipoDocumentoIdentidad data) => json.encode(data.toJson());

class GetTipoDocumentoIdentidad {
  GetTipoDocumentoIdentidad({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<TipoDocumentoIdentidadData> data;

  factory GetTipoDocumentoIdentidad.fromJson(Map<String, dynamic> json) => GetTipoDocumentoIdentidad(
        code: json["code"],
        message: json["message"],
        data: List<TipoDocumentoIdentidadData>.from(json["data"].map((x) => TipoDocumentoIdentidadData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class TipoDocumentoIdentidadData {
  TipoDocumentoIdentidadData({
    required this.iMTipoDocumentoIdentidad,
    required this.tDescripcion,
  });

  String iMTipoDocumentoIdentidad;
  String tDescripcion;

  factory TipoDocumentoIdentidadData.fromJson(Map<String, dynamic> json) => TipoDocumentoIdentidadData(
        iMTipoDocumentoIdentidad: json["iMTipoDocumentoIdentidad"],
        tDescripcion: json["tDescripcion"],
      );

  Map<String, dynamic> toJson() => {
        "iMTipoDocumentoIdentidad": iMTipoDocumentoIdentidad,
        "tDescripcion": tDescripcion,
      };
}
