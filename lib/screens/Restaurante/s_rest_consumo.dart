import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:fast/core/utils.dart';
import 'package:fast/models/Restaurante/m_GetMesas.dart';
import 'package:fast/models/Restaurante/m_GetOrdenLlevar.dart';
import 'package:fast/models/Restaurante/m_GetOrdenMesa.dart';
import 'package:fast/models/Restaurante/m_GetOrdenProductoMesa.dart';
import 'package:fast/providers/providers.dart';
import 'package:fast/providers/providers_Restaurante.dart';
import 'package:fast/screens/Restaurante/s_rest_Print.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Restaurante.dart' as vGlobal_Restaurante;
import 'package:fast/providers/options.dart' as vOptions;
import 'package:fast/widgets/reason_widget.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class consumo extends StatefulWidget {
  const consumo({Key? key}) : super(key: key);

  @override
  _consumo createState() => new _consumo();
}

class _consumo extends State<consumo> with TickerProviderStateMixin {

  bool isDelete = false;
  double tPrecuenta = 0.00;
  bool _obscureText = true;
  var CClave = TextEditingController();
  var result_CargaConsumo = <Widget>[];
  var result_CargaLiberar = <Widget>[];
  List<DatumOrden> itemsSelected = [];

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  void initState() {
    // _AsyncData();
    _asyncMethod();
    _GenerarCargaConsumo();
    super.initState();
  }

