// import 'package:habilitacion_nexa/models/m_usuarioDatosPorId.dart';
// import 'package:habilitacion_nexa/providers/providers_Restaurante.dart';
import 'dart:async';

import 'package:fast/models/Restaurante/m_GetCartaCategoria.dart';
import 'package:fast/models/Maestro/m_GetFormatosEmpresas.dart';
import 'package:fast/models/Maestro/m_Login.dart';
import 'package:fast/providers/providers.dart';
import 'package:fast/providers/providers_Restaurante.dart';
import 'package:fast/providers/providers_Transporte.dart';
import 'package:fast/providers/settings.dart';
import 'package:fast/screens/Home/s_principal.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/widgets/decoration.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/options.dart' as vOptions;
import 'package:fast/providers/global_Restaurante.dart' as vGlobal_Restaurante;
import 'dart:convert';

import 'package:url_launcher/link.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _login createState() => new _login();
}

class _login extends State<login> {
  bool _obscureText = true;
  final cusuario = TextEditingController(text: "");
  final cPassword = TextEditingController(text: "");

  int tipoConexion = vOptions.tipoConexion ?? 1;
  int statusservidorConexion = (vOptions.tipoConexion ?? 1);
  String? servidorConexion = vOptions.servidorConexion ?? "";
  final cServidorConexion = TextEditingController(text: vOptions.servidorConexion);
  String? servidorConexionPuerto = vOptions.servidorConexionPuerto ?? "";
  final cservidorConexionPuerto = TextEditingController(text: vOptions.servidorConexionPuerto.toString());

  String textValue = "";
  bool actualizado = true;

