// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:fast/models/Comprobante/m_GetComprobanteSendMail.dart';
import 'package:fast/models/Comprobante/m_GetInsertWS.dart';
import 'package:fast/models/Comprobante/m_GetNumeroDoc.dart';
import 'package:fast/models/Comprobante/m_GetSerieByTipo.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Comprobante.dart' as vGlobal_comprobante;
import 'package:intl/intl.dart';

Future<GetInsertWS?> InsertWS(
  double pInicial,
  double pFinal,
  String letra,
  double pDescuento,
  double pPorDescuento,
  String tDescripcion,
  String iMCliente,
  String tClienteDoc,
  String tCliente,
  String tClienteDireccion,
  String PlacaVehiculo,
  String ModalidaPago,
  String tSerie,
  String tNumeracion,
  String iTipoFac,
  String tTipoDocCliente,
  String tCiudadTransporteOrigen,
  String tCiudadTransporteDestino,
  String tConsignatarioEncomienda,
  String tOrigenVenta,
  String Observacion1,
  String Observacion2,
  int Mesa,
) async {
  Map<String, dynamic> resp = {};
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  String? tEmpresa = vGlobal.tEmpresa; //.replaceAll(" ", "+");
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Comprobante/InsertWS?'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      'Comprobante': '{' +
          '"IdDocumento":"${tSerie.toString()}-${tNumeracion.toString()}",' +
          '"TipoDocumento":"${iTipoFac.toString()}",' +
          '"FechaEmision":"${formattedDate.toString()}",' +
          '"Moneda":"PEN",' +
          '"TipoOperacion":"0101",' +
          '"Gravadas":0,' +
          '"Gratuitas":0,' +
          '"Inafectas":0,' +
          '"Exportacion":0,' +
          '"Exoneradas":"${pFinal.toStringAsFixed(2).toString()}",' +
          '"DescuentoGlobal":"${pDescuento.toStringAsFixed(2).toString()}",' +
          '"DescuentoGlobalV21":{' +
          '"Codigo":"00",' +
          '"Porcentaje":"${pPorDescuento.toStringAsFixed(5).toString()}",' +
          '"Monto":"${pDescuento.toStringAsFixed(2).toString()}",' +
          '"MontoBase":"${pFinal.toStringAsFixed(2).toString()}"' +
          '},' +
          '"TotalVenta":"${pFinal.toStringAsFixed(2).toString()}",' +
          '"TotalIgv":0,' +
          '"TotalIsc":0,' +
          '"TotalOtrosTributos":0,' +
          '"ICBPer":0,' +
          '"MontoEnLetras":"${letra.toString()}",' +
          '"PlacaVehiculo":"${PlacaVehiculo.toString()}",' +
          '"MontoPercepcion":0,' +
          '"MontoDetraccion":0,' +
          '"MontoAnticipo":0,' +
          '"FechaOrigen":"",' +
          '"CodigoVentaAnticipoOri":0,' +
          '"CalculoIgv":${vGlobal_comprobante.CalculoIgv.toString()},' +
          '"CalculoIsc":0,' +
          '"CalculoDetraccion":0,' +
          '"CodigoOrigen":0,' +
          '"Email":"",' +
          '"MontoEfectivo":0,' +
          '"MontoTarjeta":0,' +
          '"MontoVuelto":0,' +
          '"OrdenTrabajo":"${vGlobal.UserLogin.toString()}",' +
          '"OrdenCompra":"",' +
          '"Observacion1":"",' +
          '"ModalidaPago":"${ModalidaPago.toString()}",' +
          '"lEstadoAnticipo":0,' +
          '"Serie":"${tSerie.toString()}",' +
          '"Numero":"${tNumeracion.toString()}",' +
          '"TipoCambio":0,' +
          '"Redondeo":0,' +
          '"GuiaRemision":"",' +
          '"iMCliente":"${iMCliente.toString()}",' +
          '"Anulado":0,' +
          '"MotivoBaja":"",' +
          '"Emisor":{' +
          '"NroDocumento":"${vGlobal.tEmpresaRuc}",' +
          '"TipoDocumento":"6",' +
          '"NombreLegal":"$tEmpresa",' +
          '"NombreComercial":"",' +
          '"Ubigeo":"${vGlobal.tUbigeo}",' +
          '"Direccion":"${vGlobal.tDireccion}",' +
          '"Urbanizacion":"${vGlobal.tTipozona}",' +
          '"Departamento":"${vGlobal.tRegion}",' +
          '"Provincia":"${vGlobal.tProvincia}",' +
          '"Distrito":"${vGlobal.tDistrito}"' +
          '},' +
          '"Receptor":{' +
          '"NroDocumento":"${tClienteDoc.toString()}",' +
          '"TipoDocumento":"${tTipoDocCliente.replaceAll("0", "").toString()}",' +
          '"NombreLegal":"${tCliente.toString()}",' +
          '"NombreComercial":"",' +
          '"Ubigeo":"",' +
          '"Direccion":"${tClienteDireccion.toString()}",' +
          '"Urbanizacion":"",' +
          '"Departamento":"",' +
          '"Provincia":"",' +
          '"Distrito":"",' +
          '"CodDireccion":0' +
          '},' +
          '"tCiudadTransporteOrigen": "${tCiudadTransporteOrigen.toString()}",' +
          '"tCiudadTransporteDestino": "${tCiudadTransporteDestino.toString()}",' +
          '"tConsignatarioEncomienda":"${tConsignatarioEncomienda.toString()}",' +
          '"tOrigenVenta":"${tOrigenVenta.toString()}",' +
          '"Observacion1":"${Observacion1.toString()}",' +
          '"Observacion2": "${Observacion2.toString()}",' +
          '"Mesa":"${Mesa.toString()}",' +
          '"Relacionados":[{' +
          '"NroDocumento":"",' +
          '"TipoDocumento":""' +
          '}],' +
          '"Discrepancias":[{' +
          '"NroReferencia":"",' +
          '"Tipo":"",' +
          '"Descripcion":""' +
          '}],' +
          '"Observacion2":"",' +
          '"RecargoConsumo":0,' +
          '"Mesero":0,' +
          '"Mesa":"",' +
          '"IpVenta":"",' +
          '"GuiTransporte":"",' +
          '"lTipoVenta":0,' +
          '"lNotaSalida":false,' +
          '"lAfectaStock":0,' +
          '"FormaPago":{' +
          '"Modalidad":"${ModalidaPago.toString()}",' +
          '"PendientePago":0,' +
          '"Cuotas":[]' +
          '},' +
          '"Items":[{' +
          '"Id":1,' +
          '"Cantidad":1,' +
          '"UnidadMedida":"ZZ",' +
          '"CodigoItem":"1",' +
          '"Descripcion":"${tDescripcion.toString()}",' +
          '"PrecioUnitario":"${pFinal.toStringAsFixed(2).toString()}",' +
          '"PrecioReferencial":"${pFinal.toStringAsFixed(2).toString()}",' +
          '"TipoPrecio":"01",' +
          '"TipoImpuesto":"20",' +
          '"Impuesto":0,' +
          '"ImpuestoSelectivo":0,' +
          '"OtroImpuesto":0,' +
          '"DescuentoIGV":0,' +
          '"Descuento":0,' +
          '"TotalVenta":"${pFinal.toStringAsFixed(2).toString()}",' +
          '"Suma":"${pFinal.toStringAsFixed(2).toString()}",' +
          '"Observacion":"",' +
          '"PrecioUnit9":"${pFinal.toStringAsFixed(2).toString()}",' +
          '"Redondeo":0,' +
          '"IgvVenta":0,' +
          '"AplicaIgv":0,' +
          '"Total":"${pFinal.toStringAsFixed(2).toString()}",' +
          '"DescuentoUnidad":0,' +
          '"CodigoProductoSUNAT":"",' +
          '"PCBase":0,' +
          '"PCIgv":0,' +
          '"PrecioCompra":0,' +
          '"PCTBase":0,' +
          '"PCTIgv":0,' +
          '"PCTotal":0,' +
          '"aplica_ICBPer":false,' +
          '"Lote":""' +
          '}]}',
      'TipoDoc': iTipoFac.toString(),
      'FormatoPdf': vGlobal_comprobante.formatoPdf.toString(),
      'iTipo': '',
      'UsuarioId': vGlobal.iMUsuario.toString(),
      'tEmpresaRuc': vGlobal.tEmpresaRuc.toString()
    },
  );

  if (response.statusCode == 200) {
    return getInsertWSFromJson(response.body);
  }
  return null;
}

