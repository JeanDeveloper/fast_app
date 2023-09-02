import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fast/models/Restaurante/m_GetCartaCategoria.dart';
import 'package:fast/models/Restaurante/m_GetCartaProductos.dart';
import 'package:fast/models/Maestro/m_GetFormatosEmpresas.dart';
import 'package:fast/models/Restaurante/m_GetClienteDelivery.dart';
import 'package:fast/models/Restaurante/m_GetImpresionFormatos.dart';
import 'package:fast/models/Restaurante/m_GetMesas.dart';
import 'package:fast/models/Restaurante/m_GetNiveles.dart';
import 'package:fast/models/Restaurante/m_GetOrdenLlevar.dart';
import 'package:fast/models/Restaurante/m_GetOrdenMesa.dart';
import 'package:fast/models/Restaurante/m_GetOrdenProductoMesa.dart';
import 'package:fast/models/Restaurante/m_GetParaLlevarDelivery.dart';
import 'package:fast/models/Restaurante/m_GetReason.dart';
import 'package:fast/models/Restaurante/m_GetZonaDelivery.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Restaurante.dart' as vGlobal_Restaurante;
import 'package:fast/providers/options.dart' as vOptions;

Future<MGetNiveles?> get getNiveles async {
  String tEmpresa = vGlobal.tEmpresaRuc.toString();
  String tSucursal = vGlobal.iDSucursal.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/GetNiveles?tEmpresaRuc=$tEmpresa&iDSucursal=$tSucursal'),
    //Uri.parse('${vGlobal.urlAPI}/Habilitaciones/MisHabilitaciones?iMUsuario=33640&iMEmpresa=1'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    return mGetNivelesFromJson(response.body);
  }
  return null;
}

Future<List<ZonaDeliveryData>?> loadZonaDelivery() async {
  String iDSucursal = vGlobal.iDSucursal.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/GetZona?iDSucursal=$iDSucursal'),
    headers: {
      "Authorization": "Bearer ${vGlobal.token}",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "content-type": "application/json",
      "Accept": "application/json",
    },
  );
  if (response.statusCode == 200) {
    var sZona = getZonaFromJson(response.body);
    if (sZona.code == 0) {
      if (sZona.data!.isNotEmpty) {
        vGlobal_Restaurante.listZonaDelivery = sZona.data!;
      }
    }
  }
}

Future<MGetMesas?> get getMesas async {
  String tSalon = vGlobal_Restaurante.iMSalon.toString();
  final response =  await http.get(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/GetMesas?iMSalon=$tSalon'),
    //Uri.parse('${vGlobal.urlAPI}/Habilitaciones/MisHabilitaciones?iMUsuario=33640&iMEmpresa=1'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    // return compute(mGetMesasFromJson, response.body);
    return mGetMesasFromJson(response.body);
  }
  return null;
}

Future<GetParaLlevarDelivery?> getParaLlevarDelivery(int canal) async {
  String iDSucursal = vGlobal.iDSucursal.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/GetParaLlevarDelivery?iMCanal=$canal&iDSucursal=$iDSucursal'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    // return compute(mGetMesasFromJson, response.body);
    return getParaLlevarDeliveryFromJson(response.body);
  }
  return null;
}

Future<MGetOrdenProductoMesa?> GetOrdenProductoMesa(String? iDPedidoDetalle) async {
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/GetOrdenProductoMesa?iDPedidoDetalle=$iDPedidoDetalle'),
    //Uri.parse('${vGlobal.urlAPI}/Habilitaciones/MisHabilitaciones?iMUsuario=33640&iMEmpresa=1'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );
  print(response.body);
  if (response.statusCode == 200) {
    return mGetOrdenProductoMesaFromJson(response.body);
  }
  return null;
}

