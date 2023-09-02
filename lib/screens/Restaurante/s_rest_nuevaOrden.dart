import 'dart:convert';

import 'package:fast/models/Restaurante/m_GetClienteDelivery.dart';
import 'package:fast/models/Restaurante/m_GetImpresionFormatos.dart';
import 'package:fast/providers/providers.dart';
import 'package:fast/providers/providers_Restaurante.dart';
import 'package:fast/screens/Restaurante/s_rest_Print.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/options.dart' as vOptions;
import 'package:fast/providers/global_Restaurante.dart' as vGlobal_Restaurante;
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;

class nuevaOrden extends StatefulWidget {
  const nuevaOrden({Key? key}) : super(key: key);

  @override
  _nuevaOrden createState() => new _nuevaOrden();
}

class _nuevaOrden extends State<nuevaOrden> with TickerProviderStateMixin {
  double iMontoOrden = 0.00;
  var cCliente = TextEditingController(text: (vGlobal_Restaurante.tCliente != "" || vGlobal_Restaurante.tCliente != null) ? vGlobal_Restaurante.tCliente : "");
  var cDTelefono = TextEditingController(text: (vGlobal_Restaurante.delTelefono != "" || vGlobal_Restaurante.delTelefono != null) ? vGlobal_Restaurante.delTelefono : "");
  var cDCliente = TextEditingController(text: (vGlobal_Restaurante.delCliente != "" || vGlobal_Restaurante.delCliente != null) ? vGlobal_Restaurante.delCliente : "");
  var cDDireccion = TextEditingController(text: (vGlobal_Restaurante.delDireccion != "" || vGlobal_Restaurante.delDireccion != null) ? vGlobal_Restaurante.delDireccion : "");
  var cDReferencia = TextEditingController(text: (vGlobal_Restaurante.delReferencia != "" || vGlobal_Restaurante.delReferencia != null) ? vGlobal_Restaurante.delReferencia : "");
  var dropdownZonaDelivery;
  var result_OrdenProducto;

  @override
  void initState() {
    //dropdownZonaDelivery = vGlobal_Restaurante.listZonaDelivery.first.iMZonaDelivery!;
    super.initState();
    _OrdenProducto();
    for (int j = 0; j < vGlobal_Restaurante.listPrecuenta.length; j++) {
      if (vGlobal_Restaurante.listPrecuenta[j]["lCortesia"] == false) {
        iMontoOrden = iMontoOrden + double.parse(vGlobal_Restaurante.listPrecuenta[j]["nTotal"]);
      }
    }
  }

