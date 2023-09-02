// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iDCajaDiariaDetalle": 707017,
//             "fFecha": "09:36",
//             "tDescripcion": "PAGO CUOTA 1",
//             "tNombreCliente": "VIA QUISPE MICHAEL KARLO",
//             "nEfectivo": 100.00,
//             "nTarjeta": 0.00,
//             "nNotaCredito": 0.00,
//             "nImporte": 100.00,
//             "iEstado": 1,
//             "tTipoComprobante": "",
//             "tNroComprobante": ""
//         },
//         {
//             "iDCajaDiariaDetalle": 707022,
//             "fFecha": "09:40",
//             "tDescripcion": "PAGO CUOTA 1",
//             "tNombreCliente": "VIA QUISPE MICHAEL KARLO",
//             "nEfectivo": 100.00,
//             "nTarjeta": 0.00,
//             "nNotaCredito": 0.00,
//             "nImporte": 100.00,
//             "iEstado": 1,
//             "tTipoComprobante": "",
//             "tNroComprobante": ""
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Caja/GetCajaDiariaDetalle?iDCajaDiaria=91121&iTipo=1

import 'dart:convert';

GetCajaDiariaDetalle getCajaDiariaDetalleFromJson(String str) => GetCajaDiariaDetalle.fromJson(json.decode(str));

String getCajaDiariaDetalleToJson(GetCajaDiariaDetalle data) => json.encode(data.toJson());

class GetCajaDiariaDetalle {
  GetCajaDiariaDetalle({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<Datum> data;

  factory GetCajaDiariaDetalle.fromJson(Map<String, dynamic> json) => GetCajaDiariaDetalle(
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
    required this.iDCajaDiariaDetalle,
    required this.fFecha,
    required this.tMotivo,
    required this.tDescripcion,
    required this.tNombreCliente,
    required this.nEfectivo,
    required this.nTarjeta,
    required this.nNotaCredito,
    required this.nImporte,
    required this.iEstado,
    required this.tTipoComprobante,
    required this.tNroComprobante,
  });

  int iDCajaDiariaDetalle;
  String fFecha;
  String tMotivo;
  String tDescripcion;
  String tNombreCliente;
  double nEfectivo;
  double nTarjeta;
  double nNotaCredito;
  double nImporte;
  int iEstado;
  String tTipoComprobante;
  String tNroComprobante;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        iDCajaDiariaDetalle: json["iDCajaDiariaDetalle"],
        fFecha: json["fFecha"],
        tMotivo: json["tMotivo"],
        tDescripcion: json["tDescripcion"],
        tNombreCliente: json["tNombreCliente"],
        nEfectivo: json["nEfectivo"],
        nTarjeta: json["nTarjeta"],
        nNotaCredito: json["nNotaCredito"],
        nImporte: json["nImporte"],
        iEstado: json["iEstado"],
        tTipoComprobante: json["tTipoComprobante"],
        tNroComprobante: json["tNroComprobante"],
      );

  Map<String, dynamic> toJson() => {
        "iDCajaDiariaDetalle": iDCajaDiariaDetalle,
        "fFecha": fFecha,
        "tMotivo": tMotivo,
        "tDescripcion": tDescripcion,
        "tNombreCliente": tNombreCliente,
        "nEfectivo": nEfectivo,
        "nTarjeta": nTarjeta,
        "nNotaCredito": nNotaCredito,
        "nImporte": nImporte,
        "iEstado": iEstado,
        "tTipoComprobante": tTipoComprobante,
        "tNroComprobante": tNroComprobante,
      };
}
