// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iDCajaDiaria": 95111,
//             "fFecha": "30/01/2023",
//             "iMCaja": 342,
//             "tMCaja": "VILLA 1 SOLES",
//             "iDSucursal": 737,
//             "tDSucursal": "VILLA 1",
//             "nInicial": 11048.80,
//             "iEstado": 1,
//             "iMResponsable": 920,
//             "tMResponsable": "JUDITH JESUS ASTE MIJICHICH"
//         },
//         {
//             "iDCajaDiaria": 95137,
//             "fFecha": "30/01/2023",
//             "iMCaja": 463,
//             "tMCaja": "FINANCIERO",
//             "iDSucursal": 856,
//             "tDSucursal": "SJL",
//             "nInicial": 191.98,
//             "iEstado": 1,
//             "iMResponsable": 936,
//             "tMResponsable": "STEFANY MAGALY ESPINOZA MAMANI"
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Caja/GetCajaDiaria?tEmpresaRuc=20515070452&fFechaInicio=2023-01-30&fFechaFin=2023-01-30

import 'dart:convert';

GetCajaDiaria getCajaDiariaFromJson(String str) => GetCajaDiaria.fromJson(json.decode(str));

String getCajaDiariaToJson(GetCajaDiaria data) => json.encode(data.toJson());

class GetCajaDiaria {
  GetCajaDiaria({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<Datum> data;

  factory GetCajaDiaria.fromJson(Map<String, dynamic> json) => GetCajaDiaria(
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
    required this.iDCajaDiaria,
    required this.fFecha,
    required this.iMCaja,
    required this.tMCaja,
    required this.iDSucursal,
    required this.tDSucursal,
    required this.nInicial,
    required this.iEstado,
    required this.iMResponsable,
    required this.tMResponsable,
  });

  int iDCajaDiaria;
  String fFecha;
  int iMCaja;
  String tMCaja;
  int iDSucursal;
  String tDSucursal;
  double nInicial;
  int iEstado;
  int iMResponsable;
  String tMResponsable;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        iDCajaDiaria: json["iDCajaDiaria"],
        fFecha: json["fFecha"],
        iMCaja: json["iMCaja"],
        tMCaja: json["tMCaja"],
        iDSucursal: json["iDSucursal"],
        tDSucursal: json["tDSucursal"],
        nInicial: json["nInicial"].toDouble(),
        iEstado: json["iEstado"],
        iMResponsable: json["iMResponsable"],
        tMResponsable: json["tMResponsable"],
      );

  Map<String, dynamic> toJson() => {
        "iDCajaDiaria": iDCajaDiaria,
        "fFecha": fFecha,
        "iMCaja": iMCaja,
        "tMCaja": tMCaja,
        "iDSucursal": iDSucursal,
        "tDSucursal": tDSucursal,
        "nInicial": nInicial,
        "iEstado": iEstado,
        "iMResponsable": iMResponsable,
        "tMResponsable": tMResponsable,
      };
}
