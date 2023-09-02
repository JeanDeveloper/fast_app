import 'dart:convert';
import 'package:fast/models/Restaurante/m_GetOrdenTraslado.dart';
import 'package:fast/models/Transporte/m_%20getNiveles.dart';
import 'package:fast/models/Transporte/m_GetCiudad.dart';
import 'package:fast/models/Transporte/m_GetModeloAsientoBuscar.dart';
import 'package:fast/models/Transporte/m_GetObtenerDatosBoleto.dart';
import 'package:fast/models/Transporte/m_GetProgramacion.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Transporte.dart' as vGlobal_transporte;

// Future<List<DetalleVehiculo>?>
Future<List<CiudadData>?> loadCiudad() async {
  String tEmpresa = vGlobal.tEmpresaRuc.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Transporte/GetCiudad?tEmpresaRuc=$tEmpresa'),
    headers: {
      "Authorization": "Bearer ${vGlobal.token}",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "content-type": "application/json",
      "Accept": "application/json",
    },
  );
  if (response.statusCode == 200) {
    var sCiudad = getCiudadFromJson(response.body);
    if (sCiudad.code == 0) {
      if (sCiudad.data.isNotEmpty) {
        vGlobal_transporte.listCiudad = sCiudad.data;
      }
    }
  }
}

Future<GetProgramacion?> getlistProgramacion(String fecha, int origen, int destino) async {
  String tEmpresa = vGlobal.tEmpresaRuc.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Transporte/GetProgramacion?tEmpresaRuc=$tEmpresa&fFecha=$fecha&iOrigen=${origen.toString()}&iDestino=${destino.toString()}'),
    headers: {
      "Authorization": "Bearer ${vGlobal.token}",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "content-type": "application/json",
      "Accept": "application/json",
    },
  );
  if (response.statusCode == 200) {
    return getProgramacionFromJson(response.body);
  }
  return null;
}

Future<List<NivelesData>?> getListNiveles() async {
  String iMModeloTransporte = vGlobal_transporte.iMModeloTransporte.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Transporte/GetNiveles?iMModeloTransporte=$iMModeloTransporte'),
    headers: {
      "Authorization": "Bearer ${vGlobal.token}",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "content-type": "application/json",
      "Accept": "application/json",
    },
  );
  if (response.statusCode == 200) {
    final sNiveles = getNivelesFromJson(response.body);
    return sNiveles.data;
  }
  return null;
}

Future<GetModeloAsientoBuscar?> getlistModeloAsiento(int nivel) async {
  String iDProgramacionFecha = vGlobal_transporte.iDProgramacionFecha.toString();
  String iMModeloTransporte = vGlobal_transporte.iMModeloTransporte.toString();
  String iMOrigen = vGlobal_transporte.iCiudadOrigen.toString();
  String iMDestino = vGlobal_transporte.iCiudadDestino.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Transporte/GetModeloAsientoBuscar?iDProgramacionFecha=$iDProgramacionFecha&iMModeloTransporte=$iMModeloTransporte&iNivel=${nivel.toString()}&iMOrigen=$iMOrigen&iMDestino=$iMDestino'),
    headers: {
      "Authorization": "Bearer ${vGlobal.token}",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "content-type": "application/json",
      "Accept": "application/json",
    },
  );
  if (response.statusCode == 200) {
    return getModeloAsientoBuscarFromJson(response.body);
  }
  return null;
}

Future<Map<String, dynamic>?> VentasBoletoRegistrar(
  int iMCliente,
  String tClienteDoc,
  String tCliente,
  String tClienteDir,
  int iMPasajero,
  String tPasajeroTipoDoc,
  String tPasajeroDoc,
  String tPasajero,
  String tTipoComprobante,
  double iDescuento,
  bool aplica,
) async {
  Map<String, dynamic> resp = {};
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Transporte/PostVentasBoletoRegistrar'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      "tEmpresaRuc": vGlobal.tEmpresaRuc.toString(),
      "iMCliente": iMCliente.toString(),
      "tClienteDoc": tClienteDoc.toString(),
      "tCliente": tCliente.toString(),
      "tClienteDir": tClienteDir.toString(),
      "iMPasajero": iMPasajero.toString(),
      "iMPasajeroTipoDoc": tPasajeroTipoDoc.toString(),
      "tPasajeroDoc": tPasajeroDoc.toString(),
      "tPasajero": tPasajero.toString(),
      "tTipoComprobante": tTipoComprobante.toString(),
      "iDProgramacionFecha": vGlobal_transporte.iDProgramacionFecha.toString(),
      "iMCiudadTransporteSalida": vGlobal_transporte.iCiudadOrigen.toString(),
      "iMCiudadTransporteLlegada": vGlobal_transporte.iCiudadDestino.toString(),
      "iNroAsiento": vGlobal_transporte.iAsiento.toString(),
      "nPrecio": vGlobal_transporte.iPrecioInicial.toString(),
      "nDescuento": iDescuento.toString(),
      "nTotalPagar": vGlobal_transporte.iPrecioFinal.toString(),
      "lVentaGratuita": aplica.toString(),
    },
  );

  if (response.body.isNotEmpty) {
    int code = jsonDecode(response.body)["code"];
    final message = jsonDecode(response.body)["message"];
    int? iMVentaTransporte = jsonDecode(response.body)["data"]["iMVentaTransporte"];
    resp = {"codigo": code, "mensaje": message, "iMVentaTransporte": iMVentaTransporte};
    return resp;
  }
  return null;
}

