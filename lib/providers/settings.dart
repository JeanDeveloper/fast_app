import 'package:fast/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/widgets/decoration.dart';
import 'package:fast/providers/options.dart' as vOptions;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/navRight.dart';

class settings extends StatefulWidget {
  settings({Key? key}) : super(key: key);

  @override
  State<settings> createState() => _settings();
}

class MyInputFormatters {
  static TextInputFormatter ipAddressInputFilter() {
    return FilteringTextInputFormatter.allow(RegExp("[0-9.]"));
  }
}

class IpAddressInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    int dotCounter = 0;
    var buffer = StringBuffer();
    String ipField = "";

    for (int i = 0; i < text.length; i++) {
      if (dotCounter < 4) {
        if (text[i] != ".") {
          ipField += text[i];
          if (ipField.length < 3) {
            buffer.write(text[i]);
          } else if (ipField.length == 3) {
            if (int.parse(ipField) <= 255) {
              buffer.write(text[i]);
            } else {
              if (dotCounter < 3) {
                buffer.write(".");
                dotCounter++;
                buffer.write(text[i]);
                ipField = text[i];
              }
            }
          } else if (ipField.length == 4) {
            if (dotCounter < 3) {
              buffer.write(".");
              dotCounter++;
              buffer.write(text[i]);
              ipField = text[i];
            }
          }
        } else {
          if (dotCounter < 3) {
            buffer.write(".");
            dotCounter++;
            ipField = "";
          }
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(text: string, selection: TextSelection.collapsed(offset: string.length));
  }
}

class _settings extends State<settings> {
  int tipoImpresion = vOptions.tipoImpresion ?? 2;
  int statusservidorImpresion = (vOptions.tipoImpresion ?? 2) == 2 ? 1 : 0;
  String? servidorImpresion = vOptions.servidorImpresion ?? "";
  final cServidorImpresion = TextEditingController(text: vOptions.servidorImpresion);
  int? servidorImpresionPuerto = vOptions.servidorImpresionPuerto ?? 80;
  final cServidorImpresionPuerto = TextEditingController(text: vOptions.servidorImpresionPuerto.toString());
  String? impresoraPrecuenta = vOptions.impresoraPrecuenta ?? "";
  final cImpresoraPrecuenta = TextEditingController(text: vOptions.impresoraPrecuenta);
  String? impresoraOrden = vOptions.impresoraOrden ?? "";
  final cImpresoraOrden = TextEditingController(text: vOptions.impresoraOrden);
  String? impresoraAnulacion = vOptions.impresoraAnulacion ?? "";
  final cImpresoraAnulacion = TextEditingController(text: vOptions.impresoraAnulacion);
  String? impresoraTest = vOptions.impresoraTest ?? "";
  final cImpresoraTest = TextEditingController(text: vOptions.impresoraTest);

  void MostrarConfig(String Configuracion, int status) {
    setState(() {
      if (Configuracion == "ServidorImpresion") {
        statusservidorImpresion = status;
      }
    });
  }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: ClsDecoration.appBar(context, "navprincipal"),
        drawer: NavDrawer(),
        backgroundColor: ClsColor.tipo1(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [Expanded(child: form_recuperar(context))],
          ),
        ),
      ),
    );
  }

  Container form_recuperar(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ClsColor.tipo2(),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Configuración',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Tipo de Impresión',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: ClsColor.tipo1(), fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        // RadioListTile(
                        //   dense: true,

                        //   contentPadding: EdgeInsets.zero,
                        //   visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                        //   activeColor: ClsColor.tipo1(),
                        //   title: Text("Bluetooth", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: ClsColor.tipo5())),
                        //   value: 1,
                        //   groupValue: tipoImpresion,
                        //   onChanged: (value) async {
                        //     final prefs = await SharedPreferences.getInstance();
                        //     MostrarConfig("ServidorImpresion", 0);
                        //     setState(() {
                        //       tipoImpresion = value ?? 1;
                        //       prefs.setInt('tipoImpresion', value ?? 1);
                        //       vOptions.tipoImpresion = value;
                        //     });
                        //   },
                        // ),
                        RadioListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                          activeColor: ClsColor.tipo1(),
                          title: Text("Red Wifi", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: ClsColor.tipo5())),
                          value: 2,
                          groupValue: tipoImpresion,
                          onChanged: (value) async {
                            final prefs = await SharedPreferences.getInstance();
                            MostrarConfig("ServidorImpresion", 1);
                            setState(() {
                              tipoImpresion = value ?? 1;
                              prefs.setInt('tipoImpresion', value ?? 2);
                              vOptions.tipoImpresion = value;
                            });
                          },
                        ),
                        if (statusservidorImpresion == 1) ...[
                          Container(
                            padding: const EdgeInsets.only(left: 10, right: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Servidor de Impresión',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: ClsColor.tipo1(), fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 10, right: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 30,
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
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters: [
                                                    MyInputFormatters.ipAddressInputFilter(),
                                                    LengthLimitingTextInputFormatter(15),
                                                    IpAddressInputFormatter(),
                                                  ],
                                                  controller: cServidorImpresion,
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    fillColor: ClsColor.tipo4(),
                                                    hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo6()),
                                                    labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo5()),
                                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                                  ),
                                                  onChanged: (ip) async {
                                                    final prefs = await SharedPreferences.getInstance();
                                                    servidorImpresion = cServidorImpresion.text;
                                                    prefs.setString('servidorImpresion', cServidorImpresion.text);
                                                    vOptions.servidorImpresion = cServidorImpresion.text;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 50,
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
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  keyboardType: TextInputType.number,
                                                  inputFormatters: [LengthLimitingTextInputFormatter(4), FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly],
                                                  controller: cServidorImpresionPuerto,
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    fillColor: ClsColor.tipo4(),
                                                    hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo6()),
                                                    labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo5()),
                                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                                  ),
                                                  onChanged: (ip) async {
                                                    final prefs = await SharedPreferences.getInstance();
                                                    servidorImpresionPuerto = int.parse((cServidorImpresionPuerto.text == "" ? "80" : cServidorImpresionPuerto.text));
                                                    prefs.setInt('servidorImpresionPuerto', int.parse((cServidorImpresionPuerto.text == "" ? "80" : cServidorImpresionPuerto.text)));
                                                    vOptions.servidorImpresionPuerto = int.parse((cServidorImpresionPuerto.text == "" ? "80" : cServidorImpresionPuerto.text));
                                                  },
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Impresoras',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: ClsColor.tipo1(), fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 80,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Precuenta:',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(color: ClsColor.tipo1(), fontSize: 14, fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                              child: Column(
                                            children: [
                                              TextFormField(
                                                controller: cImpresoraPrecuenta,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  fillColor: ClsColor.tipo4(),
                                                  hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo6()),
                                                  labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo5()),
                                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                                ),
                                                onChanged: (ip) async {
                                                  final prefs = await SharedPreferences.getInstance();
                                                  impresoraPrecuenta = cImpresoraPrecuenta.text;
                                                  prefs.setString('impresoraPrecuenta', cImpresoraPrecuenta.text);
                                                  vOptions.impresoraPrecuenta = cImpresoraPrecuenta.text;
                                                },
                                              ),
                                            ],
                                          ))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 80,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Orden:',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(color: ClsColor.tipo1(), fontSize: 14, fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                              child: Column(
                                            children: [
                                              TextFormField(
                                                controller: cImpresoraOrden,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  fillColor: ClsColor.tipo4(),
                                                  hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo6()),
                                                  labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo5()),
                                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                                ),
                                                onChanged: (ip) async {
                                                  final prefs = await SharedPreferences.getInstance();
                                                  impresoraOrden = cImpresoraOrden.text;
                                                  prefs.setString('impresoraOrden', cImpresoraOrden.text);
                                                  vOptions.impresoraOrden = cImpresoraOrden.text;
                                                },
                                              ),
                                            ],
                                          ))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 80,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Anulación:',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(color: ClsColor.tipo1(), fontSize: 14, fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                              child: Column(
                                            children: [
                                              TextFormField(
                                                controller: cImpresoraAnulacion,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  fillColor: ClsColor.tipo4(),
                                                  hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo6()),
                                                  labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo5()),
                                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                                ),
                                                onChanged: (ip) async {
                                                  final prefs = await SharedPreferences.getInstance();
                                                  impresoraAnulacion = cImpresoraAnulacion.text;
                                                  prefs.setString('impresoraAnulacion', cImpresoraAnulacion.text);
                                                  vOptions.impresoraAnulacion = cImpresoraAnulacion.text;
                                                },
                                              ),
                                            ],
                                          ))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 80,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Test:',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(color: ClsColor.tipo1(), fontSize: 14, fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                              child: Column(
                                            children: [
                                              TextFormField(
                                                controller: cImpresoraTest,
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  fillColor: ClsColor.tipo4(),
                                                  hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo6()),
                                                  labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo5()),
                                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                                ),
                                                onChanged: (ip) async {
                                                  final prefs = await SharedPreferences.getInstance();
                                                  impresoraTest = cImpresoraTest.text;
                                                  prefs.setString('impresoraTest', cImpresoraTest.text);
                                                  vOptions.impresoraTest = cImpresoraTest.text;
                                                },
                                              ),
                                            ],
                                          ))
                                        ],
                                      ),
                                      const SizedBox(height: 50),
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          ClsDecoration.showDialogLoading(context);
                                          bool statusServidorLocal = true;

                                          try {
                                            Map<String, dynamic>? postReg = await getStatusServerPrint();
                                            bool codigo = postReg?["code"];
                                            if (codigo == false) {
                                              Fluttertoast.showToast(
                                                  msg: "Supero Tiempo de Espera, no se logro conectar al servidor local", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                              statusServidorLocal = false;
                                              Navigator.of(context).pop();
                                              return;
                                            }
                                          } catch (e) {
                                            Fluttertoast.showToast(msg: "Error: Verifique la Configuración", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                            statusServidorLocal = false;
                                            Navigator.of(context).pop();
                                            return;
                                          }

                                          if (statusServidorLocal == true) {
                                            Fluttertoast.showToast(msg: "Conexión Existosa", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
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
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text("Recomendaciones :", style: TextStyle(color: ClsColor.tipo8(), fontSize: 16, fontWeight: FontWeight.w700)),
                Text("  * Verifique que esté conectado a la red wifi local", style: TextStyle(color: ClsColor.tipo5(), fontSize: 14, fontWeight: FontWeight.w500)),
                Text("  * Desactive firewall del equipo principal", style: TextStyle(color: ClsColor.tipo5(), fontSize: 15, fontWeight: FontWeight.w500))
              ],
            ),
          )
        ],
      ),
    );
  }
}
