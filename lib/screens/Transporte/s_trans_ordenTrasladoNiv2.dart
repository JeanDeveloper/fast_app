import 'dart:convert';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:fast/models/Comprobante/m_GetInsertWS.dart';
import 'package:fast/models/Comprobante/m_GetNumeroDoc.dart';
import 'package:fast/models/Comprobante/m_GetSerieByTipo.dart';
import 'package:fast/models/Maestro/m_GetClienteBuscarPorNroDoc.dart';
import 'package:fast/models/Producto/m_GetCajaListar.dart';
import 'package:fast/providers/providers.dart';
import 'package:fast/providers/providers_Comprobante.dart';
import 'package:fast/providers/providers_Producto.dart';
import 'package:fast/providers/providers_Transporte.dart';
import 'package:fast/screens/Home/s_principal.dart';
import 'package:fast/screens/Transporte/s_trans_pedidoResultado.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:fast/providers/global_Transporte.dart' as vGlobal_transporte;
import 'package:fast/providers/global_Comprobante.dart' as vGlobal_comprobante;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:fast/providers/Funciones.dart';
import 'dart:math' as math;

class trans_ordenTrasladoNiv2 extends StatefulWidget {
  const trans_ordenTrasladoNiv2({Key? key}) : super(key: key);
  @override
  _trans_ordenTrasladoNiv2 createState() => new _trans_ordenTrasladoNiv2();
}

Future<bool> _onWillPop() async {
  return false;
}

class _trans_ordenTrasladoNiv2 extends State<trans_ordenTrasladoNiv2> {
  var result_CargaProducto = <Widget>[];
  var result_TrasladoProducto = <Widget>[];
  var CBusqProducto = TextEditingController();
  var CProPrecio = TextEditingController();
  var CProDescripcion = TextEditingController();

  var CClienteDoc = TextEditingController();
  var CCliente = TextEditingController();
  var CClienteDir = TextEditingController();
  var CDescuento = TextEditingController();
  var CSerieNumero = TextEditingController();
  final CFecha = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  String dropdownvalueSeries = "";
  String dropdownvalueNumero = "";
  int iMPasajero = 0, iMCliente = 0;
  int TipoDocDigitos = 8;
  String tDescuento = "0";
  bool aplicaGratuita = false;
  bool iEstadoDescuento = true;
  int tipo = 1;
  int iPago = 1;
  late List<SerieData?>? aSeries;
  late List<NumeroData?>? aNumero;
  bool EnabledRuc = false;
  var resultSerie;
  var resultNumero;
  bool precargaReserva = false;

