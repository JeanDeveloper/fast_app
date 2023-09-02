import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:fast/models/Comprobante/m_GetComprobanteSendMail.dart';
import 'package:fast/models/Transporte/m_GetObtenerDatosBoleto.dart';
import 'package:fast/providers/providers_Comprobante.dart';
import 'package:fast/providers/providers_Transporte.dart';
import 'package:fast/screens/Transporte/s_trans_seleccionarAsiento.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:fast/providers/global_Transporte.dart' as vGlobal_transporte;
import 'package:fast/providers/global_Comprobante.dart' as vGlobal_comprobante;
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

class trans_anularComprobante extends StatefulWidget {
  final String Origen;
  const trans_anularComprobante({Key? key, required this.Origen}) : super(key: key);
  @override
  _trans_anularComprobante createState() => new _trans_anularComprobante();
}

Future<bool> _onWillPop() async {
  return false; //<-- SEE HERE
}

class _trans_anularComprobante extends State<trans_anularComprobante> {
  var CFecha = TextEditingController(text: "${vGlobal_transporte.fecha} ${vGlobal_transporte.hora}");
  var CPasajero = TextEditingController(text: vGlobal_transporte.tPasajero);
  var CAsiento = TextEditingController(text: "Nivel: ${vGlobal_transporte.iNivel} - Asiento: ${vGlobal_transporte.iAsiento}");

  var CRemitente = TextEditingController(text: vGlobal_transporte.ort_remi);
  var CConsignado = TextEditingController(text: vGlobal_transporte.ort_cons);

  var CCorreo = TextEditingController();
  var CMensaje = TextEditingController();
  var CMotivo = TextEditingController();

  String tRuta = "";

  String tDescuento = "0";
  bool aplica = false;
  bool iEstadoDescuento = true;
  var CTelefono = TextEditingController(text: "");
  var CCodigoPais = TextEditingController(text: "51");
  int tipo = 1;

  @override
  void initState() {
    super.initState();
    LoadDatosBoleto();
  }

