// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iDCajaDiaria": 96133,
//             "fFecha": "10/02/2023",
//             "iMCaja": 491,
//             "tMCaja": "PRUEBA",
//             "iDSucursal": 775,
//             "tDSucursal": "PRINCIPAL",
//             "iMoneda": 1
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Caja/GetCajaDiariaAbiertaUsuario?fFechaInicio=2023-02-10&fFechaFin=2023-02-10&tEmpresaRuc=20000000001&iDSucursal=775&iMUsuario=6423

import 'dart:convert';

GetCajaDiariaAbiertaUsuario getCajaDiariaAbiertaUsuarioFromJson(String str) => GetCajaDiariaAbiertaUsuario.fromJson(json.decode(str));

String getCajaDiariaAbiertaUsuarioToJson(GetCajaDiariaAbiertaUsuario data) => json.encode(data.toJson());

class GetCajaDiariaAbiertaUsuario {
  GetCajaDiariaAbiertaUsuario({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<Datum> data;

  factory GetCajaDiariaAbiertaUsuario.fromJson(Map<String, dynamic> json) => GetCajaDiariaAbiertaUsuario(
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
    required this.iMoneda,
  });

  int iDCajaDiaria;
  String fFecha;
  int iMCaja;
  String tMCaja;
  int iDSucursal;
  String tDSucursal;
  int iMoneda;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        iDCajaDiaria: json["iDCajaDiaria"],
        fFecha: json["fFecha"],
        iMCaja: json["iMCaja"],
        tMCaja: json["tMCaja"],
        iDSucursal: json["iDSucursal"],
        tDSucursal: json["tDSucursal"],
        iMoneda: json["iMoneda"],
      );

  Map<String, dynamic> toJson() => {
        "iDCajaDiaria": iDCajaDiaria,
        "fFecha": fFecha,
        "iMCaja": iMCaja,
        "tMCaja": tMCaja,
        "iDSucursal": iDSucursal,
        "tDSucursal": tDSucursal,
        "iMoneda": iMoneda,
      };
}
