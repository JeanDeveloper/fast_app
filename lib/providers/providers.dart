import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:fast/models/Maestro/m_GetCajaListar.dart';
import 'package:fast/models/Maestro/m_GetClienteBuscarPorNroDoc.dart';
import 'package:fast/models/Maestro/m_GetEmpleado.dart';
import 'package:fast/models/Maestro/m_GetMenuPrincipal.dart';
import 'package:fast/models/Maestro/m_GetNavBarRight.dart';
import 'package:fast/models/Maestro/m_GetTipoDocumentoIdentidad.dart';
import 'package:fast/models/Maestro/m_Login.dart';
import 'package:fast/models/Maestro/m_Token.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Restaurante.dart' as vGlobal_Restaurante;
import 'package:fast/providers/global_Caja.dart' as vGlobal_caja;
import 'package:http/http.dart' as http;
import 'package:fast/providers/options.dart' as vOptions;
import 'package:shared_preferences/shared_preferences.dart';

extension ColorExtension on String {
  toColor() {
    var hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

Future<mToken?> posToken() async {
  try {
    String tUserAPI = vGlobal.UserAPI.toString();
    String tPassAPI = vGlobal.PassAPI.toString();
    final response = await http.post(
      Uri.parse("${vGlobal.urlAPI}/Seguridad/Token?usuario=$tUserAPI&clave=$tPassAPI"),
      // Uri.parse("http://192.168.1.12:7001/Seguridad/Token?usuario=$tUserAPI&clave=$tPassAPI"),
      headers: {"Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
    );
    final String responseString = response.body;  
    final Mtoken = mTokenFromJson(responseString);
    var dataToken = jsonEncode(Mtoken);
    var tJsonToken = mTokenFromJson(dataToken.toString());
    var tToken = tJsonToken.data.token;
    vGlobal.token = tToken.toString();
    vGlobal.tVersionAndroid = tJsonToken.data.tVersionAndroid.toString();
    return mTokenFromJson(responseString);
  }on SocketException catch ( e ) {
    print(e.address);
    print(e.message);
    print(e.port);
    print(e.osError);
    rethrow;
  }
}

Future<List<TipoDocumentoIdentidadData>?> loadTipoDocumentoIdentidad(String? quitar) async {
  String tEmpresa = vGlobal.tEmpresaRuc.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Maestro/GetTipoDocumentoIdentidad'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );    
  if (response.statusCode == 200) {
    var sTipoDocumentoIdentidad = getTipoDocumentoIdentidadFromJson(response.body);
    //sTipoDocumentoIdentidad.data.removeWhere((element) => element.iMTipoDocumentoIdentidad.contains("0"));
    if (quitar == "RUC") {
      sTipoDocumentoIdentidad.data.removeWhere((element) => element.iMTipoDocumentoIdentidad.contains("6"));
    }

    return sTipoDocumentoIdentidad.data;
  }
  return null;
}

Future<List<EmpleadoData>?> loadEmpleado() async {
  vGlobal.listEmpleado = [];
  String tEmpresa = vGlobal.tEmpresaRuc.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Maestro/GetEmpleado?tEmpresaRuc=$tEmpresa'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    var sEmpleado = getEmpleadoFromJson(response.body);
    if (sEmpleado.code == 0) {
      if (sEmpleado.data.isNotEmpty) {
        vGlobal.listEmpleado = sEmpleado.data;
      }
    }
  }
}   

Future<List<CajaData>?> loadCaja() async {
  vGlobal.listCajas = [];
  String tEmpresa = vGlobal.tEmpresaRuc.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Maestro/GetCajaListar?tEmpresaRuc=$tEmpresa'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    var sCaja = getCajaListarFromJson(response.body);
    if (sCaja.code == 0) {
      if (sCaja.data.isNotEmpty) {
        vGlobal.listCajas = sCaja.data;
      }
    }
  }
}

Future<GetClienteBuscarPorNroDoc?> getClienteBuscarPorNroDoc(String NroDoc, int tipo) async {
  String tEmpresa = vGlobal.tEmpresaRuc.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Maestro/GetClienteBuscarPorNroDoc?tNroDocumento=$NroDoc&tEmpresaRuc=$tEmpresa&iTipo=${tipo.toString()}'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return getClienteBuscarPorNroDocFromJson(responseString);
  } else {
    return null;
  }
}