  LoadDatosBoleto() async {
    final GetObtenerDatosBoleto? Postlog = await getDatosBoleto();
    var dataData = jsonEncode(Postlog);
    var tJsonData = getObtenerDatosBoletoFromJson(dataData.toString());
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
      String savePath = "";
      if (tJsonData.code == 0) {
        setState(() {
          CPasajero.text = tJsonData.data[0].tPasajero.toString();
          CAsiento.text = "Nivel: ${vGlobal_transporte.iNivel} - Asiento: ${vGlobal_transporte.iAsiento}";
          CFecha.text = "${tJsonData.data[0].tFechaViaje} ${tJsonData.data[0].tHoraViaje}";

          vGlobal_comprobante.iDComprobante = tJsonData.data[0].iMCodigoVenta;
          vGlobal_comprobante.linkComprobante = tJsonData.data[0].tUbicacionPdf;
          vGlobal_comprobante.nombreComprobante = "${tJsonData.data[0].tSerie}-${tJsonData.data[0].tNumero}";
          savePath = "${dir!.path}/${vGlobal_comprobante.nombreComprobante}.pdf";
          tRuta = tJsonData.data[0].tRuta;
        });
        try {
          final File? file = await FileDownloader.downloadFile(url: vGlobal_comprobante.linkComprobante, name: "${vGlobal_comprobante.nombreComprobante}.pdf");

          vGlobal_comprobante.pathComprobante = file!.path;
          // await Dio().download(vGlobal_comprobante.linkComprobante, savePath, onReceiveProgress: (received, total) {});
          // vGlobal_comprobante.pathComprobante = savePath;
        } on DioError catch (e) {
          Fluttertoast.showToast(msg: "No se pudo guardar el Pdf en el equipo", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
        }
      }
    } else {
      Fluttertoast.showToast(msg: "No se concedió permiso para guardar el Pdf en el equipo", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
      Navigator.of(context).pop();
    }
  }

  _AnularBoleto(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 180, maxHeight: 180),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Motivo', style: TextStyle(color: ClsColor.tipo6(), fontSize: 16, fontWeight: FontWeight.w500)),
                      TextFormField(
                        controller: CMotivo,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(filled: true, isDense: true, fillColor: ClsColor.tipo4()),
                        onChanged: (value) {},
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
                      onPressed: () async {
                        if (CMotivo.text.length == 0) {
                          Fluttertoast.showToast(
                            msg: "Ingrese Motivo",
                            gravity: ToastGravity.CENTER,
                            backgroundColor: ClsColor.tipo6(),
                            textColor: ClsColor.tipo4(),
                          );
                          return;
                        }
                        Map<String, dynamic>? postReg = await AnularBoleto();
                        final codigo = postReg?["codigo"].toString();
                        final mensaje = postReg?["mensaje"];
                        Fluttertoast.showToast(msg: mensaje ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                        if (codigo == "0") {
                          Map<String, dynamic>? postReg = await AnularComprobante(CMotivo.text);
                          final codigo = postReg?["codigo"].toString();
                          final mensaje = postReg?["mensaje"];
                          Fluttertoast.showToast(msg: mensaje ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                          if (codigo == "0") {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => trans_seleccionarAsiento()));
                          } else {
                            Navigator.pop(context);
                          }
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: ClsColor.tipo1(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(100, 30),
                      ),
                      icon: const Icon(Icons.block_rounded, size: 15),
                      label: const Text("Anular", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
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
                ),
              ],
            ),
          ),
        );
      },
    );
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
                subtitulo: tRuta,
                detalle: '',
              ),
              Expanded(child: form_recuperar(context)),
            ],
          ),
        ),
      ),
    );
  }

  EnviarWhatsap() async {
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
              Text('Compartir por WhatsApp', style: TextStyle(color: ClsColor.tipo5(), fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            await WhatsappShare.shareFile(
                              package: Package.businessWhatsapp,
                              text: vGlobal_comprobante.nombreComprobante,
                              filePath: [(vGlobal_comprobante.pathComprobante)],
                              phone: "0000",
                            );
                          } catch (e) {
                            await WhatsappShare.shareFile(
                              package: Package.whatsapp,
                              text: vGlobal_comprobante.nombreComprobante,
                              filePath: [(vGlobal_comprobante.pathComprobante)],
                              phone: "0000",
                            );
                          }

                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(const Size(125, 45)),
                            backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)))),
                        icon: Icon(Icons.person_add_alt_1_rounded, size: 14.0, color: ClsColor.tipo4()),
                        label: Text('Contacto(s)', style: TextStyle(color: ClsColor.tipo4(), fontSize: 14))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        CCodigoPais.text = "51";
                        CTelefono.text = "";
                        Navigator.pop(context);
                        EnviarNro();
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(const Size(155, 45)),
                        backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                      icon: Icon(Icons.numbers_rounded, size: 14.0, color: ClsColor.tipo4()),
                      label: Text('Nro de Teléfono', style: TextStyle(color: ClsColor.tipo4(), fontSize: 14)),
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

  EnviarNro() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                        child: Text('Compartir por WhatsApp', style: TextStyle(color: ClsColor.tipo5(), fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 70,
                            child: TextFormField(
                              controller: CCodigoPais,
                              enabled: iEstadoDescuento,
                              maxLength: 2,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                isDense: true,
                                fillColor: ClsColor.tipo4(),
                                enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: ClsColor.tipo1(), width: 2)),
                                errorBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: ClsColor.tipo1(), width: 2)),
                                focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: ClsColor.tipo1(), width: 2)),
                                prefixText: "+",
                              ),
                              onChanged: (value) {},
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: TextFormField(
                              controller: CTelefono,
                              enabled: iEstadoDescuento,
                              autofocus: true,
                              maxLength: 9,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly],
                              decoration: InputDecoration(
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                                  isDense: true,
                                  fillColor: ClsColor.tipo4(),
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
                        ],
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
                        EnviarWhatsap();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: ClsColor.tipo4(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(100, 30),
                      ),
                      icon: const Icon(Icons.keyboard_return_rounded, size: 15),
                      label: const Text("Regresar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (CTelefono.text.length != 9) {
                          Fluttertoast.showToast(
                            msg: "Ingrese Telefono Válido",
                            gravity: ToastGravity.CENTER,
                            backgroundColor: ClsColor.tipo6(),
                            textColor: ClsColor.tipo4(),
                          );
                          return;
                        }
                        if (CCodigoPais.text.length == 0) {
                          Fluttertoast.showToast(
                            msg: "Ingrese Còdigo de Pais",
                            gravity: ToastGravity.CENTER,
                            backgroundColor: ClsColor.tipo6(),
                            textColor: ClsColor.tipo4(),
                          );
                          return;
                        }
                        try {
                          await WhatsappShare.shareFile(
                            package: Package.businessWhatsapp,
                            text: vGlobal_comprobante.nombreComprobante,
                            filePath: [(vGlobal_comprobante.pathComprobante)],
                            phone: "${CCodigoPais.text}${CTelefono.text}",
                          );
                        } catch (e) {
                          await WhatsappShare.shareFile(
                            package: Package.whatsapp,
                            text: vGlobal_comprobante.nombreComprobante,
                            filePath: [(vGlobal_comprobante.pathComprobante)],
                            phone: "${CCodigoPais.text}${CTelefono.text}",
                          );
                        }

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: ClsColor.tipo1(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(100, 30),
                      ),
                      icon: const Icon(Icons.send_and_archive_rounded, size: 15),
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
  }

  EnviarMail() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 280, maxHeight: 300),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 60,
                            child: Text('CDP    :', style: TextStyle(color: ClsColor.tipo6(), fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                          Flexible(
                            child: TextFormField(
                              initialValue: vGlobal_comprobante.nombreComprobante.toString(),
                              enabled: false,
                              decoration: InputDecoration(filled: true, isDense: true, fillColor: ClsColor.tipo4()),
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                      Text('Correo:', style: TextStyle(color: ClsColor.tipo6(), fontSize: 16, fontWeight: FontWeight.w500)),
                      TextFormField(
                        controller: CCorreo,
                        autofocus: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(filled: true, isDense: true, fillColor: ClsColor.tipo4()),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 20),
                      Text('Mensaje', style: TextStyle(color: ClsColor.tipo6(), fontSize: 16, fontWeight: FontWeight.w500)),
                      TextFormField(
                        controller: CMensaje,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(filled: true, isDense: true, fillColor: ClsColor.tipo4()),
                        onChanged: (value) {},
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
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (CCorreo.text.length == 0) {
                          Fluttertoast.showToast(
                            msg: "Ingrese Correo",
                            gravity: ToastGravity.CENTER,
                            backgroundColor: ClsColor.tipo6(),
                            textColor: ClsColor.tipo4(),
                          );
                          return;
                        }
                        ClsDecoration.showDialogLoading(context);
                        final List<sendMailRes>? logSend = await ComprobanteSendMail(CCorreo.text, CMensaje.text);
                        Fluttertoast.showToast(msg: logSend![0].messageResult.replaceAll("<br>", "\n").toString(), gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                        Navigator.of(context).pop();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: ClsColor.tipo1(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(100, 30),
                      ),
                      icon: const Icon(Icons.send_and_archive_rounded, size: 15),
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
                    if (widget.Origen == "VentaBoleto") ...[
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Visualización de Asiento', style: TextStyle(color: ClsColor.tipo1(), fontSize: 14, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text('Fecha de Viaje', style: TextStyle(color: ClsColor.tipo6(), fontSize: 12, fontWeight: FontWeight.w400)),
                      ),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        enabled: false,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                        controller: CFecha,
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: ClsColor.tipo4(), width: 2),
                          ),
                          filled: true,
                          isDense: true,
                          fillColor: ClsColor.tipo4(),
                          prefixIcon: Icon(Icons.calendar_month_rounded, color: ClsColor.tipo5()),
                        ),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text('Asiento', style: TextStyle(color: ClsColor.tipo6(), fontSize: 12, fontWeight: FontWeight.w400)),
                      ),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        enabled: false,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                        controller: CAsiento,
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: ClsColor.tipo4(), width: 2),
                          ),
                          filled: true,
                          isDense: true,
                          fillColor: ClsColor.tipo4(),
                          prefixIcon: Icon(Icons.airline_seat_recline_extra_rounded, color: ClsColor.tipo5()),
                        ),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text('Pasajero', style: TextStyle(color: ClsColor.tipo6(), fontSize: 12, fontWeight: FontWeight.w400)),
                      ),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        enabled: false,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                        controller: CPasajero,
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: ClsColor.tipo4(), width: 2),
                          ),
                          filled: true,
                          isDense: true,
                          fillColor: ClsColor.tipo4(),
                          prefixIcon: Icon(Icons.badge_rounded, color: ClsColor.tipo5()),
                        ),
                        onChanged: (value) {},
                      ),
                    ],
                    if (widget.Origen == "OrdenTraslado") ...[
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text('Sucursal Origen', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                      ),
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          filled: true,
                          enabled: false,
                          fillColor: Colors.white,
                          disabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                          contentPadding: const EdgeInsets.all(0),
                          prefixIconColor: ClsColor.tipo5(),
                          prefixIcon: Icon(Icons.directions_bus_rounded, size: 16, color: ClsColor.tipo5()),
                        ),
                        items: vGlobal_transporte.listCiudad.map((ciudad) => DropdownMenuItem<int>(value: ciudad.iMCiudad, child: Text(ciudad.tDescripcion.toString()))).toList(),
                        value: vGlobal_transporte.ort_origen,
                        onChanged: null,
                        style: TextStyle(decoration: TextDecoration.none),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text('Destino', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                      ),
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          filled: true,
                          enabled: false,
                          fillColor: Colors.white,
                          disabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                          contentPadding: const EdgeInsets.all(0),
                          prefixIconColor: ClsColor.tipo5(),
                          prefixIcon: Icon(Icons.directions_bus_rounded, size: 16, color: ClsColor.tipo5()),
                        ),
                        items: vGlobal_transporte.listCiudad.map((ciudad) => DropdownMenuItem<int>(value: ciudad.iMCiudad, child: Text(ciudad.tDescripcion.toString()))).toList(),
                        value: vGlobal_transporte.ort_destino,
                        onChanged: null,
                        isExpanded: true,
                        style: TextStyle(decoration: TextDecoration.none),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Row(
                          children: [
                            Text('Remitente', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        enabled: false,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                        controller: CRemitente,
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: ClsColor.tipo4(), width: 2),
                          ),
                          filled: true,
                          isDense: true,
                          fillColor: ClsColor.tipo4(),
                          prefixIcon: Icon(Icons.badge_rounded, color: ClsColor.tipo5()),
                        ),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Row(
                          children: [
                            Text('Consignado', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                            // Text('Consignado', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        enabled: false,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                        controller: CConsignado,
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: ClsColor.tipo4(), width: 2),
                          ),
                          filled: true,
                          isDense: true,
                          fillColor: ClsColor.tipo4(),
                          prefixIcon: Icon(Icons.badge_rounded, color: ClsColor.tipo5()),
                        ),
                        onChanged: (value) {},
                      ),
                    ],
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('S/ ${vGlobal_transporte.iPrecioFinal.toStringAsFixed(2)}', style: TextStyle(color: ClsColor.tipo1(), fontSize: 36, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Material(
                              color: ClsColor.tipo4(),
                              child: InkWell(
                                splashColor: ClsColor.tipo1(),
                                onTap: () {
                                  OpenFile.open(vGlobal_comprobante.pathComprobante);
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => Print(
                                  //       title: "TRANSPORTE",
                                  //       tMacImpresora: "",
                                  //       listPrecuentatemp: [],
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: ClsDecoration.botonPrincipal(titulo: "Imprimir\nCDP", icono: Icons.print_outlined, ColorIcono: ClsColor.tipo1()),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Material(
                              color: ClsColor.tipo4(),
                              child: InkWell(
                                splashColor: ClsColor.tipo1(),
                                onTap: () async {
                                  CCorreo.text = "";
                                  CMensaje.text = "";
                                  EnviarMail();
                                },
                                child: ClsDecoration.botonPrincipal(titulo: "Enviar por\nCorreo", icono: Icons.mail_outline_rounded, ColorIcono: ClsColor.tipo1()),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Material(
                              color: ClsColor.tipo4(),
                              child: InkWell(
                                splashColor: ClsColor.tipo1(),
                                onTap: () {
                                  CCodigoPais.text = "51";
                                  CTelefono.text = "";
                                  EnviarWhatsap();
                                },
                                child: ClsDecoration.botonPrincipal(titulo: "Compartir\npor WhatsApp", icono: Icons.whatshot_sharp, ColorIcono: ClsColor.tipo1()),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // ElevatedButton.icon(
          //   onPressed: () async {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => trans_seleccionarAsiento(),
          //       ),
          //     );
          //   },
          //   style: ButtonStyle(
          //     fixedSize: MaterialStateProperty.all(const Size(300, 50)),
          //     backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo3()),
          //     padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
          //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(30.0),
          //     )),
          //   ),
          //   icon: Icon(Icons.chevron_right_rounded, size: 20, color: ClsColor.tipo1()),
          //   label: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text("Seleccionar otro Asiento", style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () async {
              CMotivo.text = "";
              _AnularBoleto(context);
            },
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(Size(300, 50)),
              backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo8()),
              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )),
            ),
            icon: Icon(Icons.block_rounded, size: 20, color: ClsColor.tipo4()),
            label: Text("Anular", style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }
}
