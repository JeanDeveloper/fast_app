// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": {
//         "iDFormatoPrecuenta": 712,
//         "iDFormatoOrden": 713,
//         "iDFormatoAnulacion": 714
//     }
// }

// http://apimovil.sistemafast.pe/Restaurante/GetFormatosEmpresas?tEmpresaRuc=12345696321&iDSucursal=542

import 'dart:convert';

MGetFormatosEmpresas mGetFormatosEmpresasFromJson(String str) => MGetFormatosEmpresas.fromJson(json.decode(str));

String mGetFormatosEmpresasToJson(MGetFormatosEmpresas data) => json.encode(data.toJson());

class MGetFormatosEmpresas {
  MGetFormatosEmpresas({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  Data data;

  factory MGetFormatosEmpresas.fromJson(Map<String, dynamic> json) => MGetFormatosEmpresas(
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
    this.iDFormatoPrecuenta,
    this.iDFormatoOrden,
    this.iDFormatoAnulacion,
  });

  int? iDFormatoPrecuenta;
  int? iDFormatoOrden;
  int? iDFormatoAnulacion;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        iDFormatoPrecuenta: json["iDFormatoPrecuenta"],
        iDFormatoOrden: json["iDFormatoOrden"],
        iDFormatoAnulacion: json["iDFormatoAnulacion"],
      );

  Map<String, dynamic> toJson() => {
        "iDFormatoPrecuenta": iDFormatoPrecuenta,
        "iDFormatoOrden": iDFormatoOrden,
        "iDFormatoAnulacion": iDFormatoAnulacion,
      };
}
