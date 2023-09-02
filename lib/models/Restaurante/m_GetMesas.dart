// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iMMesa": 232,
//             "tMesa": "MESA 1",
//             "tColor": "#B91308",
//             "tEstado": "OCUPADO",
//             "tHora": "8:05AM",
//             "nImporte": 54.00,
//             "tCliente": "NIKA",
//             "iPax": 2
//         },
//         {
//             "iMMesa": 243,
//             "tMesa": "MESA 7",
//             "tColor": "#00693D",
//             "tEstado": "DISPONIBLE",
//             "tHora": "",
//             "nImporte": 0.00,
//             "tCliente": "",
//             "iPax": 10
//         }
//     ]
// }

// http://apimovil.sistemafast.pe/Restaurante/GetMesas?iMSalon=43

import 'dart:convert';

MGetMesas mGetMesasFromJson(String str) => MGetMesas.fromJson(json.decode(str));

String mGetMesasToJson(MGetMesas data) => json.encode(data.toJson());

class MGetMesas {
  MGetMesas({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<MesasData> data;

  factory MGetMesas.fromJson(Map<String, dynamic> json) => MGetMesas(
        code: json["code"],
        message: json["message"],
        data: List<MesasData>.from(json["data"].map((x) => MesasData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class MesasData {
  MesasData({
    this.iMMesa,
    this.tMesa,
    this.tColor,
    this.tEstado,
    this.tHora,
    this.nImporte,
    this.tCliente,
    this.iPax,
    this.iDPedido,
    this.tMesaUnion,
    this.lUnion,
    this.iPrincipal,
  });

  int? iMMesa;
  String? tMesa;
  String? tColor;
  String? tEstado;
  String? tHora;
  double? nImporte;
  String? tCliente;
  int? iPax;
  int? iDPedido;
  String? tMesaUnion;
  bool? lUnion;
  int? iPrincipal;

  factory MesasData.fromJson(Map<String, dynamic> json) => MesasData(
        iMMesa: json["iMMesa"],
        tMesa: json["tMesa"],
        tColor: json["tColor"],
        tEstado: json["tEstado"],
        tHora: json["tHora"],
        nImporte: json["nImporte"],
        tCliente: json["tCliente"],
        iPax: json["iPax"],
        iDPedido: json["iDPedido"],
        tMesaUnion: json["tMesaUnion"],
        lUnion: json["lUnion"],
        iPrincipal: json["iPrincipal"],
      );

  Map<String, dynamic> toJson() => {
        "iMMesa": iMMesa,
        "tMesa": tMesa,
        "tColor": tColor,
        "tEstado": tEstado,
        "tHora": tHora,
        "nImporte": nImporte,
        "tCliente": tCliente,
        "iPax": iPax,
        "iDPedido": iDPedido,
        "tMesaUnion": tMesaUnion,
        "lUnion": false,
        "iPrincipal": 0,
      };
}
