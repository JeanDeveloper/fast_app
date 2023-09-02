// http://138.128.247.60/sertechalfa.pe/Restaurante/GetClienteDelivery?tTelefono=94994399&iDSucursal=542

// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "tTelefono": "949943999",
//             "tNombre": "MICHAEL VIA",
//             "tDireccion": "JR RIO RIMAC MZ. N LT. 2A",
//             "tReferencia": "",
//             "iMZona": 4
//         }
//     ]
// }

import 'dart:convert';

GetClienteDelivery getClienteDeliveryFromJson(String str) => GetClienteDelivery.fromJson(json.decode(str));

String getClienteDeliveryToJson(GetClienteDelivery data) => json.encode(data.toJson());

class GetClienteDelivery {
  GetClienteDelivery({
    this.code,
    this.message,
    this.data,
  });

  int? code;
  String? message;
  List<Datum>? data;

  factory GetClienteDelivery.fromJson(Map<String, dynamic> json) => GetClienteDelivery(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.tTelefono,
    this.tNombre,
    this.tDireccion,
    this.tReferencia,
    this.iMZona,
  });

  String? tTelefono;
  String? tNombre;
  String? tDireccion;
  String? tReferencia;
  int? iMZona;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        tTelefono: json["tTelefono"],
        tNombre: json["tNombre"],
        tDireccion: json["tDireccion"],
        tReferencia: json["tReferencia"],
        iMZona: json["iMZona"],
      );

  Map<String, dynamic> toJson() => {
        "tTelefono": tTelefono,
        "tNombre": tNombre,
        "tDireccion": tDireccion,
        "tReferencia": tReferencia,
        "iMZona": iMZona,
      };
}
