// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iMCliente": 857435,
//             "tNroDocumento": "41377969",
//             "tNombre": "SANDRA MARIANA VALDERRAMA BOCANEGRA",
//             "tDireccion": "",
//             "tCorreo": "BSANBDAHBDHABDYUHJD",
//             "iMTipoDocumentoIdentidad": "1",
//             "tTelefonoPrincipal": ""
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Maestro/GetClienteBuscarPorNroDoc?tNroDocumento=41377969&tEmpresaRuc=20000000001

import 'dart:convert';

GetClienteBuscarPorNroDoc getClienteBuscarPorNroDocFromJson(String str) => GetClienteBuscarPorNroDoc.fromJson(json.decode(str));

String getClienteBuscarPorNroDocToJson(GetClienteBuscarPorNroDoc data) => json.encode(data.toJson());

class GetClienteBuscarPorNroDoc {
  GetClienteBuscarPorNroDoc({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<ClienteBuscarPorNroDocData> data;

  factory GetClienteBuscarPorNroDoc.fromJson(Map<String, dynamic> json) => GetClienteBuscarPorNroDoc(
        code: json["code"],
        message: json["message"],
        data: List<ClienteBuscarPorNroDocData>.from(json["data"].map((x) => ClienteBuscarPorNroDocData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ClienteBuscarPorNroDocData {
  ClienteBuscarPorNroDocData({
    required this.iMCliente,
    required this.tNroDocumento,
    required this.tNombre,
    required this.tDireccion,
    required this.tCorreo,
    required this.iMTipoDocumentoIdentidad,
    required this.tTelefonoPrincipal,
  });

  int iMCliente;
  String tNroDocumento;
  String tNombre;
  String tDireccion;
  String tCorreo;
  String iMTipoDocumentoIdentidad;
  String tTelefonoPrincipal;

  factory ClienteBuscarPorNroDocData.fromJson(Map<String, dynamic> json) => ClienteBuscarPorNroDocData(
        iMCliente: json["iMCliente"],
        tNroDocumento: json["tNroDocumento"],
        tNombre: json["tNombre"],
        tDireccion: json["tDireccion"],
        tCorreo: json["tCorreo"],
        iMTipoDocumentoIdentidad: json["iMTipoDocumentoIdentidad"],
        tTelefonoPrincipal: json["tTelefonoPrincipal"],
      );

  Map<String, dynamic> toJson() => {
        "iMCliente": iMCliente,
        "tNroDocumento": tNroDocumento,
        "tNombre": tNombre,
        "tDireccion": tDireccion,
        "tCorreo": tCorreo,
        "iMTipoDocumentoIdentidad": iMTipoDocumentoIdentidad,
        "tTelefonoPrincipal": tTelefonoPrincipal,
      };
}