Future<GetInsertWS?> InsertWS2(
  double pInicial,
  double pFinal,
  String letra,
  double pDescuento,
  double pPorDescuento,
  String tDescripcion,
  String iMCliente,
  String tClienteDoc,
  String tCliente,
  String tClienteDireccion,
  String PlacaVehiculo,
  String ModalidaPago,
  String tSerie,
  String tNumeracion,
  String iTipoFac,
  String tTipoDocCliente,
  List<Map<String, dynamic>> listProductoWS,
) async {
  Map<String, dynamic> resp = {};
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  String? tEmpresa = vGlobal.tEmpresa; //.replaceAll(" ", "+");
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Comprobante/InsertWS?'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      'Comprobante': '{' +
          '"IdDocumento":"${tSerie.toString()}-${tNumeracion.toString()}",' +
          '"TipoDocumento":"${iTipoFac.toString()}",' +
          '"FechaEmision":"${formattedDate.toString()}",' +
          '"Moneda":"PEN",' +
          '"TipoOperacion":"0101",' +
          '"Gravadas":0,' +
          '"Gratuitas":0,' +
          '"Inafectas":0,' +
          '"Exportacion":0,' +
          '"Exoneradas":"${pFinal.toStringAsFixed(2).toString()}",' +
          '"DescuentoGlobal":"${pDescuento.toStringAsFixed(2).toString()}",' +
          '"DescuentoGlobalV21":' +
          '{' +
          '"Codigo":"00",' +
          '"Porcentaje":"${pPorDescuento.toStringAsFixed(5).toString()}",' +
          '"Monto":"${pDescuento.toStringAsFixed(2).toString()}",' +
          '"MontoBase":"${pFinal.toStringAsFixed(2).toString()}"' +
          '},' +
          '"TotalVenta":"${pFinal.toStringAsFixed(2).toString()}",' +
          '"TotalIgv":0,' +
          '"TotalIsc":0,' +
          '"TotalOtrosTributos":0,' +
          '"ICBPer":0,' +
          '"MontoEnLetras":"${letra.toString()}",' +
          '"PlacaVehiculo":"${PlacaVehiculo.toString()}",' +
          '"MontoPercepcion":0,' +
          '"MontoDetraccion":0,' +
          '"MontoAnticipo":0,' +
          '"FechaOrigen":"",' +
          '"CodigoVentaAnticipoOri":0,' +
          '"CalculoIgv":${vGlobal_comprobante.CalculoIgv.toString()},' +
          '"CalculoIsc":0,' +
          '"CalculoDetraccion":0,' +
          '"CodigoOrigen":0,' +
          '"Email":"",' +
          '"MontoEfectivo":0,' +
          '"MontoTarjeta":0,' +
          '"MontoVuelto":0,' +
          '"OrdenTrabajo":"${vGlobal.UserLogin.toString()}",' +
          '"OrdenCompra":"",' +
          '"Observacion1":"",' +
          '"ModalidaPago":"${ModalidaPago.toString()}",' +
          '"lEstadoAnticipo":0,' +
          '"Serie":"${tSerie.toString()}",' +
          '"Numero":"${tNumeracion.toString()}",' +
          '"TipoCambio":0,' +
          '"Redondeo":0,' +
          '"GuiaRemision":"",' +
          '"iMCliente":"${iMCliente.toString()}",' +
          '"Anulado":0,' +
          '"MotivoBaja":"",' +
          '"Emisor":' +
          '{' +
          '"NroDocumento":"${vGlobal.tEmpresaRuc}",' +
          '"TipoDocumento":"6",' +
          '"NombreLegal":"$tEmpresa",' +
          '"NombreComercial":"",' +
          '"Ubigeo":"${vGlobal.tUbigeo}",' +
          '"Direccion":"${vGlobal.tDireccion}",' +
          '"Urbanizacion":"${vGlobal.tTipozona}",' +
          '"Departamento":"${vGlobal.tRegion}",' +
          '"Provincia":"${vGlobal.tProvincia}",' +
          '"Distrito":"${vGlobal.tDistrito}"' +
          '},' +
          '"Receptor":' +
          '{' +
          '"NroDocumento":"${tClienteDoc.toString()}",' +
          '"TipoDocumento":"${tTipoDocCliente.replaceAll("0", "").toString()}",' +
          '"NombreLegal":"${tCliente.toString()}",' +
          '"NombreComercial":"",' +
          '"Ubigeo":"",' +
          '"Direccion":"${tClienteDireccion.toString()}",' +
          '"Urbanizacion":"",' +
          '"Departamento":"",' +
          '"Provincia":"",' +
          '"Distrito":"",' +
          '"CodDireccion":0},' +
          '"Relacionados":[{' +
          '"NroDocumento":"",' +
          '"TipoDocumento":""' +
          '}],' +
          '"Discrepancias":[{' +
          '"NroReferencia":"",' +
          '"Tipo":"",' +
          '"Descripcion":""' +
          '}],' +
          '"Observacion2":"",' +
          '"RecargoConsumo":0,' +
          '"Mesero":0,' +
          '"Mesa":"",' +
          '"IpVenta":"",' +
          '"GuiTransporte":"",' +
          '"lTipoVenta":0,' +
          '"lNotaSalida":false,' +
          '"lAfectaStock":0,' +
          '"FormaPago":{' +
          '"Modalidad":"${ModalidaPago.toLowerCase().toString()}",' +
          '"PendientePago":0,' +
          '"Cuotas":[]' +
          '},' +
          '"Items":${listProductoWS.toString()}}',
      'TipoDoc': iTipoFac.toString(),
      'FormatoPdf': vGlobal_comprobante.formatoPdf.toString(),
      'iTipo': '',
      'UsuarioId': vGlobal.iMUsuario.toString(),
      'tEmpresaRuc': vGlobal.tEmpresaRuc.toString()
    },
  );

  if (response.statusCode == 200) {
    return getInsertWSFromJson(response.body);
  }
  return null;
}

