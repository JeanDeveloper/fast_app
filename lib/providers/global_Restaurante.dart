library globals;

import 'package:fast/models/Restaurante/m_GetCartaProductos.dart';
import 'package:fast/models/Restaurante/m_GetMesas.dart';
import 'package:fast/models/Restaurante/m_GetReason.dart';
import 'package:fast/models/Restaurante/m_GetZonaDelivery.dart';

int? iMSalon;
String? tSalon = "";
int? iMMesa;
String? tMesa = "";
String? tCliente;
int? iPax;

String tProductosJson = "";
List<CartaProductoData>? listProductos = [];
List<ZonaDeliveryData> listZonaDelivery = [];
int? iMProducto;
int? indexProducto;
String? tProducto;
String? tSubCategoria;
String? tImagenProducto;
double? nPrecioUnitario;
double? nPrecioUnitarioBase;
double? montoAgregadoSum;

double? iPrecuentaPersonalizacion = 0;
double? iPrecuenta = 0;
int? iIDPedido;
String? horaPedido;
String? TipoPedido = "";

String? tCategoriaJson;
List<String>? labelCategoriaList;
List<int>? valuesCategoriaList;

List<Map<String, dynamic>> listPrecuenta = [];

int? iDFormatoPrecuenta;
int? iDFormatoOrden;
int? iDFormatoAnulacion;


//variables globales de anulacion.
int? tAnulacionCanal;
String? tAnulacionProducto;
String? tAnulacionCantidad;
String? tAnulacionObservacion;
Data? tMotivoAnulacion;

List<MesasData> ListaMesasNivel = [];

String? delTelefono;
String? delCliente;
String? delDireccion;
String? delReferencia;
int? deliMZona;
int? iMProductoDelivery;
