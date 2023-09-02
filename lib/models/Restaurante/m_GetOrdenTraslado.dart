import 'dart:convert';

GetOrdenTraslado getOrdenTrasladoFromJson(String str) => GetOrdenTraslado.fromJson(json.decode(str));

String getOrdenTrasladoToJson(GetOrdenTraslado data) => json.encode(data.toJson());

class GetOrdenTraslado {
  GetOrdenTraslado({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<Datum> data;

  factory GetOrdenTraslado.fromJson(Map<String, dynamic> json) => GetOrdenTraslado(
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
    required this.iMOrden,
    required this.iNumero,
    required this.tSerie,
    required this.tNumero,
    required this.tRemitente,
    required this.tConsignado,
    required this.lPAnticipado,
    required this.tOrigen,
    required this.tDestino,
    required this.tFecha,
    required this.tHora,
    required this.iImporteTotal,
  });

  int iMOrden;
  int iNumero;
  String tSerie;
  String tNumero;
  String tRemitente;
  String tConsignado;
  bool lPAnticipado;
  String tOrigen;
  String tDestino;
  String tFecha;
  String tHora;
  double iImporteTotal;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        iMOrden: json["iMOrden"],
        iNumero: json["iNumero"],
        tSerie: json["tSerie"],
        tNumero: json["tNumero"],
        tRemitente: json["tRemitente"],
        tConsignado: json["tConsignado"],
        lPAnticipado: json["lPAnticipado"],
        tOrigen: json["tOrigen"],
        tDestino: json["tDestino"],
        tFecha: json["tFecha"],
        tHora: json["tHora"],
        iImporteTotal: json["iImporteTotal"],
      );

  Map<String, dynamic> toJson() => {
        "iMOrden": iMOrden,
        "iNumero": iNumero,
        "tSerie": tSerie,
        "tNumero": tNumero,
        "tRemitente": tRemitente,
        "tConsignado": tConsignado,
        "lPAnticipado": lPAnticipado,
        "tOrigen": tOrigen,
        "tDestino": tDestino,
        "tFecha": tFecha,
        "tHora": tHora,
        "iImporteTotal": iImporteTotal,
      };
}
