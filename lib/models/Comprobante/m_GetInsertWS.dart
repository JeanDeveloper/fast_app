// {
//     "code": 0,
//     "message": "Búsqueda exitosa",
//     "data": [
//         {
//             "iMCliente": 857435,
//             "tNroDocumento": "41377969",
//             "tNombre": "SANDRA MARIANA VALDERRAMA BOCANEGRA",
//             "tDireccion": "",
//             "tCorreo": "BSANBDAHBDHABDYUHJD",
//             "iMTipoDocumentoIdentidad": "1",
//             "tTelefonoPrincipal": ""
//         }
//     ]
// }

// https://localhost:44339/Comprobante/InsertWS?

// {"IdDocumento":"B001-00000022","TipoDocumento":"03",
// "FechaEmision":"2023-01-16",
// "Moneda":"PEN",
// "TipoOperacion":"0101",
// "Gravadas":0,
// "Gratuitas":0,
// "Inafectas":0,
// "Exportacion":0,
// "Exoneradas":"24.80",
// "DescuentoGlobal":"25.20",
// "DescuentoGlobalV21":{"Codigo":"00",
// "Porcentaje":"0.50400",
// "Monto":"25.20",
// "MontoBase":"50.00"},
// "TotalVenta":"24.80",
// "TotalIgv":0,
// "TotalIsc":0,
// "TotalOtrosTributos":0,
// "ICBPer":0,
// "MontoEnLetras":"VEINTICUATRO+Y+80/100+SOLES",
// "PlacaVehiculo":"T1C-701",
// "MontoPercepcion":0,
// "MontoDetraccion":0,
// "MontoAnticipo":0,
// "FechaOrigen":"",
// "CodigoVentaAnticipoOri":0,
// "CalculoIgv":18,
// "CalculoIsc":0,
// "CalculoDetraccion":0,
// "CodigoOrigen":0,
// "Email":"",
// "MontoEfectivo":0,
// "MontoTarjeta":0,
// "MontoVuelto":0,
// "OrdenTrabajo":"mvia",
// "OrdenCompra":"",
// "Observacion1":"",
// "ModalidaPago":"CONTADO",
// "lEstadoAnticipo":0,
// "Serie":"B001",
// "Numero":"00000022",
// "TipoCambio":0,
// "Redondeo":0,
// "GuiaRemision":"",
// "iMCliente":"962878",
// "Anulado":0,
// "MotivoBaja":"",
// "Emisor":{"NroDocumento":"20000000001",
// "TipoDocumento":"6",
// "NombreLegal":"TRANSPORTES+II",
// "NombreComercial":"",
// "Ubigeo":"021801",
// "Direccion":"CHIMBOTE",
// "Urbanizacion":"0",
// "Departamento":"ANCASH",
// "Provincia":"SANTA",
// "Distrito":"CHIMBOTE"},
// "Receptor":{"NroDocumento":"43822251",
// "TipoDocumento":"1",
// "NombreLegal":"LIZBETH+SUSSY+CASTRO+RUMINO",
// "NombreComercial":"",
// "Ubigeo":"",
// "Direccion":"",
// "Urbanizacion":"",
// "Departamento":"",
// "Provincia":"",
// "Distrito":"",
// "CodDireccion":0},
// "Relacionados":[{"NroDocumento":"",
// "TipoDocumento":""}],
// "Discrepancias":[{"NroReferencia":"",
// "Tipo":"",
// "Descripcion":""}],
// "Observacion2":"",
// "RecargoConsumo":0,
// "Mesero":0,
// "Mesa":"",
// "IpVenta":"",
// "GuiTransporte":"",
// "lTipoVenta":0,
// "lNotaSalida":false,
// "lAfectaStock":0,
// "FormaPago":{"Modalidad":"Contado",
// "PendientePago":0,
// "Cuotas":[]},
// "Items":[{"Id":1,
// "Cantidad":1,
// "UnidadMedida":"ZZ",
// "CodigoItem":"1",
// "Descripcion":"CHIMBOTE+-+LIMA|ASIENTO+:+66|PAJ+:+ESPINOZA+CABELLO+JOHNN+PAOLO|DNI+:+43046150|F.VIAJE+:+16/01/2023|H.VIAJE+:+07:00+AM|",
// "PrecioUnitario":"24.80",
// "PrecioReferencial":"24.80",
// "TipoPrecio":"01",
// "TipoImpuesto":"20",
// "Impuesto":0,
// "ImpuestoSelectivo":0,
// "OtroImpuesto":0,
// "DescuentoIGV":0,
// "Descuento":0,
// "TotalVenta":"24.80",
// "Suma":"24.80",
// "Observacion":"",
// "PrecioUnit9":"24.80",
// "Redondeo":0,
// "IgvVenta":0,
// "AplicaIgv":0,
// "Total":"24.80",
// "DescuentoUnidad":0,
// "CodigoProductoSUNAT":"",
// "PCBase":0,
// "PCIgv":0,
// "PrecioCompra":0,
// "PCTBase":0,
// "PCTIgv":0,
// "PCTotal":0,
// "aplica_ICBPer":false,
// "Lote":""}]}

