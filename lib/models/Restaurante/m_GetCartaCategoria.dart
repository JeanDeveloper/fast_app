// http://apimovil.sistemafast.pe/Restaurante/GetCartaCategoria?tEmpresaRuc=12345696321

// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iMCategoria": 40683,
//             "tCategoria": "BRASAS",
//             "iMImpresora": 5,
//             "tImpresora": "HP",
//             "subCategoria": []
//         },
//         {
//             "iMCategoria": 40688,
//             "tCategoria": "PIQUEOS",
//             "iMImpresora": 5,
//             "tImpresora": "HP",
//             "subCategoria": [
//                 {
//                     "iMSubCategoria": 113,
//                     "tSubCategoria": "BROCHETAS DE POLLO"
//                 },
//                 {
//                     "iMSubCategoria": 114,
//                     "tSubCategoria": "TEQUEÑOS DE JAMON Y QUESO"
//                 }
//             ]
//         }
//     ]
// }

// To parse this JSON data, do
//
//     final mGetCartaCategoriaFromJson = mGetCartaCategoriaFromJsonFromJson(jsonString);

import 'dart:convert';

MGetCartaCategoria mGetCartaCategoriaFromJson(String str) => MGetCartaCategoria.fromJson(json.decode(str));

String mGetCartaCategoriaToJson(MGetCartaCategoria data) => json.encode(data.toJson());

class MGetCartaCategoria {
  MGetCartaCategoria({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<Datum> data;

  factory MGetCartaCategoria.fromJson(Map<String, dynamic> json) => MGetCartaCategoria(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.iMCategoria,
    this.tCategoria,
    this.iMImpresora,
    this.tImpresora,
    this.subCategoria,
  });

  int? iMCategoria;
  String? tCategoria;
  int? iMImpresora;
  String? tImpresora;
  List<SubCategoria>? subCategoria;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        iMCategoria: json["iMCategoria"],
        tCategoria: json["tCategoria"],
        iMImpresora: json["iMImpresora"],
        tImpresora: json["tImpresora"],
        subCategoria: json["subCategoria"] == null ? [] : List<SubCategoria>.from(json["subCategoria"]!.map((x) => SubCategoria.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "iMCategoria": iMCategoria,
        "tCategoria": tCategoria,
        "iMImpresora": iMImpresora,
        "tImpresora": tImpresora,
        "subCategoria": subCategoria == null ? [] : List<dynamic>.from(subCategoria!.map((x) => x.toJson())),
      };
}

class SubCategoria {
  SubCategoria({
    this.iMSubCategoria,
    this.tSubCategoria,
  });

  int? iMSubCategoria;
  String? tSubCategoria;

  factory SubCategoria.fromJson(Map<String, dynamic> json) => SubCategoria(
        iMSubCategoria: json["iMSubCategoria"],
        tSubCategoria: json["tSubCategoria"],
      );

  Map<String, dynamic> toJson() => {
        "iMSubCategoria": iMSubCategoria,
        "tSubCategoria": tSubCategoria,
      };
}
