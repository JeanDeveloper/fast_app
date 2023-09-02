// http://apimovil.sistemafast.pe/Restaurante/GetParaLlevarDelivery?iMCanal=2&iDSucursal=542

// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iDPedido": 33989,
//             "tDescripcion": "P.LLEVAR 1",
//             "tClienteResponsable": "ANÓNIMO",
//             "iCapacidad": 0,
//             "nTotal": 50.00,
//             "tHora": "9:45AM",
//             "iEstado": 1
//         },
//         {
//             "iDPedido": 33993,
//             "tDescripcion": "P.LLEVAR 5",
//             "tClienteResponsable": "ANÓNIMO",
//             "iCapacidad": 0,
//             "nTotal": 35.00,
//             "tHora": "12:10PM",
//             "iEstado": 1
//         }
//     ]
// }

// To parse this JSON data, do
//
//     final getParaLlevarDelivery = getParaLlevarDeliveryFromJson(jsonString);

import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';

GetParaLlevarDelivery getParaLlevarDeliveryFromJson(String str) => GetParaLlevarDelivery.fromJson(json.decode(str));

String getParaLlevarDeliveryToJson(GetParaLlevarDelivery data) => json.encode(data.toJson());

class GetParaLlevarDelivery {
  GetParaLlevarDelivery({
    this.code,
    this.message,
    this.data,
  });

  int? code;
  String? message;
  List<Datum>? data;

  factory GetParaLlevarDelivery.fromJson(Map<String, dynamic> json) => GetParaLlevarDelivery(
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
    this.iDPedido,
    this.tDescripcion,
    this.tClienteResponsable,
    this.iCapacidad,
    required this.nTotal,
    this.tHora,
    this.iEstado,
    this.iEstadoPago,
    this.iEstadoEnvio,
  });

  int? iDPedido;
  String? tDescripcion;
  String? tClienteResponsable;
  int? iCapacidad;
  double nTotal;
  String? tHora;
  int? iEstado;
  int? iEstadoPago;
  int? iEstadoEnvio;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        iDPedido: json["iDPedido"],
        tDescripcion: json["tDescripcion"],
        tClienteResponsable: json["tClienteResponsable"],
        iCapacidad: json["iCapacidad"],
        nTotal: json["nTotal"],
        tHora: json["tHora"],
        iEstado: json["iEstado"],
        iEstadoPago: json["iEstadoPago"],
        iEstadoEnvio: json["iEstadoEnvio"],
      );

  Map<String, dynamic> toJson() => {
        "iDPedido": iDPedido,
        "tDescripcion": tDescripcion,
        "tClienteResponsable": tClienteResponsable,
        "iCapacidad": iCapacidad,
        "nTotal": nTotal,
        "tHora": tHora,
        "iEstado": iEstado,
        "iEstadoPago": iEstadoPago,
        "iEstadoEnvio": iEstadoEnvio,
      };
}
