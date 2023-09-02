// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iMMenu": 1,
//             "tModulo": "PERSONAL",
//             "tNombre": "Cuenta",
//             "tRuta": "navprincipal",
//             "tIcono": "person"
//         },
//         {
//             "iMMenu": 2,
//             "tModulo": "PERSONAL",
//             "tNombre": "Cambiar Contraseña",
//             "tRuta": "",
//             "tIcono": "key"
//         },
//         {
//             "iMMenu": 5,
//             "tModulo": "RESTAURANTE",
//             "tNombre": "Mesa",
//             "tRuta": "navniveles",
//             "tIcono": "restaurant_rounded"
//         },
//         {
//             "iMMenu": 6,
//             "tModulo": "RESTAURANTE",
//             "tNombre": "Test Impresión",
//             "tRuta": "",
//             "tIcono": "print_rounded"
//         },
//         {
//             "iMMenu": 10,
//             "tModulo": "RESTAURANTE",
//             "tNombre": "Para llevar",
//             "tRuta": "",
//             "tIcono": "check_box_outline_blank"
//         },
//         {
//             "iMMenu": 11,
//             "tModulo": "RESTAURANTE",
//             "tNombre": "Delivery",
//             "tRuta": "",
//             "tIcono": "motorcycle_outlined"
//         },
//         {
//             "iMMenu": 12,
//             "tModulo": "TRANSPORTE",
//             "tNombre": "Registro Boleto Viaje",
//             "tRuta": "navtrans_registrarBoleto",
//             "tIcono": "airplane_ticket_rounded"
//         },
//         {
//             "iMMenu": 13,
//             "tModulo": "TRANSPORTE",
//             "tNombre": "Orden de Traslado",
//             "tRuta": "navtrans_ordenTrasladoLista",
//             "tIcono": "transfer_within_a_station_outlined"
//         },
//         {
//             "iMMenu": 14,
//             "tModulo": "CAJA",
//             "tNombre": "Caja",
//             "tRuta": "navcaja_cajaChica",
//             "tIcono": "monetization_on_rounded"
//         },
//         {
//             "iMMenu": 3,
//             "tModulo": "SOPORTE",
//             "tNombre": "Soporte",
//             "tRuta": "",
//             "tIcono": "question_mark"
//         },
//         {
//             "iMMenu": 4,
//             "tModulo": "SOPORTE",
//             "tNombre": "Configurar Impresora",
//             "tRuta": "navSettings",
//             "tIcono": "settings"
//         }
//     ]
// }

// https://localhost:44339/Maestro/GetMenuPrincipal?iMUsuario=6348

import 'dart:convert';

GetMenuPrincipal getMenuPrincipalFromJson(String str) => GetMenuPrincipal.fromJson(json.decode(str));

String getMenuPrincipalToJson(GetMenuPrincipal data) => json.encode(data.toJson());

class GetMenuPrincipal {
  GetMenuPrincipal({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<MenuData> data;

  factory GetMenuPrincipal.fromJson(Map<String, dynamic> json) => GetMenuPrincipal(
        code: json["code"],
        message: json["message"],
        data: List<MenuData>.from(json["data"].map((x) => MenuData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class MenuData {
  MenuData({
    required this.iMMenu,
    required this.tModulo,
    required this.tNombre,
    required this.tRuta,
    required this.tIcono,
  });

  int iMMenu;
  String tModulo;
  String tNombre;
  String tRuta;
  String tIcono;

  factory MenuData.fromJson(Map<String, dynamic> json) => MenuData(
        iMMenu: json["iMMenu"],
        tModulo: json["tModulo"],
        tNombre: json["tNombre"],
        tRuta: json["tRuta"],
        tIcono: json["tIcono"],
      );

  Map<String, dynamic> toJson() => {
        "iMMenu": iMMenu,
        "tModulo": tModulo,
        "tNombre": tNombre,
        "tRuta": tRuta,
        "tIcono": tIcono,
      };
}
