// {
//     "code": 0,
//     "message": "Credenciales Válidas",
//     "data": {
//         "iMUsuario": 6423,
//         "tUsuario": "mvia",
//         "tRol": "12345696321",
//         "tEmpresaRuc": "RESTAURANTE",
//         "tEmpresa": "ADMINISTRADOR",
//         "iDSucursal": 542,
//         "tSucursal": "PRINCIPAL"
//     }
// }

// http://apimovil.sistemafast.pe/Seguridad/IniciarSesion?usuario=mvia&clave=mvia

import 'dart:convert';

MLogin mLoginFromJson(String str) => MLogin.fromJson(json.decode(str));

String mLoginToJson(MLogin data) => json.encode(data.toJson());

class MLogin {
  MLogin({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  Data data;

  factory MLogin.fromJson(Map<String, dynamic> json) => MLogin(
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
    this.iMUsuario,
    this.tUsuario,
    this.tRol,
    this.tEmpresaRuc,
    this.tEmpresa,
    this.iDSucursal,
    this.tSucursal,
    this.tUbigeo,
    this.tRegion,
    this.tProvincia,
    this.tDistrito,
    this.tTipozona,
    this.tDireccion,
    this.tCodigoValidacion,
  });

  int? iMUsuario;
  String? tUsuario;
  String? tRol;
  String? tEmpresaRuc;
  String? tEmpresa;
  int? iDSucursal;
  String? tSucursal;
  String? tUbigeo;
  String? tRegion;
  String? tProvincia;
  String? tDistrito;
  String? tTipozona;
  String? tDireccion;
  String? tCodigoValidacion;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        iMUsuario: json["iMUsuario"],
        tUsuario: json["tUsuario"],
        tRol: json["tRol"],
        tEmpresaRuc: json["tEmpresaRuc"],
        tEmpresa: json["tEmpresa"],
        iDSucursal: json["iDSucursal"],
        tSucursal: json["tSucursal"],
        tUbigeo: json["tUbigeo"],
        tRegion: json["tRegion"],
        tProvincia: json["tProvincia"],
        tDistrito: json["tDistrito"],
        tTipozona: json["tTipozona"],
        tDireccion: json["tDireccion"],
        tCodigoValidacion: json["tCodigoValidacion"],
      );

  Map<String, dynamic> toJson() => {
        "iMUsuario": iMUsuario,
        "tUsuario": tUsuario,
        "tRol": tRol,
        "tEmpresaRuc": tEmpresaRuc,
        "tEmpresa": tEmpresa,
        "iDSucursal": iDSucursal,
        "tSucursal": tSucursal,
        "tUbigeo": tUbigeo,
        "tRegion": tRegion,
        "tProvincia": tProvincia,
        "tDistrito": tDistrito,
        "tTipozona": tTipozona,
        "tDireccion": tDireccion,
        "tCodigoValidacion": tCodigoValidacion,
      };
}
