// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iMEmpleado": 728,
//             "tNombres": "MIGUEL SA",
//             "iUsuario": 0,
//             "tUsuario": "",
//             "iMTipoDocumentoIdentidad": "",
//             "descripcionDocumento": ""
//         },
//         {
//             "iMEmpleado": 950,
//             "tNombres": "MEYLIN DEL ROSARIO INFANTAS ARIAS",
//             "iUsuario": 6242,
//             "tUsuario": "MINFANTAS",
//             "iMTipoDocumentoIdentidad": "1",
//             "descripcionDocumento": "DNI"
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Maestro/GetEmpleado?tEmpresaRuc=20515070452

import 'dart:convert';

GetEmpleado getEmpleadoFromJson(String str) => GetEmpleado.fromJson(json.decode(str));

String getEmpleadoToJson(GetEmpleado data) => json.encode(data.toJson());

class GetEmpleado {
  GetEmpleado({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<EmpleadoData> data;

  factory GetEmpleado.fromJson(Map<String, dynamic> json) => GetEmpleado(
        code: json["code"],
        message: json["message"],
        data: List<EmpleadoData>.from(json["data"].map((x) => EmpleadoData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class EmpleadoData {
  EmpleadoData({
    required this.iMEmpleado,
    required this.tNombres,
    required this.iUsuario,
    required this.tUsuario,
    required this.iMTipoDocumentoIdentidad,
    required this.descripcionDocumento,
  });

  int iMEmpleado;
  String tNombres;
  int iUsuario;
  String tUsuario;
  String iMTipoDocumentoIdentidad;
  String descripcionDocumento;

  factory EmpleadoData.fromJson(Map<String, dynamic> json) => EmpleadoData(
        iMEmpleado: json["iMEmpleado"],
        tNombres: json["tNombres"],
        iUsuario: json["iUsuario"],
        tUsuario: json["tUsuario"],
        iMTipoDocumentoIdentidad: json["iMTipoDocumentoIdentidad"],
        descripcionDocumento: json["descripcionDocumento"],
      );

  Map<String, dynamic> toJson() => {
        "iMEmpleado": iMEmpleado,
        "tNombres": tNombres,
        "iUsuario": iUsuario,
        "tUsuario": tUsuario,
        "iMTipoDocumentoIdentidad": iMTipoDocumentoIdentidad,
        "descripcionDocumento": descripcionDocumento,
      };
}
