// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iMPasajero": 968676,
//             "tPasajeroDoc": "46392002",
//             "tPasajeroTipoDoc": "1",
//             "tPasajero": "VIA QUISPE MICHAEL KARLO",
//             "tFechaViaje": "29/01/2023",
//             "tHoraViaje": " 7:00:00 AM"
//         }
//     ]
// }

import 'dart:convert';

GetObtenerDatosBoleto getObtenerDatosBoletoFromJson(String str) => GetObtenerDatosBoleto.fromJson(json.decode(str));

String getObtenerDatosBoletoToJson(GetObtenerDatosBoleto data) => json.encode(data.toJson());

class GetObtenerDatosBoleto {
  GetObtenerDatosBoleto({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<Datum> data;

  factory GetObtenerDatosBoleto.fromJson(Map<String, dynamic> json) => GetObtenerDatosBoleto(
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
    required this.iMPasajero,
    required this.tPasajeroDoc,
    required this.tPasajeroTipoDoc,
    required this.tPasajero,
    required this.tFechaViaje,
    required this.tHoraViaje,
    required this.iDProgramacion,
    required this.iDProgramacionFecha,
    required this.iDProgramacionPrecio,
    required this.tUbicacionPdf,
    required this.nDescuento,
    required this.iMCodigoVenta,
    required this.nPrecio,
    required this.nTotalPagar,
    required this.lVentaGratuita,
    required this.tSerie,
    required this.tNumero,
    required this.tRuta,
  });

  int iMPasajero;
  String tPasajeroDoc;
  String tPasajeroTipoDoc;
  String tPasajero;
  String tFechaViaje;
  String tHoraViaje;
  int iDProgramacion;
  int iDProgramacionFecha;
  int iDProgramacionPrecio;
  String tUbicacionPdf;
  int nDescuento;
  int iMCodigoVenta;
  double nPrecio;
  double nTotalPagar;
  bool lVentaGratuita;
  String tSerie;
  String tNumero;
  String tRuta;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        iMPasajero: json["iMPasajero"],
        tPasajeroDoc: json["tPasajeroDoc"],
        tPasajeroTipoDoc: json["tPasajeroTipoDoc"],
        tPasajero: json["tPasajero"],
        tFechaViaje: json["tFechaViaje"],
        tHoraViaje: json["tHoraViaje"],
        iDProgramacion: json["iDProgramacion"],
        iDProgramacionFecha: json["iDProgramacionFecha"],
        iDProgramacionPrecio: json["iDProgramacionPrecio"],
        tUbicacionPdf: json["tUbicacionPdf"],
        nDescuento: json["nDescuento"].truncate(),
        iMCodigoVenta: json["iMCodigoVenta"],
        nPrecio: json["nPrecio"].toDouble(),
        nTotalPagar: json["nTotalPagar"].toDouble(),
        lVentaGratuita: json["lVentaGratuita"],
        tSerie: json["tSerie"],
        tNumero: json["tNumero"],
        tRuta: json["tRuta"],
      );

  Map<String, dynamic> toJson() => {
        "iMPasajero": iMPasajero,
        "tPasajeroDoc": tPasajeroDoc,
        "tPasajeroTipoDoc": tPasajeroTipoDoc,
        "tPasajero": tPasajero,
        "tFechaViaje": tFechaViaje,
        "tHoraViaje": tHoraViaje,
        "iDProgramacion": iDProgramacion,
        "iDProgramacionFecha": iDProgramacionFecha,
        "iDProgramacionPrecio": iDProgramacionPrecio,
        "tUbicacionPdf": tUbicacionPdf,
        "nDescuento": nDescuento,
        "iMCodigoVenta": iMCodigoVenta,
        "nPrecio": nPrecio,
        "nTotalPagar": nTotalPagar,
        "lVentaGratuita": lVentaGratuita,
        "tSerie": tSerie,
        "tNumero": tNumero,
        "tRuta": tRuta,
      };
}