  @override
  void initState() {
    super.initState();
    vGlobal_transporte.ort_fecha = _selectedDate.toString().substring(0, 10);
    CFecha.text = DateFormat('dd/MM/yyyy').format(_selectedDate!).toString();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoadSerie();
    });
    _TrasladoProducto();
    updatePrecio();
  }

  LoadSerie() async {
    aSeries = await getSerieComprobante((tipo == 1 ? "03" : "01"), true);
    if (aSeries != null) {
      if (aSeries!.length > 0) {
        GenerarSerie();
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          if (aSeries![0]!.documentoSerie != "") {
            LoadNumero();
          }
        });
      }
    }
  }

  LoadNumero() async {
    aNumero = await getNumeroComprobante((tipo == 1 ? "03" : "01"), vGlobal_comprobante.documentoSerie);
    if (aNumero != null) {
      if (aNumero!.length > 0) {
        setState(() {
          GenerarNumero();
        });
      }
    }
  }

  Widget GenerarSerie() {
    resultSerie = null;
    resultSerie = Flexible(
      child: Container(
        //padding: const EdgeInsets.symmetric(horizontal: 15),
        child: FutureBuilder<List<SerieData>?>(
          future: getSerieComprobante((tipo == 1 ? "03" : "01"), true),
          builder: (BuildContext context, AsyncSnapshot<List<SerieData>?> snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            return DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: ClsDecoration.inputborder(),
                  enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                  focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                  contentPadding: const EdgeInsets.all(0),
                  prefixIconColor: ClsColor.tipo5(),
                  prefixIcon: Icon(Icons.format_list_numbered_rtl_rounded, size: 16, color: ClsColor.tipo5()),
                ),
                value: snapshot.data![0].documentoSerie ?? "",
                items: snapshot.data?.map((Serie) => DropdownMenuItem<String>(value: Serie.documentoSerie, child: Text(Serie.documentoSerie.toString()))).toList(),
                isExpanded: true,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  decorationStyle: TextDecorationStyle.dotted,
                  decorationColor: Colors.white,
                  color: ClsColor.tipo1(),
                  backgroundColor: ClsColor.tipo4(),
                ),
                onChanged: (String? value) async {
                  setState(() {
                    dropdownvalueSeries = value!;
                    vGlobal_comprobante.documentoSerie = dropdownvalueSeries;
                    vGlobal_comprobante.formatoPdf = snapshot.data![0].formatoPdf!;
                    LoadNumero();
                  });
                  //tipoNumero();
                },
              ),
            );
          },
        ),
      ),
    );
    return resultSerie;
  }

  Widget GenerarNumero() {
    resultNumero = null;
    resultNumero = Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: FutureBuilder<List<NumeroData>?>(
          future: getNumeroComprobante((tipo == 1 ? "03" : "01"), vGlobal_comprobante.documentoSerie),
          builder: (BuildContext context, AsyncSnapshot<List<NumeroData>?> snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            NumberFormat formatter = NumberFormat("00000000");
            int numero = int.parse(snapshot.data![0].codigo ?? "0");
            CSerieNumero.text = formatter.format(numero).toString();
            vGlobal_comprobante.documentoNumero = formatter.format(numero).toString();
            return TextFormField(
              controller: CSerieNumero,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                filled: true,
                isDense: true,
                enabled: false,
                fillColor: ClsColor.tipo2(),
                disabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo11(), width: 2)),
              ),
            );
          },
        ),
      ),
    );
    return resultNumero;
  }

  selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 250,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoButton(
                    child: const Text('Aceptar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      vGlobal_transporte.ort_fecha = _selectedDate.toString().substring(0, 10);
                      CFecha.text = DateFormat('dd/MM/yyyy').format(_selectedDate!).toString();
                    },
                  ),
                ],
              ),
              const Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: Container(
                  child: CupertinoDatePicker(
                    initialDateTime: _selectedDate,
                    dateOrder: DatePickerDateOrder.dmy,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime dateTime) {
                      _selectedDate = dateTime;
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void updatePrecio() {
    setState(() {
      double iDescuento = double.parse(tDescuento);
      vGlobal_transporte.iPrecioInicial = 0;
      if (vGlobal_transporte.listProductoTraslado.isNotEmpty) {
        for (int j = 0; j < vGlobal_transporte.listProductoTraslado.length; j++) {
          vGlobal_transporte.iPrecioInicial = vGlobal_transporte.iPrecioInicial + double.parse(vGlobal_transporte.listProductoTraslado[j]["nTotal"]);
        }
      }
      if (aplicaGratuita == true) {
        vGlobal_transporte.iPrecioFinal = 0;
        vGlobal_transporte.iDescuento = 0;
        iEstadoDescuento = false;
        CDescuento.text = "";
      } else {
        if (vGlobal_transporte.iPrecioInicial < iDescuento) {
          CDescuento.text = vGlobal_transporte.iPrecioInicial.toStringAsFixed(0);
          iDescuento = vGlobal_transporte.iPrecioInicial;
          vGlobal_transporte.iDescuento = vGlobal_transporte.iPrecioInicial;
        }
        vGlobal_transporte.iDescuento = iDescuento;
        vGlobal_transporte.iPrecioFinal = vGlobal_transporte.iPrecioInicial - iDescuento;
        iEstadoDescuento = true;
      }
    });
  }

  void _GenerarCargaProducto() {
    setState(() {
      result_CargaProducto = <Widget>[];
      result_CargaProducto.add(
        Container(
          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
          child: FutureBuilder<GetProductoPorNombre?>(
            future: getistProductoPorNombre(CBusqProducto.text),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator.adaptive());
              }
              final GetProductoPorNombre? Lista = snapshot.data;
              return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: Lista?.data.length ?? 0,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        for (var map in vGlobal_transporte.listProductoTraslado) {
                          if (map.containsKey("iMProducto")) {
                            if (map["iMProducto"] == Lista.data[index].iMProducto) {
                              Fluttertoast.showToast(msg: "Producto ya esta agregado en la lista", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                              return;
                            }
                          }
                        }
                        Map<String, dynamic> detalle = {
                          "iMProducto": Lista.data[index].iMProducto,
                          "tProducto": Lista.data[index].tDescripcion,
                          "tUnidad": Lista.data[index].tUnidad,
                          "nPrecioUnitario": Lista.data[index].iPrecioTotal.toStringAsFixed(2),
                          "nCantidad": 1,
                          "nTotal": Lista.data[index].iPrecioTotal.toStringAsFixed(2),
                          "tObservacion": ""
                        };
                        vGlobal_transporte.listProductoTraslado.add(detalle);
                        updatePrecio();
                        // CBeneficiario.text = Lista.data[index].tNombre.toString();
                        // iMBeneficiario = Lista.data[index].iIdBeneficiario;
                        // CBuscador.text = Lista.data[index].tNroDoc.toString();
                        result_CargaProducto = [];
                        CBusqProducto.text = "";
                        _TrasladoProducto();
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(
                              Lista!.data[index].tDescripcion,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: ClsColor.tipo5(), fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              NumberFormat('S/ #,##,##0.00').format(Lista.data[index].iPrecioTotal),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: TextStyle(color: ClsColor.tipo5(), fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      );
    });
    // return result;
  }

  void _TrasladoProducto() {
    setState(() {
      result_TrasladoProducto = <Widget>[];
      result_TrasladoProducto.add(
        Container(
            child: Column(
          children: [
            for (int i = 0; i < vGlobal_transporte.listProductoTraslado.length; i++) ...[
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 60,
                    child: Row(
                      children: [
                        Container(
                          color: ClsColor.tipo1(),
                          width: 40,
                          height: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    int ncantidad = int.parse(vGlobal_transporte.listProductoTraslado[i]["nCantidad"].toString());
                                    double nPrecioUnit = double.parse(vGlobal_transporte.listProductoTraslado[i]["nPrecioUnitario"].toString());
                                    double itotal = double.parse(vGlobal_transporte.listProductoTraslado[i]["nTotal"].toString());

                                    vGlobal_transporte.listProductoTraslado[i]["nTotal"] = (nPrecioUnit * (ncantidad + 1)).toStringAsFixed(2);
                                    vGlobal_transporte.listProductoTraslado[i]["nCantidad"] = (ncantidad + 1);
                                    // iMontoOrden = 0.00;
                                    // for (int j = 0; j < vGlobal_transporte.listPrecuenta.length; j++) {
                                    //   iMontoOrden = iMontoOrden + double.parse(vGlobal_transporte.listPrecuenta[j]["nTotal"]);
                                    // }
                                    _TrasladoProducto();
                                    updatePrecio();
                                  });
                                },
                                child: Icon(
                                  Icons.add,
                                  size: 15.0,
                                  color: ClsColor.tipo4(),
                                ),
                              ),
                              Divider(color: ClsColor.tipo4(), height: 3),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (int.parse(vGlobal_transporte.listProductoTraslado[i]["nCantidad"].toString()) == 1) {
                                      Fluttertoast.showToast(msg: "Cantidad minima 1", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                      return;
                                    }
                                    int ncantidad = int.parse(vGlobal_transporte.listProductoTraslado[i]["nCantidad"].toString());
                                    double nPrecioUnit = double.parse(vGlobal_transporte.listProductoTraslado[i]["nPrecioUnitario"].toString());
                                    double itotal = double.parse(vGlobal_transporte.listProductoTraslado[i]["nTotal"].toString());

                                    vGlobal_transporte.listProductoTraslado[i]["nTotal"] = (nPrecioUnit * (ncantidad - 1)).toStringAsFixed(2);
                                    vGlobal_transporte.listProductoTraslado[i]["nCantidad"] = (ncantidad - 1);
                                    // iMontoOrden = 0.00;
                                    // for (int j = 0; j < vGlobal_transporte.listPrecuenta.length; j++) {
                                    //   iMontoOrden = iMontoOrden + double.parse(vGlobal_transporte.listPrecuenta[j]["nTotal"]);
                                    // }
                                    _TrasladoProducto();
                                    updatePrecio();
                                  });
                                },
                                child: SizedBox(
                                    child: Icon(
                                  Icons.remove,
                                  size: 15.0,
                                  color: ClsColor.tipo4(),
                                )),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("${vGlobal_transporte.listProductoTraslado[i]["nCantidad"].toString()} - ${vGlobal_transporte.listProductoTraslado[i]["tProducto"].toString()}",
                                    style: TextStyle(color: ClsColor.tipo5(), fontSize: 13, fontWeight: FontWeight.w600)),
                                Text(vGlobal_transporte.listProductoTraslado[i]["tObservacion"].toString(), style: TextStyle(color: ClsColor.tipo6(), fontSize: 11, fontWeight: FontWeight.w400)),
                                Text(NumberFormat('S/ #,##,##0.00').format(double.parse(vGlobal_transporte.listProductoTraslado[i]["nTotal"])),
                                    style: TextStyle(color: ClsColor.tipo6(), fontSize: 12, fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: ClsColor.tipo11(),
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                CProDescripcion.text = vGlobal_transporte.listProductoTraslado[i]["tObservacion"];
                                CProPrecio.text = vGlobal_transporte.listProductoTraslado[i]["nPrecioUnitario"];
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                        width: double.infinity,
                                        constraints: const BoxConstraints(maxHeight: 300),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(vGlobal_transporte.listProductoTraslado[i]["tProducto"].toString(),
                                                textAlign: TextAlign.center, style: TextStyle(color: ClsColor.tipo1(), fontSize: 14, fontWeight: FontWeight.w700)),
                                            const SizedBox(height: 20),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text('Precio Unit. : ', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                                                      Expanded(
                                                        child: TextFormField(
                                                          controller: CProPrecio,
                                                          enabled: iEstadoDescuento,
                                                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                                          ],
                                                          decoration: const InputDecoration(isDense: true, prefix: Text(" S/ ")),
                                                          onChanged: (value) {},
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Text('Descripción:', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                                                  TextField(
                                                    controller: CProDescripcion,
                                                    maxLength: 50,
                                                    minLines: 1,
                                                    maxLines: 3,
                                                    decoration: const InputDecoration(isDense: true),
                                                    onChanged: (value) {},
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
                                                    if (CProPrecio.text.length == 0) {
                                                      Fluttertoast.showToast(
                                                        msg: "Ingrese Precio",
                                                        gravity: ToastGravity.CENTER,
                                                        backgroundColor: ClsColor.tipo6(),
                                                        textColor: ClsColor.tipo4(),
                                                      );
                                                      return;
                                                    }
                                                    if (double.tryParse(CProPrecio.text) == null) {
                                                      Fluttertoast.showToast(
                                                        msg: "Ingrese Precio Válido",
                                                        gravity: ToastGravity.CENTER,
                                                        backgroundColor: ClsColor.tipo6(),
                                                        textColor: ClsColor.tipo4(),
                                                      );
                                                      return;
                                                    }
                                                    if (double.parse(CProPrecio.text) <= 0) {
                                                      Fluttertoast.showToast(
                                                        msg: "Ingrese Precio Válido",
                                                        gravity: ToastGravity.CENTER,
                                                        backgroundColor: ClsColor.tipo6(),
                                                        textColor: ClsColor.tipo4(),
                                                      );
                                                      return;
                                                    }
                                                    int ncantidad = int.parse(vGlobal_transporte.listProductoTraslado[i]["nCantidad"].toString());
                                                    double nPrecioUnit = double.parse(CProPrecio.text);
                                                    double itotal = double.parse(vGlobal_transporte.listProductoTraslado[i]["nTotal"].toString());
                                                    vGlobal_transporte.listProductoTraslado[i]["tObservacion"] = CProDescripcion.text;
                                                    vGlobal_transporte.listProductoTraslado[i]["nPrecioUnitario"] = nPrecioUnit.toStringAsFixed(2);
                                                    vGlobal_transporte.listProductoTraslado[i]["nTotal"] = (nPrecioUnit * ncantidad).toStringAsFixed(2);
                                                    _TrasladoProducto();
                                                    updatePrecio();
                                                    Navigator.pop(context);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    foregroundColor: Colors.white,
                                                    backgroundColor: ClsColor.tipo1(),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                    minimumSize: const Size(100, 30),
                                                  ),
                                                  icon: const Icon(Icons.save_rounded, size: 15),
                                                  label: const Text("Guardar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                                ),
                                                const SizedBox(width: 10),
                                                ElevatedButton.icon(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    foregroundColor: Colors.white,
                                                    backgroundColor: ClsColor.tipo8(),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                    minimumSize: const Size(100, 30),
                                                  ),
                                                  icon: const Icon(Icons.close_outlined, size: 15),
                                                  label: const Text("Cerrar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.edit),
                              iconSize: 18.0,
                              color: ClsColor.tipo4(),
                            ),
                          ),
                        ),
                        Container(
                          color: ClsColor.tipo8(),
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  vGlobal_transporte.listProductoTraslado.removeAt(i);
                                  _TrasladoProducto();
                                  updatePrecio();
                                });
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
              ),
            ]
          ],
        )),
      );
    });
    // return result;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: ClsDecoration.appBar(context, "navtrans_ordenTrasladoNiv1"),
        drawer: NavDrawer(),
        backgroundColor: ClsColor.tipo1(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              ClsTextStyle.cabeceraBienvenida(
                titulo: 'FECHA : ${vGlobal_transporte.fecha}',
                subtitulo: vGlobal_transporte.ruta,
                detalle: '',
              ),
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
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text('2/3 (Items a completar)', style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                      controller: CBusqProducto,
                      decoration: InputDecoration(
                        hintText: "Buscar Producto",
                        filled: true,
                        isDense: true,
                        fillColor: ClsColor.tipo4(),
                        enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        prefixIcon: Icon(Icons.search, color: ClsColor.tipo1()),
                        // suffixIcon: IconButton(
                        // onPressed: _textController.clear,
                        // icon: Icon(Icons.clear),
                        // ),
                      ),
                      onChanged: (value) {
                        _GenerarCargaProducto();
                      },
                    ),
                    const SizedBox(height: 10),
                    Column(children: result_CargaProducto),
                    const SizedBox(height: 10),
                    Column(children: result_TrasladoProducto),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('TOTAL', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                          Text(NumberFormat('S/ #,##,##0.00').format(vGlobal_transporte.iPrecioFinal),
                              style: TextStyle(
                                color: ClsColor.tipo1(),
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Venta Gratuita', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                        Text('Descuento', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: aplicaGratuita == true ? ClsColor.tipo1() : ClsColor.tipo4(),
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: CheckboxListTile(
                              dense: true,
                              activeColor: ClsColor.tipo1(),
                              title: Text(
                                "Si Aplica",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: aplicaGratuita == true ? ClsColor.tipo4() : ClsColor.tipo1()),
                              ),
                              value: aplicaGratuita,
                              onChanged: (newValue) {
                                setState(() {
                                  aplicaGratuita = newValue!;
                                  updatePrecio();
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: TextFormField(
                            controller: CDescuento,
                            enabled: iEstadoDescuento,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              isDense: true,
                              fillColor: iEstadoDescuento == true ? ClsColor.tipo4() : ClsColor.tipo2(),
                              enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                              focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                              disabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo11(), width: 2)),
                              prefix: const Text(" S/ "),
                            ),
                            onChanged: (value) {
                              setState(() {
                                if (CDescuento.text == "" || CDescuento.text == null) {
                                  tDescuento = "0";
                                } else {
                                  tDescuento = value;
                                }
                                updatePrecio();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    //   child: Text('Fecha', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                    // ),
                    // TextField(
                    //   onTap: () => selectDate(),
                    //   controller: CFecha,
                    //   enabled: true,
                    //   keyboardType: TextInputType.none,
                    //   enableInteractiveSelection: false,
                    //   focusNode: FocusNode(),
                    //   decoration: InputDecoration(
                    //     filled: true,
                    //     fillColor: Colors.white,
                    //     border: ClsDecoration.inputborder(),
                    //     enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                    //     focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                    //     contentPadding: const EdgeInsets.all(0),
                    //     labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo1()),
                    //     floatingLabelBehavior: FloatingLabelBehavior.never,
                    //     prefixIconColor: ClsColor.tipo5(),
                    //     prefixIcon: Icon(Icons.calendar_month_rounded, size: 16, color: ClsColor.tipo5()),
                    //     suffixIconColor: ClsColor.tipo5(),
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: iPago == 1 ? ClsColor.tipo1() : ClsColor.tipo4(),
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: RadioListTile(
                              visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity),
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              activeColor: iPago == 1 ? ClsColor.tipo4() : ClsColor.tipo1(),
                              title: Text(
                                "Paga Ahora",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: iPago == 1 ? ClsColor.tipo4() : ClsColor.tipo1()),
                              ),
                              value: 1,
                              groupValue: iPago,
                              onChanged: (value) {
                                setState(() {
                                  iPago = value!;
                                  iMCliente = 0;
                                  CClienteDoc.text = "";
                                  CCliente.text = "";
                                  CClienteDir.text = "";
                                  EnabledRuc = false;
                                  resultSerie = null;
                                  resultNumero = null;
                                  LoadSerie();
                                });
                                //tipoSerie();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Container(
                            // height: 80,
                            decoration: BoxDecoration(
                              color: iPago == 2 ? ClsColor.tipo1() : ClsColor.tipo4(),
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: RadioListTile(
                              visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity),
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              activeColor: iPago == 2 ? ClsColor.tipo4() : ClsColor.tipo1(),
                              title: Text(
                                "Paga Destino",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: iPago == 2 ? ClsColor.tipo4() : ClsColor.tipo1()),
                              ),
                              value: 2,
                              groupValue: iPago,
                              onChanged: (value) {
                                setState(() {
                                  iMCliente = 0;
                                  CClienteDoc.text = "";
                                  CCliente.text = "";
                                  CClienteDir.text = "";
                                  tipo = 1;
                                  iPago = value!;
                                  EnabledRuc = false;
                                  resultSerie = null;
                                  resultNumero = null;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (iPago == 1) ...[
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                color: tipo == 1 ? ClsColor.tipo1() : ClsColor.tipo4(),
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                              ),
                              child: RadioListTile(
                                visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity),
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                activeColor: tipo == 1 ? ClsColor.tipo4() : ClsColor.tipo1(),
                                title: Text(
                                  "Boleta",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: tipo == 1 ? ClsColor.tipo4() : ClsColor.tipo1()),
                                ),
                                value: 1,
                                groupValue: tipo,
                                onChanged: (value) {
                                  setState(() {
                                    tipo = value!;
                                    iMCliente = 0;
                                    CClienteDoc.text = "";
                                    CCliente.text = "";
                                    CClienteDir.text = "";
                                    EnabledRuc = false;
                                    resultSerie = null;
                                    resultNumero = null;
                                    LoadSerie();
                                  });
                                  //tipoSerie();
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Container(
                              // height: 80,
                              decoration: BoxDecoration(
                                color: tipo == 2 ? ClsColor.tipo1() : ClsColor.tipo4(),
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                              ),
                              child: RadioListTile(
                                visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity),
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                activeColor: tipo == 2 ? ClsColor.tipo4() : ClsColor.tipo1(),
                                title: Text(
                                  "Factura",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: tipo == 2 ? ClsColor.tipo4() : ClsColor.tipo1()),
                                ),
                                value: 2,
                                groupValue: tipo,
                                onChanged: (value) {
                                  setState(() {
                                    iMCliente = 0;
                                    CClienteDoc.text = "";
                                    CCliente.text = "";
                                    CClienteDir.text = "";
                                    tipo = value!;
                                    EnabledRuc = true;
                                    resultSerie = null;
                                    resultNumero = null;
                                    LoadSerie();
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            child: resultSerie,
                          ),
                          const SizedBox(width: 10),
                          Container(
                            child: resultNumero,
                          ),
                        ],
                      ),
                    ],
                    if (EnabledRuc == true) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text('RUC', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: TextFormField(
                              enabled: EnabledRuc,
                              maxLength: 11,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly],
                              validator: (value) {
                                return (value != null) ? null : 'Nro. Digitos Permitidos 11';
                              },
                              controller: CClienteDoc,
                              decoration: InputDecoration(
                                filled: true,
                                isDense: true,
                                fillColor: ClsColor.tipo4(),
                                enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                                focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                                prefixIcon: Icon(Icons.badge_rounded, color: ClsColor.tipo5()),
                              ),
                              onChanged: (value) {
                                CCliente.text = "";
                                CClienteDir.text = "";
                                iMCliente = 0;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (CClienteDoc.text.length == 11) {
                                final GetClienteBuscarPorNroDoc? Postlog = await getClienteBuscarPorNroDoc(CClienteDoc.text, 2);
                                var dataClienteBuscar = jsonEncode(Postlog);
                                var tJsonClienteBuscar = getClienteBuscarPorNroDocFromJson(dataClienteBuscar.toString());
                                if (tJsonClienteBuscar.code == 2) {
                                  Fluttertoast.showToast(msg: tJsonClienteBuscar.message, gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                } else {
                                  // ignore: use_build_context_synchronously
                                  FocusScope.of(context).unfocus();
                                  iMCliente = tJsonClienteBuscar.data[0].iMCliente;
                                  CCliente.text = tJsonClienteBuscar.data[0].tNombre == null ? "" : tJsonClienteBuscar.data[0].tNombre;
                                  CClienteDir.text = tJsonClienteBuscar.data[0].tDireccion == null ? "" : tJsonClienteBuscar.data[0].tDireccion;
                                }
                              } else {
                                Fluttertoast.showToast(msg: "Nro. Digitos Permitidos 11", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                              }
                            },
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(Size(20, 50)),
                              backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
                              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.only(left: 5)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                            ),
                            icon: Icon(Icons.search, size: 25, color: ClsColor.tipo4()),
                            label: const Text(""),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        child: Text('Razón Social', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                      ),
                      TextField(
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        enabled: false, // EnabledRuc,
                        controller: CCliente,
                        decoration: InputDecoration(
                          filled: true,
                          isDense: true,
                          fillColor: ClsColor.tipo2(),
                        ),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        child: Text('Dirección', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        enabled: true, //EnabledRuc,
                        controller: CClienteDir,
                        decoration: InputDecoration(
                          filled: true,
                          isDense: true,
                          fillColor: ClsColor.tipo4(),
                          enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                          focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        ),
                        onChanged: (value) {},
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () async {
              // EasyLoading.show(status: 'Registrando...', maskType: EasyLoadingMaskType.black);

              if (vGlobal_comprobante.documentoSerie == "" || vGlobal_comprobante.documentoSerie == null || vGlobal_comprobante.documentoNumero == "" || vGlobal_comprobante.documentoNumero == "00000000") {
                Fluttertoast.showToast(msg: "No tiene serie para la emision de Comprobante", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                // EasyLoading.dismiss();
                return;
              }
              if (tipo == 2) {
                if (iMCliente == 0 && CCliente.text.length == 0) {
                  Fluttertoast.showToast(msg: "Ingrese Cliente", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                  // EasyLoading.dismiss();
                  return;
                }

                if (CClienteDir.text == "" && CClienteDir.text == null) {
                  Fluttertoast.showToast(msg: "Ingrese Dirección", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                  // EasyLoading.dismiss();
                  return;
                }
              }

              Map<Permission, PermissionStatus> statuses = await [
                Permission.storage,
              ].request();

              if (statuses[Permission.storage]!.isGranted) {
                var dir = await DownloadsPathProvider.downloadsDirectory;
                vGlobal_transporte.tTipoComprobante = (tipo == 1 ? "BOLETA" : "FACTURA");
                if (dir != null) {
                  var codigo;
                  var mensaje;
                  var iMOrden;

                  Map<String, dynamic>? postReg = await OrdenTrasladoRegistrar(
                    iMCliente,
                    CClienteDoc.text,
                    CCliente.text,
                    CClienteDir.text,
                    (tipo == 1 ? "BOLETA" : "FACTURA"),
                    double.parse(tDescuento),
                    aplicaGratuita,
                    (iPago == 1 ? true : false),
                    0, //(iPago == 1 ? 1 : 2),
                  );
                  codigo = postReg?["codigo"].toString();
                  mensaje = postReg?["mensaje"];
                  iMOrden = postReg?["iMOrden"];

                  Fluttertoast.showToast(msg: mensaje ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());

                  if (codigo == "0") {
                    if (iPago == 1) {
                      try {
                        LoadNumero();
                        await Future.delayed(const Duration(seconds: 2));

                        double pFinal = vGlobal_transporte.iPrecioFinal;
                        double pDescuento = vGlobal_transporte.iDescuento;
                        double pPorDescuento = (vGlobal_transporte.iDescuento == 0 ? 0 : (vGlobal_transporte.iDescuento / vGlobal_transporte.iPrecioInicial));

                        String Letra = (Funciones.numeroALetras(vGlobal_transporte.iPrecioFinal.toString(), 'SOLES')).toUpperCase();
                        String tDescripcion = "ORDEN TRASLADO";
                        vGlobal_transporte.letra = Letra;
                        vGlobal_transporte.descripcion = tDescripcion;
                        List<Map<String, dynamic>> listProductoWS = [];
                        Map<String, dynamic> detalle = {};
                        for (int i = 0; i < vGlobal_transporte.listProductoTraslado.length; i++) {
                          detalle = {
                            '"Id"': i + 1,
                            '"Cantidad"': vGlobal_transporte.listProductoTraslado[i]["nCantidad"],
                            '"UnidadMedida"': '"${vGlobal_transporte.listProductoTraslado[i]["tUnidad"].toString()}"',
                            '"CodigoItem"': '"1"',
                            '"Descripcion"': '"${vGlobal_transporte.listProductoTraslado[i]["tProducto"].toString()}"',
                            '"PrecioUnitario"': '"${vGlobal_transporte.listProductoTraslado[i]["nPrecioUnitario"].toString()}"',
                            '"PrecioReferencial"': '"${vGlobal_transporte.listProductoTraslado[i]["nPrecioUnitario"].toString()}"',
                            '"TipoPrecio"': '"01"',
                            '"TipoImpuesto"': '"20"',
                            '"Impuesto"': 0,
                            '"ImpuestoSelectivo"': 0,
                            '"OtroImpuesto"': 0,
                            '"DescuentoIGV"': 0,
                            '"Descuento"': 0,
                            '"TotalVenta"': '"${vGlobal_transporte.listProductoTraslado[i]["nTotal"].toString()}"',
                            '"Suma"': '"${vGlobal_transporte.listProductoTraslado[i]["nTotal"].toString()}"',
                            '"Observacion"': '"${vGlobal_transporte.listProductoTraslado[i]["tObservacion"].toString()}"',
                            '"PrecioUnit9"': '"${vGlobal_transporte.listProductoTraslado[i]["nTotal"].toString()}"',
                            '"Redondeo"': 0,
                            '"IgvVenta"': 0,
                            '"AplicaIgv"': 0,
                            '"Total"': '"${vGlobal_transporte.listProductoTraslado[i]["nTotal"].toString()}"',
                            '"DescuentoUnidad"': 0,
                            '"CodigoProductoSUNAT"': '""',
                            '"PCBase"': 0,
                            '"PCIgv"': 0,
                            '"PrecioCompra"': 0,
                            '"PCTBase"': 0,
                            '"PCTIgv"': 0,
                            '"PCTotal"': 0,
                            '"aplica_ICBPer"': false,
                            '"Lote"': '""',
                          };
                          listProductoWS.add(detalle);
                        }
                        try {
                          GetInsertWS? postRegWS = await InsertWS2(
                            pFinal,
                            pFinal,
                            Letra,
                            pDescuento,
                            pPorDescuento,
                            tDescripcion,
                            iMCliente.toString(),
                            CClienteDoc.text,
                            CCliente.text,
                            CClienteDir.text,
                            "",
                            'CONTADO',
                            vGlobal_comprobante.documentoSerie,
                            vGlobal_comprobante.documentoNumero,
                            (tipo == 1 ? "03" : "01"),
                            (tipo == 1 ? "0${vGlobal_transporte.ort_remi_tipoDoc.toString()}" : "06"),
                            listProductoWS,
                          );
                          var datagetInsert = jsonEncode(postRegWS);
                          var tJsongetInsert = getInsertWSFromJson(datagetInsert.toString());
                          if (tJsongetInsert.code == 0) {
                            if (tJsongetInsert.data.isNotEmpty) {
                              vGlobal_comprobante.iDComprobante = tJsongetInsert.data[0].comprobanteId;
                              vGlobal_comprobante.linkComprobante = tJsongetInsert.data[0].directorioPdf;
                              vGlobal_comprobante.nombreComprobante = "${tJsongetInsert.data[0].serie}-${tJsongetInsert.data[0].numero}";
                              if (tJsongetInsert.message == "Búsqueda exitosa") {
                                Fluttertoast.showToast(msg: "Generando Comprobante", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                //EasyLoading.show(status: "Generando Comprobante", maskType: EasyLoadingMaskType.black);
                              } else {
                                Fluttertoast.showToast(msg: tJsongetInsert.message, gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                //EasyLoading.show(status: tJsongetInsert.message, maskType: EasyLoadingMaskType.black);
                              }

                              Map<String, dynamic>? postReg = await CodigoOrdenTraslado_Registrar(iMOrden, vGlobal_comprobante.iDComprobante);

                              String savePath = dir.path + "/${vGlobal_comprobante.nombreComprobante}.pdf";
                              try {
                                await Dio().download(vGlobal_comprobante.linkComprobante, savePath, onReceiveProgress: (received, total) {});
                                vGlobal_comprobante.pathComprobante = savePath;
                              } on DioError catch (e) {
                                Fluttertoast.showToast(msg: "No se pudo guardar el Pdf en el equipo", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                              }
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const trans_pedidoPResultado(Origen: "OrdenTraslado")));
                            } else {
                              //EasyLoading.dismiss();
                              Fluttertoast.showToast(msg: tJsongetInsert.message, gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                            }
                          } else {
                            //EasyLoading.dismiss();
                            Fluttertoast.showToast(msg: tJsongetInsert.message, gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                          }
                        } catch (e) {
                          Fluttertoast.showToast(msg: e.toString(), gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                        }
                      } catch (e) {
                        //EasyLoading.dismiss();
                        Fluttertoast.showToast(msg: "Error de Conexión", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                      }
                    } else {
                      vGlobal_comprobante.iDComprobante = 0;
                      vGlobal_comprobante.linkComprobante = "";
                      vGlobal_comprobante.nombreComprobante = "";
                      vGlobal_comprobante.pathComprobante = "";
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const principal()));
                    }
                  } else {
                    //EasyLoading.dismiss();
                    Fluttertoast.showToast(msg: "Error de Conexión", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                  } //else {
                  //   EasyLoading.dismiss();
                  // }
                }
              } else {
                //EasyLoading.dismiss();
                Fluttertoast.showToast(msg: "No se concedió permiso para guardar el Pdf en el equipo", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
              }
              //EasyLoading.dismiss();
            },
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(Size(300, 50)),
              backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )),
            ),
            icon: Icon(Icons.save_rounded, size: 20, color: ClsColor.tipo4()),
            label: Text("Continuar", style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }
}
