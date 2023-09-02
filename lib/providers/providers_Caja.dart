import 'dart:convert';

import 'package:fast/models/Caja/m_GetCajaDiaria.dart';
import 'package:fast/models/Caja/m_GetCajaDiariaAbiertaUsuario.dart';
import 'package:fast/models/Caja/m_GetCajaDiariaDetalle.dart';
import 'package:fast/models/Caja/m_GetCajaDiariaPorId.dart';
import 'package:fast/models/Caja/m_GetTerminalCajaDiariaImporte.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Caja.dart' as vGlobal_caja;
import 'package:intl/intl.dart';

Future<GetCajaDiaria?> getlistCajaDiaria(DateTime? _DDesde, DateTime _DHasta) async {
  String tDesde = DateFormat("yyyy-MM-dd").format(_DDesde!).toString();
  String tHasta = DateFormat("yyyy-MM-dd").format(_DHasta).toString();
  String tEmpresa = vGlobal.tEmpresaRuc.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Caja/GetCajaDiaria?tEmpresaRuc=${tEmpresa.toString()}&fFechaInicio=${tDesde.toString()}&fFechaFin=${tHasta.toString()}'),
    //Uri.parse('${vGlobal.urlAPI}/Habilitaciones/MisHabilitaciones?iMUsuario=33640&iMEmpresa=1'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    return getCajaDiariaFromJson(response.body);
  }
  return null;
}

Future<GetCajaDiariaDetalle?> getlistCajaDiariaDetalle(int iTipo) async {
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Caja/GetCajaDiariaDetalle?iDCajaDiaria=${vGlobal_caja.iDCajaDiaria}&iTipo=$iTipo'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    return getCajaDiariaDetalleFromJson(response.body);
  }
  return null;
}

Future<GetTerminalCajaDiariaImporte?> getlistTerminalCajaDiariaImporte() async {
  String iMCaja = vGlobal_caja.iMCaja.toString();
  String iDCajaDiaria = vGlobal_caja.iDCajaDiaria.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Caja/GetTerminalCajaDiariaImporte?iMCaja=$iMCaja&iDCajaDiaria=$iDCajaDiaria'),
    headers: {
      "Authorization": "Bearer ${vGlobal.token}",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "content-type": "application/json",
      "Accept": "application/json",
    },
  );
  if (response.statusCode == 200) {
    return getTerminalCajaDiariaImporteFromJson(response.body);
  }
  return null;
}

Future<Map<String, dynamic>?> CajaAperturar(
  int iMEmpleado,
  int iMCaja,
  int iMSucursal,
  double importe,
) async {
  Map<String, dynamic> resp = {};
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Caja/PostCajaDiariaRegistrar'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      "tEmpresaRuc": vGlobal.tEmpresaRuc.toString(),
      "iMCaja": iMCaja.toString(),
      "iDSucursal": iMSucursal.toString(),
      "iResponsable": iMEmpleado.toString(),
      "iMoneda": (1).toString(),
      "nInicial": importe.toString(),
      "iUsuarioRegistro": vGlobal.iMUsuario.toString(),
    },
  );

  try {
    if (response.body.isNotEmpty) {
      int code = jsonDecode(response.body)["code"];
      final message = jsonDecode(response.body)["message"];
      int? iMCajadiaria = jsonDecode(response.body)["data"]["iMCajadiaria"];
      resp = {"codigo": code, "mensaje": message, "iMCajadiaria": iMCajadiaria};
      return resp;
    }
  } catch (e) {}

  return null;
}

Future<GetCajaDiariaPorId?> getCajaDiariaPorId() async {
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Caja/GetCajaDiariaPorId?iDCajaDiaria=${vGlobal_caja.iDCajaDiaria}'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );

  if (response.statusCode == 200) {
    final String responseString = response.body;

    var jsonLogin = getCajaDiariaPorIdFromJson(responseString);
    var varl = jsonLogin.code;
    return getCajaDiariaPorIdFromJson(responseString);
  } else {
    return null;
  }
}

