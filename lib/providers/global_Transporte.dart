library globals;

import 'package:fast/models/Comprobante/m_GetComprobanteSendMail.dart';
import 'package:fast/models/Transporte/m_GetCiudad.dart';
import 'package:fast/models/Transporte/m_GetProgramacion.dart';

List<CiudadData> listCiudad = [];
List<ProgramacionData> listProgramacion = [];
int iMModeloTransporte = 0;
int iDProgramacionFecha = 0;
int iCiudadOrigen = 0;
int iCiudadDestino = 0;
String tCiudadOrigen = "";
String tCiudadDestino = "";

int? iAsientoStatus;
int iAsiento = 0;
int iNivel = 0;
String tPasajeroDoc = "";
String tPasajero = "";
String fecha = "";
String hora = "";
String ruta = "";
String tPlaca = "";
int iMVentaTransporte = 0;

String tTipoComprobante = "";
List<Map<String, dynamic>> listProductoTraslado = [];

double iPrecioInicial = 0;
double iPrecioFinal = 0;
double iDescuento = 0;

String letra = "";
String descripcion = "";

int iDCajaDiaria = 0;
int iMCaja = 0;
int iMoneda = 0;

//ORDEN DE TRASLADO
int ort_origen = listCiudad[0].iMCiudad;
int ort_destino = listCiudad[0].iMCiudad;
String ort_fecha = "";

int ort_remi_id = 0;
String ort_remi_tipoDoc = "1";
String ort_remi_doc = "";
String ort_remi = "";

int ort_cons_id = 0;
String ort_cons_tipoDoc = "1";
String ort_cons_doc = "";
String ort_cons = "";
String ort_cons_telef = "";

//VENTA BOLETO
String? TipoAcceso;
int? iMCliente;
String? CClienteDoc;
String? CCliente;
String? CClienteDir;
int? iMPasajero;
String? tPasajeroTipoDoc;
String? CPasajeroDoc;
String? CPasajero;
String? TipoComprobante;
double? descuento;
bool? aplica;

double? pInicial;
double? pFinal;
String? Letra;
double? pDescuento;
double? pPorDescuento;
String? tDescripcion;
// String? iMCliente;
String? tClienteDoc;
String? tCliente;
String? tClienteDireccion;
String? PlacaVehiculo;
String? ModalidaPago;
String? tSerie;
String? tNumeracion;
String? iTipoFac;
String? tTipoDocCliente;
