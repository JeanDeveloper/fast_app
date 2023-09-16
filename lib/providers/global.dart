library globals;

import 'package:fast/models/Maestro/m_GetCajaListar.dart';
import 'package:fast/models/Maestro/m_GetEmpleado.dart';
import 'package:fast/models/Maestro/m_GetMenuPrincipal.dart';
import 'package:fast/models/Maestro/m_GetNavBarRight.dart';
import 'package:fast/models/Maestro/m_GetTipoDocumentoIdentidad.dart';
import 'package:fast/providers/options.dart' as vOptions;

String? tVersionActual = '1.0.40';
String urlFastGPlay =  "https://play.google.com/store/apps/details?id=com.sertech.fast";

// conexion API
String? UserAPI = 'DEMOAPI';
String? PassAPI = 'DEMOAPI';

// TOKEN
String? token = "";
String? tVersionAndroid = "";

// Login
String? UserLogin = '';
String? PassLogin = '';

// Datos Inicio Sesion
int? iMUsuario = 0;
String? tUsuario = '';
String? tRol = '';
String? tEmpresaRuc = '';
String? tEmpresa = '';
int? iDSucursal = 0;
String? tSucursal = '';
String? tRegion = '';
String? tProvincia = '';
String? tDistrito = '';
String? tUbigeo = '';
String? tTipozona = '';
String? tDireccion = '';
String? tCodigoValidacion = '';
String? tEmpresasJson;

List<TipoDocumentoIdentidadData> listTipoDocumento = [];
List<EmpleadoData> listEmpleado = [];
List<CajaData> listCajas = [];

List<MenuData> listMenuPrincipal = [];
List<NavRightData> listNavRight = [];

// Ruta API
const urlNube = 'http://apimovil.sistemafast.pe'; //'http://138.128.247.60/sertechalfa.pe'; //

String urlAPI = "";