  void MostrarConfig(String Configuracion, int status) {
    setState(() {
      if (Configuracion == "ServidorConexion") {
        statusservidorConexion = status;
      }
    });
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: ClsColor.tipo1(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [Expanded(child: form_login(context))],
          ),
        ),
      ),
    );
  }

  _Configuracion(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 370, maxHeight: 370),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Tipo de Conexión',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: ClsColor.tipo1(), fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                activeColor: ClsColor.tipo1(),
                                title: Text("Nube", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: ClsColor.tipo5())),
                                value: 1,
                                groupValue: tipoConexion,
                                onChanged: (value) async {
                                  final prefs = await SharedPreferences.getInstance();
                                  MostrarConfig("ServidorConexion", 1);
                                  setState(() {
                                    tipoConexion = value ?? 1;
                                    prefs.setInt('tipoConexion', value ?? 1);
                                    vOptions.tipoConexion = value;
                                    Navigator.pop(context);
                                    _Configuracion(context);
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                activeColor: ClsColor.tipo1(),
                                title: Text("Local", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: ClsColor.tipo5())),
                                value: 2,
                                groupValue: tipoConexion,
                                onChanged: (value) async {
                                  final prefs = await SharedPreferences.getInstance();
                                  MostrarConfig("ServidorConexion", 2);
                                  setState(() {
                                    tipoConexion = value ?? 1;
                                    prefs.setInt('tipoConexion', value ?? 2);
                                    vOptions.tipoConexion = value;
                                    Navigator.pop(context);
                                    _Configuracion(context);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (statusservidorConexion == 2) ...[
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Servidor',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: ClsColor.tipo1(), fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                Container(
                                  //padding: const EdgeInsets.only(left: 10, right: 10),
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 70,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'IP:',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(color: ClsColor.tipo1(), fontSize: 14, fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              MyInputFormatters.ipAddressInputFilter(),
                                              LengthLimitingTextInputFormatter(15),
                                              IpAddressInputFormatter(),
                                            ],
                                            controller: cServidorConexion,
                                            style:const  TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                            decoration: InputDecoration(
                                              // isDense: true,
                                              fillColor: ClsColor.tipo4(),
                                              hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo6()),
                                              labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo5()),
                                              floatingLabelBehavior: FloatingLabelBehavior.never,
                                            ),
                                            onChanged: (ip) async {
                                              final prefs = await SharedPreferences.getInstance();
                                              servidorConexion = cServidorConexion.text;
                                              prefs.setString('servidorConexion', cServidorConexion.text);
                                              vOptions.servidorConexion = cServidorConexion.text;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 70,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'Puerto:',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(color: ClsColor.tipo1(), fontSize: 14, fontWeight: FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: cservidorConexionPuerto,
                                            maxLength: 4,
                                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                            decoration: InputDecoration(
                                              // isDense: true,
                                              fillColor: ClsColor.tipo4(),
                                              hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo6()),
                                              labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo5()),
                                              floatingLabelBehavior: FloatingLabelBehavior.never,
                                            ),
                                            onChanged: (ip) async {
                                              final prefs = await SharedPreferences.getInstance();
                                              servidorConexionPuerto = cservidorConexionPuerto.text;
                                              prefs.setString('servidorConexionPuerto', cservidorConexionPuerto.text);
                                              vOptions.servidorConexionPuerto = cservidorConexionPuerto.text;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () async {
                            ClsDecoration.showDialogLoading(context);
                            try {
                              if (vOptions.tipoConexion == 1) {
                                vGlobal.urlAPI = vGlobal.urlNube;
                                await posToken();
                              } else {
                                if (vOptions.servidorConexion!.length > 0 && vOptions.servidorConexionPuerto!.length > 0) {
                                  
                                  //JEAN MODIFICACION
                                  vGlobal.urlAPI = 'https://${vOptions.servidorConexion}:${vOptions.servidorConexionPuerto}';
                                  // vGlobal.urlAPI = 'https://localhost:5001';
                                  await posToken();
                                } else {
                                  Navigator.of(context).pop();
                                  Fluttertoast.showToast(msg: "Ingrese parametros de Conexión", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                  return;
                                }
                              }
                            } catch (e) {
                              Navigator.of(context).pop();
                              Fluttertoast.showToast(msg: "Error de Conexion al servidor", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                              return;
                            }

                            if (vGlobal.token!.length > 0) {
                              Fluttertoast.showToast(msg: "Conexión Exitosa", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                            } else {
                              Fluttertoast.showToast(msg: "Error de Conexion al servidor", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                            }
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(const Size(220, 40)),
                            backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo6()),
                            padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            )),
                          ),
                          icon: Icon(Icons.private_connectivity_rounded, size: 20, color: ClsColor.tipo4()),
                          label: Text("Prueba de Conexion", style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: ClsColor.tipo4(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(100, 30),
                      ),
                      icon: const Icon(Icons.keyboard_return_rounded, size: 15),
                      label: const Text("Cerrar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void updateText(String valor) {
    setState(() {
      textValue = valor;
    });
  }

  Container form_login(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    onPressed: () {
                      _Configuracion(context);
                    },
                    icon: const Icon(Icons.settings),
                    color: ClsColor.tipo4()
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(height: 120),
                      const Image(image: ExactAssetImage('assets/images/FAST_BLANCO_2x.png'), fit: BoxFit.fill, width: 170),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: cusuario,
                        decoration: InputDecoration(
                          filled: true,
                          isDense: true,
                          fillColor: ClsColor.tipo4(),
                          border: ClsDecoration.inputborder(),
                          enabledBorder: ClsDecoration.inputborder(),
                          focusedBorder: ClsDecoration.focusborder(),
                          hintText: 'Usuario',
                          hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo6()),
                          labelText: 'Usuario',
                          labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo5()),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          prefixIconColor: ClsColor.tipo5(),
                          prefixIcon: Icon(Icons.badge, size: 16, color: ClsColor.tipo5()),
                          suffixIconColor: ClsColor.tipo5(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: cPassword,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          filled: true,
                          isDense: true,
                          fillColor: ClsColor.tipo4(),
                          border: ClsDecoration.inputborder(),
                          enabledBorder: ClsDecoration.inputborder(),
                          focusedBorder: ClsDecoration.focusborder(),
                          hintText: '**********',
                          hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo6()),
                          labelText: 'Contraseña',
                          labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo5()),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          prefixIconColor: ClsColor.tipo5(),
                          prefixIcon: Icon(Icons.key, size: 16, color: ClsColor.tipo5()),
                          suffixIconColor: ClsColor.tipo5(),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText == false ? Icons.visibility : Icons.visibility_off, size: 16, color: ClsColor.tipo5()),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      MaterialButton(
                        onPressed: () async {
                          vGlobal.token = "";
                          try {
                            if (vOptions.tipoConexion == 1) {
                              vGlobal.urlAPI = vGlobal.urlNube;
                              await posToken();
                            } else {
                              if (vOptions.servidorConexion!.length > 0 && vOptions.servidorConexionPuerto!.length > 0) {
                                vGlobal.urlAPI = 'http://${vOptions.servidorConexion}:${vOptions.servidorConexionPuerto}';
                                await posToken();
                              } else {
                                _Configuracion(context);
                                Fluttertoast.showToast(msg: "Ingrese parametros de Conexión", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                return;
                              }
                            }
                          } catch (e) {
                            _Configuracion(context);
                            Fluttertoast.showToast(msg: "Error de Conexion al servidor", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                            return;
                          }

                          if (vGlobal.token == "") {
                            _Configuracion(context);
                            Fluttertoast.showToast(msg: "Error de Conexion al servidor", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                            return;
                          } else {
                            // if (vGlobal.tVersionAndroid != vGlobal.tVersionActual) {
                            //   actualizado = false;
                            //   updateText("Version instalada ${vGlobal.tVersionActual}\n\nActualíce a la versión mas reciente...");
                            //   return;
                            // } else {
                            ClsDecoration.showDialogLoading(context);
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
                            await Future.delayed(const Duration(seconds: 1));
                            try {
                              await posToken();
                            } catch (e) {
                              Navigator.of(context).pop();
                              Fluttertoast.showToast(msg: "Error de Conexion al servidor", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                              return;
                            }

                            await Future.delayed(const Duration(seconds: 1));
                            bool alert = false;
                            String title = 'Alerta';
                            String message = '';
                            String cierre = 'Cerrar';

                            if (cusuario.text != '' && cPassword.text != '') {
                              try {
                                final MLogin? Postlog = await posLogin(cusuario.text, cPassword.text);
                                var dataLogin = jsonEncode(Postlog);
                                var tJsonLogin = mLoginFromJson(dataLogin.toString());
                                if (tJsonLogin.code == 0) {
                                  final prefs = await SharedPreferences.getInstance();
                                  prefs.setString('usuario', cusuario.text);
                                  prefs.setString('password', cPassword.text);
                                  vGlobal.UserLogin = cusuario.text;
                                  // vOptions.tipoImpresion = prefs.getInt('tipoImpresion') ?? 1;
                                  vOptions.tipoConexion = prefs.getInt('tipoConexion') ?? 1;
                                  vOptions.servidorImpresion = prefs.getString('servidorImpresion') ?? "";
                                  vOptions.servidorImpresionPuerto = prefs.getInt('servidorImpresionPuerto') ?? 80;
                                  vOptions.impresoraPrecuenta = prefs.getString('impresoraPrecuenta') ?? "";
                                  vOptions.impresoraOrden = prefs.getString('impresoraOrden') ?? "";
                                  vOptions.impresoraAnulacion = prefs.getString('impresoraAnulacion') ?? "";
                                  vOptions.impresoraTest = prefs.getString('impresoraTest') ?? "";
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
                                  await loadProductos();
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
                                  Navigator.of(context).pop();
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const principal()));
                                } else {
                                  Navigator.of(context).pop();
                                  Fluttertoast.showToast(msg: tJsonLogin.message, gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                }
                              } catch (e) {
                                Navigator.of(context).pop();
                                Fluttertoast.showToast(msg: "No pudo Conectar al Servidor", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                              }
                            } else {
                              Navigator.of(context).pop();
                              Fluttertoast.showToast(msg: "Complete Datos", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                            }
                            // }
                          }
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        color: ClsColor.tipo3(),
                        splashColor: ClsColor.tipo1(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Iniciar Sesión',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: ClsColor.tipo5(), fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
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
                              uri: Uri.parse('https://play.google.com/store/apps/details?id=com.sertech.fast'),
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
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Un producto de SERTECH PERU EIRL', textAlign: TextAlign.center, style: TextStyle(color: ClsColor.tipo4(), fontSize: 12, fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
              Text('Version ${vGlobal.tVersionActual}', style: TextStyle(color: ClsColor.tipo4(), fontSize: 12, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ),
    );
  }
}
