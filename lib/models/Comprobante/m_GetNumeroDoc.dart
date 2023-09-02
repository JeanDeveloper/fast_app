// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "codigo": "34",
//             "descripcion": null,
//             "uFecha": "16/01/2023",
//             "rFecha": "17/01/2023"
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Comprobante/GetNumeroDoc?tEmpresaRuc=20000000001&TipoDoc=03&SerieDoc=B001

import 'dart:convert';

GetNumeroDoc getNumeroDocFromJson(String str) => GetNumeroDoc.fromJson(json.decode(str));

String getNumeroDocToJson(GetNumeroDoc data) => json.encode(data.toJson());

class GetNumeroDoc {
  GetNumeroDoc({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<NumeroData> data;

  factory GetNumeroDoc.fromJson(Map<String, dynamic> json) => GetNumeroDoc(
        code: json["code"],
        message: json["message"],
        data: List<NumeroData>.from(json["data"].map((x) => NumeroData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class NumeroData {
  NumeroData({
    this.codigo,
    this.descripcion,
    this.uFecha,
    this.rFecha,
  });

  String? codigo;
  dynamic? descripcion;
  String? uFecha;
  String? rFecha;

  factory NumeroData.fromJson(Map<String, dynamic> json) => NumeroData(
        codigo: json["codigo"],
        descripcion: json["descripcion"],
        uFecha: json["uFecha"],
        rFecha: json["rFecha"],
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "descripcion": descripcion,
        "uFecha": uFecha,
        "rFecha": rFecha,
      };
}
