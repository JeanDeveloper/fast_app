import 'dart:convert';

ImpresionFormatos impresionFormatosFromJson(String str) => ImpresionFormatos.fromJson(json.decode(str));

String impresionFormatosToJson(ImpresionFormatos data) => json.encode(data.toJson());

class ImpresionFormatos {
  ImpresionFormatos({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  Data data;

  factory ImpresionFormatos.fromJson(Map<String, dynamic> json) => ImpresionFormatos(
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.formatos,
  });

  List<FormatoLista> formatos;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        formatos: List<FormatoLista>.from(json["formatos"].map((x) => FormatoLista.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "formatos": List<dynamic>.from(formatos.map((x) => x.toJson())),
      };
}

class FormatoLista {
  FormatoLista({
    required this.tImpresora,
    required this.tPdf,
  });

  String tImpresora;
  String tPdf;

  factory FormatoLista.fromJson(Map<String, dynamic> json) => FormatoLista(
        tImpresora: json["tImpresora"],
        tPdf: json["tPdf"],
      );

  Map<String, dynamic> toJson() => {
        "tImpresora": tImpresora,
        "tPdf": tPdf,
      };
}