import 'dart:convert';

GetInsertWS getInsertWSFromJson(String str) => GetInsertWS.fromJson(json.decode(str));

String getInsertWSToJson(GetInsertWS data) => json.encode(data.toJson());

class GetInsertWS {
  GetInsertWS({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  List<InsertWSData> data;

  factory GetInsertWS.fromJson(Map<String, dynamic> json) => GetInsertWS(
        code: json["code"],
        message: json["message"],
        data: List<InsertWSData>.from(json["data"].map((x) => InsertWSData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class InsertWSData {
  InsertWSData({
    required this.comprobanteId,
    // required this.rucEmisor,
    // required this.fechaEmision,
    // required this.rucCliente,
    // required this.razonSocialCliente,
    // required this.direccionCliente,
    // required this.correoCliente,
    // required this.tipoDocumento,
    required this.serie,
    required this.numero,
    // required this.serieOrigen,
    // required this.numeroOrigen,
    // required this.tipoDocOrigen,
    // required this.moneda,
    // required this.tipoCambio,
    // required this.importe,
    // required this.subtotal,
    // required this.descuento,
    // required this.igv,
    // required this.estadoDocumento,
    // required this.estadoSunat,
    // required this.fechaEnvio,
    // required this.directorioXml,
    // required this.directorioZip,
    required this.directorioPdf,
    // required this.directorioZipSunat,
    // required this.anulado,
    // required this.fechaAnulado,
    // required this.motivoBaja,
    // required this.emailsEnviados,
    // required this.nResumenes,
    // required this.enviadoPortal,
    // required this.empresa,
    // required this.fechaOrigen,
    // required this.item,
    // required this.codigoPro,
    // required this.um,
    // required this.descripcion,
    // required this.precioUnit,
    // required this.cantidad,
    // required this.igvPro,
    // required this.precio,
    // required this.consulta,
    // required this.codigoErrorSunat,
    // required this.codigoErrorSistema,
    // required this.usuarioRegistra,
    // required this.isDayAutorized,
    // required this.montoDetraccion,
    // required this.textoDetraccion,
    // required this.observacion,
    // required this.ordenCompra,
    // required this.importeSoles,
    // required this.modalidadPago,
    // required this.placaVehiculo,
    // required this.requerimiento,
    // required this.fechaVencimiento,
    // required this.fechaRegistro,
    // required this.idTipoDoc,
    // required this.isLast,
    // required this.datumTipoDocOrigen,
    // required this.correlativoOrgien,
    // required this.ubicacionPdf,
    // required this.tTransporteConsignatario,
    // required this.tTransporteOrigen,
    // required this.tTransporteDestinp,
    // required this.tEmbarcacionPesquera,
    // required this.tLiquidacion,
    // required this.tTicket,
    // required this.tipoDocSunat,
    // required this.diasTranscurridos,
    // required this.nDiasAnulacion,
    // required this.iMCliente,
    // required this.guiTransporte,
    // required this.iDAlmacen,
    // required this.gratuitas,
    // required this.inafectas,
    // required this.exoneradas,
    // required this.recargoConsumo,
    // required this.exportacion,
    // required this.icbPer,
    // required this.iMVendedor,
    // required this.tVendedor,
    // required this.detalle,
    // required this.iEstadoSunat,
    // required this.iEstadoOse,
    // required this.nPendiente,
    // required this.nCancelado,
    // required this.tDireccionEmisor,
    // required this.tTelefonoEmisor,
    // required this.tMontoLetras,
    // required this.empNomcomercial,
    // required this.tipoNc,
    // required this.sustentoNc,
    // required this.correlativoModNc,
    // required this.docModNc,
    // required this.fecModNc,
    // required this.tipoDoc,
    // required this.hash,
    // required this.mensajeConsulta,
    // required this.docCliente,
    // required this.cdpMoneda,
    // required this.iTransporteOrigen,
    // required this.iTransporteDestino,
    // required this.tOrigenVenta,
    // required this.tGuiaRemision,
    // required this.iDSucursalVenta,
    // required this.tCiudadTransporteOrigen,
    // required this.tCiudadTransporteDestino,
    // required this.tConsignatarioEncomienda,
    // required this.lPagado,
    // required this.pendientePago,
    // required this.iMDetraccion,
    // required this.lRetencionIgv,
    // required this.nRetencionIgv,
    // required this.nRetencionIgvPorcentaje,
  });

  int comprobanteId;
  // String rucEmisor;
  // String fechaEmision;
  // String rucCliente;
  // String razonSocialCliente;
  // String direccionCliente;
  // String correoCliente;
  // String tipoDocumento;
  String serie;
  String numero;
  // String serieOrigen;
  // String numeroOrigen;
  // String tipoDocOrigen;
  // String moneda;
  // String tipoCambio;
  // String importe;
  // String subtotal;
  // String descuento;
  // String igv;
  // String estadoDocumento;
  // String estadoSunat;
  // String fechaEnvio;
  // String directorioXml;
  // String directorioZip;
  String directorioPdf;
  // String directorioZipSunat;
  // String anulado;
  // String fechaAnulado;
  // String motivoBaja;
  // int emailsEnviados;
  // int nResumenes;
  // int enviadoPortal;
  // String empresa;
  // String fechaOrigen;
  // dynamic item;
  // dynamic codigoPro;
  // dynamic um;
  // dynamic descripcion;
  // dynamic precioUnit;
  // dynamic cantidad;
  // dynamic igvPro;
  // dynamic precio;
  // int consulta;
  // dynamic codigoErrorSunat;
  // dynamic codigoErrorSistema;
  // String usuarioRegistra;
  // int isDayAutorized;
  // int montoDetraccion;
  // String textoDetraccion;
  // String observacion;
  // String ordenCompra;
  // int importeSoles;
  // String modalidadPago;
  // String placaVehiculo;
  // String requerimiento;
  // String fechaVencimiento;
  // String fechaRegistro;
  // String idTipoDoc;
  // bool isLast;
  // dynamic datumTipoDocOrigen;
  // dynamic correlativoOrgien;
  // String ubicacionPdf;
  // String tTransporteConsignatario;
  // String tTransporteOrigen;
  // String tTransporteDestinp;
  // String tEmbarcacionPesquera;
  // String tLiquidacion;
  // String tTicket;
  // dynamic tipoDocSunat;
  // int diasTranscurridos;
  // int nDiasAnulacion;
  // int iMCliente;
  // dynamic guiTransporte;
  // int iDAlmacen;
  // int gratuitas;
  // int inafectas;
  // double exoneradas;
  // int recargoConsumo;
  // int exportacion;
  // int icbPer;
  // int iMVendedor;
  // String tVendedor;
  // dynamic detalle;
  // int iEstadoSunat;
  // int iEstadoOse;
  // double nPendiente;
  // int nCancelado;
  // String tDireccionEmisor;
  // String tTelefonoEmisor;
  // String tMontoLetras;
  // String empNomcomercial;
  // String tipoNc;
  // String sustentoNc;
  // String correlativoModNc;
  // String docModNc;
  // String fecModNc;
  // String tipoDoc;
  // String hash;
  // String mensajeConsulta;
  // String docCliente;
  // String cdpMoneda;
  // int iTransporteOrigen;
  // int iTransporteDestino;
  // String tOrigenVenta;
  // String tGuiaRemision;
  // int iDSucursalVenta;
  // String tCiudadTransporteOrigen;
  // String tCiudadTransporteDestino;
  // String tConsignatarioEncomienda;
  // bool lPagado;
  // int pendientePago;
  // int iMDetraccion;
  // bool lRetencionIgv;
  // int nRetencionIgv;
  // int nRetencionIgvPorcentaje;

  factory InsertWSData.fromJson(Map<String, dynamic> json) => InsertWSData(
        comprobanteId: json["comprobanteId"],
        // rucEmisor: json["rucEmisor"],
        // fechaEmision: json["fechaEmision"],
        // rucCliente: json["rucCliente"],
        // razonSocialCliente: json["razonSocialCliente"],
        // direccionCliente: json["direccionCliente"],
        // correoCliente: json["correoCliente"],
        // tipoDocumento: json["tipoDocumento"],
        serie: json["serie"],
        numero: json["numero"],
        // serieOrigen: json["serieOrigen"],
        // numeroOrigen: json["numeroOrigen"],
        // tipoDocOrigen: json["tipoDocOrigen"],
        // moneda: json["moneda"],
        // tipoCambio: json["tipoCambio"],
        // importe: json["importe"],
        // subtotal: json["subtotal"],
        // descuento: json["descuento"],
        // igv: json["igv"],
        // estadoDocumento: json["estadoDocumento"],
        // estadoSunat: json["estadoSunat"],
        // fechaEnvio: json["fechaEnvio"],
        // directorioXml: json["directorioXml"],
        // directorioZip: json["directorioZip"],
        directorioPdf: json["directorioPdf"],
        // directorioZipSunat: json["directorioZipSunat"],
        // anulado: json["anulado"],
        // fechaAnulado: json["fechaAnulado"],
        // motivoBaja: json["motivoBaja"],
        // emailsEnviados: json["emailsEnviados"],
        // nResumenes: json["nResumenes"],
        // enviadoPortal: json["enviadoPortal"],
        // empresa: json["empresa"],
        // fechaOrigen: json["fechaOrigen"],
        // item: json["item"],
        // codigoPro: json["codigoPro"],
        // um: json["um"],
        // descripcion: json["descripcion"],
        // precioUnit: json["precioUnit"],
        // cantidad: json["cantidad"],
        // igvPro: json["igvPro"],
        // precio: json["precio"],
        // consulta: json["consulta"],
        // codigoErrorSunat: json["codigoErrorSunat"],
        // codigoErrorSistema: json["codigoErrorSistema"],
        // usuarioRegistra: json["usuarioRegistra"],
        // isDayAutorized: json["isDayAutorized"],
        // montoDetraccion: json["monto_detraccion"],
        // textoDetraccion: json["texto_detraccion"],
        // observacion: json["observacion"],
        // ordenCompra: json["ordenCompra"],
        // importeSoles: json["importeSoles"],
        // modalidadPago: json["modalidadPago"],
        // placaVehiculo: json["placaVehiculo"],
        // requerimiento: json["requerimiento"],
        // fechaVencimiento: json["fechaVencimiento"],
        // fechaRegistro: json["fechaRegistro"],
        // idTipoDoc: json["idTipo_Doc"],
        // isLast: json["isLast"],
        // datumTipoDocOrigen: json["tipo_doc_origen"],
        // correlativoOrgien: json["correlativo_orgien"],
        // ubicacionPdf: json["ubicacionPDF"],
        // tTransporteConsignatario: json["tTransporteConsignatario"],
        // tTransporteOrigen: json["tTransporteOrigen"],
        // tTransporteDestinp: json["tTransporteDestinp"],
        // tEmbarcacionPesquera: json["tEmbarcacionPesquera"],
        // tLiquidacion: json["tLiquidacion"],
        // tTicket: json["tTicket"],
        // tipoDocSunat: json["tipoDocSunat"],
        // diasTranscurridos: json["diasTranscurridos"],
        // nDiasAnulacion: json["nDiasAnulacion"],
        // iMCliente: json["iMCliente"],
        // guiTransporte: json["guiTransporte"],
        // iDAlmacen: json["iDAlmacen"],
        // gratuitas: json["gratuitas"],
        // inafectas: json["inafectas"],
        // exoneradas: json["exoneradas"].toDouble(),
        // recargoConsumo: json["recargo_consumo"],
        // exportacion: json["exportacion"],
        // icbPer: json["icbPer"],
        // iMVendedor: json["iMVendedor"],
        // tVendedor: json["tVendedor"],
        // detalle: json["detalle"],
        // iEstadoSunat: json["iEstadoSunat"],
        // iEstadoOse: json["iEstadoOse"],
        // nPendiente: json["nPendiente"].toDouble(),
        // nCancelado: json["nCancelado"],
        // tDireccionEmisor: json["tDireccionEmisor"],
        // tTelefonoEmisor: json["tTelefonoEmisor"],
        // tMontoLetras: json["tMontoLetras"],
        // empNomcomercial: json["emp_nomcomercial"],
        // tipoNc: json["tipo_nc"],
        // sustentoNc: json["sustento_nc"],
        // correlativoModNc: json["correlativo_mod_nc"],
        // docModNc: json["doc_mod_nc"],
        // fecModNc: json["fec_mod_nc"],
        // tipoDoc: json["tipo_doc"],
        // hash: json["hash"],
        // mensajeConsulta: json["mensaje_consulta"],
        // docCliente: json["doc_cliente"],
        // cdpMoneda: json["cdp_moneda"],
        // iTransporteOrigen: json["iTransporteOrigen"],
        // iTransporteDestino: json["iTransporteDestino"],
        // tOrigenVenta: json["tOrigenVenta"],
        // tGuiaRemision: json["tGuiaRemision"],
        // iDSucursalVenta: json["iDSucursalVenta"],
        // tCiudadTransporteOrigen: json["tCiudadTransporteOrigen"],
        // tCiudadTransporteDestino: json["tCiudadTransporteDestino"],
        // tConsignatarioEncomienda: json["tConsignatarioEncomienda"],
        // lPagado: json["lPagado"],
        // pendientePago: json["pendientePago"],
        // iMDetraccion: json["iMDetraccion"],
        // lRetencionIgv: json["lRetencionIGV"],
        // nRetencionIgv: json["nRetencionIGV"],
        // nRetencionIgvPorcentaje: json["nRetencionIGVPorcentaje"],
      );

  Map<String, dynamic> toJson() => {
        "comprobanteId": comprobanteId,
        // "rucEmisor": rucEmisor,
        // "fechaEmision": fechaEmision,
        // "rucCliente": rucCliente,
        // "razonSocialCliente": razonSocialCliente,
        // "direccionCliente": direccionCliente,
        // "correoCliente": correoCliente,
        // "tipoDocumento": tipoDocumento,
        "serie": serie,
        "numero": numero,
        // "serieOrigen": serieOrigen,
        // "numeroOrigen": numeroOrigen,
        // "tipoDocOrigen": tipoDocOrigen,
        // "moneda": moneda,
        // "tipoCambio": tipoCambio,
        // "importe": importe,
        // "subtotal": subtotal,
        // "descuento": descuento,
        // "igv": igv,
        // "estadoDocumento": estadoDocumento,
        // "estadoSunat": estadoSunat,
        // "fechaEnvio": fechaEnvio,
        // "directorioXml": directorioXml,
        // "directorioZip": directorioZip,
        "directorioPdf": directorioPdf,
        // "directorioZipSunat": directorioZipSunat,
        // "anulado": anulado,
        // "fechaAnulado": fechaAnulado,
        // "motivoBaja": motivoBaja,
        // "emailsEnviados": emailsEnviados,
        // "nResumenes": nResumenes,
        // "enviadoPortal": enviadoPortal,
        // "empresa": empresa,
        // "fechaOrigen": fechaOrigen,
        // "item": item,
        // "codigoPro": codigoPro,
        // "um": um,
        // "descripcion": descripcion,
        // "precioUnit": precioUnit,
        // "cantidad": cantidad,
        // "igvPro": igvPro,
        // "precio": precio,
        // "consulta": consulta,
        // "codigoErrorSunat": codigoErrorSunat,
        // "codigoErrorSistema": codigoErrorSistema,
        // "usuarioRegistra": usuarioRegistra,
        // "isDayAutorized": isDayAutorized,
        // "monto_detraccion": montoDetraccion,
        // "texto_detraccion": textoDetraccion,
        // "observacion": observacion,
        // "ordenCompra": ordenCompra,
        // "importeSoles": importeSoles,
        // "modalidadPago": modalidadPago,
        // "placaVehiculo": placaVehiculo,
        // "requerimiento": requerimiento,
        // "fechaVencimiento": fechaVencimiento,
        // "fechaRegistro": fechaRegistro,
        // "idTipo_Doc": idTipoDoc,
        // "isLast": isLast,
        // "tipo_doc_origen": datumTipoDocOrigen,
        // "correlativo_orgien": correlativoOrgien,
        // "ubicacionPDF": ubicacionPdf,
        // "tTransporteConsignatario": tTransporteConsignatario,
        // "tTransporteOrigen": tTransporteOrigen,
        // "tTransporteDestinp": tTransporteDestinp,
        // "tEmbarcacionPesquera": tEmbarcacionPesquera,
        // "tLiquidacion": tLiquidacion,
        // "tTicket": tTicket,
        // "tipoDocSunat": tipoDocSunat,
        // "diasTranscurridos": diasTranscurridos,
        // "nDiasAnulacion": nDiasAnulacion,
        // "iMCliente": iMCliente,
        // "guiTransporte": guiTransporte,
        // "iDAlmacen": iDAlmacen,
        // "gratuitas": gratuitas,
        // "inafectas": inafectas,
        // "exoneradas": exoneradas,
        // "recargo_consumo": recargoConsumo,
        // "exportacion": exportacion,
        // "icbPer": icbPer,
        // "iMVendedor": iMVendedor,
        // "tVendedor": tVendedor,
        // "detalle": detalle,
        // "iEstadoSunat": iEstadoSunat,
        // "iEstadoOse": iEstadoOse,
        // "nPendiente": nPendiente,
        // "nCancelado": nCancelado,
        // "tDireccionEmisor": tDireccionEmisor,
        // "tTelefonoEmisor": tTelefonoEmisor,
        // "tMontoLetras": tMontoLetras,
        // "emp_nomcomercial": empNomcomercial,
        // "tipo_nc": tipoNc,
        // "sustento_nc": sustentoNc,
        // "correlativo_mod_nc": correlativoModNc,
        // "doc_mod_nc": docModNc,
        // "fec_mod_nc": fecModNc,
        // "tipo_doc": tipoDoc,
        // "hash": hash,
        // "mensaje_consulta": mensajeConsulta,
        // "doc_cliente": docCliente,
        // "cdp_moneda": cdpMoneda,
        // "iTransporteOrigen": iTransporteOrigen,
        // "iTransporteDestino": iTransporteDestino,
        // "tOrigenVenta": tOrigenVenta,
        // "tGuiaRemision": tGuiaRemision,
        // "iDSucursalVenta": iDSucursalVenta,
        // "tCiudadTransporteOrigen": tCiudadTransporteOrigen,
        // "tCiudadTransporteDestino": tCiudadTransporteDestino,
        // "tConsignatarioEncomienda": tConsignatarioEncomienda,
        // "lPagado": lPagado,
        // "pendientePago": pendientePago,
        // "iMDetraccion": iMDetraccion,
        // "lRetencionIGV": lRetencionIgv,
        // "nRetencionIGV": nRetencionIgv,
        // "nRetencionIGVPorcentaje": nRetencionIgvPorcentaje,
      };
}