  _AsyncData() async {
    Timer mytimer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      if (this.mounted) {
        _GenerarCargaConsumo();
        _asyncMethod();
      }
    });
  }

  _DetalleOrden(
    BuildContext context,
    String? tCantidad,
    String? tProducto,
    bool? iCortesia,
    int? iConsumo,
    String? tObservacion,
    String? tUnitario,
    String? tAdicional,
    String? tTotal,
    int? idpedidoDetalle,
    String? fRegistro,
    String? tUsuario,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 400, minHeight: 300),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Usuario:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ClsColor.tipo1())),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 15),
                            child: Text(tUsuario.toString(), textAlign: TextAlign.justify, maxLines: 2, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ClsColor.tipo9())),
                          ),
                          Text("Fecha de Registro:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ClsColor.tipo1())),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 15),
                            child: Text(fRegistro.toString(), textAlign: TextAlign.justify, maxLines: 2, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ClsColor.tipo9())),
                          ),
                          Text("Producto:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ClsColor.tipo1())),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 15),
                            child: Text(tProducto.toString(), textAlign: TextAlign.justify, maxLines: 2, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ClsColor.tipo9())),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Cantidad:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ClsColor.tipo1())),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, bottom: 15),
                                    child: Text(tCantidad.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ClsColor.tipo9())),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text("PU:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ClsColor.tipo1())),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, bottom: 15),
                                    child: Text(tUnitario.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ClsColor.tipo9())),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text("AD:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ClsColor.tipo1())),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, bottom: 15),
                                    child: Text(tAdicional.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ClsColor.tipo9())),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text("Total:", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ClsColor.tipo1())),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, bottom: 15),
                                    child: Text(tTotal.toString(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ClsColor.tipo9())),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text("Observaciones:", maxLines: 7, style: TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w600, color: ClsColor.tipo1())),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 15),
                            child: Text(tObservacion.toString(), textAlign: TextAlign.justify, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ClsColor.tipo9())),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: ClsColor.tipo4(),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                minimumSize: const Size(80, 30),
                              ),
                              icon: Icon(Icons.keyboard_return_rounded, size: 15, color: ClsColor.tipo5()),
                              label: Text("Cerrar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: ClsColor.tipo5())),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                List<Map<String, dynamic>> array = [
                                  {"iDPedidoDetalle": idpedidoDetalle}
                                ];
                                Map<String, dynamic> Items = {"Items": array};
                                String tItems = jsonEncode(Items);
                                _anularConfirmacion(context, tItems);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: ClsColor.tipo8(),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                minimumSize: const Size(80, 30),
                              ),
                              icon: const Icon(Icons.delete, size: 15),
                              label: const Text("Anular", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _anularConfirmacion(BuildContext context, String tItems) async {
    showModalBottomSheet(
      backgroundColor: ClsColor.tipo4(),
      context: context,
      builder: (context) {
        return SizedBox(
          height: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text('¿Desea Anular la Orden?', style: TextStyle(color: ClsColor.tipo6(), fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(const Size(130, 45)),
                            backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo4()),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)))),
                        icon: Icon(Icons.cancel, size: 16.0, color: ClsColor.tipo5()),
                        label: Text('No', style: TextStyle(color: ClsColor.tipo5(), fontSize: 16, fontWeight: FontWeight.w700))),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _obscureText = true;
                          CClave.text = "";
                          _anular(context, tItems);
                        });
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(const Size(130, 45)),
                        backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                      icon: Icon(Icons.check, size: 20.0, color: ClsColor.tipo4()),
                      label: Text('Si', style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  _anular(BuildContext context, String tItems) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 200, maxHeight: 200),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text('Clave de Validación', style: TextStyle(color: ClsColor.tipo5(), fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Container(
                          width: 250,
                          child: TextFormField(
                            controller: CClave,
                            autofocus: true,
                            maxLength: 4,
                            obscureText: _obscureText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 24, letterSpacing: 5, fontWeight: FontWeight.w500),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                                filled: true,
                                isDense: true,
                                fillColor: ClsColor.tipo4(),
                                suffixIconColor: ClsColor.tipo5(),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureText == false ? Icons.visibility : Icons.visibility_off, size: 16, color: ClsColor.tipo5()),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                      Navigator.pop(context);
                                      _anular(context, tItems);
                                    });
                                  },
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: ClsColor.tipo1(), width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: ClsColor.tipo1(), width: 2),
                                )),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
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
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: ClsColor.tipo4(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(100, 30),
                      ),
                      icon: Icon(Icons.keyboard_return_rounded, size: 15, color: ClsColor.tipo5()),
                      label: Text("Cerrar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: ClsColor.tipo5())),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        // if (CClave.text != vGlobal.tCodigoValidacion) {
                        //   Fluttertoast.showToast(
                        //     msg: "Clave de Anulación Incorrecta",
                        //     gravity: ToastGravity.CENTER,
                        //     backgroundColor: ClsColor.tipo6(),
                        //     textColor: ClsColor.tipo4(),
                        //   );
                        //   return;
                        // }
                        ClsDecoration.showDialogLoading(context);
                        bool statusServidorLocal = true;
                        if (vOptions.tipoConexion == 1) {
                          if (vOptions.tipoImpresion == 2 || vOptions.tipoImpresion == null) {

                            //TODO: COMENTADO
                            // try {
                            //   Map<String, dynamic>? postReg = await getStatusServerPrint();
                            //   bool codigo = postReg?["code"];
                            //   if (codigo == false) {
                            //     Fluttertoast.showToast(
                            //         msg: "Error: No se logro conectar al servidor local, Verifique la Configuración de Impresoras",
                            //         gravity: ToastGravity.CENTER,
                            //         backgroundColor: ClsColor.tipo6(),
                            //         textColor: ClsColor.tipo4());
                            //     statusServidorLocal = false;
                            //     Navigator.of(context).pop();
                            //     return;
                            //   }
                            // } catch (e) {
                            //   Fluttertoast.showToast(msg: "Error: Verifique la Configuración de Impresoras", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                            //   statusServidorLocal = false;
                            //   Navigator.of(context).pop();
                            //   return;
                            // }
                          }
                        }

                        if (statusServidorLocal == true) {
                          try {
                            Map<String, dynamic>? postReg = await PutAnularOrdenQA(tItems);
                            final codigo = postReg?["codigo"].toString();
                            final mensaje = postReg?["mensaje"];
                            var tImpresora;
                            var tPdf;
                            if (vOptions.tipoConexion == 1) {
                              tImpresora = postReg?["tImpresora"];
                              tPdf = postReg?["tPdf"];
                            }
                            Fluttertoast.showToast(msg: mensaje ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                            if (codigo == "0" || codigo == "-6") {
                              if (vOptions.tipoConexion == 1) {
                                if (vOptions.tipoImpresion == 2 || vOptions.tipoImpresion == null) {
                                  try {
                                    Map<String, dynamic>? postReg =
                                        await posImpresionWifi(tPdf, (vOptions.impresoraAnulacion == "" ? tImpresora : vOptions.impresoraAnulacion), "Anulacion" + vGlobal_Restaurante.iIDPedido.toString());
                                    final code = postReg?["code"].toString();
                                    final mensaje = postReg?["mensaje"];
                                    Fluttertoast.showToast(msg: mensaje ?? "error al enviar Pdf", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                    if (codigo == "0") {
                                      Navigator.of(context).pop();
                                      if (vGlobal_Restaurante.TipoPedido == "LLEVAR") {
                                        final GetOrdenLlevar? postlog = await getOrdenLlevar;
                                        var dataLogin = jsonEncode(postlog);
                                        var tJsonLogin = getOrdenLlevarFromJson(dataLogin.toString());
                                        if (tJsonLogin.data!.isEmpty) {
                                          Navigator.of(context).pushNamedAndRemoveUntil('navllevar', (Route<dynamic> route) => false);
                                        } else {
                                          Navigator.of(context).pushNamedAndRemoveUntil('navconsumo', (Route<dynamic> route) => false);
                                        }
                                      } else if (vGlobal_Restaurante.TipoPedido == "DELIVERY") {
                                        final GetOrdenLlevar? postlog = await getOrdenLlevar;
                                        var dataLogin = jsonEncode(postlog);
                                        var tJsonLogin = getOrdenLlevarFromJson(dataLogin.toString());
                                        if (tJsonLogin.data!.isEmpty) {
                                          Navigator.of(context).pushNamedAndRemoveUntil('navdelivery', (Route<dynamic> route) => false);
                                        } else {
                                          Navigator.of(context).pushNamedAndRemoveUntil('navconsumo', (Route<dynamic> route) => false);
                                        }
                                      } else {
                                        Navigator.of(context).pushNamedAndRemoveUntil('navconsumo', (Route<dynamic> route) => false);
                                      }
                                    } else {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushNamedAndRemoveUntil('navmesaSeleccionar', (Route<dynamic> route) => false);
                                    }
                                  } catch (e) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushNamedAndRemoveUntil('navmesaSeleccionar', (Route<dynamic> route) => false);
                                  }
                                } else {
                                  Navigator.of(context).pop();
                                }
                              } else {
                                Navigator.of(context).pop();
                                if (vGlobal_Restaurante.TipoPedido == "LLEVAR") {
                                  final GetOrdenLlevar? postlog = await getOrdenLlevar;
                                  var dataLogin = jsonEncode(postlog);
                                  var tJsonLogin = getOrdenLlevarFromJson(dataLogin.toString());
                                  if (tJsonLogin.data!.isEmpty) {
                                    Navigator.of(context).pushNamedAndRemoveUntil('navllevar', (Route<dynamic> route) => false);
                                  } else {
                                    Navigator.of(context).pushNamedAndRemoveUntil('navconsumo', (Route<dynamic> route) => false);
                                  }
                                } else if (vGlobal_Restaurante.TipoPedido == "DELIVERY") {
                                  final GetOrdenLlevar? postlog = await getOrdenLlevar;
                                  var dataLogin = jsonEncode(postlog);
                                  var tJsonLogin = getOrdenLlevarFromJson(dataLogin.toString());
                                  if (tJsonLogin.data!.isEmpty) {
                                    Navigator.of(context).pushNamedAndRemoveUntil('navdelivery', (Route<dynamic> route) => false);
                                  } else {
                                    Navigator.of(context).pushNamedAndRemoveUntil('navconsumo', (Route<dynamic> route) => false);
                                  }
                                } else {
                                  Navigator.of(context).pushNamedAndRemoveUntil('navconsumo', (Route<dynamic> route) => false);
                                }
                              }
                            } else {
                              Navigator.of(context).pop();
                            }
                          } catch (e) {
                            Fluttertoast.showToast(msg: "El sistema no pudo generar el Comprobante", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: ClsColor.tipo8(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(100, 30),
                      ),
                      icon: const Icon(Icons.delete, size: 15),
                      label: const Text("Anular", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
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
  
  void _GenerarCargaConsumo() {
    setState(() {
      result_CargaConsumo = <Widget>[];
      if (vGlobal_Restaurante.TipoPedido == "MESA") {
        result_CargaConsumo.add(
          FutureBuilder<MGetOrdenMesa?>(
            future: getOrdenMesa,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator.adaptive());
              }
              final MGetOrdenMesa? Lista = snapshot.data;
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: Lista?.data.length ?? 0,
                itemBuilder: (context, index) {

                  //CADA ITEM DETALLADO
                  return Card(
                    shape: RoundedRectangleBorder(    
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              color: ClsColor.tipo1(),
                              width: 35,
                              height: double.infinity,
                              child: Center(
                                child: Text(Lista?.data[index].nCantidad!.toStringAsFixed(0) ?? "", style: TextStyle(color: ClsColor.tipo4(), fontSize: 18, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                              ),
                            ),
                            //const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 5),
                                color: itemsSelected.any((item) => item.iMProducto == Lista!.data[index].iMProducto)? const Color(0xffffe4e4) : Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(Lista?.data[index].tProducto ?? "", style: TextStyle(color: ClsColor.tipo5(), fontSize: 13, fontWeight: FontWeight.w600)),
                                    Text('PU. ${(Lista!.data[index].nPrecioUnitario! - Lista.data[index].nAdicional!).toStringAsFixed(2)} + AD. ${(Lista.data[index].nAdicional!).toStringAsFixed(2)}',
                                        style: TextStyle(color: ClsColor.tipo6(), fontSize: 12, fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: double.infinity,
                              color: itemsSelected.any((item) => item.iMProducto == Lista!.data[index].iMProducto)? const Color(0xffffe4e4) : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10, top: 8),
                                child: Text(Lista.data[index].nTotal!.toStringAsFixed(2), style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w500)),
                              ),
                            ),
                            Container(
                              color: ClsColor.tipo11(),
                              child: Center(
                                child: IconButton(
                                  onPressed: () async {
                                    String? tPedidoDetalle = Lista.data[index].iDPedidoDetalle.toString();
                                    final MGetOrdenProductoMesa? Postlog = await GetOrdenProductoMesa(tPedidoDetalle.toString());
                                    var dataOrden = jsonEncode(Postlog);
                                    var tJsonOrden = mGetOrdenProductoMesaFromJson(dataOrden.toString());
                                    if (tJsonOrden.code == 0) {
                                      // ignore: use_build_context_synchronously
                                      vGlobal_Restaurante.tAnulacionCanal = tJsonOrden.data.iTipoConsumo;
                                      vGlobal_Restaurante.tAnulacionProducto = Lista.data[index].tProducto ?? "";
                                      vGlobal_Restaurante.tAnulacionCantidad = Lista.data[index].nCantidad!.toStringAsFixed(0);
                                      vGlobal_Restaurante.tAnulacionObservacion = tJsonOrden.data.tObservacion;
                  
                                      // ignore: use_build_context_synchronously
                                      _DetalleOrden(
                                        context,
                                        Lista.data[index].nCantidad!.toStringAsFixed(0),
                                        Lista.data[index].tProducto ?? "",
                                        tJsonOrden.data.lCortesia,
                                        tJsonOrden.data.iTipoConsumo,
                                        tJsonOrden.data.tObservacion,
                                        (Lista.data[index].nPrecioUnitario! - Lista.data[index].nAdicional!).toStringAsFixed(2),
                                        (Lista.data[index].nAdicional!).toStringAsFixed(2),
                                        Lista.data[index].nTotal!.toStringAsFixed(2),
                                        tJsonOrden.data.iDPedidoDetalle,
                                        Lista.data[index].fRegistro,
                                        Lista.data[index].tUsuario,
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.remove_red_eye_outlined),
                                  iconSize: 18.0,
                                  color: ClsColor.tipo4(),
                                ),
                              ),
                            ),
                            
                            //BOTON DE MULTISELECCION
                            InkWell(
                              onTap: (){
                                if(itemsSelected.any((item) => item.iMProducto == Lista.data[index].iMProducto)){
                                  itemsSelected.removeWhere((item) => item.iMProducto == Lista.data[index].iMProducto);
                                }else{
                                  itemsSelected.add(Lista.data[index]);
                                }
                  
                                if(itemsSelected.isEmpty){
                                  isDelete = false;
                                }else{
                                  isDelete = true;
                                }
                                
                                print(itemsSelected.length);
                                _GenerarCargaConsumo();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ClsColor.tipo4(),
                                  border:Border.all(
                                    color: Colors.blueAccent.shade200,
                                    width: 3, 
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  )
                                ),
                                child: Center(
                                  child: SizedBox(
                                    width: 40,
                                    child: itemsSelected.any((item) => item.iMProducto == Lista.data[index].iMProducto)
                                      ? const Icon(Icons.check, size:30, color: Colors.blue, weight: 20)
                                      : Container(),
                                    // 
                                  ),
                                ),
                              ),
                            ),
                  
                            // BOTON DE BORRADO
                            // Container(
                            //   color: ClsColor.tipo8(),
                            //   child: Center(
                            //     child: IconButton(
                            //       onPressed: () async {
                            //         String? tPedidoDetalle = Lista.data[index].iDPedidoDetalle.toString();
                            //         final MGetOrdenProductoMesa? Postlog = await GetOrdenProductoMesa(tPedidoDetalle.toString());
                            //         var dataOrden = jsonEncode(Postlog);
                            //         var tJsonOrden = mGetOrdenProductoMesaFromJson(dataOrden.toString());
                            //         if (tJsonOrden.code == 0) {
                            //           List<Map<String, dynamic>> array = [
                            //             {"iDPedidoDetalle": Lista.data[index].iDPedidoDetalle}
                            //           ];
                  
                            //           vGlobal_Restaurante.tAnulacionCanal = tJsonOrden.data.iTipoConsumo;
                            //           vGlobal_Restaurante.tAnulacionProducto = Lista.data[index].tProducto ?? "";
                            //           vGlobal_Restaurante.tAnulacionCantidad = Lista.data[index].nCantidad!.toStringAsFixed(0);
                            //           vGlobal_Restaurante.tAnulacionObservacion = tJsonOrden.data.tObservacion;
                            //           Map<String, dynamic> Items = {"Items": array};
                            //           String tItems = jsonEncode(Items);
                            //           _anularConfirmacion(context, tItems);
                            //         }
                            //       },
                            //       icon: const Icon(Icons.delete),
                            //       iconSize: 18.0,
                            //       color: ClsColor.tipo4(),
                            //     ),
                            //   ),
                            // ),

                          ],
                        ),
                      ),
                    ),
                  );

                },
              );
            },
          ),
        );
      }
      if (vGlobal_Restaurante.TipoPedido == "LLEVAR" || vGlobal_Restaurante.TipoPedido == "DELIVERY") {
        result_CargaConsumo.add(
          FutureBuilder<GetOrdenLlevar?>(
            future: getOrdenLlevar,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator.adaptive());
              }
              final GetOrdenLlevar? Lista = snapshot.data;
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: Lista?.data!.length ?? 0,
                itemBuilder: (context, index) {
                  //if (Lista!.data.isNotEmpty) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 50,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              color: ClsColor.tipo1(),
                              width: 35,
                              height: double.infinity,
                              child: Center(
                                child: Text(Lista?.data![index].nCantidad!.toStringAsFixed(0) ?? "", style: TextStyle(color: ClsColor.tipo4(), fontSize: 18, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(Lista?.data![index].tProducto ?? "", style: TextStyle(color: ClsColor.tipo5(), fontSize: 13, fontWeight: FontWeight.w600)),
                                  Text('PU. ${(Lista!.data![index].nPrecioUnitario! - Lista.data![index].nAdicional!).toStringAsFixed(2)} + AD. ${(Lista.data![index].nAdicional!).toStringAsFixed(2)}',
                                      style: TextStyle(color: ClsColor.tipo6(), fontSize: 12, fontWeight: FontWeight.w400)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10, top: 8),
                              child: Text(Lista.data![index].nTotal!.toStringAsFixed(2), style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w500)),
                            ),
                            Container(
                              color: ClsColor.tipo11(),
                              child: Center(
                                child: IconButton(
                                  onPressed: () async {
                                    String? tPedidoDetalle = Lista.data![index].iDPedidoDetalle.toString();
                                    final MGetOrdenProductoMesa? Postlog = await GetOrdenProductoMesa(tPedidoDetalle.toString());
                                    var dataOrden = jsonEncode(Postlog);
                                    var tJsonOrden = mGetOrdenProductoMesaFromJson(dataOrden.toString());
                                    if (tJsonOrden.code == 0) {
                                      // ignore: use_build_context_synchronously
                                      vGlobal_Restaurante.tAnulacionCanal = tJsonOrden.data.iTipoConsumo;
                                      vGlobal_Restaurante.tAnulacionProducto = Lista.data![index].tProducto ?? "";
                                      vGlobal_Restaurante.tAnulacionCantidad = Lista.data![index].nCantidad!.toStringAsFixed(0);
                                      vGlobal_Restaurante.tAnulacionObservacion = tJsonOrden.data.tObservacion;

                                      // ignore: use_build_context_synchronously
                                      _DetalleOrden(
                                        context,
                                        Lista.data![index].nCantidad!.toStringAsFixed(0),
                                        Lista.data![index].tProducto ?? "",
                                        tJsonOrden.data.lCortesia,
                                        tJsonOrden.data.iTipoConsumo,
                                        tJsonOrden.data.tObservacion,
                                        (Lista.data![index].nPrecioUnitario! - Lista.data![index].nAdicional!).toStringAsFixed(2),
                                        (Lista.data![index].nAdicional!).toStringAsFixed(2),
                                        Lista.data![index].nTotal!.toStringAsFixed(2),
                                        tJsonOrden.data.iDPedidoDetalle,
                                        Lista.data![index].fRegistro,
                                        Lista.data![index].tUsuario,
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.remove_red_eye_outlined),
                                  iconSize: 18.0,
                                  color: ClsColor.tipo4(),
                                ),
                              ),
                            ),
                            Container(
                              color: ClsColor.tipo8(),
                              child: Center(
                                child: IconButton(
                                  onPressed: () async {
                                    String? tPedidoDetalle = Lista.data![index].iDPedidoDetalle.toString();
                                    final MGetOrdenProductoMesa? Postlog = await GetOrdenProductoMesa(tPedidoDetalle.toString());
                                    var dataOrden = jsonEncode(Postlog);
                                    var tJsonOrden = mGetOrdenProductoMesaFromJson(dataOrden.toString());
                                    if (tJsonOrden.code == 0) {
                                      List<Map<String, dynamic>> array = [
                                        {"iDPedidoDetalle": Lista.data![index].iDPedidoDetalle}
                                      ];

                                      vGlobal_Restaurante.tAnulacionCanal = tJsonOrden.data.iTipoConsumo;
                                      vGlobal_Restaurante.tAnulacionProducto = Lista.data![index].tProducto ?? "";
                                      vGlobal_Restaurante.tAnulacionCantidad = Lista.data![index].nCantidad!.toStringAsFixed(0);
                                      vGlobal_Restaurante.tAnulacionObservacion = tJsonOrden.data.tObservacion;
                                      Map<String, dynamic> Items = {"Items": array};
                                      String tItems = jsonEncode(Items);
                                      _anularConfirmacion(context, tItems);
                                    }
                                  },
                                  icon: const Icon(Icons.delete),
                                  iconSize: 18.0,
                                  color: ClsColor.tipo4(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                  // return ClsDecoration.listOrdenMesa(lista: Lista, index: index, context: context);
                  //}
                },
              );
            },
          ),
        );
      }
    });
    // return result;
  }

  void _GenerarCargaLiberar() {
    setState(() {
      result_CargaLiberar = <Widget>[];
      result_CargaLiberar.add(
        Material(
          type: MaterialType.transparency,
          child: Ink(
            decoration: BoxDecoration(border: Border.all(color: ClsColor.tipo2(), width: 1), color: ClsColor.tipo7(), borderRadius: BorderRadius.circular(50.0)), //<-- SEE HERE
            child: InkWell(
              borderRadius: BorderRadius.circular(50.0),
              onTap: () async {
                Map<String, dynamic>? postReg = await postLiberar(vGlobal_Restaurante.iMMesa, vGlobal_Restaurante.iIDPedido);
                final codigo = postReg?["codigo"].toString();
                final mensaje = postReg?["mensaje"];
                Fluttertoast.showToast(msg: mensaje ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                if (codigo == "0") {
                  Navigator.pushNamed(context, "navmesaSeleccionar");
                } else {}
              },
              child: Padding(padding: const EdgeInsets.all(7), child: Icon(Icons.exit_to_app_rounded, size: 18.0, color: ClsColor.tipo4())),
            ),
          ),
        ),
        // ElevatedButton(
        //   onPressed: () async {
        //     Map<String, dynamic>? postReg = await postLiberar(vGlobal_Restaurante.iMMesa, vGlobal_Restaurante.iIDPedido);
        //     final codigo = postReg?["codigo"].toString();
        //     final mensaje = postReg?["mensaje"];
        //     Fluttertoast.showToast(msg: mensaje ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
        //     if (codigo == "0") {
        //       Navigator.pushNamed(context, "navmesaSeleccionar");
        //     } else {}
        //   },
        //   child: Icon(Icons.exit_to_app_rounded, color: Colors.white, size: 20),
        //   style: ElevatedButton.styleFrom(backgroundColor: ClsColor.tipo7(), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        // ),
        // ElevatedButton.icon(
        //   onPressed: () async {
        //     Map<String, dynamic>? postReg = await postLiberar(vGlobal_Restaurante.iMMesa, vGlobal_Restaurante.iIDPedido);
        //     final codigo = postReg?["codigo"].toString();
        //     final mensaje = postReg?["mensaje"];
        //     Fluttertoast.showToast(msg: mensaje ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
        //     if (codigo == "0") {
        //       Navigator.pushNamed(context, "navmesaSeleccionar");
        //     } else {}
        //   },
        //   style: ElevatedButton.styleFrom(fixedSize: const Size(100, 30), backgroundColor: ClsColor.tipo7(), splashFactory: InkSplash.splashFactory),
        //   icon: Icon(Icons.exit_to_app_rounded, size: 17.0, color: ClsColor.tipo4()),
        //   label: Text('Liberar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: ClsColor.tipo4())),
        // ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: ClsColor.tipo1(),
          title: Transform(
            transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_circle_left_rounded, size: 25, color: ClsColor.tipo4()),
                  onPressed: () {
                    if (vGlobal_Restaurante.TipoPedido == "MESA") {
                      Navigator.pushNamed(context, "navmesaSeleccionar");
                    }
                    if (vGlobal_Restaurante.TipoPedido == "LLEVAR") {
                      Navigator.pushNamed(context, "navllevar");
                    }
                    if (vGlobal_Restaurante.TipoPedido == "DELIVERY") {
                      Navigator.pushNamed(context, "navdelivery");
                    }
                  },
                ),
              ],
            ),
          ),
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    vGlobal_Restaurante.TipoPedido == "LLEVAR"
                        ? "PARA LLEVAR"
                        : vGlobal_Restaurante.TipoPedido == "DELIVERY"
                            ? "DELIVERY"
                            : ("${vGlobal_Restaurante.tSalon!} - ${vGlobal_Restaurante.tMesa!}"),
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 14, overflow: TextOverflow.fade, fontWeight: FontWeight.w700, color: ClsColor.tipo4()),
                  ),
                  const SizedBox(height: 5),
                  Text(vGlobal.tUsuario!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: ClsColor.tipo4())),
                ],
              ),
            ),
          ],
        ),
        drawer: NavDrawer(),
        backgroundColor: ClsColor.tipo1(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Expanded(child: form_recuperar(context)),
            ],
          ),
        ),
      ),
    );
  }

  void updateText(double valor) {
    // try {
    setState(() {
      tPrecuenta = valor;
    });
    // } catch (e) {}
  }

  _asyncMethod() async {
    if (vGlobal_Restaurante.TipoPedido == "MESA") {
      final MGetOrdenMesa? postlog = await getOrdenMesa;
      setState(() {
        result_CargaLiberar = <Widget>[];
        vGlobal_Restaurante.iPrecuenta = 0;
        var dataLogin = jsonEncode(postlog);
        var tJsonLogin = mGetOrdenMesaFromJson(dataLogin.toString());
        for (int i = 0; i < tJsonLogin.data.length; i++) {
          vGlobal_Restaurante.iPrecuenta = vGlobal_Restaurante.iPrecuenta! + tJsonLogin.data[i].nTotal!;
        }
        if (tJsonLogin.data.isEmpty) {
          _GenerarCargaLiberar();
        }
        updateText(vGlobal_Restaurante.iPrecuenta!);
      });
    }
    if (vGlobal_Restaurante.TipoPedido == "LLEVAR" || vGlobal_Restaurante.TipoPedido == "DELIVERY") {
      final GetOrdenLlevar? postlog = await getOrdenLlevar;
      setState(() {
        result_CargaLiberar = <Widget>[];
        vGlobal_Restaurante.iPrecuenta = 0;
        var dataLogin = jsonEncode(postlog);
        var tJsonLogin = getOrdenLlevarFromJson(dataLogin.toString());
        for (int i = 0; i < tJsonLogin.data!.length; i++) {
          vGlobal_Restaurante.iPrecuenta = vGlobal_Restaurante.iPrecuenta! + tJsonLogin.data![i].nTotal!;
        }
        updateText(vGlobal_Restaurante.iPrecuenta!);
      });
    }
  }

  _ConfimarDesunirMesa(BuildContext context) async {
    showModalBottomSheet(
      backgroundColor: ClsColor.tipo4(),
      context: context,
      builder: (context) {
        return SizedBox(
          height: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text('¿Estas Seguro(a) de desunir las mesas?', style: TextStyle(color: ClsColor.tipo6(), fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(const Size(130, 45)),
                            backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo4()),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)))),
                        icon: Icon(Icons.cancel, size: 16.0, color: ClsColor.tipo5()),
                        label: Text('No', style: TextStyle(color: ClsColor.tipo5(), fontSize: 16, fontWeight: FontWeight.w700))),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Map<String, dynamic>? postReg = await postDesUnirMesas();
                        final codigo = postReg?["codigo"].toString();
                        final mensaje = postReg?["mensaje"];
                        Fluttertoast.showToast(msg: mensaje ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                        if (codigo == "0") {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(const Size(130, 45)),
                        backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                      icon: Icon(Icons.check, size: 20.0, color: ClsColor.tipo4()),
                      label: Text('Si', style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [

          Expanded(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 1,
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '  Cliente : ',
                                    style: TextStyle(
                                      color: ClsColor.tipo1(),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: (vGlobal_Restaurante.tCliente == "" || vGlobal_Restaurante.tCliente == null) ? "..." : vGlobal_Restaurante.tCliente,
                                    style: TextStyle(color: ClsColor.tipo5(), fontSize: 14, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                            ),
                            if (vGlobal_Restaurante.TipoPedido == "MESA") ...[
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '  Pax       : ',
                                      style: TextStyle(color: ClsColor.tipo1(), fontSize: 14, fontWeight: FontWeight.w700),
                                    ),
                                    TextSpan(
                                      text: vGlobal_Restaurante.iPax.toString(),
                                      style: TextStyle(color: ClsColor.tipo5(), fontSize: 14, fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),

                              //JEAN
                              Text.rich(
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                maxLines: 1,
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '  Hora     : ',
                                      style: TextStyle(
                                        color: ClsColor.tipo1(),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    TextSpan(
                                      text: (vGlobal_Restaurante.horaPedido == "" || vGlobal_Restaurante.horaPedido == null) ? "" : vGlobal_Restaurante.horaPedido!.toLowerCase(),
                                      style: TextStyle(color: ClsColor.tipo5(), fontSize: 14, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                                    ),
                                    TextSpan(
                                      text: (vGlobal_Restaurante.horaPedido == "" || vGlobal_Restaurante.horaPedido == null) ? "" : Utils.convertTime(vGlobal_Restaurante.horaPedido!.toLowerCase()),
                                      style: TextStyle(color: ClsColor.tipo5(), fontSize: 14, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                              ),
 
                            ],
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Material(
                            type: MaterialType.transparency,
                            child: Ink(
                              decoration: BoxDecoration(border: Border.all(color: ClsColor.tipo2(), width: 1), color: ClsColor.tipo1(), borderRadius: BorderRadius.circular(50.0)), //<-- SEE HERE
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50.0),
                                onTap: () {
                                  _GenerarCargaConsumo();
                                  _asyncMethod();
                                },
                                child: Padding(padding: const EdgeInsets.all(7), child: Icon(Icons.refresh_rounded, size: 18.0, color: ClsColor.tipo4())),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (vGlobal_Restaurante.TipoPedido == "MESA") ...[
                            Material(
                              type: MaterialType.transparency,
                              child: Ink(
                                decoration: BoxDecoration(border: Border.all(color: ClsColor.tipo2(), width: 1), color: ClsColor.tipo1(), borderRadius: BorderRadius.circular(50.0)), //<-- SEE HERE
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(50.0),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          insetPadding: const EdgeInsets.all(60),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            width: double.infinity,
                                            constraints: const BoxConstraints(maxHeight: 190, minHeight: 190),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      ElevatedButton.icon(
                                                        onPressed: () {
                                                          _ConfimarDesunirMesa(context);
                                                        },
                                                        style: ButtonStyle(
                                                          fixedSize: MaterialStateProperty.all(const Size(200, 40)),
                                                          backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                                                        ),
                                                        icon: Icon(Icons.widgets_rounded, size: 15, color: ClsColor.tipo4()),
                                                        label: Text("Desunir Mesas", style: TextStyle(color: ClsColor.tipo4(), fontSize: 14, fontWeight: FontWeight.w400)),
                                                      ),
                                                      // ElevatedButton.icon(
                                                      //   onPressed: () {
                                                      //     Fluttertoast.showToast(msg: "Pronto estará disponible esta función", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                                      //   },
                                                      //   style: ButtonStyle(
                                                      //     fixedSize: MaterialStateProperty.all(const Size(200, 40)),
                                                      //     backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
                                                      //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                                                      //   ),
                                                      //   icon: Icon(Icons.safety_divider_rounded, size: 15, color: ClsColor.tipo4()),
                                                      //   label: Text("Dividir Mesa", style: TextStyle(color: ClsColor.tipo4(), fontSize: 14, fontWeight: FontWeight.w400)),
                                                      // ),
                                                      ElevatedButton.icon(
                                                        onPressed: () {
                                                          Navigator.pushNamed(context, "navmesaTransferir");
                                                        },
                                                        style: ButtonStyle(
                                                          fixedSize: MaterialStateProperty.all(const Size(200, 40)),
                                                          backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
                                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                                                        ),
                                                        icon: Icon(Icons.transfer_within_a_station_rounded, size: 15, color: ClsColor.tipo4()),
                                                        label: Text("Transferir Mesa", style: TextStyle(color: ClsColor.tipo4(), fontSize: 14, fontWeight: FontWeight.w400)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                                                  icon: const Icon(Icons.close_outlined, size: 15),
                                                  label: const Text("Cerrar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(padding: const EdgeInsets.all(7), child: Icon(Icons.plumbing_rounded, size: 18.0, color: ClsColor.tipo4())),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // ElevatedButton(
                            //   onPressed: () {},
                            //   child: Icon(Icons.plumbing_rounded, color: Colors.white, size: 20),
                            //   style: ElevatedButton.styleFrom(backgroundColor: ClsColor.tipo1(), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                            // ),
                          ],
                          // ElevatedButton.icon(
                          //   onPressed: () {

                          //   },
                          //   style: ElevatedButton.styleFrom(fixedSize: const Size(120, 30), backgroundColor: ClsColor.tipo1(), splashFactory: InkSplash.splashFactory),
                          //   icon: Icon(Icons.plumbing_rounded, size: 17.0, color: ClsColor.tipo4()),
                          //   label: Text('Opciones', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: ClsColor.tipo4())),
                          // ),
                          if (vGlobal_Restaurante.TipoPedido == "MESA") ...[
                            SizedBox(width: 10),
                            Column(children: result_CargaLiberar),
                            SizedBox(width: 10),
                          ]
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column( children: result_CargaConsumo),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
          if(!isDelete)
            //BOTON AÑADIR ORDEN
            ElevatedButton.icon(
            onPressed: () {
              vGlobal_Restaurante.listPrecuenta = [];
              Navigator.pushNamed(context, "navproductoSeleccionar");
            },
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(300, 50)),
              backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )),
            ),
            icon: Icon(Icons.add, size: 20, color: ClsColor.tipo4()),
            label: Text("Nueva Orden", style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w400)),
          ),
          
          if(isDelete)
            //BOTON ANULAR ITEM
            ElevatedButton.icon(
              onPressed: () async {

                // _anularMultipleConfirmacion(context);

                //IRÁ TODO LA LOGICA PARA PODER BORRAR TODO.

                // List<Map<String, dynamic>> array = [
                //   {
                //     "iDPedidoDetalle": itemsSelected[0].iDPedidoDetalle,
                //   },
                //   {
                //     "iDPedidoDetalle": itemsSelected[1].iDPedidoDetalle,
                //   },
                // ];

                List<Map<String, dynamic>> array = itemsSelected.map(
                  (item) {
                    return {
                      "iDPedidoDetalle": item.iDPedidoDetalle,
                    };
                  }
                ).toList();

                Map<String, dynamic> Items = {"Items": array};
                String tItems = jsonEncode(Items);

                _anularMultipleConfirmacion(context, tItems);

              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(300, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo8()),
                padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                )),
              ),
              icon: Icon(Icons.delete, size: 20, color: ClsColor.tipo4()), 
              label: Text("Anular Item(s)", style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w400)),
            ),

          const SizedBox(height: 10),
          if(!isDelete)
            //BOTON DE PRECUENTA
            ElevatedButton.icon(
            onPressed: () async {
              ClsDecoration.showDialogLoading(context);
              bool statusServidorLocal = true;
              if (vOptions.tipoConexion == 1) {
                if (vOptions.tipoImpresion == 2 || vOptions.tipoImpresion == null) {
                  try {
                    Map<String, dynamic>? postReg = await getStatusServerPrint();
                    final codigo = postReg?["code"];
                    if (codigo == false) {
                      Fluttertoast.showToast(
                          msg: "Error: No se logro conectar al servidor local, Verifique la Configuración de Impresoras", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
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
              }

              if (statusServidorLocal == true) {
                try {
                  Map<String, dynamic>? postReg = await getPrecuenta();
                  final codigo = postReg?["codigo"].toString();
                  final mensaje = postReg?["mensaje"];
                  var tImpresora;
                  var tPdf;
                  if (vOptions.tipoConexion == 1) {
                    tImpresora = postReg?["tImpresora"];
                    tPdf = postReg?["tPdf"];
                  }
                  Fluttertoast.showToast(msg: mensaje ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                  if (codigo == "0") {
                    if (vOptions.tipoConexion == 1) {
                      if (vOptions.tipoImpresion == 2 || vOptions.tipoImpresion == null) {
                        try {
                          Map<String, dynamic>? postReg =
                              await posImpresionWifi(tPdf, (vOptions.impresoraPrecuenta == "" ? tImpresora : vOptions.impresoraPrecuenta), "Precuenta" + vGlobal_Restaurante.iIDPedido.toString());
                          final code = postReg?["code"].toString();
                          final mensaje = postReg?["mensaje"];
                          Fluttertoast.showToast(msg: mensaje ?? "error al enviar Pdf", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                          Navigator.of(context).pop();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => consumo()));
                        } catch (e) {
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(msg: "error al enviar Pdf", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                        }
                      } else {
                        Navigator.of(context).pop();
                      }
                    } else {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => consumo()));
                    }
                  } else {
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  Fluttertoast.showToast(msg: "El sistema no pudo generar el Comprobante", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                  Navigator.of(context).pop();
                }
              } else {
                Navigator.of(context).pop();
              }
            },
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(300, 50)),
              backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo3()),
              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )),
            ),
            icon: Icon(Icons.point_of_sale_rounded, size: 20, color: ClsColor.tipo1()),
            label: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Precuenta", style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text("S/ ${tPrecuenta.toStringAsFixed(2).toString()}", style: TextStyle(color: ClsColor.tipo5(), fontSize: 20, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _anularMultipleConfirmacion(BuildContext context, String tItems) async {
    showModalBottomSheet(
      backgroundColor: ClsColor.tipo4(),
      context: context,
      builder: (context) {
        return SizedBox(
          height: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text('¿Desea Anular la Orden?', style: TextStyle(color: ClsColor.tipo6(), fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(const Size(130, 45)),
                            backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo4()),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)))),
                        icon: Icon(Icons.cancel, size: 16.0, color: ClsColor.tipo5()),
                        label: Text('No', style: TextStyle(color: ClsColor.tipo5(), fontSize: 16, fontWeight: FontWeight.w700))),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _obscureText = true;
                          CClave.text = "";
                          _anularMultiple(context, tItems);
                        });
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(const Size(130, 45)),
                        backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                      icon: Icon(Icons.check, size: 20.0, color: ClsColor.tipo4()),
                      label: Text('Si', style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  _anularMultiple(BuildContext context, String tItems) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 200, maxHeight: 300),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text('Motivo', style: TextStyle(color: ClsColor.tipo5(), fontSize: 16, fontWeight: FontWeight.w500)),
                      ),

                      ReasonWidget(ruc:vGlobal.tEmpresaRuc!),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text('Clave de Validación', style: TextStyle(color: ClsColor.tipo5(), fontSize: 16, fontWeight: FontWeight.w500)),
                      ),

                      const SizedBox(height: 10),

                      Flexible(
                        child: Container(
                          width: 250,
                          child: TextFormField(
                            controller: CClave,
                            autofocus: true,
                            maxLength: 4,
                            obscureText: _obscureText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 24, letterSpacing: 5, fontWeight: FontWeight.w500),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                                filled: true,
                                isDense: true,
                                fillColor: ClsColor.tipo4(),
                                suffixIconColor: ClsColor.tipo5(),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureText == false ? Icons.visibility : Icons.visibility_off, size: 16, color: ClsColor.tipo5()),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                      Navigator.pop(context);
                                      _anularMultiple(context,tItems);
                                    });
                                  },
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: ClsColor.tipo1(), width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: ClsColor.tipo1(), width: 2),
                                )),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 10),
                    ],
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
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: ClsColor.tipo4(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(100, 30),
                      ),
                      icon: Icon(Icons.keyboard_return_rounded, size: 15, color: ClsColor.tipo5()),
                      label: Text("Cerrar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: ClsColor.tipo5())),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        // if (CClave.text != vGlobal.tCodigoValidacion) {
                        //   Fluttertoast.showToast(
                        //     msg: "Clave de Anulación Incorrecta",
                        //     gravity: ToastGravity.CENTER,
                        //     backgroundColor: ClsColor.tipo6(),
                        //     textColor: ClsColor.tipo4(),
                        //   );
                        //   return;
                        // }
                        ClsDecoration.showDialogLoading(context);
                        bool statusServidorLocal = true;
                        if (vOptions.tipoConexion == 1) {
                          if (vOptions.tipoImpresion == 2 || vOptions.tipoImpresion == null) {
                            // try {
                            //   Map<String, dynamic>? postReg = await getStatusServerPrint();
                            //   bool codigo = postReg?["code"];
                            //   if (codigo == false) {
                            //     Fluttertoast.showToast(
                            //         msg: "Error: No se logro conectar al servidor local, Verifique la Configuración de Impresoras",
                            //         gravity: ToastGravity.CENTER,
                            //         backgroundColor: ClsColor.tipo6(),
                            //         textColor: ClsColor.tipo4());
                            //     statusServidorLocal = false;
                            //     Navigator.of(context).pop();
                            //     return;
                            //   }
                            // } catch (e) {
                            //   Fluttertoast.showToast(msg: "Error: Verifique la Configuración de Impresoras", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                            //   statusServidorLocal = false;
                            //   Navigator.of(context).pop();
                            //   return;
                            // }
                          }
                        }

                        if (statusServidorLocal == true) {
                          try {
                            //TODO:CONVERTIR EL OBJETO ITEMSSELECTED EN UN STRING CON TODOS LOS PRODUCTOS

                            Map<String, dynamic>? postReg = await PutAnularOrdenQA(tItems);
                            final codigo = postReg?["codigo"].toString();
                            final mensaje = postReg?["mensaje"];
                            var tImpresora;
                            var tPdf;
                            if (vOptions.tipoConexion == 1) {
                              tImpresora = postReg?["tImpresora"];
                              tPdf = postReg?["tPdf"];
                            }
                            Fluttertoast.showToast(msg: mensaje ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                            if (codigo == "0" || codigo == "-6") {
                              if (vOptions.tipoConexion == 1) {
                                if (vOptions.tipoImpresion == 2 || vOptions.tipoImpresion == null) {
                                  try {
                                    Map<String, dynamic>? postReg =
                                        await posImpresionWifi(tPdf, (vOptions.impresoraAnulacion == "" ? tImpresora : vOptions.impresoraAnulacion), "Anulacion" + vGlobal_Restaurante.iIDPedido.toString());
                                    final code = postReg?["code"].toString();
                                    final mensaje = postReg?["mensaje"];
                                    Fluttertoast.showToast(msg: mensaje ?? "error al enviar Pdf", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                    if (codigo == "0") {
                                      Navigator.of(context).pop();
                                      if (vGlobal_Restaurante.TipoPedido == "LLEVAR") {
                                        final GetOrdenLlevar? postlog = await getOrdenLlevar;
                                        var dataLogin = jsonEncode(postlog);
                                        var tJsonLogin = getOrdenLlevarFromJson(dataLogin.toString());
                                        if (tJsonLogin.data!.isEmpty) {
                                          Navigator.of(context).pushNamedAndRemoveUntil('navllevar', (Route<dynamic> route) => false);
                                        } else {
                                          Navigator.of(context).pushNamedAndRemoveUntil('navconsumo', (Route<dynamic> route) => false);
                                        }
                                      } else if (vGlobal_Restaurante.TipoPedido == "DELIVERY") {
                                        final GetOrdenLlevar? postlog = await getOrdenLlevar;
                                        var dataLogin = jsonEncode(postlog);
                                        var tJsonLogin = getOrdenLlevarFromJson(dataLogin.toString());
                                        if (tJsonLogin.data!.isEmpty) {
                                          Navigator.of(context).pushNamedAndRemoveUntil('navdelivery', (Route<dynamic> route) => false);
                                        } else {
                                          Navigator.of(context).pushNamedAndRemoveUntil('navconsumo', (Route<dynamic> route) => false);
                                        }
                                      } else {
                                        Navigator.of(context).pushNamedAndRemoveUntil('navconsumo', (Route<dynamic> route) => false);
                                      }
                                    } else {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushNamedAndRemoveUntil('navmesaSeleccionar', (Route<dynamic> route) => false);
                                    }
                                  } catch (e) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushNamedAndRemoveUntil('navmesaSeleccionar', (Route<dynamic> route) => false);
                                  }
                                } else {
                                  Navigator.of(context).pop();
                                }
                              } else {
                                Navigator.of(context).pop();
                                if (vGlobal_Restaurante.TipoPedido == "LLEVAR") {
                                  final GetOrdenLlevar? postlog = await getOrdenLlevar;
                                  var dataLogin = jsonEncode(postlog);
                                  var tJsonLogin = getOrdenLlevarFromJson(dataLogin.toString());
                                  if (tJsonLogin.data!.isEmpty) {
                                    Navigator.of(context).pushNamedAndRemoveUntil('navllevar', (Route<dynamic> route) => false);
                                  } else {
                                    Navigator.of(context).pushNamedAndRemoveUntil('navconsumo', (Route<dynamic> route) => false);
                                  }
                                } else if (vGlobal_Restaurante.TipoPedido == "DELIVERY") {
                                  final GetOrdenLlevar? postlog = await getOrdenLlevar;
                                  var dataLogin = jsonEncode(postlog);
                                  var tJsonLogin = getOrdenLlevarFromJson(dataLogin.toString());
                                  if (tJsonLogin.data!.isEmpty) {
                                    Navigator.of(context).pushNamedAndRemoveUntil('navdelivery', (Route<dynamic> route) => false);
                                  } else {
                                    Navigator.of(context).pushNamedAndRemoveUntil('navconsumo', (Route<dynamic> route) => false);
                                  }
                                } else {
                                  Navigator.of(context).pushNamedAndRemoveUntil('navconsumo', (Route<dynamic> route) => false);
                                }
                              }
                            } else {
                              Navigator.of(context).pop();
                            }

                          } catch (e) {
                            Fluttertoast.showToast(msg: "El sistema no pudo generar el Comprobante", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                            Navigator.of(context).pop();
                          }
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: ClsColor.tipo8(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(100, 30),
                      ),
                      icon: const Icon(Icons.delete, size: 15),
                      label: const Text("Anular", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),

                    )
                  
                  ]
                )
              ]
            )
          )
        );
      }
    );
  }

}
