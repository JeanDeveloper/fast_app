// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iMTerminal": 261,
//             "tNombre": "BCP LMOT",
//             "tBanco": "BCP",
//             "iImporte": 109981.43
//         },
//         {
//             "iMTerminal": 339,
//             "tNombre": "BCP SECT",
//             "tBanco": "BCP",
//             "iImporte": 3536.01
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Caja/GetTerminalCajaDiariaImporte?iMCaja=342&iDCajaDiaria=95111

import 'dart:convert';

GetTerminalCajaDiariaImporte getTerminalCajaDiariaImporteFromJson(String str) => GetTerminalCajaDiariaImporte.fromJson(json.decode(str));

String getTerminalCajaDiariaImporteToJson(GetTerminalCajaDiariaImporte data) => json.encode(data.toJson());

class GetTerminalCajaDiariaImporte {
  GetTerminalCajaDiariaImporte({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<Datum> data;

  factory GetTerminalCajaDiariaImporte.fromJson(Map<String, dynamic> json) => GetTerminalCajaDiariaImporte(
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
    required this.iMTerminal,
    required this.tNombre,
    required this.tBanco,
    required this.iImporte,
  });

  int iMTerminal;
  String tNombre;
  String tBanco;
  double iImporte;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        iMTerminal: json["iMTerminal"],
        tNombre: json["tNombre"],
        tBanco: json["tBanco"],
        iImporte: json["iImporte"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "iMTerminal": iMTerminal,
        "tNombre": tNombre,
        "tBanco": tBanco,
        "iImporte": iImporte,
      };
}
