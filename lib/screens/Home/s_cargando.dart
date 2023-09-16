import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fast/models/Restaurante/m_GetCartaCategoria.dart';
import 'package:fast/models/Maestro/m_GetFormatosEmpresas.dart';
import 'package:fast/models/Maestro/m_Login.dart';
import 'package:fast/providers/providers.dart';
import 'package:fast/providers/providers_Transporte.dart';
import 'package:fast/styles/color_style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fast/screens/Home/s_Principal.dart';
import 'package:fast/screens/Home/s_Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/options.dart' as vOptions;
import 'package:fast/providers/providers_Restaurante.dart';
import 'package:fast/providers/global_Restaurante.dart' as vGlobal_Restaurante;
import 'package:url_launcher/link.dart';

// ignore: camel_case_types
class cargando extends StatefulWidget {
  const cargando({Key? key}) : super(key: key);

  @override
  State<cargando> createState() => _cargando();
}

class _cargando extends State<cargando> {
  String textValue = "Iniciando...";
  bool actualizado = true;

  @override
  void initState() {
    _asyncMethod();
    super.initState();
  }

  void updateText(String valor) {
    setState(() {
      textValue = valor;
    });
  }

  _asyncMethod() async {
    // updateText("Iniciando...");
    try {
      await Future.delayed(const Duration(seconds: 1));
      final prefs = await SharedPreferences.getInstance();
      String usuario = prefs.getString('usuario') ?? "";
      vGlobal.UserLogin = usuario;
      String password = prefs.getString('password') ?? "";
      vGlobal.urlAPI = vGlobal.urlNube;
      await Future.delayed(const Duration(seconds: 1));

      // updateText("Conectando al Servidor...");
      // await Future.delayed(const Duration(seconds: 1));
      // if (vGlobal.token == "") {
      //   updateText("No se logro connectar al servidor, vuelva a iniciar el Aplicativo...");
      //   Timer(const Duration(seconds: 3), () => exit(0));
      //   return;
      // } else {
      //   if (vGlobal.tVersionAndroid != vGlobal.tVersionActual) {
      //     updateText("Version instalada ${vGlobal.tVersionActual}\n\n  Actualíce a la versión mas reciente...");
      //     actualizado = false;
      //     return;
      //   } 
      // }

      vOptions.servidorImpresion = prefs.getString('servidorImpresion') ?? "";
      vOptions.servidorImpresionPuerto = prefs.getInt('servidorImpresionPuerto') ?? 80;
      vOptions.impresoraPrecuenta = prefs.getString('impresoraPrecuenta') ?? "";
      vOptions.impresoraOrden = prefs.getString('impresoraOrden') ?? "";
      vOptions.impresoraAnulacion = prefs.getString('impresoraAnulacion') ?? "";
      vOptions.impresoraTest = prefs.getString('impresoraTest') ?? "";
      await Future.delayed(const Duration(seconds: 1));
      if (usuario != '' && password != '') {
        try {
          updateText("Conectando al servidor...");
          final prefs = await SharedPreferences.getInstance();
          int? va1 = prefs.getInt('tipoConexion') ?? 1;
          String? va2 = prefs.getString('servidorConexion') ?? "";
          String? va3 = prefs.getString('servidorConexionPuerto') ?? "";
          setState(() {
            vOptions.tipoConexion = va1;
            vOptions.servidorConexion = va2;
            vOptions.servidorConexionPuerto = va3;
            if (va1 == 1) {
              vGlobal.urlAPI = vGlobal.urlNube;
            } else {
              vGlobal.urlAPI = 'http://${vOptions.servidorConexion}:${vOptions.servidorConexionPuerto}';
            }
          });
          await Future.delayed(const Duration(seconds: 2));

          final MLogin? postlog = await posLogin(usuario, password);
          var dataLogin = jsonEncode(postlog);
          var tJsonLogin = mLoginFromJson(dataLogin.toString());

          vGlobal.iMUsuario = tJsonLogin.data.iMUsuario;
          vGlobal.tUsuario = tJsonLogin.data.tUsuario;
          vGlobal.tRol = tJsonLogin.data.tRol;
          vGlobal.tEmpresaRuc = tJsonLogin.data.tEmpresaRuc;
          vGlobal.tEmpresa = tJsonLogin.data.tEmpresa;
          vGlobal.iDSucursal = tJsonLogin.data.iDSucursal;
          vGlobal.tSucursal = tJsonLogin.data.tSucursal;
          vGlobal.tUbigeo = tJsonLogin.data.tUbigeo;
          vGlobal.tRegion = tJsonLogin.data.tRegion;
          vGlobal.tProvincia = tJsonLogin.data.tProvincia;
          vGlobal.tDistrito = tJsonLogin.data.tDistrito;
          vGlobal.tTipozona = tJsonLogin.data.tTipozona;
          vGlobal.tDireccion = tJsonLogin.data.tDireccion;
          vGlobal.tCodigoValidacion = tJsonLogin.data.tCodigoValidacion;

          await loadMenuPrincipal();
          await loadNavRight();

          String? listEmpresas = await loadEmpresas;
          try {
            await loadProductos();
          } catch (e) {
            updateText("No se logro cargar datos del usuario...");
            Timer(const Duration(seconds: 1), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const login())));
          }
          String? listCategoria = await loadCategoria;
          await loadTipoDocumentoIdentidad;
          await loadEmpleado();
          await loadCaja();
          await loadCiudad();
          await loadZonaDelivery();
          MGetFormatosEmpresas? cargaformatos = await loadFormatos;

          for (int i = 0; i < mGetCartaCategoriaFromJson(listCategoria.toString()).data.length; i++) {
            vGlobal_Restaurante.valuesCategoriaList![i] = mGetCartaCategoriaFromJson(listCategoria.toString()).data[i].iMCategoria!;
            vGlobal_Restaurante.labelCategoriaList![i] = mGetCartaCategoriaFromJson(listCategoria.toString()).data[i].tCategoria!;
          }
          vGlobal_Restaurante.valuesCategoriaList![mGetCartaCategoriaFromJson(listCategoria.toString()).data.length] = 0;
          vGlobal_Restaurante.labelCategoriaList![mGetCartaCategoriaFromJson(listCategoria.toString()).data.length] = "TODOS";
          updateText("Obteniendo datos de usuario...");
          await Future.delayed(const Duration(seconds: 1));

          updateText("Cargando pantalla principal...");
          Timer(const Duration(seconds: 1), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const principal())));
        } catch (e) {
          updateText("No se logro cargar datos del usuario...");
          Timer(const Duration(seconds: 1), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const login())));
        }
      } else {
        updateText("Cargando pantalla de inicio...");
        Timer(const Duration(seconds: 1), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const login())));
      }
      //   }
      // }
    } catch (e) {
      updateText("No se logro cargar datos del usuario...");
      Timer(const Duration(seconds: 1), () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const login())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ClsColor.tipo1(),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   'CONTROL DE ASISTENCIA',
            //   style: TextStyle(color: ClsColor.tipo5(), fontSize: 20, fontWeight: FontWeight.w700),
            // ),
            const Image(
              image: ExactAssetImage('assets/images/FAST_ICONO2.png'),
              fit: BoxFit.cover,
              width: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                textValue,
                textAlign: TextAlign.center,
                style: TextStyle(color: ClsColor.tipo4(), fontSize: 15),
              ),
            ),
            if (actualizado == false) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(Icons.cloud_download_rounded, size: 30, color: ClsColor.tipo3()),
                  Link(
                    uri: Uri.parse(vGlobal.urlFastGPlay),
                    target: LinkTarget.self,
                    builder: (context, followLink) {
                      return RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Descargar version ${vGlobal.tVersionAndroid}',
                              style: TextStyle(
                                color: ClsColor.tipo3(),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                // decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = followLink,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}