Future<MGetOrdenMesa?> get getOrdenMesa async {
  String tEmpresa = vGlobal.tEmpresaRuc.toString();
  String tiMMesa = vGlobal_Restaurante.iMMesa.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/GetOrdenMesa?iMMesa=$tiMMesa&tEmpresaRuc=$tEmpresa'),
    //Uri.parse('${vGlobal.urlAPI}/Habilitaciones/MisHabilitaciones?iMUsuario=33640&iMEmpresa=1'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    vGlobal_Restaurante.iPrecuenta = 0;
    print(mGetOrdenMesaFromJson(response.body).data.length);
    return mGetOrdenMesaFromJson(response.body);
  }
  return null;
}

Future<GetOrdenLlevar?> get getOrdenLlevar async {
  String tEmpresa = vGlobal.tEmpresaRuc.toString();
  String iIDPedido = vGlobal_Restaurante.iIDPedido.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/GetOrdenLlevar?iDPedido=$iIDPedido&tEmpresaRuc=$tEmpresa'),
    //Uri.parse('${vGlobal.urlAPI}/Habilitaciones/MisHabilitaciones?iMUsuario=33640&iMEmpresa=1'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    vGlobal_Restaurante.iPrecuenta = 0;
    print(getOrdenLlevarFromJson(response.body).data!.length);
    return getOrdenLlevarFromJson(response.body);
  }
  return null;
}

Future<Map<String, dynamic>?> postGenerarOrden(String tCliente, int iPax) async {
  Map<String, dynamic> resp = {};
  var map = new Map<String, dynamic>();
  map['iMMesa'] = vGlobal_Restaurante.iMMesa;
  map['tCliente'] = tCliente.toString();
  map['iPax'] = iPax;
  map['tEmpresaRuc'] = vGlobal.tEmpresaRuc.toString();
  map['iDSucursal'] = vGlobal.iDSucursal;
  map['iUsuarioRegistro'] = vGlobal.iMUsuario;
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/PostGenerarOrden?'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      "iMMesa": vGlobal_Restaurante.iMMesa.toString(),
      "tCliente": tCliente.toString(),
      "iPax": iPax.toString(),
      "tEmpresaRuc": vGlobal.tEmpresaRuc,
      "iDSucursal": vGlobal.iDSucursal.toString(),
      "iUsuarioRegistro": vGlobal.iMUsuario.toString()
    },
  );
  print(response);
  if (response.body.isNotEmpty) {
    int code = jsonDecode(response.body)["code"];
    final message = jsonDecode(response.body)["message"];
    int? iDDetalle = jsonDecode(response.body)["data"]["iDPedido"];
    resp = {
      "codigo": code, 
      "mensaje": message, 
      "iDDetalle": iDDetalle
    };
    return resp;
  }
  return null;
}

Future<Map<String, dynamic>?> getPrecuenta() async {
  Map<String, dynamic> resp = {};
  final response = await http.get(
    Uri.parse(
        '${vGlobal.urlAPI}/Restaurante/GetPedido_GenerarPdf?iDPedido=${vGlobal_Restaurante.iIDPedido.toString()}&iDFormato=${vGlobal_Restaurante.iDFormatoPrecuenta.toString()}&iConexion=${vOptions.tipoConexion.toString()}&tipo=PRECUENTA'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
  );
  print(response);
  if (response.body.isNotEmpty) {
    int code = jsonDecode(response.body)["code"];
    final message = jsonDecode(response.body)["message"];
    if (vOptions.tipoConexion == 1) {
      String? tImpresora = jsonDecode(response.body)["data"]["formatos"][0]["tImpresora"];
      String? tPdf = jsonDecode(response.body)["data"]["formatos"][0]["tPdf"];
      resp = {"codigo": code, "mensaje": message, "tImpresora": tImpresora, "tPdf": tPdf};
    } else {
      resp = {"codigo": code, "mensaje": message};
    }
    return resp;
  }
  return null;
}

Future<Map<String, dynamic>?> PutAnularOrden(String Productos) async {
  Map<String, dynamic> resp = {};
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  final response = await http.put(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/PutAnularOrden'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      "iDPedido": vGlobal_Restaurante.iIDPedido.toString(),
      "productos": Productos,
      "iUsuarioRegistro": vGlobal.iMUsuario.toString(),
      "iDFormatoAnulacion": vGlobal_Restaurante.iDFormatoAnulacion.toString(),
      "iConexion": vOptions.tipoConexion.toString(),
      "iUsuario": vGlobal.iMUsuario.toString(),
      "tAndroInfo": androidInfo.model.toString()
    },
  );
  print(response);
  if (response.body.isNotEmpty) {
    int code = jsonDecode(response.body)["code"];
    final message = jsonDecode(response.body)["message"];
    if (vOptions.tipoConexion == 1) {
      String? tImpresora;
      String? tPdf;
      if (code == 0 || code == -6) {
        tImpresora = jsonDecode(response.body)["data"]["formatos"][0]["tImpresora"];
        tPdf = jsonDecode(response.body)["data"]["formatos"][0]["tPdf"];
      } else {
        tImpresora = "";
        tPdf = "";
      }

      resp = {"codigo": code, "mensaje": message, "tImpresora": tImpresora, "tPdf": tPdf};
    } else {
      resp = {"codigo": code, "mensaje": message};
    }
    return resp;
  }
  return null;
}