  _DetalleOrden(
    BuildContext context,
    String? tCantidad,
    String? tProducto,
    String? tObservacion,
    String? tUnitario,
    String? tAdicional,
    String? tTotal,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 300, minHeight: 200),
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
                                    child: Text(tTotal.toString(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ClsColor.tipo9())),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text("Observaciones:", maxLines: 7, textAlign: TextAlign.justify, style: TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w600, color: ClsColor.tipo1())),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 15),
                            child: Text(tObservacion.toString(), textAlign: TextAlign.justify, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ClsColor.tipo9())),
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

  void _OrdenProducto() {
    setState(
      () {
        result_OrdenProducto = <Widget>[];
        result_OrdenProducto.add(
          Column(
            children: [
              for (int i = 0; i < vGlobal_Restaurante.listPrecuenta.length; i++) ...[
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: (vGlobal_Restaurante.listPrecuenta[i]["tObservacion"].toString().length <= 30
                          ? 65
                          : ((vGlobal_Restaurante.listPrecuenta[i]["tObservacion"].toString().length > 30 && vGlobal_Restaurante.listPrecuenta[i]["tObservacion"].toString().length <= 90) ? 90 : 115)),
                      child: Row(
                        children: [
                          Container(
                            color: ClsColor.tipo8(),
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    vGlobal_Restaurante.listPrecuenta.removeAt(i);
                                    iMontoOrden = 0.00;
                                    for (int j = 0; j < vGlobal_Restaurante.listPrecuenta.length; j++) {
                                      if (vGlobal_Restaurante.listPrecuenta[j]["lCortesia"] == false) {
                                        iMontoOrden = iMontoOrden + double.parse(vGlobal_Restaurante.listPrecuenta[j]["nTotal"]);
                                      }
                                    }
                                    _OrdenProducto();
                                  });
                                },
                                icon: const Icon(Icons.delete),
                                iconSize: 18.0,
                                color: ClsColor.tipo4(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: GestureDetector(
                                onTap: () {
                                  _DetalleOrden(
                                    context,
                                    vGlobal_Restaurante.listPrecuenta[i]["nCantidad"].toStringAsFixed(0),
                                    vGlobal_Restaurante.listPrecuenta[i]["tProducto"],
                                    vGlobal_Restaurante.listPrecuenta[i]["tObservacion"].toString(),
                                    vGlobal_Restaurante.listPrecuenta[i]["nPrecioUnitario"],
                                    vGlobal_Restaurante.listPrecuenta[i]["nPrecioAdicional"],
                                    vGlobal_Restaurante.listPrecuenta[i]["lCortesia"] == true ? "0.00" : vGlobal_Restaurante.listPrecuenta[i]["nTotal"],
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text("${vGlobal_Restaurante.listPrecuenta[i]["nCantidad"]} - ${vGlobal_Restaurante.listPrecuenta[i]["tProducto"]}",
                                        textAlign: TextAlign.justify, style: TextStyle(color: ClsColor.tipo5(), fontSize: 13, fontWeight: FontWeight.w600)),
                                    Text(vGlobal_Restaurante.listPrecuenta[i]["tObservacion"].toString(),
                                        maxLines: 4, textAlign: TextAlign.justify, style: TextStyle(overflow: TextOverflow.ellipsis, color: ClsColor.tipo6(), fontSize: 10, fontWeight: FontWeight.w400)),
                                    Text(
                                        "PU: ${vGlobal_Restaurante.listPrecuenta[i]["nPrecioUnitario"]} + AD. ${double.parse(vGlobal_Restaurante.listPrecuenta[i]["nTotal"]) == 0 ? "0.00" : ((double.parse(vGlobal_Restaurante.listPrecuenta[i]["nTotal"]) / vGlobal_Restaurante.listPrecuenta[i]["nCantidad"]) - double.parse(vGlobal_Restaurante.listPrecuenta[i]["nPrecioUnitario"])).toStringAsFixed(2)}",
                                        style: TextStyle(color: ClsColor.tipo6(), fontSize: 12, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: ClsColor.tipo1(),
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    int ncantidad = 0;
                                    ncantidad = int.parse(vGlobal_Restaurante.listPrecuenta[i]["nCantidad"].toString());
                                    double itotal = double.parse(vGlobal_Restaurante.listPrecuenta[i]["nTotal"].toString());
                                    vGlobal_Restaurante.listPrecuenta[i]["nTotal"] = ((itotal / ncantidad) * (ncantidad + 1)).toStringAsFixed(2);
                                    vGlobal_Restaurante.listPrecuenta[i]["nCantidad"] = int.parse(ncantidad.toString()) + 1;
                                    iMontoOrden = 0.00;
                                    for (int j = 0; j < vGlobal_Restaurante.listPrecuenta.length; j++) {
                                      if (vGlobal_Restaurante.listPrecuenta[j]["lCortesia"] == false) {
                                        iMontoOrden = iMontoOrden + double.parse(vGlobal_Restaurante.listPrecuenta[j]["nTotal"]);
                                      }
                                    }
                                    _OrdenProducto();
                                  });
                                },
                                icon: const Icon(Icons.add),
                                iconSize: 18.0,
                                color: ClsColor.tipo4(),
                              ),
                            ),
                          ),
                          Container(
                            color: ClsColor.tipo12(),
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (int.parse(vGlobal_Restaurante.listPrecuenta[i]["nCantidad"].toString()) == 1) {
                                      Fluttertoast.showToast(msg: "Cantidad minima 1", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                      return;
                                    }
                                    int ncantidad = 0;
                                    ncantidad = int.parse(vGlobal_Restaurante.listPrecuenta[i]["nCantidad"].toString());
                                    double itotal = double.parse(vGlobal_Restaurante.listPrecuenta[i]["nTotal"].toString());
                                    vGlobal_Restaurante.listPrecuenta[i]["nTotal"] = ((itotal / ncantidad) * (ncantidad - 1)).toStringAsFixed(2);
                                    vGlobal_Restaurante.listPrecuenta[i]["nCantidad"] = int.parse(ncantidad.toString()) - 1;
                                    iMontoOrden = 0.00;
                                    for (int j = 0; j < vGlobal_Restaurante.listPrecuenta.length; j++) {
                                      if (vGlobal_Restaurante.listPrecuenta[j]["lCortesia"] == false) {
                                        iMontoOrden = iMontoOrden + double.parse(vGlobal_Restaurante.listPrecuenta[j]["nTotal"]);
                                      }
                                    }
                                    _OrdenProducto();
                                  });
                                },
                                icon: const Icon(Icons.remove),
                                iconSize: 18.0,
                                color: ClsColor.tipo4(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  _ConfimarAnularOrden(BuildContext context) async {
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
                child: Text('¿Deseas cancelar la orden?', style: TextStyle(color: ClsColor.tipo6(), fontSize: 12, fontWeight: FontWeight.w700)),
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
                        vGlobal_Restaurante.listPrecuenta = [];
                        Navigator.pop(context, true);
                        if (vGlobal_Restaurante.TipoPedido == "MESA") {
                          Navigator.pushNamed(context, "navconsumo");
                        }
                        if (vGlobal_Restaurante.TipoPedido == "LLEVAR") {
                          Navigator.pushNamed(context, "navllevar");
                        }
                        if (vGlobal_Restaurante.TipoPedido == "DELIVERY") {
                          Navigator.pushNamed(context, "navdelivery");
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (_ConfimarAnularOrden(context));
      },
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
                  onPressed: () async {
                    return (_ConfimarAnularOrden(context));
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
                  Text(
                    vGlobal.tUsuario!,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: ClsColor.tipo4()),
                  ),
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
                            ],
                          ],
                        ),
                      ),
                      Text('NUEVA ORDEN   ', style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: result_OrdenProducto,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
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
            label: Text("Agregar Item", style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w400)),
          ),
          const SizedBox(height: 10), 
          ElevatedButton.icon(
            onPressed: () async {
              if (vGlobal_Restaurante.listPrecuenta.isNotEmpty) {
                ClsDecoration.showDialogLoading(context);

                bool statusServidorLocal = true;
                if (vOptions.tipoConexion != 1) { //JEAN
                  if (vOptions.tipoImpresion == 2 || vOptions.tipoImpresion == null) {
                    try {
                      // Map<String, dynamic>? postReg = await getStatusServerPrint();
                      // bool codigo = postReg?["code"];
                      // if (codigo == false) {
                      //   Fluttertoast.showToast(msg: "Supero Tiempo de Espera, no se logro conectar al servidor local", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                      //   statusServidorLocal = false;
                      //   Navigator.of(context).pop();
                      //   return;
                      // }
                    } catch (e) {
                      Fluttertoast.showToast(msg: "Error: Verifique la Configuración de Impresoras", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                      statusServidorLocal = false;
                      Navigator.of(context).pop();
                      return;
                    }
                  }
                }
                var codigo;
                var mensaje;
                List<FormatoLista>? Impresoras;
                if (statusServidorLocal == true) {
                  try {
                    switch (vGlobal_Restaurante.TipoPedido) {
                      case "MESA":
                        Map<String, dynamic>? postReg = await postAgregarItemOrden();
                        codigo = postReg?["codigo"].toString();
                        mensaje = postReg?["mensaje"];
                        if (vOptions.tipoConexion == 1) {
                          Impresoras = postReg?["tImpresora"];
                        }
                        Fluttertoast.showToast(msg: mensaje ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                        break;
                      case "LLEVAR":
                        if (vGlobal_Restaurante.tCliente != "" && vGlobal_Restaurante.tCliente != null) {
                          Map<String, dynamic>? postReg = await postGenerarOrdenLlevar();
                          codigo = postReg?["codigo"].toString();
                          mensaje = postReg?["mensaje"];
                          if (vOptions.tipoConexion == 1) {
                            Impresoras = postReg?["tImpresora"];
                          }
                          Fluttertoast.showToast(msg: (codigo == "0" ? "Registro Correcto" : mensaje) ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                        } else {
                          Navigator.of(context).pop();
                          vGlobal_Restaurante.tCliente = "";
                          cCliente.text = "";
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                  width: double.infinity,
                                  constraints: const BoxConstraints(minHeight: 190, maxHeight: 190),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                              child: Text('Cliente', style: TextStyle(color: ClsColor.tipo5(), fontSize: 16, fontWeight: FontWeight.w600)),
                                            ),
                                            const SizedBox(height: 10),
                                            Flexible(
                                              child: TextFormField(
                                                controller: cCliente,
                                                autofocus: true,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                                keyboardType: TextInputType.text,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  isDense: true,
                                                  fillColor: ClsColor.tipo4(),
                                                  enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: ClsColor.tipo1(), width: 2)),
                                                  focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: ClsColor.tipo1(), width: 2)),
                                                ),
                                              ),
                                            ),
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
                                              if (cCliente.text.trim() == "") {
                                                Fluttertoast.showToast(
                                                  msg: "Ingrese Cliente",
                                                  gravity: ToastGravity.CENTER,
                                                  backgroundColor: ClsColor.tipo6(),
                                                  textColor: ClsColor.tipo4(),
                                                );
                                                return;
                                              }
                                              vGlobal_Restaurante.tCliente = cCliente.text.trim();
                                              ClsDecoration.showDialogLoading(context);
                                              Map<String, dynamic>? postReg = await postGenerarOrdenLlevar();
                                              codigo = postReg?["codigo"].toString();
                                              mensaje = postReg?["mensaje"];
                                              if (vOptions.tipoConexion == 1) {
                                                Impresoras = postReg?["tImpresora"];
                                              }
                                              Fluttertoast.showToast(
                                                  msg: (codigo == "0" ? "Registro Correcto" : mensaje) ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                              if (codigo == "0") {
                                                if (vOptions.tipoConexion == 1) {
                                                  vGlobal_Restaurante.listPrecuenta = [];
                                                  if (vOptions.tipoImpresion == 2 || vOptions.tipoImpresion == null) {
                                                    try {
                                                      Navigator.of(context).pop();
                                                      for (var i = 0; i < Impresoras!.length; i++) {
                                                        ClsDecoration.showDialogLoading(context);
                                                        Map<String, dynamic>? postReg = await posImpresionWifi(
                                                            Impresoras![i].tPdf, (vOptions.impresoraOrden == "" ? Impresoras![i].tImpresora : "${vOptions.impresoraOrden}"), "Orden${vGlobal_Restaurante.iIDPedido}");
                                                        final code = postReg?["code"].toString();
                                                        final mensaje = postReg?["mensaje"];
                                                        Navigator.of(context).pop();
                                                        Fluttertoast.showToast(msg: mensaje ?? "error al enviar Pdf", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                                      }

                                                      Navigator.of(context).pushNamedAndRemoveUntil('navllevar', (Route<dynamic> route) => false);
                                                    } catch (e) {
                                                      Navigator.of(context).pop();
                                                      Fluttertoast.showToast(
                                                          msg: "Supero el tiempo de espera, verifique la conexión al servidor local",
                                                          gravity: ToastGravity.CENTER,
                                                          backgroundColor: ClsColor.tipo6(),
                                                          textColor: ClsColor.tipo4());
                                                      Navigator.of(context).pushNamedAndRemoveUntil('navconsumo', (Route<dynamic> route) => false);
                                                    }
                                                  } else {
                                                    Navigator.of(context).pop();
                                                  }
                                                } else {
                                                  Navigator.of(context).pushNamedAndRemoveUntil('navllevar', (Route<dynamic> route) => false);
                                                }
                                              } else {
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: ClsColor.tipo1(),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              minimumSize: const Size(100, 30),
                                            ),
                                            icon: const Icon(Icons.send_to_mobile_rounded, size: 15),
                                            label: const Text("Enviar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          return;
                        }
                        break;
                      case "DELIVERY":
                        if (vGlobal_Restaurante.tCliente != "" && vGlobal_Restaurante.tCliente != null) {
                          Map<String, dynamic>? postReg = await postGenerarOrdenDelivery();
                          codigo = postReg?["codigo"].toString();
                          mensaje = postReg?["mensaje"];
                          if (vOptions.tipoConexion == 1) {
                            Impresoras = postReg?["tImpresora"];
                          }
                          Fluttertoast.showToast(msg: (codigo == "0" ? "Registro Correcto" : mensaje) ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                        } else {
                          Navigator.of(context).pop();
                          vGlobal_Restaurante.delTelefono = "";
                          vGlobal_Restaurante.delCliente = "";
                          vGlobal_Restaurante.delDireccion = "";
                          vGlobal_Restaurante.delReferencia = "";
                          cDTelefono.text = "";
                          cDCliente.text = "";
                          cDDireccion.text = "";
                          cDReferencia.text = "";
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                  width: double.infinity,
                                  constraints: const BoxConstraints(minHeight: 530, maxHeight: 550),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Text('Celular: ', style: TextStyle(color: ClsColor.tipo5(), fontSize: 16, fontWeight: FontWeight.w600)),
                                                  const SizedBox(height: 10),
                                                  Flexible(
                                                    child: TextFormField(
                                                      controller: cDTelefono,
                                                      maxLength: 9,
                                                      autofocus: true,
                                                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w700, letterSpacing: 3),
                                                      keyboardType: TextInputType.phone,
                                                      decoration: InputDecoration(
                                                        filled: true,
                                                        isDense: true,
                                                        fillColor: ClsColor.tipo4(),
                                                      ),
                                                      onChanged: (value) async {
                                                        if (value.length == 9) {
                                                          final GetClienteDelivery? Postlog = await getClienteDelivey(value);
                                                          var dataLogin = jsonEncode(Postlog);
                                                          var tJsonLogin = getClienteDeliveryFromJson(dataLogin.toString());
                                                          if (tJsonLogin.data!.isNotEmpty) {
                                                            setState(() {
                                                              cDCliente.text = tJsonLogin.data!.first.tNombre!;
                                                              cDDireccion.text = tJsonLogin.data!.first.tDireccion!;
                                                              cDReferencia.text = tJsonLogin.data!.first.tReferencia!;
                                                              //dropdownZonaDelivery = tJsonLogin.data!.first.iMZona!;
                                                            });
                                                          }
                                                        } else {
                                                          cDCliente.text = "";
                                                          cDDireccion.text = "";
                                                          cDReferencia.text = "";
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Text('Cliente:', style: TextStyle(color: ClsColor.tipo5(), fontSize: 16, fontWeight: FontWeight.w600)),
                                              const SizedBox(height: 10),
                                              TextFormField(
                                                controller: cDCliente,
                                                maxLines: 1,
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                                keyboardType: TextInputType.text,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  isDense: true,
                                                  fillColor: ClsColor.tipo4(),
                                                  enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: ClsColor.tipo1(), width: 2)),
                                                  focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: ClsColor.tipo1(), width: 2)),
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              Text('Dirección:', style: TextStyle(color: ClsColor.tipo5(), fontSize: 16, fontWeight: FontWeight.w600)),
                                              const SizedBox(height: 10),
                                              TextFormField(
                                                controller: cDDireccion,
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                                keyboardType: TextInputType.text,
                                                maxLines: 2,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  isDense: true,
                                                  fillColor: ClsColor.tipo4(),
                                                  enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: ClsColor.tipo1(), width: 2)),
                                                  focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: ClsColor.tipo1(), width: 2)),
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              Text('Referencia:', style: TextStyle(color: ClsColor.tipo5(), fontSize: 16, fontWeight: FontWeight.w600)),
                                              const SizedBox(height: 10),
                                              TextFormField(
                                                controller: cDReferencia,
                                                maxLines: 2,
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                                                keyboardType: TextInputType.text,
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  isDense: true,
                                                  fillColor: ClsColor.tipo4(),
                                                  enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: ClsColor.tipo1(), width: 2)),
                                                  focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: ClsColor.tipo1(), width: 2)),
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              Text('Zona:', style: TextStyle(color: ClsColor.tipo5(), fontSize: 16, fontWeight: FontWeight.w600)),
                                              const SizedBox(height: 5),
                                              DropdownButtonFormField<int>(
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: ClsDecoration.inputborder(),
                                                  enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: ClsColor.tipo1(), width: 2)),
                                                  focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: ClsColor.tipo1(), width: 2)),
                                                  contentPadding: const EdgeInsets.all(0),
                                                  prefixIconColor: ClsColor.tipo5(),
                                                  prefixIcon: Icon(Icons.location_on_sharp, size: 16, color: ClsColor.tipo5()),
                                                ),
                                                value: dropdownZonaDelivery,
                                                items: vGlobal_Restaurante.listZonaDelivery
                                                    .map((ciudad) => DropdownMenuItem<int>(
                                                          value: ciudad.iMZonaDelivery,
                                                          child: Text("${ciudad.tZona} - S/ ${ciudad.iPrecio!.toStringAsFixed(2)}"),
                                                        ))
                                                    .toList(),
                                                onChanged: (int? value) {
                                                  setState(() {
                                                    dropdownZonaDelivery = value!;
                                                    //vGlobal_Restaurante.iMProductoDelivery = int.parse(value.split("|")[1]);
                                                  });
                                                },
                                                isExpanded: true,
                                                style: TextStyle(
                                                  decoration: TextDecoration.none,
                                                  decorationStyle: TextDecorationStyle.dotted,
                                                  decorationColor: Colors.white,
                                                  color: ClsColor.tipo1(),
                                                  backgroundColor: ClsColor.tipo4(),
                                                ),
                                                hint: const Text('Seleccione Zona'),
                                              ),
                                              const SizedBox(height: 10),
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
                                              if (cDTelefono.text.trim().length != 9) {
                                                Fluttertoast.showToast(msg: "Ingrese Nro de Celular", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                                return;
                                              }
                                              if (cDCliente.text.trim() == "") {
                                                Fluttertoast.showToast(msg: "Ingrese Cliente", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                                return;
                                              }
                                              if (cDDireccion.text.trim() == "") {
                                                Fluttertoast.showToast(msg: "Ingrese Dirección", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                                return;
                                              }
                                              if (dropdownZonaDelivery == null || dropdownZonaDelivery == 0) {
                                                Fluttertoast.showToast(msg: "Seleccione Zona", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                                return;
                                              }

                                              vGlobal_Restaurante.delTelefono = cDTelefono.text.trim();
                                              vGlobal_Restaurante.delCliente = cDCliente.text.trim();
                                              vGlobal_Restaurante.delDireccion = cDDireccion.text.trim();
                                              vGlobal_Restaurante.delReferencia = cDReferencia.text.trim();
                                              vGlobal_Restaurante.deliMZona = dropdownZonaDelivery;
                                              ClsDecoration.showDialogLoading(context);
                                              Map<String, dynamic>? postReg = await postGenerarOrdenDelivery();
                                              codigo = postReg?["codigo"].toString();
                                              mensaje = postReg?["mensaje"];
                                              if (vOptions.tipoConexion == 1) {
                                                Impresoras = postReg?["tImpresora"];
                                              }
                                              Fluttertoast.showToast(
                                                  msg: (codigo == "0" ? "Registro Correcto" : mensaje) ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                              if (codigo == "0") {
                                                if (vOptions.tipoConexion == 1) {
                                                  vGlobal_Restaurante.listPrecuenta = [];
                                                  if (vOptions.tipoImpresion == 2 || vOptions.tipoImpresion == null) {
                                                    try {
                                                      Navigator.of(context).pop();
                                                      for (var i = 0; i < Impresoras!.length; i++) {
                                                        ClsDecoration.showDialogLoading(context);
                                                        Map<String, dynamic>? postReg = await posImpresionWifi(
                                                            Impresoras![i].tPdf, (vOptions.impresoraOrden == "" ? Impresoras![i].tImpresora : "${vOptions.impresoraOrden}"), "Orden${vGlobal_Restaurante.iIDPedido}");
                                                        final code = postReg?["code"].toString();
                                                        final mensaje = postReg?["mensaje"];
                                                        Navigator.of(context).pop();
                                                        Fluttertoast.showToast(msg: mensaje ?? "error al enviar Pdf", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                                      }

                                                      Navigator.of(context).pushNamedAndRemoveUntil('navdelivery', (Route<dynamic> route) => false);
                                                    } catch (e) {
                                                      Navigator.of(context).pop();
                                                      Fluttertoast.showToast(
                                                          msg: "Supero el tiempo de espera, verifique la conexión al servidor local",
                                                          gravity: ToastGravity.CENTER,
                                                          backgroundColor: ClsColor.tipo6(),
                                                          textColor: ClsColor.tipo4());
                                                      Navigator.of(context).pushNamedAndRemoveUntil('navconsumo', (Route<dynamic> route) => false);
                                                    }
                                                  } else {
                                                    Navigator.of(context).pop();
                                                  }
                                                } else {
                                                  Navigator.of(context).pushNamedAndRemoveUntil('navdelivery', (Route<dynamic> route) => false);
                                                }
                                              } else {
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: ClsColor.tipo1(),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              minimumSize: const Size(100, 30),
                                            ),
                                            icon: const Icon(Icons.send_to_mobile_rounded, size: 15),
                                            label: const Text("Enviar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          return;
                        }
                        break;
                    }
                    if (vOptions.tipoConexion == 1) {
                      if (codigo == "0") {
                        vGlobal_Restaurante.listPrecuenta = [];
                        if (vOptions.tipoImpresion == 2 || vOptions.tipoImpresion == null) {
                          try {
                            Navigator.of(context).pop();
                            for (var i = 0; i < Impresoras!.length; i++) {
                              ClsDecoration.showDialogLoading(context);
                              Map<String, dynamic>? postReg =
                                  await posImpresionWifi(Impresoras[i].tPdf, (vOptions.impresoraOrden == "" ? Impresoras[i].tImpresora : "${vOptions.impresoraOrden}"), "Orden${vGlobal_Restaurante.iIDPedido}");
                              final code = postReg?["code"].toString();
                              final mensaje = postReg?["mensaje"];
                              Navigator.of(context).pop();
                              Fluttertoast.showToast(msg: mensaje ?? "error al enviar Pdf", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                            }
                            switch (vGlobal_Restaurante.TipoPedido) {
                              case "MESA":
                                Navigator.of(context).pushNamedAndRemoveUntil('navconsumo', (Route<dynamic> route) => false);
                                break;
                              case "LLEVAR":
                                Navigator.of(context).pushNamedAndRemoveUntil('navllevar', (Route<dynamic> route) => false);
                                break;
                              case "DELIVERY":
                                Navigator.of(context).pushNamedAndRemoveUntil('navdelivery', (Route<dynamic> route) => false);
                                break;
                            }
                          } catch (e) {
                            Navigator.of(context).pop();
                            Fluttertoast.showToast(
                                msg: "Supero el tiempo de espera, verifique la conexión al servidor local", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                            Navigator.of(context).pushNamedAndRemoveUntil('navconsumo', (Route<dynamic> route) => false);
                          }
                        } else {
                          Navigator.of(context).pop();
                        }
                      } else {
                        Navigator.of(context).pop();
                      }
                    } else {
                      switch (vGlobal_Restaurante.TipoPedido) {
                        case "MESA":
                          Navigator.of(context).pushNamedAndRemoveUntil('navconsumo', (Route<dynamic> route) => false);
                          break;
                        case "LLEVAR":
                          Navigator.of(context).pushNamedAndRemoveUntil('navllevar', (Route<dynamic> route) => false);
                          break;
                        case "DELIVERY":
                          Navigator.of(context).pushNamedAndRemoveUntil('navdelivery', (Route<dynamic> route) => false);
                          break;
                      }
                    }
                  } catch (e) {
                    Fluttertoast.showToast(msg: "El sistema no pudo generar el Comprobante", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                    Navigator.of(context).pop();
                  }
                }
              } else {
                Fluttertoast.showToast(msg: "Agregue Productos", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
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
            icon: Icon(Icons.check, size: 20, color: ClsColor.tipo1()),
            label: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Enviar Orden", style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text((iMontoOrden.toStringAsFixed(2)), style: TextStyle(color: ClsColor.tipo5(), fontSize: 20, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