Future<Map<String, dynamic>?> VentasReservaRegistrar(
  int iMCliente,
  String tClienteDoc,
  String tCliente,
  String tClienteDir,
  int iMPasajero,
  String tPasajeroTipoDoc,
  String tPasajeroDoc,
  String tPasajero,
  String tTipoComprobante,
  double iDescuento,
  bool aplica,
) async {
  Map<String, dynamic> resp = {};
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Transporte/PostVentasReservaRegistrar'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      "iMVentaTransporte": vGlobal_transporte.iMVentaTransporte.toString(),
      "tEmpresaRuc": vGlobal.tEmpresaRuc.toString(),
      "iMCliente": iMCliente.toString(),
      "tClienteDoc": tClienteDoc.toString(),
      "tCliente": tCliente.toString(),
      "tClienteDir": tClienteDir.toString(),
      "iMPasajero": iMPasajero.toString(),
      "iMPasajeroTipoDoc": tPasajeroTipoDoc.toString(),
      "tPasajeroDoc": tPasajeroDoc.toString(),
      "tPasajero": tPasajero.toString(),
      "tTipoComprobante": tTipoComprobante.toString(),
      "iDProgramacionFecha": vGlobal_transporte.iDProgramacionFecha.toString(),
      "iMCiudadTransporteSalida": vGlobal_transporte.iCiudadOrigen.toString(),
      "iMCiudadTransporteLlegada": vGlobal_transporte.iCiudadDestino.toString(),
      "iNroAsiento": vGlobal_transporte.iAsiento.toString(),
      "nPrecio": vGlobal_transporte.iPrecioInicial.toString(),
      "nDescuento": iDescuento.toString(),
      "nTotalPagar": vGlobal_transporte.iPrecioFinal.toString(),
      "lVentaGratuita": aplica.toString(),
    },
  );

  if (response.body.isNotEmpty) {
    int code = jsonDecode(response.body)["code"];
    final message = jsonDecode(response.body)["message"];
    int? iDPedido = jsonDecode(response.body)["data"]["iDPedido"];
    resp = {"codigo": code, "mensaje": message, "iDPedido": iDPedido};
    return resp;
  }
  return null;
}

Future<Map<String, dynamic>?> CodigoVentasTransporte_Registrar(
  int iMVentaTransporte,
  int iDComprobante,
) async {
  Map<String, dynamic> resp = {};
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Transporte/PostCodigoVentasTransporteRegistrar'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      "iMVentaTransporte": iMVentaTransporte.toString(),
      "iDComprobante": iDComprobante.toString(),
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

Future<Map<String, dynamic>?> ReservaBoletoRegistrar(
  int iMPasajero,
  String tPasajeroTipoDoc,
  String tPasajeroDoc,
  String tPasajero,
) async {
  Map<String, dynamic> resp = {};
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Transporte/PostVentasBoletoReservar'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      "tEmpresaRuc": vGlobal.tEmpresaRuc.toString(),
      "iMPasajero": iMPasajero.toString(),
      "iMPasajeroTipoDoc": tPasajeroTipoDoc.toString(),
      "tPasajeroDoc": tPasajeroDoc.toString(),
      "tPasajero": tPasajero.toString(),
      "iDProgramacionFecha": vGlobal_transporte.iDProgramacionFecha.toString(),
      "iMCiudadTransporteSalida": vGlobal_transporte.iCiudadOrigen.toString(),
      "iMCiudadTransporteLlegada": vGlobal_transporte.iCiudadDestino.toString(),
      "iNroAsiento": vGlobal_transporte.iAsiento.toString(),
    },
  );

  if (response.body.isNotEmpty) {
    int code = jsonDecode(response.body)["code"];
    final message = jsonDecode(response.body)["message"];
    int? iDPedido = jsonDecode(response.body)["data"]["iDPedido"];
    resp = {"codigo": code, "mensaje": message, "iDPedido": iDPedido};
    return resp;
  }
  return null;
}