//PUTANULARORDEN QA

Future<Map<String, dynamic>?> PutAnularOrdenQA(String Productos) async {
  Map<String, dynamic> resp = {};
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  final response = await http.put(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/PutAnularOrdenQA'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {   
      "iDPedido": vGlobal_Restaurante.iIDPedido.toString(),
      "productos": Productos,
      "iUsuarioRegistro": vGlobal.iMUsuario.toString(),
      "iDFormatoAnulacion": vGlobal_Restaurante.iDFormatoAnulacion.toString(),
      "iConexion": vOptions.tipoConexion.toString(),
      "iUsuario": vGlobal.iMUsuario.toString(),
      "tAndroInfo": androidInfo.model.toString(),
      "reasonID": vGlobal_Restaurante.tMotivoAnulacion!.iMMotivoBajaPedido.toString(),
    },
  );
  print(response);
  if (response.body.isNotEmpty) {
    int code = jsonDecode(response.body)["code"];
    final message = jsonDecode(response.body)["message"];
    if (vOptions.tipoConexion == 1) {
      String? tImpresora;
      String? tPdf;
      if (code == 0 || code == -6) {
        tImpresora = jsonDecode(response.body)["data"]["formatos"][0]["tImpresora"];
        tPdf = jsonDecode(response.body)["data"]["formatos"][0]["tPdf"];
      } else {
        tImpresora = "";
        tPdf = "";
      }

      resp = {"codigo": code, "mensaje": message, "tImpresora": tImpresora, "tPdf": tPdf};
    } else {
      resp = {"codigo": code, "mensaje": message};
    }
    return resp;
  }
  return null;
}

Future<Map<String, dynamic>?> postAgregarItemOrden() async {
  Map<String, dynamic> resp = {};
  // Map<String, dynamic> Items = {"Items": vGlobal.listPrecuenta};
  List<Map<String, dynamic>> pre = vGlobal_Restaurante.listPrecuenta;
  // pre.forEach((item) => item..remove("tProducto"));
  Map<String, dynamic> Items = {"Items": pre};
  String tItems = jsonEncode(Items);
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  print(tItems);
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/PostAgregarItemOrden'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      "iDPedido": vGlobal_Restaurante.iIDPedido.toString(),
      "productos": tItems,
      "iDFormatoOrden": vGlobal_Restaurante.iDFormatoOrden.toString(),
      "iConexion": vOptions.tipoConexion.toString(),
      "iUsuario": vGlobal.iMUsuario.toString(),
      "tAndroInfo": androidInfo.model.toString()
    },
  );
  print(response);
  if (response.body.isNotEmpty) {
    int code = jsonDecode(response.body)["code"];
    final message = jsonDecode(response.body)["message"];
    if (vOptions.tipoConexion == 1) {
      List<FormatoLista>? Impresoras = null;
      if (code == 0) {
        Impresoras = impresionFormatosFromJson(response.body).data.formatos;
      }
      resp = {"codigo": code, "mensaje": message, "tImpresora": Impresoras};
    } else {
      resp = {"codigo": code, "mensaje": message};
    }
    return resp;
  }
  return null;
}