Future<Map<String, dynamic>?> CajaCerrar() async {
  Map<String, dynamic> resp = {};
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Caja/PostCajaDiariaCerrar'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      "iDCajaDiaria": vGlobal_caja.iDCajaDiaria.toString(),
      "iUsuario": vGlobal.iMUsuario.toString(),
      // "tObservacionesCierre": ("").toString(),
      // "tEmailCierreCaja": ("").toString(),
      "lReabrirCaja": (0).toString(),
      // "nSobrante": "",
      // "nFaltante": "",
      // "nEfectivoFisico": "",
    },
  );

  try {
    if (response.body.isNotEmpty) {
      int code = jsonDecode(response.body)["code"];
      final message = jsonDecode(response.body)["message"];
      int? iDCajaDiaria = jsonDecode(response.body)["data"]["iDCajaDiaria"];
      resp = {"codigo": code, "mensaje": message, "iMCajadiaria": iDCajaDiaria};
      return resp;
    }
  } catch (e) {}

  return null;
}

Future<GetCajaDiariaAbiertaUsuario?> getCajaDiariaAbierta() async {
  String tInicio = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  String tFin = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  String tEmpresa = vGlobal.tEmpresaRuc.toString();
  String iSucursal = vGlobal.iDSucursal.toString();
  String iUsuario = vGlobal.iMUsuario.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Caja/GetCajaDiariaAbiertaUsuario?fFechaInicio=$tInicio&fFechaFin=$tFin&tEmpresaRuc=$tEmpresa&iDSucursal=$iSucursal&iMUsuario=$iUsuario'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return getCajaDiariaAbiertaUsuarioFromJson(responseString);
  } else {
    return null;
  }
}

Future<Map<String, dynamic>?> PostCajaDiariaDetalleRegistrar(
  int iDCajaDiaria,
  int iTipo,
  String tMotivoCaja,
  String tDescripcion,
  int iMoneda,
  double nEfectivo,
  double nImporte,
  String tLetra,
  String iMCliente,
  int iCodigoVenta,
) async {
  Map<String, dynamic> resp = {};
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Caja/PostCajaDiariaDetalleRegistrar'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      "iDCajaDiaria": iDCajaDiaria.toString(),
      "iTipo": iTipo.toString(),
      "tMotivoCaja": tMotivoCaja.toString(),
      "tDescripcion": tDescripcion.toString(),
      "iMCliente": iMCliente.toString(),
      "iMEmpleado": vGlobal.iMUsuario.toString(),
      "iMoneda": iMoneda.toString(),
      "nTipoCambio": (0).toString(),
      "nEfectivo": nEfectivo.toString(),
      "nTarjeta": (0).toString(),
      "nNotaCredito": (0).toString(),
      "nImporte": nImporte.toString(),
      "iCodigoVenta": iCodigoVenta.toString(),
      "iDCotizacion": (0).toString(),
      "iDCompra": (0).toString(),
      "operaciones": ("").toString(),
      "iUsuarioRegistro": vGlobal.iMUsuario.toString(),
      "tObservaciones": ("").toString(),
      "iMCentroCosto": (0).toString(),
      "iDContratoVentaCuota": (0).toString(),
      "tTotalLetras": tLetra.toString(),
      "iDFormato": (0).toString(),
      "iDOrdenServicio": (0).toString(),
      "lCobranza": (0).toString(),
    },
  );
  try {
    if (response.body.isNotEmpty) {
      int code = jsonDecode(response.body)["code"];
      final message = jsonDecode(response.body)["message"];
      int? iMCajadiaria = jsonDecode(response.body)["data"]["iDCajadiaria"];
      resp = {"codigo": code, "mensaje": message, "iMCajadiaria": iMCajadiaria};
      return resp;
    }
  } catch (e) {}

  return null;
}
