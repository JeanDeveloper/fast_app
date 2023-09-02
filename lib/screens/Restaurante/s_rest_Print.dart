import 'dart:convert';
// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:fast/models/Restaurante/m_GetOrdenMesa.dart';
import 'package:fast/providers/providers_Restaurante.dart';
import 'package:fast/screens/Restaurante/s_rest_consumo.dart';
import 'package:fast/screens/Home/s_principal.dart';
import 'package:fast/screens/Restaurante/s_rest_mesaSeleccionar.dart';
import 'package:fast/screens/Transporte/s_trans_resultado.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fast/providers/global_Transporte.dart' as vGlobal_transporte;
import 'package:fast/providers/global_Comprobante.dart' as vGlobal_comprobante;
import 'package:fast/providers/global_Restaurante.dart' as vGlobal_Restaurante;
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:fast/providers/global.dart' as vGlobal;
import 'dart:async';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:intl/intl.dart';

class Print extends StatefulWidget {
  final String title;
  final String tMacImpresora;
  List<Map<String, dynamic>>? listPrecuentatemp = [];
  Print({Key? key, required this.title, required this.tMacImpresora, required this.listPrecuentatemp}) : super(key: key);

  @override
  _PrintState createState() => _PrintState();
}

class _PrintState extends State<Print> {
  // PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  // List<PrinterBluetooth> _devices = [];

  @override
  void initState() {
    super.initState();

    // printerManager.scanResults.listen((devices) async {
    //   // print('UI: Devices found ${devices.length}');
    //   await Permission.bluetooth.request();
    //   await Permission.bluetoothConnect.request();
    //   await Permission.bluetoothScan.request();
    //   await Permission.bluetoothAdvertise.request();
    //   setState(() {
    //     _devices = devices;
    //     // _devices.removeWhere((element) => element.address!.contains("DC:0D:30:18:41:65"));
    //   });
    // });
  }

  // void _startScanDevices() {
  //   setState(() {
  //     _devices = [];
  //   });
  //   printerManager.startScan(Duration(seconds: 3));
  // }

  // void _stopScanDevices() {
  //   printerManager.stopScan();
  // }