Future<Map<String, dynamic>?> postGenerarOrdenLlevar() async {
  Map<String, dynamic> resp = {};
  // Map<String, dynamic> Items = {"Items": vGlobal.listPrecuenta};
  List<Map<String, dynamic>> pre = vGlobal_Restaurante.listPrecuenta;
  // pre.forEach((item) => item..remove("tProducto"));
  Map<String, dynamic> Items = {"Items": pre};
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  String tItems = jsonEncode(Items);
  print(tItems);
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/PostGenerarOrdenLlevar'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      "iDPedido": vGlobal_Restaurante.iIDPedido.toString(),
      "iDFormatoOrden": vGlobal_Restaurante.iDFormatoOrden.toString(),
      "productos": tItems,
      "iConexion": vOptions.tipoConexion.toString(),
      "tCliente": vGlobal_Restaurante.tCliente.toString(),
      "tEmpresaRuc": vGlobal.tEmpresaRuc.toString(),
      "iDSucursal": vGlobal.iDSucursal.toString(),
      "iUsuarioRegistro": vGlobal.iMUsuario.toString(),
      "tVersionApp": vGlobal.tVersionActual.toString(),
      "tAndroInfo": androidInfo.model.toString()
    },
  );
  print(response);
  if (response.body.isNotEmpty) {
    int code = jsonDecode(response.body)["code"];
    final message = jsonDecode(response.body)["message"];
    if (vOptions.tipoConexion == 1) {
      List<FormatoLista>? Impresoras = null;
      if (code == 0) {
        Impresoras = impresionFormatosFromJson(response.body).data.formatos;
      }
      resp = {"codigo": code, "mensaje": message, "tImpresora": Impresoras};
    } else {
      resp = {"codigo": code, "mensaje": message};
    }

    return resp;
  }
  return null;
}

Future<Map<String, dynamic>?> postGenerarOrdenDelivery() async {
  Map<String, dynamic> resp = {};
  // Map<String, dynamic> Items = {"Items": vGlobal.listPrecuenta};
  List<Map<String, dynamic>> pre = vGlobal_Restaurante.listPrecuenta;
  // pre.forEach((item) => item..remove("tProducto"));
  Map<String, dynamic> Items = {"Items": pre};
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  String tItems = jsonEncode(Items);
  print(tItems);
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/PostGenerarOrdenDelivery'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      "iDPedido": vGlobal_Restaurante.iIDPedido.toString(),
      "iDFormatoOrden": vGlobal_Restaurante.iDFormatoOrden.toString(),
      "productos": tItems,
      "iConexion": vOptions.tipoConexion.toString(),
      "tTelefono": vGlobal_Restaurante.delTelefono.toString(),
      "tCliente": vGlobal_Restaurante.delCliente.toString(),
      "tDireccion": vGlobal_Restaurante.delDireccion.toString(),
      "tReferencia": vGlobal_Restaurante.delReferencia.toString(),
      "iZona": vGlobal_Restaurante.deliMZona.toString(),
      "tEmpresaRuc": vGlobal.tEmpresaRuc.toString(),
      "iDSucursal": vGlobal.iDSucursal.toString(),
      "iUsuarioRegistro": vGlobal.iMUsuario.toString(),
      "tVersionApp": vGlobal.tVersionActual.toString(),
      "iUsuario": vGlobal.iMUsuario.toString(),
      "tAndroInfo": androidInfo.model.toString()
    },
  );
  print(response);
  if (response.body.isNotEmpty) {
    int code = jsonDecode(response.body)["code"];
    final message = jsonDecode(response.body)["message"];
    if (vOptions.tipoConexion == 1) {
      List<FormatoLista>? Impresoras = null;
      if (code == 0) {
        Impresoras = impresionFormatosFromJson(response.body).data.formatos;
      }
      resp = {"codigo": code, "mensaje": message, "tImpresora": Impresoras};
    } else {
      resp = {"codigo": code, "mensaje": message};
    }
    return resp;
  }
  return null;
}

