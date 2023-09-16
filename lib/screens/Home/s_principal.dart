import 'dart:convert';

import 'package:fast/models/Caja/m_GetCajaDiariaAbiertaUsuario.dart';
import 'package:fast/models/Maestro/m_GetMenuPrincipal.dart';
import 'package:fast/providers/providers.dart';
import 'package:fast/providers/providers_Caja.dart';
import 'package:fast/screens/Caja/s_caja_aperturar.dart';
import 'package:fast/screens/Caja/s_caja_cajaChica.dart';
import 'package:fast/screens/Restaurante/s_rest_Print.dart';
import 'package:fast/screens/Restaurante/s_rest_niveles.dart';
import 'package:fast/screens/Transporte/s_trans_ordenTrasladoLista.dart';
import 'package:fast/screens/Transporte/s_trans_registrar.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Restaurante.dart' as vGlobal_Restaurante;
import 'package:fast/providers/global_Transporte.dart' as vGlobal_transporte;
import 'package:fast/providers/options.dart' as vOptions;
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whatsapp_share/whatsapp_share.dart';
// import 'package:whatsapp_share2/whatsapp_share2.dart';

class principal extends StatefulWidget {
  const principal({Key? key}) : super(key: key);

  @override
  _principal createState() => new _principal();
}

class _principal extends State<principal> {
  List<MenuData> menu = vGlobal.listMenuPrincipal;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('¿Estas Seguro(a)?'),
          content: const Text('¿Quieres salir de la aplicación?'),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('No')),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Si')),
          ],
        ),
      )
    ) 
    ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: ClsDecoration.appBar(context, ""),
        drawer: NavDrawer(),
        backgroundColor: ClsColor.tipo1(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              ClsTextStyle.cabeceraBienvenida(
                titulo: 'Bienvenido',
                subtitulo: vGlobal.tUsuario == null ? "" : vGlobal.tUsuario.toString(),
                detalle: 'CARGO: ${vGlobal.tRol == null ? "" : vGlobal.tRol.toString()}',
              ),
              Expanded(child: form_recuperar(context)),
            ],
          ),
        ),
      ),
    );
  }

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

  Container form_recuperar(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ClsColor.tipo2(),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        children: [
          GestureDetector(
              onTap: () {
                print(vGlobal_Restaurante.iDFormatoAnulacion);
              },
              child: Text('Operaciones', style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700))),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        SizedBox(
                          child: GridView.count(
                            physics: const ScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            children: [
                              for (int i = 0; i < menu.length; i++) ...[
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Material(
                                      color: ClsColor.tipo4(),
                                      child: InkWell(
                                        splashColor: ClsColor.tipo1(),
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
                                                      textColor: ClsColor.tipo4());
                                                  statusServidorLocal = false;
                                                  Navigator.of(context).pop();
                                                  return;
                                                }
                                              } catch (e) {
                                                Fluttertoast.showToast(
                                                    msg: "Error: Verifique la Configuración de Impresoras", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                                statusServidorLocal = false;
                                                Navigator.of(context).pop();
                                                return;
                                              }
                                            }

                                            if (statusServidorLocal == true) {
                                              // if (vOptions.tipoImpresion == 1) {
                                              //   Navigator.push(context, MaterialPageRoute(builder: (context) => Print(title: "PRUEBA", tMacImpresora: "", listPrecuentatemp: vGlobal_Restaurante.listPrecuenta)));
                                              // }
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
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Icon(IconData(int.parse(menu[i].tIcono), fontFamily: 'MaterialIcons'), size: 35, color: ClsColor.tipo7()),
                                              Text(menu[i].tNombre, textAlign: TextAlign.center, style: TextStyle(color: ClsColor.tipo1(), fontSize: 12, fontWeight: FontWeight.w400)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
