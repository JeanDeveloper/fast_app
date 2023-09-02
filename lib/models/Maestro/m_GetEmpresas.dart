// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "tEmpresaRuc": "12345696321",
//             "tEmpresa": "RESTAURANTE",
//             "sucursal": [
//                 {
//                     "iDSucursal": 542,
//                     "tSucursal": "PRINCIPAL"
//                 },
//                 {
//                     "iDSucursal": 39,
//                     "tSucursal": "F. MUNDIAL"
//                }
//             ]
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Usuario/GetEmpresas?iMUsuario=5044

import 'dart:convert';

MGetEmpresas mGetEmpresasFromJson(String str) => MGetEmpresas.fromJson(json.decode(str));

String mGetEmpresasToJson(MGetEmpresas data) => json.encode(data.toJson());

class MGetEmpresas {
  MGetEmpresas({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<Datum> data;

  factory MGetEmpresas.fromJson(Map<String, dynamic> json) => MGetEmpresas(
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
    this.tEmpresaRuc,
    this.tEmpresa,
    this.sucursal,
    this.tCodigoValidacion,
  });

  String? tEmpresaRuc;
  String? tEmpresa;
  String? tCodigoValidacion;
  List<Sucursal>? sucursal;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        tEmpresaRuc: json["tEmpresaRuc"],
        tEmpresa: json["tEmpresa"],
        tCodigoValidacion: json["tCodigoValidacion"],
        sucursal: List<Sucursal>.from(json["sucursal"].map((x) => Sucursal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tEmpresaRuc": tEmpresaRuc,
        "tEmpresa": tEmpresa,
        "tCodigoValidacion": tCodigoValidacion,
        "sucursal": List<dynamic>.from(sucursal!.map((x) => x.toJson())),
      };
}

class Sucursal {
  Sucursal({
    this.iDSucursal,
    this.tSucursal,
  });

  int? iDSucursal;
  String? tSucursal;

  factory Sucursal.fromJson(Map<String, dynamic> json) => Sucursal(
        iDSucursal: json["iDSucursal"],
        tSucursal: json["tSucursal"],
      );

  Map<String, dynamic> toJson() => {
        "iDSucursal": iDSucursal,
        "tSucursal": tSucursal,
      };
}