Future<List<CartaProductoData>?> getProductos(int iMCategoria, int iMSubCategoria, String filtro) async {
  var listFilter = mGetCartaProductosFromJson(vGlobal_Restaurante.tProductosJson).data;
  String filtro1 = "", filtro2 = "", filtro3 = "", filtro4 = "", filtro5 = "", filtro6 = "";
  if (listFilter!.isNotEmpty) {
    if (iMCategoria != 0) {
      listFilter.removeWhere((element) => element.iMCategoria != iMCategoria);
    }
    if (iMSubCategoria != 0) {
      listFilter.removeWhere((element) => element.iMSubCategoria != iMSubCategoria);
    }
    if (filtro.trim() != "") {
      if (filtro.contains(" ")) {
        filtro1 = filtro.split(" ")[0].toUpperCase();
        try {
          filtro2 = filtro.split(" ")[1].toUpperCase();
        } catch (e) {
          filtro2 = "";
        }
        try {
          filtro3 = filtro.split(" ")[2].toUpperCase();
        } catch (e) {
          filtro3 = "";
        }
        try {
          filtro4 = filtro.split(" ")[3].toUpperCase();
        } catch (e) {
          filtro4 = "";
        }
        try {
          filtro5 = filtro.split(" ")[4].toUpperCase();
        } catch (e) {
          filtro5 = "";
        }
        try {
          filtro6 = filtro.split(" ")[5].toUpperCase();
        } catch (e) {
          filtro6 = "";
        }
        // filtro2 = filtro.split(" ")[1].toUpperCase() ?? "";
        // filtro3 = filtro.split(" ")[2].toUpperCase() ?? "";
        // filtro4 = filtro.split(" ")[3].toUpperCase() ?? "";
        // filtro5 = filtro.split(" ")[4].toUpperCase();
        // filtro6 = filtro.split(" ")[5].toUpperCase();
        listFilter.removeWhere(
          (element) => (!element.tProducto!.toUpperCase().contains(filtro1) ||
              !element.tProducto!.toUpperCase().contains(filtro2) ||
              !element.tProducto!.toUpperCase().contains(filtro3) ||
              !element.tProducto!.toUpperCase().contains(filtro4) ||
              !element.tProducto!.toUpperCase().contains(filtro5) ||
              !element.tProducto!.toUpperCase().contains(filtro6)),
        );
      } else {
        listFilter.removeWhere((element) => !element.tProducto!.toUpperCase().contains(filtro.toUpperCase()));
      }
    }
    return listFilter;
  }
  vGlobal_Restaurante.listProductos = listFilter;
  return null;
}

Future<List<CartaProductoData>?> loadProductos() async {
  String tEmpresa = vGlobal.tEmpresaRuc.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/GetCartaProductos?tEmpresaRuc=$tEmpresa'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    vGlobal_Restaurante.tProductosJson = "";
    if (response.body.isNotEmpty) {
      vGlobal_Restaurante.tProductosJson = response.body;
    }
  }
}

Future<String?> get loadCategoria async {
  String tEmpresa = vGlobal.tEmpresaRuc.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/GetCartaCategoria?tEmpresaRuc=$tEmpresa'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    vGlobal_Restaurante.tCategoriaJson = "";
    vGlobal_Restaurante.tCategoriaJson = response.body;
    vGlobal_Restaurante.labelCategoriaList = List.filled(mGetCartaCategoriaFromJson(response.body.toString()).data.length + 1, "");
    vGlobal_Restaurante.valuesCategoriaList = List.filled(mGetCartaCategoriaFromJson(response.body.toString()).data.length + 1, 0);
    // vGlobal.valuesCategoriaList![0] = 0;
    // vGlobal.labelCategoriaList![0] = "TODOS";
    return response.body;
    //return compute(mGetCartaProductosFromJson, response.body);
  }
  return null;
}