Future<MLogin?> posLogin(String usuario, String pass) async {
  final response = await http.post(
    Uri.parse('${vGlobal.urlAPI}/Seguridad/IniciarSesion?usuario=$usuario&clave=$pass'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );

  if (response.statusCode == 200) {
    final String responseString = response.body;
    var jsonLogin = mLoginFromJson(responseString);
    var varl = jsonLogin.code;
    return mLoginFromJson(responseString);
  } else {
    return null;
  }
}

Future<String?> get loadEmpresas async {
  String tiUsuario = vGlobal.iMUsuario.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Usuario/GetEmpresas?iMUsuario=$tiUsuario'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    vGlobal.tEmpresasJson = "";
    vGlobal.tEmpresasJson = response.body;
    return response.body;
    //return compute(mGetCartaProductosFromJson, response.body);
  }
  return null;
}

Future<Map<String, dynamic>?> posImpresionWifi(String url, String impresora, String codigo) async {
  Map<String, dynamic> resp = {};
  final response = await http.post(
    Uri.parse('http://${vOptions.servidorImpresion}:${vOptions.servidorImpresionPuerto.toString()}/Download/guardar?url=$url&tImpresora=$impresora&tCodigo=$codigo'),
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "content-type": "application/json",
      "Accept": "application/json",
    },
  ).timeout(
    const Duration(seconds: 7),
    onTimeout: () => throw TimeoutException('Can\'t connect in 10 seconds.'),
  );
  // await Future.delayed(const Duration(seconds: 5));
  print(response);

  if (response.body.isNotEmpty) {
    bool code = jsonDecode(response.body)["success"];
    final message = jsonDecode(response.body)["message"];
    resp = {"code": code, "mensaje": message};
    return resp;
  }
  return null;
}

Future<Map<String, dynamic>?> getStatusServerPrint() async {
  // try {
  Map<String, dynamic> resp = {};
  final response = await http.get(
    Uri.parse('http://${vOptions.servidorImpresion}:${vOptions.servidorImpresionPuerto.toString()}/Download/VerificarStatus'),
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "content-type": "application/json",
      "Accept": "application/json",
    },
  ).timeout(
    const Duration(seconds: 7),
    onTimeout: () => throw TimeoutException('Can\'t connect in 10 seconds.'),
  );
  //192.168.1.9:8081

  if (response.body.isNotEmpty) {
    bool code = jsonDecode(response.body)["success"];
    final message = jsonDecode(response.body)["message"];
    resp = {"code": code, "mensaje": message};
  } else {
    bool code = false;
    final message = "";
    resp = {"code": code, "mensaje": message};
  }
  return resp;
  // } catch (e) {
  //   return null;
  // }
}

Future<List<MenuData>?> loadMenuPrincipal() async {
  vGlobal.listMenuPrincipal = [];
  String iMUsuario = vGlobal.iMUsuario.toString();
  String tEmpresaRuc = vGlobal.tEmpresaRuc.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Maestro/GetMenuPrincipal?iMUsuario=$iMUsuario&tEmpresaRuc=$tEmpresaRuc'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    var sMenu = getMenuPrincipalFromJson(response.body);
    if (sMenu.code == 0) {
      if (sMenu.data.isNotEmpty) {
        vGlobal.listMenuPrincipal = sMenu.data;
      }
    }
  }
}

Future<List<NavRightData>?> loadNavRight() async {
  vGlobal.listNavRight = [];
  String iMUsuario = vGlobal.iMUsuario.toString();
  String tEmpresaRuc = vGlobal.tEmpresaRuc.toString();
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Maestro/GetNavBarRight?iMUsuario=$iMUsuario&tEmpresaRuc=$tEmpresaRuc'),
    headers: {"Authorization": "Bearer ${vGlobal.token}", "Access-Control-Allow-Origin": "*", "Access-Control-Allow-Credentials": "true", "content-type": "application/json", "Accept": "application/json"},
  );
  if (response.statusCode == 200) {
    var sMenu = getNavBarRightFromJson(response.body);
    if (sMenu.code == 0) {
      if (sMenu.data.isNotEmpty) {
        vGlobal.listNavRight = sMenu.data;
      }
    }
  }
}
