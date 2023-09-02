// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iMCaja": 22,
//             "tMCaja": "CAJA PRINCIPAL",
//             "nInicial": 300.00,
//             "iEstado": 2,
//             "nImporteFinal": 1374.70,
//             "nTotalEgresos": 0.00,
//             "nTotalIngresos": 1074.70
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Caja/GetCajaDiariaPorId?iDCajaDiaria=200

import 'dart:convert';

GetCajaDiariaPorId getCajaDiariaPorIdFromJson(String str) => GetCajaDiariaPorId.fromJson(json.decode(str));

String getCajaDiariaPorIdToJson(GetCajaDiariaPorId data) => json.encode(data.toJson());

class GetCajaDiariaPorId {
  GetCajaDiariaPorId({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<Datum> data;

  factory GetCajaDiariaPorId.fromJson(Map<String, dynamic> json) => GetCajaDiariaPorId(
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
    required this.iMCaja,
    required this.tMCaja,
    required this.nInicial,
    required this.iEstado,
    required this.nImporteFinal,
    required this.nTotalEgresos,
    required this.nTotalIngresos,
  });

  int iMCaja;
  String tMCaja;
  double nInicial;
  int iEstado;
  double nImporteFinal;
  double nTotalEgresos;
  double nTotalIngresos;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        iMCaja: json["iMCaja"],
        tMCaja: json["tMCaja"],
        nInicial: json["nInicial"],
        iEstado: json["iEstado"],
        nImporteFinal: json["nImporteFinal"].toDouble(),
        nTotalEgresos: json["nTotalEgresos"],
        nTotalIngresos: json["nTotalIngresos"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "iMCaja": iMCaja,
        "tMCaja": tMCaja,
        "nInicial": nInicial,
        "iEstado": iEstado,
        "nImporteFinal": nImporteFinal,
        "nTotalEgresos": nTotalEgresos,
        "nTotalIngresos": nTotalIngresos,
      };
}