Future<MGetFormatosEmpresas?> get loadFormatos async {
  String tEmpresa = vGlobal.tEmpresaRuc.toString();
  String tiDSucursal = vGlobal.iDSucursal.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/GetFormatosEmpresas?tEmpresaRuc=$tEmpresa&iDSucursal=$tiDSucursal'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    final Postlog = mGetFormatosEmpresasFromJson(response.body);
    var dataLogin = jsonEncode(Postlog);
    var tJsonLogin = mGetFormatosEmpresasFromJson(dataLogin.toString());

    vGlobal_Restaurante.iDFormatoPrecuenta = tJsonLogin.data.iDFormatoPrecuenta;
    vGlobal_Restaurante.iDFormatoOrden = tJsonLogin.data.iDFormatoOrden;
    vGlobal_Restaurante.iDFormatoAnulacion = tJsonLogin.data.iDFormatoAnulacion;
    return mGetFormatosEmpresasFromJson(response.body);
  }
  return null;
}

Future<Map<String, dynamic>?> postUnirMesas(int iPrincipal) async {
  Map<String, dynamic> resp = {};
  Map<String, dynamic> Items = {"Items": vGlobal_Restaurante.ListaMesasNivel};
  String tItems = jsonEncode(Items);
  print(tItems);
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/PostUnirMesas'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {"iMMesaPrincipal": iPrincipal.toString(), "mesas": tItems},
  );
  if (response.body.isNotEmpty) {
    int code = jsonDecode(response.body)["code"];
    final message = jsonDecode(response.body)["message"];

    resp = {"codigo": code, "mensaje": message};
    return resp;
  }
  return null;
}

Future<Map<String, dynamic>?> postDesUnirMesas() async {
  Map<String, dynamic> resp = {};
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/PostDesUnirMesas'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {"iMMesa": vGlobal_Restaurante.iMMesa.toString()},
  );
  if (response.body.isNotEmpty) {
    int code = jsonDecode(response.body)["code"];
    final message = jsonDecode(response.body)["message"];

    resp = {"codigo": code, "mensaje": message};
    return resp;
  }
  return null;
}

Future<Map<String, dynamic>?> postTransferirMesa(int iMMesaDestino) async {
  Map<String, dynamic> resp = {};
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/PostTransferirMesa'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {"iMMesaOrigen": vGlobal_Restaurante.iMMesa.toString(), "iMMesaDestino": iMMesaDestino.toString()},
  );
  if (response.body.isNotEmpty) {
    int code = jsonDecode(response.body)["code"];
    final message = jsonDecode(response.body)["message"];

    resp = {"codigo": code, "mensaje": message};
    return resp;
  }
  return null;
}

Future<Map<String, dynamic>?> postLiberar(int? iMMesa, int? iDPedido) async {
  Map<String, dynamic> resp = {};
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/PostLiberar'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      "iMMesa": iMMesa.toString(),
      "iDPedido": iDPedido.toString(),
    },
  );
  if (response.body.isNotEmpty) {
    int code = jsonDecode(response.body)["code"];
    final message = jsonDecode(response.body)["message"];

    resp = {"codigo": code, "mensaje": message};
    return resp;
  }
  return null;
}

Future<GetClienteDelivery?> getClienteDelivey(String tTelefono) async {
  String tSucursal = vGlobal.iDSucursal.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Restaurante/GetClienteDelivery?tTelefono=$tTelefono&iDSucursal=$tSucursal'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return getClienteDeliveryFromJson(responseString);
  } else {
    return null;
  }
}

Future<GetReason?> getReason( String ruc ) async {
  Uri url = Uri.parse('${vGlobal.urlAPI}/Restaurante/GetReasons?ruc=$ruc');
  final response = await http.get(
    url,
    headers: {
      "Authorization": "Bearer ${vGlobal.token}", 
      "Access-Control-Allow-Origin": "*", 
      "Access-Control-Allow-Credentials": "true", 
      "content-type": "application/json", 
      "Accept": "application/json"
    },
  );

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return getReasonFromJson(responseString);
  } else {
    return null;
  }


}