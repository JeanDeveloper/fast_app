// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iTipo": 0,
//             "inivel": 1,
//             "iColumna": 0,
//             "iFila": 0,
//             "iAsiento": 0,
//             "iEstado": 0
//         },
//         {
//             "iTipo": 0,
//             "inivel": 2,
//             "iColumna": 0,
//             "iFila": 0,
//             "iAsiento": 0,
//             "iEstado": 0
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Transporte/GetModeloAsientoBuscar?iDProgramacionFecha=229582&iMModeloTransporte=58&iNivel=1

import 'dart:convert';

GetModeloAsientoBuscar getModeloAsientoBuscarFromJson(String str) => GetModeloAsientoBuscar.fromJson(json.decode(str));

String getModeloAsientoBuscarToJson(GetModeloAsientoBuscar data) => json.encode(data.toJson());

class GetModeloAsientoBuscar {
  GetModeloAsientoBuscar({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<Datum> data;

  factory GetModeloAsientoBuscar.fromJson(Map<String, dynamic> json) => GetModeloAsientoBuscar(
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
  Datum({this.iTipo, this.inivel, this.iColumna, this.iFila, this.iAsiento, this.iEstado, this.iPrecio, this.iMVentaTransporte, this.tColor});

  int? iTipo;
  int? inivel;
  int? iColumna;
  int? iFila;
  int? iAsiento;
  int? iEstado;
  double? iPrecio;
  int? iMVentaTransporte;
  String? tColor;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        iTipo: json["iTipo"],
        inivel: json["inivel"],
        iColumna: json["iColumna"],
        iFila: json["iFila"],
        iAsiento: json["iAsiento"],
        iEstado: json["iEstado"],
        iPrecio: json["iPrecio"],
        iMVentaTransporte: json["iMVentaTransporte"],
        tColor: json["tColor"],
      );

  Map<String, dynamic> toJson() => {
        "iTipo": iTipo,
        "inivel": inivel,
        "iColumna": iColumna,
        "iFila": iFila,
        "iAsiento": iAsiento,
        "iEstado": iEstado,
        "iPrecio": iPrecio,
        "iMVentaTransporte": iMVentaTransporte,
        "tColor": tColor,
      };
}
