// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iMMenu": 15,
//             "tModulo": "PERSONAL",
//             "tNombre": "divide",
//             "tRuta": "",
//             "tIcono": "",
//             "iTipo": 2
//         },
//         {
//             "iMMenu": 1,
//             "tModulo": "PERSONAL",
//             "tNombre": "Cuenta",
//             "tRuta": "navprincipal",
//             "tIcono": "person",
//             "iTipo": 1
//         },
//         {
//             "iMMenu": 2,
//             "tModulo": "PERSONAL",
//             "tNombre": "Cambiar Contraseña",
//             "tRuta": "",
//             "tIcono": "key",
//             "iTipo": 1
//         },
//         {
//             "iMMenu": 17,
//             "tModulo": "RESTAURANTE",
//             "tNombre": "divide",
//             "tRuta": "",
//             "tIcono": "",
//             "iTipo": 2
//         },
//         {
//             "iMMenu": 5,
//             "tModulo": "RESTAURANTE",
//             "tNombre": "Mesa",
//             "tRuta": "navniveles",
//             "tIcono": "restaurant_rounded",
//             "iTipo": 1
//         },
//         {
//             "iMMenu": 6,
//             "tModulo": "RESTAURANTE",
//             "tNombre": "Test Impresión",
//             "tRuta": "",
//             "tIcono": "print_rounded",
//             "iTipo": 1
//         },
//         {
//             "iMMenu": 10,
//             "tModulo": "RESTAURANTE",
//             "tNombre": "Para llevar",
//             "tRuta": "",
//             "tIcono": "check_box_outline_blank",
//             "iTipo": 1
//         },
//         {
//             "iMMenu": 11,
//             "tModulo": "RESTAURANTE",
//             "tNombre": "Delivery",
//             "tRuta": "",
//             "tIcono": "motorcycle_outlined",
//             "iTipo": 1
//         },
//         {
//             "iMMenu": 18,
//             "tModulo": "TRANSPORTE",
//             "tNombre": "divide",
//             "tRuta": "",
//             "tIcono": "",
//             "iTipo": 2
//         },
//         {
//             "iMMenu": 12,
//             "tModulo": "TRANSPORTE",
//             "tNombre": "Registro Boleto Viaje",
//             "tRuta": "navtrans_registrarBoleto",
//             "tIcono": "airplane_ticket_rounded",
//             "iTipo": 1
//         },
//         {
//             "iMMenu": 13,
//             "tModulo": "TRANSPORTE",
//             "tNombre": "Orden de Traslado",
//             "tRuta": "navtrans_ordenTrasladoLista",
//             "tIcono": "transfer_within_a_station_outlined",
//             "iTipo": 1
//         },
//         {
//             "iMMenu": 19,
//             "tModulo": "CAJA",
//             "tNombre": "divide",
//             "tRuta": "",
//             "tIcono": "",
//             "iTipo": 2
//         },
//         {
//             "iMMenu": 14,
//             "tModulo": "CAJA",
//             "tNombre": "Caja",
//             "tRuta": "navcaja_cajaChica",
//             "tIcono": "monetization_on_rounded",
//             "iTipo": 1
//         },
//         {
//             "iMMenu": 16,
//             "tModulo": "SOPORTE",
//             "tNombre": "divide",
//             "tRuta": "",
//             "tIcono": "",
//             "iTipo": 2
//         },
//         {
//             "iMMenu": 3,
//             "tModulo": "SOPORTE",
//             "tNombre": "Soporte",
//             "tRuta": "",
//             "tIcono": "question_mark",
//             "iTipo": 1
//         },
//         {
//             "iMMenu": 4,
//             "tModulo": "SOPORTE",
//             "tNombre": "Configurar Impresora",
//             "tRuta": "navSettings",
//             "tIcono": "settings",
//             "iTipo": 1
//         }
//     ]
// }

// https://localhost:44339/Maestro/GetNavBarRight?iMUsuario=6348

import 'dart:convert';

GetNavBarRight getNavBarRightFromJson(String str) => GetNavBarRight.fromJson(json.decode(str));

String getNavBarRightToJson(GetNavBarRight data) => json.encode(data.toJson());

class GetNavBarRight {
  GetNavBarRight({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<NavRightData> data;

  factory GetNavBarRight.fromJson(Map<String, dynamic> json) => GetNavBarRight(
        code: json["code"],
        message: json["message"],
        data: List<NavRightData>.from(json["data"].map((x) => NavRightData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class NavRightData {
  NavRightData({
    required this.iMMenu,
    required this.tModulo,
    required this.tNombre,
    required this.tRuta,
    required this.tIcono,
    required this.iTipo,
  });

  int iMMenu;
  String tModulo;
  String tNombre;
  String tRuta;
  String tIcono;
  int iTipo;

  factory NavRightData.fromJson(Map<String, dynamic> json) => NavRightData(
        iMMenu: json["iMMenu"],
        tModulo: json["tModulo"],
        tNombre: json["tNombre"],
        tRuta: json["tRuta"],
        tIcono: json["tIcono"],
        iTipo: json["iTipo"],
      );

  Map<String, dynamic> toJson() => {
        "iMMenu": iMMenu,
        "tModulo": tModulo,
        "tNombre": tNombre,
        "tRuta": tRuta,
        "tIcono": tIcono,
        "iTipo": iTipo,
      };
}