Future<List<sendMailRes>?>? ComprobanteSendMail(String tCorreo, String tMensaje) async {
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Comprobante/GetComprobanteSendMail?Comprobante=${vGlobal_comprobante.iDComprobante.toString()}&Correo=$tCorreo&autoriza=${vGlobal.UserLogin.toString()}&Mensaje=${tMensaje.toString()}'),
    headers: {
      "Authorization": "Bearer ${vGlobal.token}",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "content-type": "application/json",
      "Accept": "application/json",
    },
  );
  if (response.statusCode == 200) {
    final sMail = getComprobanteSendMailFromJson(response.body);
    return sMail.data;
  }
  return null;
}

Future<List<SerieData>?>? getSerieComprobante(String iTipo, bool lTransporte) async {
  ///GetSerieByTipo?TipoDoc=03&lTransporte=true&tEmpresaRuc=$tEmpresa&iDSucursal=775&UsuarioId=6423'
  String tEmpresa = vGlobal.tEmpresaRuc.toString();
  final response = await http.get(
    Uri.parse(
        '${vGlobal.urlAPI}/Comprobante/GetSerieByTipo?TipoDoc=${iTipo.toString()}&lTransporte=${lTransporte.toString()}&tEmpresaRuc=${tEmpresa.toString()}&iDSucursal=${vGlobal.iDSucursal.toString()}&UsuarioId=${vGlobal.iMUsuario.toString()}'),
    headers: {
      "Authorization": "Bearer ${vGlobal.token}",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "content-type": "application/json",
      "Accept": "application/json",
    },
  );
  if (response.statusCode == 200) {
    final sSerie = getSerieByTipoFromJson(response.body);
    if (sSerie.data.length > 0) {
      vGlobal_comprobante.formatoPdf = sSerie.data[0].formatoPdf!;
      vGlobal_comprobante.documentoSerie = sSerie.data[0].documentoSerie!;
    } else {
      vGlobal_comprobante.formatoPdf = "";
      vGlobal_comprobante.documentoSerie = "";
    }
    return sSerie.data;
    //}
  }
  return null;
}

