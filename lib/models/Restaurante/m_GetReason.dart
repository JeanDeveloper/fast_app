import 'dart:convert';

GetReason getReasonFromJson(String str) => GetReason.fromJson(json.decode(str));

String getReasonToJson(GetReason data) => json.encode(data.toJson());

class GetReason {
    int code;
    String message;
    List<Data> data;

    GetReason({
        required this.code,
        required this.message,
        required this.data,
    });

    factory GetReason.fromJson(Map<String, dynamic> json) => GetReason(
        code: json["code"],
        message: json["message"],
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Data {
    int iMMotivoBajaPedido;
    String tDescripcion;

    Data({
        required this.iMMotivoBajaPedido,
        required this.tDescripcion,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        iMMotivoBajaPedido: json["iMMotivoBajaPedido"],
        tDescripcion: json["tDescripcion"],
    );

    Map<String, dynamic> toJson() => {
        "iMMotivoBajaPedido": iMMotivoBajaPedido,
        "tDescripcion": tDescripcion,
    };
}