Future<GetObtenerDatosBoleto?> getDatosBoleto() async {
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Transporte/GetObtenerDatosBoleto?iMVentaTransporte=${vGlobal_transporte.iMVentaTransporte.toString()}'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return getObtenerDatosBoletoFromJson(responseString);
  } else {
    return null;
  }
}

Future<Map<String, dynamic>?> AnularReserva() async {
  Map<String, dynamic> resp = {};
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Transporte/PostAnularReserva'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      "tEmpresaRuc": vGlobal.tEmpresaRuc.toString(),
      "iMVentaTransporte": vGlobal_transporte.iMVentaTransporte.toString(),
    },
  );

  if (response.body.isNotEmpty) {
    int code = jsonDecode(response.body)["code"];
    final message = jsonDecode(response.body)["message"];
    int? iMVentaTransporte = jsonDecode(response.body)["data"]["iMVentaTransporte"];
    resp = {"codigo": code, "mensaje": message, "iMVentaTransporte": iMVentaTransporte};
    return resp;
  }
  return null;
}

Future<Map<String, dynamic>?> OrdenTrasladoRegistrar(
  int iMCliente,
  String tClienteDoc,
  String tCliente,
  String tClienteDir,
  String tTipoComprobante,
  double iDescuento,
  bool aplica,
  bool iPagoAnticipado,
  int iEstado,
) async {
  Map<String, dynamic> resp = {};
  Map<String, dynamic> Items = {"Items": vGlobal_transporte.listProductoTraslado};
  String tItems = jsonEncode(Items);
  print(tItems);
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Transporte/PostOrdenTrasladoRegistrar'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      "tEmpresaRuc": vGlobal.tEmpresaRuc.toString(),
      "iDSucursal": vGlobal.iDSucursal.toString(),
      "iMCiudadOrigen": vGlobal_transporte.ort_origen.toString(),
      "iMCiudadDestino": vGlobal_transporte.ort_destino.toString(),
      "iMCliente": iMCliente.toString(),
      "tClienteDoc": tClienteDoc.toString(),
      "tCliente": tCliente.toString(),
      "tClienteDir": tClienteDir.toString(),
      "iMRemitente": vGlobal_transporte.ort_remi_id.toString(),
      "iMRemitenteTipoDoc": vGlobal_transporte.ort_remi_tipoDoc.toString(),
      "tRemitenteDoc": vGlobal_transporte.ort_remi_doc.toString(),
      "tRemitente": vGlobal_transporte.ort_remi.toString(),
      "iMConsignado": vGlobal_transporte.ort_cons_id.toString(),
      "iMConsignadoTipoDoc": vGlobal_transporte.ort_cons_tipoDoc.toString(),
      "tConsignadoDoc": vGlobal_transporte.ort_cons_doc.toString(),
      "tConsignado": vGlobal_transporte.ort_cons.toString(),
      "iPagoAnticipado": iPagoAnticipado.toString(),
      "iVentaGratuita": aplica.toString(),
      "iDescuento": iDescuento.toString(),
      "iImporteTotal": vGlobal_transporte.iPrecioFinal.toString(),
      "tTipoComprobante": tTipoComprobante.toString(),
      "iUsuario": vGlobal.iMUsuario.toString(),
      "iEstado": iEstado.toString(),
      "productos": tItems.toString(),
    },
  );

  if (response.body.isNotEmpty) {
    int code = jsonDecode(response.body)["code"];
    final message = jsonDecode(response.body)["message"];
    int? iMOrden = jsonDecode(response.body)["data"]["iMOrden"];
    resp = {"codigo": code, "mensaje": message, "iMOrden": iMOrden};
    return resp;
  }
  return null;
}

Future<Map<String, dynamic>?> CodigoOrdenTraslado_Registrar(
  int iMOrden,
  int iDComprobante,
) async {
  Map<String, dynamic> resp = {};
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Transporte/PostCodigoOrdenTrasladoRegistrar'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      "iMOrden": iMOrden.toString(),
      "iDComprobante": iDComprobante.toString(),
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

Future<GetOrdenTraslado?> getlistOrdenTraslado(String _DDesde, String _DHasta) async {
  String tEmpresa = vGlobal.tEmpresaRuc.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Transporte/GetOrdenTraslado?tEmpresaRuc=${tEmpresa.toString()}&fDesde=${_DDesde.toString()}&fHasta=${_DHasta.toString()}'),
    //Uri.parse('${vGlobal.urlAPI}/Habilitaciones/MisHabilitaciones?iMUsuario=33640&iMEmpresa=1'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    return getOrdenTrasladoFromJson(response.body);
  }
  return null;
}

Future<Map<String, dynamic>?> AnularBoleto() async {
  Map<String, dynamic> resp = {};
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Transporte/PostAnularBoleto'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      "iMVentaTransporte": vGlobal_transporte.iMVentaTransporte.toString(),
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