Future<List<NumeroData>?> getNumeroComprobante(String iTipo, String tSerie) async {
  ///GetSerieByTipo?TipoDoc=03&lTransporte=true&tEmpresaRuc=$tEmpresa&iDSucursal=775&UsuarioId=6423'
  String tEmpresa = vGlobal.tEmpresaRuc.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Comprobante/GetNumeroDoc?tEmpresaRuc=${tEmpresa.toString()}&TipoDoc=${iTipo.toString()}&SerieDoc=${tSerie.toString()}'),
    headers: {
      "Authorization": "Bearer ${vGlobal.token}",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "content-type": "application/json",
      "Accept": "application/json",
    },
  );
  if (response.statusCode == 200) {
    final sNumero = getNumeroDocFromJson(response.body);
    if (sNumero.data.isNotEmpty) {
      vGlobal_comprobante.documentoNumero = sNumero.data[0].codigo!;
    } else {
      vGlobal_comprobante.documentoNumero = "";
    }
    return sNumero.data;
    //}
  }
  return null;
}

Future<Map<String, dynamic>?> AnularComprobante(String Motivo) async {
  Map<String, dynamic> resp = {};
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Comprobante/AnularComprobante'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true"},
    body: {
      "ComprobanteId": vGlobal_comprobante.iDComprobante.toString(),
      "Motivo": Motivo.toString(),
      "UsuarioId": vGlobal.iMUsuario.toString(),
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
