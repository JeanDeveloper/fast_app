import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:fast/models/Caja/m_GetCajaDiariaAbiertaUsuario.dart';
import 'package:fast/models/Comprobante/m_GetInsertWS.dart';
import 'package:fast/providers/providers_Caja.dart';
import 'package:fast/providers/providers_Comprobante.dart';
import 'package:fast/providers/providers_Transporte.dart';
import 'package:fast/screens/Caja/s_caja_aperturar.dart';
import 'package:fast/screens/Transporte/s_trans_pedidoResultado.dart';
import 'package:fast/screens/Transporte/s_trans_seleccionarAsiento.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:fast/providers/global_Transporte.dart' as vGlobal_transporte;
import 'package:fast/providers/global_Comprobante.dart' as vGlobal_comprobante;
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class trans_cobrar extends StatefulWidget {
  final String Origen;
  const trans_cobrar({Key? key, required this.Origen}) : super(key: key);
  @override
  _trans_cobrar createState() => new _trans_cobrar();
}

Future<bool> _onWillPop() async {
  return false; //<-- SEE HERE
}

class _trans_cobrar extends State<trans_cobrar> {
  var CEfectivo = TextEditingController(text: vGlobal_transporte.iPrecioFinal.toStringAsFixed(2));
  double ivuelto = 0;
  String tEfectivo = "0";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String nav = "";
    if (widget.Origen == "VentaBoleto") {
      nav = "navtrans_seleccionarAsiento";
    }
    if (widget.Origen == "OrdenTraslado") {
      nav = "navprincipal";
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: ClsDecoration.appBar(context, nav),
        drawer: NavDrawer(),
        backgroundColor: ClsColor.tipo1(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              ClsTextStyle.cabeceraBienvenida(
                titulo: 'FECHA : ${vGlobal_transporte.fecha == "" ? DateFormat('dd/MM/yyyy').format(DateTime.now()).toString() : vGlobal_transporte.fecha}',
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const caja_aperturar()));
                        },
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(const Size(100, 40)),
                            backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)))),
                        icon: Icon(Icons.check, size: 14.0, color: ClsColor.tipo4()),
                        label: Text('Si', style: TextStyle(color: ClsColor.tipo4(), fontSize: 14))),
                  ),
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
            child: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Importe a Pagar', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                        Text('S/ ${vGlobal_transporte.iPrecioFinal.toStringAsFixed(2)}', style: TextStyle(color: ClsColor.tipo6(), fontSize: 36, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text('Efectivo', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                    ),
                    TextFormField(
                      controller: CEfectivo,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        isDense: true,
                        fillColor: ClsColor.tipo4(),
                        enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        disabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo11(), width: 2)),
                        prefix: const Text(" S/ "),
                      ),
                      onChanged: (value) {
                        if (CEfectivo.text == "" || CEfectivo.text == null) {
                          tEfectivo = "0";
                        } else {
                          tEfectivo = value;
                        }
                        setState(() {
                          ivuelto = double.parse(tEfectivo) - vGlobal_transporte.iPrecioFinal;
                        });
                        //updateText(tDescuento, aplica);
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Vuelto', style: TextStyle(color: ClsColor.tipo6(), fontSize: 20, fontWeight: FontWeight.w400)),
                        Text('S/ ${ivuelto.toStringAsFixed(2)}', style: TextStyle(color: ClsColor.tipo1(), fontSize: 36, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => trans_seleccionarAsiento(),
                ),
              );
            },
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(300, 50)),
              backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo4()),
              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )),
            ),
            icon: Icon(Icons.chevron_left_rounded, size: 20, color: ClsColor.tipo1()),
            label: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Salir de la Operación", style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () async {
              ClsDecoration.showDialogLoading(context);
              if (ivuelto < 0) {
                Fluttertoast.showToast(msg: "Ingrese monto igual o superior al importe", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                Navigator.of(context).pop();
                return;
              }
              Fluttertoast.showToast(msg: "Registrando..", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
              Map<Permission, PermissionStatus> statuses = await [
                Permission.storage,
              ].request();

              Map<Permission, PermissionStatus> statuspack = await [
                Permission.requestInstallPackages,
              ].request();
              // Map<Permission, PermissionStatus> statuswin = await [
              //   Permission.systemAlertWindow,
              // ].request();
              // Map<Permission, PermissionStatus> statusren = await [
              //   Permission.reminders,
              // ].request();
              // Map<Permission, PermissionStatus> statusnot = await [
              //   Permission.accessNotificationPolicy,
              // ].request();
              // Map<Permission, PermissionStatus> statusunk = await [
              //   Permission.unknown,
              // ].request();

              final androidInfo = await DeviceInfoPlugin().androidInfo;
              final sdkInt = androidInfo.version.sdkInt;

              print(androidInfo.version.sdkInt);
              if ((statuses[Permission.storage]!.isGranted || androidInfo.version.sdkInt! >= 33) && statuspack[Permission.requestInstallPackages]!.isGranted /*&& statuswin[Permission.systemAlertWindow]!.isGranted*/) {
                var dir = await DownloadsPathProvider.downloadsDirectory;
                // String dir = (await getApplicationDocumentsDirectory()).path;
                vGlobal_transporte.tTipoComprobante = vGlobal_transporte.TipoComprobante!;
                if (dir != null) {
                  final GetCajaDiariaAbiertaUsuario? postlog = await getCajaDiariaAbierta();
                  var dataCaja = jsonEncode(postlog);
                  var tJsonCaja = getCajaDiariaAbiertaUsuarioFromJson(dataCaja.toString());
                  if (tJsonCaja.data.isNotEmpty) {
                    vGlobal_transporte.iDCajaDiaria = tJsonCaja.data[0].iDCajaDiaria;
                    vGlobal_transporte.iMCaja = tJsonCaja.data[0].iMCaja;
                    vGlobal_transporte.iMoneda = tJsonCaja.data[0].iMoneda;
                    var codigo;
                    var mensaje;
                    var iMVentaTransporte;
                    if (vGlobal_transporte.TipoAcceso == "Nuevo") {
                      Map<String, dynamic>? postReg = await VentasBoletoRegistrar(
                        vGlobal_transporte.iMCliente!,
                        vGlobal_transporte.CClienteDoc!,
                        vGlobal_transporte.CCliente!,
                        vGlobal_transporte.CClienteDir!,
                        vGlobal_transporte.iMPasajero!,
                        vGlobal_transporte.tPasajeroTipoDoc!,
                        vGlobal_transporte.CPasajeroDoc!,
                        vGlobal_transporte.CPasajero!,
                        vGlobal_transporte.TipoComprobante!,
                        vGlobal_transporte.descuento!,
                        vGlobal_transporte.aplica!,
                      );
                      codigo = postReg?["codigo"].toString();
                      mensaje = postReg?["mensaje"];
                      iMVentaTransporte = postReg?["iMVentaTransporte"];
                    }
                    if (vGlobal_transporte.TipoAcceso == "Reserva") {
                      Map<String, dynamic>? postReg = await VentasReservaRegistrar(
                        vGlobal_transporte.iMCliente!,
                        vGlobal_transporte.CClienteDoc!,
                        vGlobal_transporte.CCliente!,
                        vGlobal_transporte.CClienteDir!,
                        vGlobal_transporte.iMPasajero!,
                        vGlobal_transporte.tPasajeroTipoDoc!,
                        vGlobal_transporte.CPasajeroDoc!,
                        vGlobal_transporte.CPasajero!,
                        vGlobal_transporte.TipoComprobante!,
                        vGlobal_transporte.descuento!,
                        vGlobal_transporte.aplica!,
                      );
                      codigo = postReg?["codigo"].toString();
                      mensaje = postReg?["mensaje"];
                    }

                    Fluttertoast.showToast(msg: mensaje ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                    if (codigo == "0") {
                      try {
                        GetInsertWS? postRegWS = await InsertWS(
                          vGlobal_transporte.pInicial!,
                          vGlobal_transporte.pFinal!,
                          vGlobal_transporte.Letra!,
                          vGlobal_transporte.pDescuento!,
                          vGlobal_transporte.pPorDescuento!,
                          vGlobal_transporte.tDescripcion!,
                          vGlobal_transporte.iMCliente.toString(),
                          vGlobal_transporte.CClienteDoc!,
                          vGlobal_transporte.CCliente!,
                          vGlobal_transporte.CClienteDir!,
                          vGlobal_transporte.PlacaVehiculo ?? "",
                          vGlobal_transporte.ModalidaPago!,
                          vGlobal_transporte.tSerie!,
                          vGlobal_transporte.tNumeracion!,
                          vGlobal_transporte.iTipoFac!,
                          vGlobal_transporte.tTipoDocCliente!,
                          vGlobal_transporte.tCiudadOrigen,
                          vGlobal_transporte.tCiudadDestino,
                          vGlobal_transporte.CPasajero!,
                          vGlobal_transporte.CPasajeroDoc!,
                          vGlobal_transporte.fecha,
                          vGlobal_transporte.hora,
                          vGlobal_transporte.iAsiento,
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
                            } else {
                              Fluttertoast.showToast(msg: tJsongetInsert.message, gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                            }

                            Map<String, dynamic>? postReg = await CodigoVentasTransporte_Registrar(iMVentaTransporte, vGlobal_comprobante.iDComprobante);

                            String savePath = dir.path + "/${vGlobal_comprobante.nombreComprobante}.pdf";
                            try {
                              // await Dio().download(vGlobal_comprobante.linkComprobante, savePath);
                              // String dir = (await getApplicationDocumentsDirectory()).path;

                              // if (await File(savePath).exists()) {
                              //   File(savePath);
                              // }
                              // String url = vGlobal_comprobante.linkComprobante;
                              // var request = await HttpClient().getUrl(Uri.parse(url));
                              // var response = await request.close();
                              // var bytes = await consolidateHttpClientResponseBytes(response);
                              // File file = File(savePath);

                              final File? file = await FileDownloader.downloadFile(url: vGlobal_comprobante.linkComprobante, name: "${vGlobal_comprobante.nombreComprobante}.pdf");

                              vGlobal_comprobante.pathComprobante = file!.path;
                            } on DioError catch (e) {
                              Fluttertoast.showToast(msg: "No se pudo guardar el Pdf en el equipo", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                            }
                            Map<String, dynamic>? postcaja = await PostCajaDiariaDetalleRegistrar(
                              vGlobal_transporte.iDCajaDiaria,
                              1,
                              "VENTA DE BOLETO",
                              "Asiento: ${vGlobal_transporte.iAsiento} - ${vGlobal_transporte.fecha} ${vGlobal_transporte.hora}",
                              vGlobal_transporte.iMoneda,
                              vGlobal_transporte.iPrecioFinal,
                              vGlobal_transporte.iPrecioFinal,
                              vGlobal_transporte.Letra!,
                              vGlobal_transporte.iMCliente.toString(),
                              vGlobal_comprobante.iDComprobante,
                            );
                            var codigo = postcaja?["codigo"].toString();
                            var mensaje = postcaja?["mensaje"];

                            Fluttertoast.showToast(msg: mensaje ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                            Navigator.of(context).pop();
                            if (codigo == "0") {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const trans_pedidoPResultado(Origen: "VentaBoleto")));
                            }
                          } else {
                            Fluttertoast.showToast(msg: tJsongetInsert.message, gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                            Navigator.of(context).pop();
                          }
                        } else {
                          Fluttertoast.showToast(msg: tJsongetInsert.message, gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                          Navigator.of(context).pop();
                        }
                      } catch (e) {
                        Fluttertoast.showToast(msg: "Error de Conexión", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                        Navigator.of(context).pop();
                      }
                    } else {
                      Fluttertoast.showToast(msg: "Error de Conexión", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                      Navigator.of(context).pop();
                    }
                  } else {
                    Fluttertoast.showToast(msg: "No cuenta con una caja abierta", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                    Navigator.of(context).pop();
                    _modalBottom();
                  }
                }
              } else {
                Fluttertoast.showToast(msg: "No se concedió permiso para guardar el Pdf en el equipo", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                Navigator.of(context).pop();
              }
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
            label: Text("Generar Comprobante", style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }
}