  // Future<List<int>> demoReceipt(PaperSize paper, CapabilityProfile profile) async {
  //   final Generator ticket = Generator(paper, profile);
  //   List<int> bytes = [];
  //   DateTime now = DateTime.now();
  //   String formattedDate = DateFormat('dd/MM/yyyy hh:mm aaa').format(now);
  //   bytes += ticket.text(vGlobal.tEmpresa.toString(), styles: const PosStyles(bold: false, align: PosAlign.center, height: PosTextSize.size2, width: PosTextSize.size2));
  //   bytes += ticket.hr();
  //   bytes += ticket.text(vGlobal.tEmpresaRuc.toString(), styles: const PosStyles(bold: true, align: PosAlign.center));
  //   bytes += ticket.hr();
  //   if (widget.title == "TRANSPORTE") {
  //     bytes += ticket.hr(ch: '-', linesAfter: 1);
  //     bytes += ticket.text("${vGlobal_transporte.tTipoComprobante} ELECTRONICA", styles: const PosStyles(bold: true, align: PosAlign.center), linesAfter: 1);
  //     bytes += ticket.text("${vGlobal_comprobante.documentoSerie}-${vGlobal_comprobante.documentoNumero}", styles: const PosStyles(bold: true, align: PosAlign.center), linesAfter: 1);
  //     bytes += ticket.hr(ch: '-', linesAfter: 1);
  //     bytes += ticket.row([
  //       PosColumn(text: 'SEÑOR(A)', styles: const PosStyles(bold: false, align: PosAlign.left), width: 3),
  //       PosColumn(text: ": ${vGlobal_transporte.tPasajero}", styles: const PosStyles(bold: false, align: PosAlign.left), width: 9),
  //     ]);
  //     bytes += ticket.row([
  //       PosColumn(text: 'DNI', styles: const PosStyles(bold: false, align: PosAlign.left), width: 3),
  //       PosColumn(text: ": ${vGlobal_transporte.tPasajeroDoc}", styles: const PosStyles(bold: false, align: PosAlign.left), width: 9),
  //     ]);
  //     bytes += ticket.row([
  //       PosColumn(text: 'DIREC.', styles: const PosStyles(bold: false, align: PosAlign.left), width: 3),
  //       PosColumn(text: ": ", styles: const PosStyles(bold: false, align: PosAlign.left), width: 9),
  //     ]);
  //     bytes += ticket.row([
  //       PosColumn(text: 'PROCED.', styles: const PosStyles(bold: false, align: PosAlign.left), width: 3),
  //       PosColumn(text: ": ${vGlobal_transporte.ruta.split(' - ')[0]}", styles: const PosStyles(bold: false, align: PosAlign.left), width: 9),
  //     ]);
  //     bytes += ticket.row([
  //       PosColumn(text: 'DESTINO', styles: const PosStyles(bold: false, align: PosAlign.left), width: 3),
  //       PosColumn(text: ": ${vGlobal_transporte.ruta.split(' - ')[1]}", styles: const PosStyles(bold: false, align: PosAlign.left), width: 9),
  //     ]);
  //     bytes += ticket.row([
  //       PosColumn(text: 'CONSIGN.', styles: const PosStyles(bold: false, align: PosAlign.left), width: 3),
  //       PosColumn(text: ": ", styles: const PosStyles(bold: false, align: PosAlign.left), width: 9),
  //     ]);
  //     bytes += ticket.hr(ch: '-', linesAfter: 1);
  //     bytes += ticket.row([
  //       PosColumn(text: 'CNT', styles: const PosStyles(bold: true, align: PosAlign.center), width: 2),
  //       PosColumn(text: "U.M", styles: const PosStyles(bold: true, align: PosAlign.center), width: 2),
  //       PosColumn(text: "DESCRIPCIÓN", styles: const PosStyles(bold: true, align: PosAlign.center), width: 5),
  //       PosColumn(text: "TOTAL", styles: const PosStyles(bold: true, align: PosAlign.center), width: 3),
  //     ]);
  //     bytes += ticket.hr(ch: '-', linesAfter: 1);
  //     bytes += ticket.row([
  //       PosColumn(text: '1', styles: const PosStyles(bold: true, align: PosAlign.center), width: 2),
  //       PosColumn(text: "UND", styles: const PosStyles(bold: true, align: PosAlign.center), width: 2),
  //       PosColumn(text: "${vGlobal_transporte.descripcion}", styles: const PosStyles(bold: true, align: PosAlign.center), width: 5),
  //       PosColumn(text: "S/ ${vGlobal_transporte.iPrecioFinal.toStringAsFixed(2)}", styles: const PosStyles(bold: true, align: PosAlign.center), width: 3),
  //     ]);
  //     bytes += ticket.hr(ch: '-', linesAfter: 1);
  //     bytes += ticket.row([
  //       PosColumn(text: '', styles: const PosStyles(bold: true, align: PosAlign.center), width: 2),
  //       PosColumn(text: "", styles: const PosStyles(bold: true, align: PosAlign.center), width: 2),
  //       PosColumn(text: "Op. No Gravada : S/", styles: const PosStyles(bold: true, align: PosAlign.center), width: 5),
  //       PosColumn(text: "", styles: const PosStyles(bold: true, align: PosAlign.center), width: 3),
  //     ]);
  //     bytes += ticket.row([
  //       PosColumn(text: '', styles: const PosStyles(bold: true, align: PosAlign.center), width: 2),
  //       PosColumn(text: "", styles: const PosStyles(bold: true, align: PosAlign.center), width: 2),
  //       PosColumn(text: "Op. Gravada : S/", styles: const PosStyles(bold: true, align: PosAlign.center), width: 5),
  //       PosColumn(text: "0.00", styles: const PosStyles(bold: true, align: PosAlign.center), width: 3),
  //     ]);
  //     bytes += ticket.row([
  //       PosColumn(text: '', styles: const PosStyles(bold: true, align: PosAlign.center), width: 2),
  //       PosColumn(text: "", styles: const PosStyles(bold: true, align: PosAlign.center), width: 2),
  //       PosColumn(text: "TOTAL IGV : S/", styles: const PosStyles(bold: true, align: PosAlign.center), width: 5),
  //       PosColumn(text: "0.00", styles: const PosStyles(bold: true, align: PosAlign.center), width: 3),
  //     ]);
  //     bytes += ticket.row([
  //       PosColumn(text: '', styles: const PosStyles(bold: true, align: PosAlign.center), width: 2),
  //       PosColumn(text: "", styles: const PosStyles(bold: true, align: PosAlign.center), width: 2),
  //       PosColumn(text: "IMPORTE TOTAL : S/", styles: const PosStyles(bold: true, align: PosAlign.center), width: 5),
  //       PosColumn(text: "S/ ${vGlobal_transporte.iPrecioFinal.toStringAsFixed(2)}", styles: const PosStyles(bold: true, align: PosAlign.center), width: 3),
  //     ]);
  //     bytes += ticket.hr();
  //     bytes += ticket.hr(ch: '-', linesAfter: 1);
  //     bytes += ticket.text("SON: ${vGlobal_transporte.letra}", styles: const PosStyles(bold: true, align: PosAlign.left), linesAfter: 1);
  //     bytes += ticket.hr(ch: '-', linesAfter: 1);
  //     bytes += ticket.text("FECHA EMISION : ${DateFormat('dd/MM/yyyy').format(now)}", styles: const PosStyles(bold: true, align: PosAlign.left), linesAfter: 1);
  //     bytes += ticket.text("VENDEDOR:", styles: const PosStyles(bold: true, align: PosAlign.left), linesAfter: 1);
  //     bytes += ticket.text("HORA IMPRESION: ${DateFormat('hh:mm aaa').format(now)}", styles: const PosStyles(bold: true, align: PosAlign.left), linesAfter: 1);
  //     bytes += ticket.hr(ch: '-', linesAfter: 1);
  //     bytes += ticket.text(
  //         "La empresa no responde de pérdidas de encomiendas o todo bulto que contenga dinero, alhajas y otros objetos que no hubiera sido declarados y recogidos hasta 8 días, no respondemos por encomiendas susceptibles a malograrse pasado las 24 horas",
  //         styles: const PosStyles(bold: true, align: PosAlign.center),
  //         linesAfter: 1);
  //     bytes += ticket.hr();
  //     bytes += ticket.text("Representación impresa del Comprobante Electrónico, puede ser consultada en app.sistemafast.pe", styles: const PosStyles(bold: true, align: PosAlign.center), linesAfter: 9);
  //   }
  //   if (widget.title == "PRUEBA") {
  //     bytes += ticket.text("${widget.title} DE IMPRESION", styles: const PosStyles(bold: true, align: PosAlign.center), linesAfter: 9);
  //   }
  //   if (widget.title == "PEDIDO") {
  //     bytes += ticket.text(widget.title, styles: const PosStyles(bold: true, align: PosAlign.center));
  //     bytes += ticket.hr();
  //     bytes += ticket.row([
  //       PosColumn(text: 'MESA', styles: const PosStyles(bold: false, align: PosAlign.left), width: 3),
  //       PosColumn(text: ": ${vGlobal_Restaurante.tMesa}", styles: const PosStyles(bold: false, align: PosAlign.left), width: 9),
  //     ]);
  //     bytes += ticket.row([
  //       PosColumn(text: 'MOZO', styles: const PosStyles(bold: false, align: PosAlign.left), width: 3),
  //       PosColumn(text: ": ${vGlobal.tUsuario}", styles: const PosStyles(bold: false, align: PosAlign.left), width: 9),
  //     ]);
  //     bytes += ticket.row([
  //       PosColumn(text: 'CANAL', styles: const PosStyles(bold: false, align: PosAlign.left), width: 3),
  //       PosColumn(text: ": ${widget.listPrecuentatemp[0]["iTipoConsumo"] == 1 ? "CONSUMO EN MESA" : "PARA LLEVAR"}", styles: const PosStyles(bold: false, align: PosAlign.left), width: 9),
  //     ]);
  //     bytes += ticket.row([
  //       PosColumn(text: 'HORA', styles: const PosStyles(bold: false, align: PosAlign.left), width: 3),
  //       PosColumn(text: ": $formattedDate", styles: const PosStyles(bold: false, align: PosAlign.left), width: 9),
  //     ]);
  //     bytes += ticket.hr();
  //     bytes += ticket.row([
  //       PosColumn(text: 'DESCRIPCION', styles: const PosStyles(bold: true, align: PosAlign.center), width: 10),
  //       PosColumn(text: "CNT", styles: const PosStyles(bold: true, align: PosAlign.center), width: 2),
  //     ]);
  //     bytes += ticket.hr();
  //     for (int i = 0; i < widget.listPrecuentatemp.length; i++) {
  //       bytes += ticket.row([
  //         PosColumn(text: widget.listPrecuentatemp[i]["tProducto"].toString(), styles: const PosStyles(bold: true, align: PosAlign.left), width: 10),
  //         PosColumn(text: widget.listPrecuentatemp[i]["nCantidad"].toString(), styles: const PosStyles(bold: false, align: PosAlign.center), width: 2)
  //       ]);
  //       bytes += ticket.row([
  //         PosColumn(text: widget.listPrecuentatemp[i]["tObservacion"].toString(), styles: const PosStyles(bold: false, align: PosAlign.left), width: 10),
  //         PosColumn(text: "", styles: const PosStyles(bold: false, align: PosAlign.center), width: 2)
  //       ]);
  //     }
  //     bytes += ticket.hr();
  //     bytes += ticket.text("", styles: const PosStyles(align: PosAlign.center), linesAfter: 8);
  //   }
  //   if (widget.title == "PRECUENTA") {
  //     bytes += ticket.text(widget.title, styles: const PosStyles(bold: true, align: PosAlign.center));
  //     bytes += ticket.hr();
  //     bytes += ticket.row([
  //       PosColumn(text: 'SEÑOR(A)', styles: const PosStyles(bold: false, align: PosAlign.left), width: 3),
  //       PosColumn(text: ": ${vGlobal_Restaurante.tCliente}", styles: const PosStyles(bold: false, align: PosAlign.left), width: 9),
  //     ]);
  //     bytes += ticket.row([
  //       PosColumn(text: 'MESA', styles: const PosStyles(bold: false, align: PosAlign.left), width: 3),
  //       PosColumn(text: ": ${vGlobal_Restaurante.tMesa}", styles: const PosStyles(bold: false, align: PosAlign.left), width: 9),
  //     ]);
  //     bytes += ticket.hr();
  //     bytes += ticket.row([
  //       PosColumn(text: 'DESCRIPCION', styles: const PosStyles(bold: true, align: PosAlign.center), width: 8),
  //       PosColumn(text: "CNT", styles: const PosStyles(bold: true, align: PosAlign.center), width: 2),
  //       PosColumn(text: "TOTAL", styles: const PosStyles(bold: true, align: PosAlign.center), width: 2),
  //     ]);
  //     bytes += ticket.hr();
  //     final MGetOrdenMesa? Postlog = await getOrdenMesa;
  //     var dataPrecuenta = jsonEncode(Postlog);
  //     var tJsonPrecuenta = mGetOrdenMesaFromJson(dataPrecuenta.toString());
  //     double iSuma = 0.00;
  //     for (int i = 0; i < tJsonPrecuenta.data.length; i++) {
  //       iSuma += tJsonPrecuenta.data[i].nTotal!;
  //       bytes += ticket.row([
  //         PosColumn(text: tJsonPrecuenta.data[i].tProducto.toString(), styles: const PosStyles(bold: true, align: PosAlign.left), width: 8),
  //         PosColumn(text: tJsonPrecuenta.data[i].nCantidad.toString(), styles: const PosStyles(bold: false, align: PosAlign.center), width: 2),
  //         PosColumn(text: tJsonPrecuenta.data[i].nTotal.toString(), styles: const PosStyles(bold: false, align: PosAlign.right), width: 2),
  //       ]);
  //       bytes += ticket.row([
  //         PosColumn(text: tJsonPrecuenta.data[i].tObservacion.toString(), styles: const PosStyles(bold: false, align: PosAlign.left), width: 10),
  //         PosColumn(text: "", styles: const PosStyles(bold: false, align: PosAlign.center), width: 2)
  //       ]);
  //     }
  //     bytes += ticket.hr();
  //     bytes += ticket.row([
  //       PosColumn(text: formattedDate.toString(), styles: const PosStyles(bold: true, align: PosAlign.left), width: 6),
  //       PosColumn(text: "Total: S/", styles: const PosStyles(bold: false, align: PosAlign.center), width: 3),
  //       PosColumn(text: iSuma.toStringAsFixed(2).toString(), styles: const PosStyles(bold: false, align: PosAlign.right), width: 3),
  //     ]);
  //     bytes += ticket.text("", styles: const PosStyles(bold: true, align: PosAlign.left), linesAfter: 1);
  //     bytes += ticket.hr();
  //     bytes += ticket.text("RUC/DNI", styles: const PosStyles(bold: true, align: PosAlign.left), linesAfter: 1);
  //     bytes += ticket.hr();
  //     bytes += ticket.text("RAZÓN SOCIAL", styles: const PosStyles(bold: true, align: PosAlign.left), linesAfter: 1);
  //     bytes += ticket.hr();
  //     bytes += ticket.text("DIRECCIÓN", styles: const PosStyles(bold: true, align: PosAlign.left), linesAfter: 1);
  //     bytes += ticket.hr();
  //     bytes += ticket.text("", styles: const PosStyles(bold: true, align: PosAlign.left), linesAfter: 2);
  //     bytes += ticket.hr();
  //     bytes += ticket.text("CORREO", styles: const PosStyles(bold: true, align: PosAlign.left), linesAfter: 1);
  //     bytes += ticket.hr();
  //     bytes += ticket.text("", styles: const PosStyles(bold: true, align: PosAlign.left), linesAfter: 1);
  //     bytes += ticket.text("AGRADECEMOS TU PREFERENCIA", styles: const PosStyles(bold: false, align: PosAlign.center));
  //     bytes += ticket.text("VUELVA PRONTO", styles: const PosStyles(bold: false, align: PosAlign.center), linesAfter: 8);
  //   }
  //   if (widget.title == "COMANDA DE ANULACION" || widget.title == "COMANDA DE ANULACION.") {
  //     bytes += ticket.text(widget.title, styles: const PosStyles(bold: true, align: PosAlign.center));
  //     bytes += ticket.hr();
  //     bytes += ticket.row([
  //       PosColumn(text: 'MESA', styles: const PosStyles(bold: false, align: PosAlign.left), width: 3),
  //       PosColumn(text: ": ${vGlobal_Restaurante.tMesa}", styles: const PosStyles(bold: false, align: PosAlign.left), width: 9),
  //     ]);
  //     bytes += ticket.row([
  //       PosColumn(text: 'MOZO', styles: const PosStyles(bold: false, align: PosAlign.left), width: 3),
  //       PosColumn(text: ": ${vGlobal.tUsuario}", styles: const PosStyles(bold: false, align: PosAlign.left), width: 9),
  //     ]);
  //     bytes += ticket.row([
  //       PosColumn(text: 'CANAL', styles: const PosStyles(bold: false, align: PosAlign.left), width: 3),
  //       PosColumn(text: ": ${vGlobal_Restaurante.tAnulacionCanal == 1 ? "CONSUMO EN MESA" : "PARA LLEVAR"}", styles: const PosStyles(bold: false, align: PosAlign.left), width: 9),
  //     ]);
  //     bytes += ticket.row([
  //       PosColumn(text: 'HORA', styles: const PosStyles(bold: false, align: PosAlign.left), width: 3),
  //       PosColumn(text: ": $formattedDate", styles: const PosStyles(bold: false, align: PosAlign.left), width: 9),
  //     ]);
  //     bytes += ticket.hr();
  //     bytes += ticket.row([
  //       PosColumn(text: 'DESCRIPCION', styles: const PosStyles(bold: true, align: PosAlign.center), width: 10),
  //       PosColumn(text: "CNT", styles: const PosStyles(bold: true, align: PosAlign.center), width: 2),
  //     ]);
  //     bytes += ticket.hr();
  //     bytes += ticket.row([
  //       PosColumn(text: vGlobal_Restaurante.tAnulacionProducto.toString(), styles: const PosStyles(bold: true, align: PosAlign.left), width: 10),
  //       PosColumn(text: vGlobal_Restaurante.tAnulacionCantidad.toString(), styles: const PosStyles(bold: false, align: PosAlign.center), width: 2)
  //     ]);
  //     bytes += ticket.row([
  //       PosColumn(text: vGlobal_Restaurante.tAnulacionObservacion.toString(), styles: const PosStyles(bold: false, align: PosAlign.left), width: 10),
  //       PosColumn(text: "", styles: const PosStyles(bold: false, align: PosAlign.center), width: 2)
  //     ]);
  //     bytes += ticket.hr();
  //     bytes += ticket.text("MOTIVO", styles: const PosStyles(bold: false, align: PosAlign.left));
  //     bytes += ticket.text("NO DESEA PEDIDO", styles: const PosStyles(bold: true, align: PosAlign.center), linesAfter: 8);
  //   }
  //   ticket.feed(9);
  //   ticket.cut();
  //   return bytes;
  // }

