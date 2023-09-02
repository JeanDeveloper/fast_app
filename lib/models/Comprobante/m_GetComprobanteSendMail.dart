// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "messageResult": "Comprobante Actualizado Correctamente <br> <br> El correo fue enviado",
//             "messageValue": "1"
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Comprobante/GetComprobanteSendMail?Comprobante=4795718&Correo=micvia@hotmail.com&autoriza=mvia&Mensaje=Hola

import 'dart:convert';

GetComprobanteSendMail getComprobanteSendMailFromJson(String str) => GetComprobanteSendMail.fromJson(json.decode(str));

String getComprobanteSendMailToJson(GetComprobanteSendMail data) => json.encode(data.toJson());

class GetComprobanteSendMail {
  GetComprobanteSendMail({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<sendMailRes> data;

  factory GetComprobanteSendMail.fromJson(Map<String, dynamic> json) => GetComprobanteSendMail(
        code: json["code"],
        message: json["message"],
        data: List<sendMailRes>.from(json["data"].map((x) => sendMailRes.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class sendMailRes {
  sendMailRes({
    required this.messageResult,
    required this.messageValue,
  });

  String messageResult;
  String messageValue;

  factory sendMailRes.fromJson(Map<String, dynamic> json) => sendMailRes(
        messageResult: json["messageResult"],
        messageValue: json["messageValue"],
      );

  Map<String, dynamic> toJson() => {
        "messageResult": messageResult,
        "messageValue": messageValue,
      };
}
