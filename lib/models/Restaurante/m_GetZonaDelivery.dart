// http://138.128.247.60/sertechalfa.pe/Restaurante/GetZona?iDSucursal=542

// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iMZonaDelivery": 2,
//             "tZona": "AAAA",
//             "iPrecio": 4.00,
//             "iMProductoDelivery": 1569034
//         },
//         {
//             "iMZonaDelivery": 3,
//             "tZona": "BBB",
//             "iPrecio": 3.00,
//             "iMProductoDelivery": 1569034
//         },
//         {
//             "iMZonaDelivery": 4,
//             "tZona": "CCCC",
//             "iPrecio": 6.00,
//             "iMProductoDelivery": 1569034
//         },
//         {
//             "iMZonaDelivery": 5,
//             "tZona": "DDDD",
//             "iPrecio": 12.00,
//             "iMProductoDelivery": 1569034
//         }
//     ]
// }
import 'dart:convert';

GetZona getZonaFromJson(String str) => GetZona.fromJson(json.decode(str));

String getZonaToJson(GetZona data) => json.encode(data.toJson());

class GetZona {
  GetZona({
    this.code,
    this.message,
    this.data,
  });

  int? code;
  String? message;
  List<ZonaDeliveryData>? data;

  factory GetZona.fromJson(Map<String, dynamic> json) => GetZona(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null ? [] : List<ZonaDeliveryData>.from(json["data"]!.map((x) => ZonaDeliveryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ZonaDeliveryData {
  ZonaDeliveryData({
    this.iMZonaDelivery,
    this.tZona,
    this.iPrecio,
    this.iMProductoDelivery,
  });

  int? iMZonaDelivery;
  String? tZona;
  double? iPrecio;
  int? iMProductoDelivery;

  factory ZonaDeliveryData.fromJson(Map<String, dynamic> json) => ZonaDeliveryData(
        iMZonaDelivery: json["iMZonaDelivery"],
        tZona: json["tZona"],
        iPrecio: json["iPrecio"],
        iMProductoDelivery: json["iMProductoDelivery"],
      );

  Map<String, dynamic> toJson() => {
        "iMZonaDelivery": iMZonaDelivery,
        "tZona": tZona,
        "iPrecio": iPrecio,
        "iMProductoDelivery": iMProductoDelivery,
      };
}
