import 'dart:convert';

import 'package:fast/models/Caja/m_GetCajaDiariaAbiertaUsuario.dart';
import 'package:fast/models/Maestro/m_GetNavBarRight.dart';
import 'package:fast/providers/providers.dart';
import 'package:fast/providers/providers_Caja.dart';
import 'package:fast/screens/Caja/s_caja_cajaChica.dart';
import 'package:fast/screens/Transporte/s_trans_registrar.dart';
import 'package:flutter/material.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/widgets/decoration.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Transporte.dart' as vGlobal_transporte;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:whatsapp_share2/whatsapp_share2.dart';
import 'package:fast/providers/options.dart' as vOptions;
import 'package:whatsapp_share/whatsapp_share.dart';

class NavDrawer extends StatefulWidget {
  NavDrawer({Key? key}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawer();
}

class _NavDrawer extends State<NavDrawer> {
  List<NavRightData> menu = vGlobal.listNavRight;

  _modalBottom() async {
    showModalBottomSheet(
      backgroundColor: ClsColor.tipo4(),
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('¿Desea aperturar Caja?', style: TextStyle(color: ClsColor.tipo5(), fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(const Size(100, 40)),
                        backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo8()),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                      icon: Icon(Icons.block, size: 14.0, color: ClsColor.tipo4()),
                      label: Text('No', style: TextStyle(color: ClsColor.tipo4(), fontSize: 14)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const caja_cajaChica()));
                        },
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(const Size(100, 40)),
                            backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)))),
                        icon: Icon(Icons.check, size: 14.0, color: ClsColor.tipo4()),
                        label: Text('Si', style: TextStyle(color: ClsColor.tipo4(), fontSize: 14))),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ClsColor.tipo1(),
      child: DrawerHeader(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: ClsColor.tipo3(),
                    child: CircleAvatar(
                      radius: 25,
                      child: ClsDecoration.ImageAvatar(),
                    ),
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          vGlobal.tUsuario == null ? "" : vGlobal.tUsuario.toString(),
                          style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          vGlobal.tEmpresa == null ? "" : vGlobal.tEmpresa.toString(),
                          style: TextStyle(color: ClsColor.tipo4(), fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Divider(color: ClsColor.tipo2(), thickness: 0.5, endIndent: 0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < menu.length; i++) ...[
                      if (menu[i].iTipo == 1) ...[
                        ListTile(
                          leading: Icon(IconData(int.parse(menu[i].tIcono), fontFamily: 'MaterialIcons')),
                          title: Text(
                            menu[i].tNombre,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          iconColor: const Color.fromARGB(255, 255, 255, 255),
                          textColor: const Color.fromARGB(255, 255, 255, 255),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          ),
                          onTap: () async {
                            if (menu[i].iMMenu == 3) {
                              //SOPORTE
                              try {
                                await WhatsappShare.share(package: Package.businessWhatsapp, text: "Hola! ", phone: "51919475719");
                              } catch (e) {
                                await WhatsappShare.share(package: Package.whatsapp, text: "Hola! ", phone: "51919475719");
                              }
                            } else if (menu[i].iMMenu == 6) {
                              //TEST IMPRESION
                              ClsDecoration.showDialogLoading(context);
                              bool statusServidorLocal = true;
                              if (vOptions.tipoImpresion == 2 || vOptions.tipoImpresion == null) {
                                try {
                                  Map<String, dynamic>? postReg = await getStatusServerPrint();
                                  bool codigo = postReg?["code"];
                                  if (codigo == false) {
                                    Fluttertoast.showToast(
                                      msg: "Error: No se logro conectar al servidor local, Verifique la Configuración de Impresoras",
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: ClsColor.tipo6(),
                                      textColor: ClsColor.tipo4()
                                    );
                                    statusServidorLocal = false;
                                    Navigator.of(context).pop();
                                    return;
                                  }
                                } catch (e) {
                                  Fluttertoast.showToast(msg: "Error: Verifique la Configuración de Impresoras", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                  statusServidorLocal = false;
                                  Navigator.of(context).pop();
                                  return;
                                }
                              }

                              if (statusServidorLocal == true) {
                                if (vOptions.tipoImpresion == 2 || vOptions.tipoImpresion == null) {
                                  Map<String, dynamic>? postReg = await posImpresionWifi("https://app.sistemafast.pe/PDF//TestImpresionRestaurante.pdf", vOptions.impresoraTest!, "Test");
                                  final code = postReg?["code"].toString();
                                  final mensaje = postReg?["mensaje"];
                                  Navigator.of(context).pop();
                                  Fluttertoast.showToast(msg: mensaje ?? "error al enviar Pdf", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                } else {
                                  Navigator.of(context).pop();
                                }
                              }
                            } else if (menu[i].iMMenu == 12) {
                              //REGISTRO BOLETO DE VIAJE
                              final GetCajaDiariaAbiertaUsuario? postlog = await getCajaDiariaAbierta();
                              var dataCaja = jsonEncode(postlog);
                              var tJsonCaja = getCajaDiariaAbiertaUsuarioFromJson(dataCaja.toString());
                              if (tJsonCaja.data.isNotEmpty) {
                                vGlobal_transporte.iDCajaDiaria = tJsonCaja.data[0].iDCajaDiaria;
                                vGlobal_transporte.iMCaja = tJsonCaja.data[0].iMCaja;
                                vGlobal_transporte.iMoneda = tJsonCaja.data[0].iMoneda;
                                Navigator.push(context, MaterialPageRoute(builder: (context) => trans_registrarBoleto()));
                              } else {
                                _modalBottom();
                                Fluttertoast.showToast(msg: "No cuenta con una caja abierta para hoy", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                              }
                            } else {
                              if (menu[i].tRuta == "") {
                                Fluttertoast.showToast(msg: "Pronto estará disponible esta función", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                              } else {
                                Navigator.pushReplacementNamed(context, menu[i].tRuta);
                              }
                            }
                          },
                        )
                      ] else ...[
                        Divider(color: ClsColor.tipo2(), thickness: 0.5, endIndent: 50)
                      ]
                    ],
                  ],
                ),
              ),
            ),
            Divider(color: ClsColor.tipo2(), thickness: 0.5, endIndent: 0),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Cerrar Sesión", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              iconColor: const Color.fromARGB(255, 255, 255, 255),
              textColor: const Color.fromARGB(255, 255, 255, 255),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
              ),
              onTap: () async {
                vGlobal.iMUsuario = 0;
                final prefs = await SharedPreferences.getInstance();
                prefs.remove('usuario');
                prefs.remove('password');
                Navigator.pushReplacementNamed(context, "navlogin");
              },
            ),
            if (vOptions.tipoConexion == 1) ...[
              Icon(Icons.cloud_done_rounded, color: ClsColor.tipo3()),
            ] else ...[
              Icon(Icons.house_rounded, color: ClsColor.tipo3()),
            ],
            const SizedBox(height: 5),
            Text("Version ${vGlobal.tVersionActual}", style: TextStyle(color: ClsColor.tipo3(), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
