// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "year_": 0,
//             "estadoSunat": null,
//             "estadoDocumento": null,
//             "tipoDocumento": null,
//             "documentoSerie": "B001",
//             "formatoPdf": "268",
//             "estadoAnulado": null,
//             "tServicio": "",
//             "tTipo": "",
//             "iAlmacen": 0,
//             "iNumeracion": 0
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Comprobante/GetSerieByTipo?TipoDoc=03&lTransporte=true&tEmpresaRuc=20000000001&iDSucursal=775&UsuarioId=6423

import 'dart:convert';

import 'package:flutter/src/material/dropdown.dart';

GetSerieByTipo getSerieByTipoFromJson(String str) => GetSerieByTipo.fromJson(json.decode(str));

String getSerieByTipoToJson(GetSerieByTipo data) => json.encode(data.toJson());

class GetSerieByTipo {
  GetSerieByTipo({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<SerieData> data;

  factory GetSerieByTipo.fromJson(Map<String, dynamic> json) => GetSerieByTipo(
        code: json["code"],
        message: json["message"],
        data: List<SerieData>.from(json["data"].map((x) => SerieData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class SerieData {
  SerieData({
    this.year,
    this.estadoSunat,
    this.estadoDocumento,
    this.tipoDocumento,
    this.documentoSerie,
    this.formatoPdf,
    this.estadoAnulado,
    this.tServicio,
    this.tTipo,
    this.iAlmacen,
    this.iNumeracion,
  });

  int? year;
  dynamic? estadoSunat;
  dynamic? estadoDocumento;
  dynamic? tipoDocumento;
  String? documentoSerie;
  String? formatoPdf;
  dynamic? estadoAnulado;
  String? tServicio;
  String? tTipo;
  int? iAlmacen;
  int? iNumeracion;

  factory SerieData.fromJson(Map<String, dynamic> json) => SerieData(
        year: json["year_"],
        estadoSunat: json["estadoSunat"],
        estadoDocumento: json["estadoDocumento"],
        tipoDocumento: json["tipoDocumento"],
        documentoSerie: json["documentoSerie"],
        formatoPdf: json["formatoPdf"],
        estadoAnulado: json["estadoAnulado"],
        tServicio: json["tServicio"],
        tTipo: json["tTipo"],
        iAlmacen: json["iAlmacen"],
        iNumeracion: json["iNumeracion"],
      );

  Map<String, dynamic> toJson() => {
        "year_": year,
        "estadoSunat": estadoSunat,
        "estadoDocumento": estadoDocumento,
        "tipoDocumento": tipoDocumento,
        "documentoSerie": documentoSerie,
        "formatoPdf": formatoPdf,
        "estadoAnulado": estadoAnulado,
        "tServicio": tServicio,
        "tTipo": tTipo,
        "iAlmacen": iAlmacen,
        "iNumeracion": iNumeracion,
      };

  static map(DropdownMenuItem<String> Function(String items) param0) {}
}
