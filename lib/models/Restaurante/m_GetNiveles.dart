// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iMSalon": 43,
//             "tSalon": "PISO 1",
//             "tColor": "#00693D",
//             "tObservacion": ""
//         },
//         {
//             "iMSalon": 44,
//             "tSalon": "PISO 2",
//             "tColor": "#00693D",
//             "tObservacion": ""
//         },
//         {
//             "iMSalon": 45,
//             "tSalon": "TERRAZA",
//             "tColor": "#00693D",
//             "tObservacion": ""
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Restaurante/GetNiveles?tEmpresaRuc=12345696321&iDSucursal=542

import 'dart:convert';

MGetNiveles mGetNivelesFromJson(String str) => MGetNiveles.fromJson(json.decode(str));

String mGetNivelesToJson(MGetNiveles data) => json.encode(data.toJson());

class MGetNiveles {
  MGetNiveles({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<Datum> data;

  factory MGetNiveles.fromJson(Map<String, dynamic> json) => MGetNiveles(
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
    this.iMSalon,
    this.tSalon,
    this.tColor,
    this.tObservacion,
  });

  int? iMSalon;
  String? tSalon;
  String? tColor;
  String? tObservacion;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        iMSalon: json["iMSalon"],
        tSalon: json["tSalon"],
        tColor: json["tColor"],
        tObservacion: json["tObservacion"],
      );

  Map<String, dynamic> toJson() => {
        "iMSalon": iMSalon,
        "tSalon": tSalon,
        "tColor": tColor,
        "tObservacion": tObservacion,
      };
}