  // void _testPrint(PrinterBluetooth printer) async {
  //   // try {
  //   printerManager.selectPrinter(printer);
  //   const PaperSize paper = PaperSize.mm58;
  //   final profile = await CapabilityProfile.load();
  //   final PosPrintResult res = await printerManager.printTicket((await demoReceipt(paper, profile)));
  //   Fluttertoast.showToast(msg: res.msg, gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());

  //   if (res.msg == "Exito") {
  //     if (widget.title == "PRUEBA") {
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => principal()));
  //     }
  //     if (widget.title == "PRECUENTA") {
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => consumo()));
  //     }
  //     if (widget.title == "PEDIDO") {
  //       widget.listPrecuentatemp = [];
  //       vGlobal_Restaurante.listPrecuenta = [];
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => consumo()));
  //     }
  //     if (widget.title == "COMANDA DE ANULACION") {
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => consumo()));
  //     }
  //     if (widget.title == "COMANDA DE ANULACION.") {
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => mesaSeleccionar()));
  //     }
  //     if (widget.title == "TRANSPORTE") {
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => trans_resultadoBoleto()));
  //     }
  //   }
  // }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.tMacImpresora != "") {
    //   _devices.removeWhere((element) => !element.address!.contains(widget.tMacImpresora));
    // }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ClsColor.tipo1(),
          title: Transform(
            transform: Matrix4.translationValues(0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_circle_left_rounded,
                    size: 25,
                    color: ClsColor.tipo4(),
                  ),
                  onPressed: () {
                    widget.listPrecuentatemp = [];
                    vGlobal_Restaurante.listPrecuenta = [];
                    if (widget.title == "PRUEBA") {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => principal()));
                    }
                    if (widget.title == "PRECUENTA") {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => consumo()));
                    }
                    if (widget.title == "PEDIDO") {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => consumo()));
                    }
                    if (widget.title == "COMANDA DE ANULACION") {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => consumo()));
                    }
                    if (widget.title == "COMANDA DE ANULACION.") {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => mesaSeleccionar()));
                    }
                    if (widget.title == "TRANSPORTE") {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => trans_resultadoBoleto()));
                    }
                  },
                ),
              ],
            ),
          ),
          elevation: 0,
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform(
                  transform: Matrix4.translationValues(-150, 0.0, 0.0),
                  child: Text(
                    "IMPRESION",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.fade,
                      fontWeight: FontWeight.w700,
                      color: ClsColor.tipo4(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // body: ListView.builder(
        //     itemCount: _devices.length,
        //     itemBuilder: (BuildContext context, int index) {
        //       return InkWell(
        //         onTap: () => _testPrint(_devices[index]),
        //         child: Column(
        //           children: <Widget>[
        //             Container(
        //               height: 85,
        //               padding: EdgeInsets.only(left: 10),
        //               alignment: Alignment.centerLeft,
        //               child: Row(
        //                 children: <Widget>[
        //                   Icon(Icons.print),
        //                   SizedBox(width: 10),
        //                   Expanded(
        //                     child: Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       mainAxisAlignment: MainAxisAlignment.center,
        //                       children: <Widget>[
        //                         Text(
        //                           (_devices[index].name ?? ''),
        //                           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        //                         ),
        //                         Text(_devices[index].address!),
        //                         Text('Click para imprimir ticket', style: TextStyle(color: Colors.grey[700])),
        //                       ],
        //                     ),
        //                   )
        //                 ],
        //               ),
        //             ),
        //             Divider(),
        //           ],
        //         ),
        //       );
        //     }),
        // floatingActionButton: StreamBuilder<bool>(
        //   stream: printerManager.isScanningStream,
        //   initialData: false,
        //   builder: (c, snapshot) {
        //     if (snapshot.data!) {
        //       return FloatingActionButton(child: Icon(Icons.stop), onPressed: _stopScanDevices, backgroundColor: Colors.red);
        //     } else {
        //       return FloatingActionButton(child: Icon(Icons.search), onPressed: _startScanDevices, backgroundColor: ClsColor.tipo1());
        //     }
        //   },
        // ),
      ),
    );
  }
}
