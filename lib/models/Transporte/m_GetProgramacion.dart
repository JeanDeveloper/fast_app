// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "fHoraSalida": "07:00 AM",
//             "tServicio": "SEMI CAMA",
//             "iCapacidad": 69,
//             "tRuta": "CHIMBOTE - LIMA",
//             "tFecha": "08/01/2023",
//             "tPrecio": "50.00"
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Transporte/GetProgramacion?tEmpresaRuc=20000000001&fFecha=2023-01-08&iOrigen=176&iDestino=177

import 'dart:convert';

import 'package:flutter/foundation.dart';

GetProgramacion getProgramacionFromJson(String str) => GetProgramacion.fromJson(json.decode(str));

String getProgramacionToJson(GetProgramacion data) => json.encode(data.toJson());

class GetProgramacion {
  GetProgramacion({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<ProgramacionData> data;

  factory GetProgramacion.fromJson(Map<String, dynamic> json) => GetProgramacion(
        code: json["code"],
        message: json["message"],
        data: List<ProgramacionData>.from(json["data"].map((x) => ProgramacionData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ProgramacionData {
  ProgramacionData({
    required this.fHoraSalida,
    required this.tServicio,
    required this.iCapacidad,
    required this.tRuta,
    required this.tFecha,
    required this.tPrecio,
    required this.iDProgramacion,
    required this.iDProgramacionFecha,
    required this.iNumeroViaje,
    required this.iMModeloTransporte,
    required this.tPlaca,
  });

  String fHoraSalida; //
  String tServicio; //
  int iCapacidad;
  String tRuta;
  String tFecha;
  String tPrecio; //
  int iDProgramacion;
  int iDProgramacionFecha;
  int iNumeroViaje;
  int iMModeloTransporte;
  String tPlaca;

  factory ProgramacionData.fromJson(Map<String, dynamic> json) => ProgramacionData(
        fHoraSalida: json["fHoraSalida"],
        tServicio: json["tServicio"],
        iCapacidad: json["iCapacidad"],
        tRuta: json["tRuta"],
        tFecha: json["tFecha"],
        tPrecio: json["tPrecio"],
        iDProgramacion: json["iDProgramacion"],
        iDProgramacionFecha: json["iDProgramacionFecha"],
        iNumeroViaje: json["iNumeroViaje"],
        iMModeloTransporte: json["iMModeloTransporte"],
        tPlaca: json["tPlaca"],
      );

  Map<String, dynamic> toJson() => {
        "fHoraSalida": fHoraSalida,
        "tServicio": tServicio,
        "iCapacidad": iCapacidad,
        "tRuta": tRuta,
        "tFecha": tFecha,
        "tPrecio": tPrecio,
        "iDProgramacion": iDProgramacion,
        "iDProgramacionFecha": iDProgramacionFecha,
        "iNumeroViaje": iNumeroViaje,
        "iMModeloTransporte": iMModeloTransporte,
        "tPlaca": tPlaca,
      };
}
