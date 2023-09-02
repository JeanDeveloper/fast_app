import 'dart:convert';
import 'package:fast/models/Maestro/m_GetClienteBuscarPorNroDoc.dart';
import 'package:fast/models/Maestro/m_GetTipoDocumentoIdentidad.dart';
import 'package:fast/providers/providers.dart';
import 'package:fast/screens/Transporte/s_trans_ordenTrasladoNiv2.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:fast/providers/global_Transporte.dart' as vGlobal_transporte;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as math;

class trans_ordenTrasladoNiv1 extends StatefulWidget {
  const trans_ordenTrasladoNiv1({Key? key}) : super(key: key);
  @override
  _trans_ordenTrasladoNiv1 createState() => new _trans_ordenTrasladoNiv1();
}

Future<bool> _onWillPop() async {
  return false;
}

class _trans_ordenTrasladoNiv1 extends State<trans_ordenTrasladoNiv1> {
  // String dropdownTipoDocRem = "1";
  int TipoDocDigitosRem = 8;
  // int iMRemitente = 0;
  var CRemitenteDoc = TextEditingController(text: vGlobal_transporte.ort_remi_doc);
  var CRemitente = TextEditingController(text: vGlobal_transporte.ort_remi);

  // String dropdownTipoDocConsig = "1";
  int TipoDocDigitosConsig = 8;
  // int iMConsignado = 0;
  var CConsignadoDoc = TextEditingController(text: vGlobal_transporte.ort_cons_doc);
  var CConsignado = TextEditingController(text: vGlobal_transporte.ort_cons);
  var CConsignadoTelef = TextEditingController(text: vGlobal_transporte.ort_cons_telef);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: ClsDecoration.appBar(context, "navtrans_ordenTrasladoLista"),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          Text('1/3 (Datos del Remitente y Consignado)', style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text('Sucursal Origen', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                    ),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: ClsDecoration.inputborder(),
                        enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        contentPadding: const EdgeInsets.all(0),
                        prefixIconColor: ClsColor.tipo5(),
                        prefixIcon: Icon(Icons.directions_bus_rounded, size: 16, color: ClsColor.tipo5()),
                      ),
                      items: vGlobal_transporte.listCiudad.map((ciudad) => DropdownMenuItem<int>(value: ciudad.iMCiudad, child: Text(ciudad.tDescripcion.toString()))).toList(),
                      value: vGlobal_transporte.ort_origen,
                      onChanged: (int? value) {
                        setState(() {
                          vGlobal_transporte.ort_origen = value!;
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
                      hint: const Text('Seleccione Origen'),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text('Destino', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                    ),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: ClsDecoration.inputborder(),
                        enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        contentPadding: const EdgeInsets.all(0),
                        prefixIconColor: ClsColor.tipo5(),
                        prefixIcon: Icon(Icons.directions_bus_rounded, size: 16, color: ClsColor.tipo5()),
                      ),
                      items: vGlobal_transporte.listCiudad.map((ciudad) => DropdownMenuItem<int>(value: ciudad.iMCiudad, child: Text(ciudad.tDescripcion.toString()))).toList(),
                      value: vGlobal_transporte.ort_destino,
                      onChanged: (int? value) {
                        setState(() {
                          vGlobal_transporte.ort_destino = value!;
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
                      hint: const Text('Seleccione Destino'),
                    ),
                    const SizedBox(height: 20),
                    Text('Remitente', style: TextStyle(color: ClsColor.tipo6(), fontSize: 16, fontWeight: FontWeight.w900)),
                    const Divider(thickness: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Row(
                        children: [
                          Text('Tipo Documento ', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                          // Text('Remitente', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                    FutureBuilder<List<TipoDocumentoIdentidadData>?>(
                      future: loadTipoDocumentoIdentidad('RUC'),
                      builder: (BuildContext context, AsyncSnapshot<List<TipoDocumentoIdentidadData>?> snapshot) {
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
                              prefixIcon: Icon(Icons.badge_rounded, size: 16, color: ClsColor.tipo5()),
                            ),
                            value: vGlobal_transporte.ort_remi_tipoDoc,
                            items: snapshot.data
                                ?.map((tipodoc) => DropdownMenuItem<String>(
                                      value: tipodoc.iMTipoDocumentoIdentidad.toString(),
                                      child: Text(tipodoc.tDescripcion.replaceAll("\r\n", "").toString()),
                                    ))
                                .toList(),
                            onChanged: (String? value) {
                              setState(
                                () {
                                  vGlobal_transporte.ort_remi_tipoDoc = value!;
                                  if (vGlobal_transporte.ort_remi_tipoDoc == "0") {
                                    TipoDocDigitosRem = 15; // OTROS
                                  }
                                  if (vGlobal_transporte.ort_remi_tipoDoc == "1") {
                                    TipoDocDigitosRem = 8; // DNI
                                  }
                                  if (vGlobal_transporte.ort_remi_tipoDoc == "4") {
                                    TipoDocDigitosRem = 12; // CARNET DE EXTRANJERIA
                                  }
                                  if (vGlobal_transporte.ort_remi_tipoDoc == "7") {
                                    TipoDocDigitosRem = 12; // PASAPORTE
                                  }
                                  CRemitenteDoc.text = "";
                                  CRemitente.text = "";
                                  vGlobal_transporte.ort_remi_id = 0;
                                  vGlobal_transporte.ort_remi_doc = "";
                                  vGlobal_transporte.ort_remi = "";
                                },
                              );
                            },
                            isExpanded: true,
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              decorationStyle: TextDecorationStyle.dotted,
                              decorationColor: Colors.white,
                              color: ClsColor.tipo1(),
                              backgroundColor: ClsColor.tipo4(),
                            ),
                            hint: const Text('Seleccione Tipo de Documento'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Row(
                        children: [
                          Text('Nro. Documento ', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                          // Text('Remitente', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: CRemitenteDoc,
                      keyboardType: TextInputType.number,
                      maxLength: TipoDocDigitosRem,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        return (value != null && value.length == TipoDocDigitosRem) ? null : 'Nro. Digitos permitido $TipoDocDigitosRem';
                      },
                      decoration: InputDecoration(
                        filled: true,
                        isDense: true,
                        fillColor: ClsColor.tipo4(),
                        border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        prefixIcon: Icon(Icons.numbers_rounded, color: ClsColor.tipo5()),
                      ),
                      onChanged: (value) async {
                        CRemitente.text = "";
                        vGlobal_transporte.ort_remi_doc = value;
                        vGlobal_transporte.ort_remi = "";
                        vGlobal_transporte.ort_remi_id = 0;
                        if (value.length == TipoDocDigitosRem) {
                          if (vGlobal_transporte.ort_remi_tipoDoc == "1") {
                            final GetClienteBuscarPorNroDoc? Postlog = await getClienteBuscarPorNroDoc(CRemitenteDoc.text, 1);
                            var dataClienteBuscar = jsonEncode(Postlog);
                            var tJsonClienteBuscar = getClienteBuscarPorNroDocFromJson(dataClienteBuscar.toString());
                            if (tJsonClienteBuscar.data.length > 0) {
                              // ignore: use_build_context_synchronously
                              FocusScope.of(context).unfocus();
                              CRemitente.text = tJsonClienteBuscar.data[0].tNombre == null ? "" : tJsonClienteBuscar.data[0].tNombre;
                              vGlobal_transporte.ort_remi_id = tJsonClienteBuscar.data[0].iMCliente;
                              vGlobal_transporte.ort_remi_id = tJsonClienteBuscar.data[0].iMCliente;
                              vGlobal_transporte.ort_remi = tJsonClienteBuscar.data[0].tNombre == null ? "" : tJsonClienteBuscar.data[0].tNombre;
                              setState(() {
                                if (tJsonClienteBuscar.code != 200) {
                                  vGlobal_transporte.ort_remi_tipoDoc = tJsonClienteBuscar.data[0].iMTipoDocumentoIdentidad.toString();
                                } else {
                                  vGlobal_transporte.ort_remi_tipoDoc = "1";
                                }
                              });
                            } else {
                              Fluttertoast.showToast(msg: tJsonClienteBuscar.message, gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                            }
                          }
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                      child: Row(
                        children: [
                          Text('Nombres y Apellidos del ', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                          // Text('Remitente', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                    TextField(
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      controller: CRemitente,
                      decoration: InputDecoration(
                        filled: true,
                        isDense: true,
                        enabled: false,
                        fillColor: ClsColor.tipo2(),
                      ),
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 20),
                    Text('Consignado', style: TextStyle(color: ClsColor.tipo6(), fontSize: 16, fontWeight: FontWeight.w900)),
                    const Divider(thickness: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Row(
                        children: [
                          Text('Tipo Documento ', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                          // Text('Consignado', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                    FutureBuilder<List<TipoDocumentoIdentidadData>?>(
                      future: loadTipoDocumentoIdentidad('RUC'),
                      builder: (BuildContext context, AsyncSnapshot<List<TipoDocumentoIdentidadData>?> snapshot) {
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
                              prefixIcon: Icon(Icons.badge_rounded, size: 16, color: ClsColor.tipo5()),
                            ),
                            value: vGlobal_transporte.ort_cons_tipoDoc,
                            items: snapshot.data
                                ?.map((tipodoc) => DropdownMenuItem<String>(
                                      value: tipodoc.iMTipoDocumentoIdentidad.toString(),
                                      child: Text(tipodoc.tDescripcion.replaceAll("\r\n", "").toString()),
                                    ))
                                .toList(),
                            onChanged: (String? value) {
                              setState(
                                () {
                                  vGlobal_transporte.ort_cons_tipoDoc = value!;
                                  if (vGlobal_transporte.ort_cons_tipoDoc == "0") {
                                    TipoDocDigitosConsig = 15; // OTROS
                                  }
                                  if (vGlobal_transporte.ort_cons_tipoDoc == "1") {
                                    TipoDocDigitosConsig = 8; // DNI
                                  }
                                  if (vGlobal_transporte.ort_cons_tipoDoc == "4") {
                                    TipoDocDigitosConsig = 12; // CARNET DE EXTRANJERIA
                                  }
                                  if (vGlobal_transporte.ort_cons_tipoDoc == "7") {
                                    TipoDocDigitosConsig = 12; // PASAPORTE
                                  }
                                  CConsignadoDoc.text = "";
                                  CConsignado.text = "";
                                  vGlobal_transporte.ort_cons_telef = "";
                                  vGlobal_transporte.ort_cons_id = 0;
                                  vGlobal_transporte.ort_cons_doc = "";
                                  vGlobal_transporte.ort_cons = "";
                                },
                              );
                            },
                            isExpanded: true,
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              decorationStyle: TextDecorationStyle.dotted,
                              decorationColor: Colors.white,
                              color: ClsColor.tipo1(),
                              backgroundColor: ClsColor.tipo4(),
                            ),
                            hint: const Text('Seleccione Tipo de Documento'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Row(
                        children: [
                          Text('Nro. Documento ', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                          // Text('Consignado', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: CConsignadoDoc,
                      keyboardType: TextInputType.number,
                      maxLength: TipoDocDigitosConsig,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        return (value != null && value.length == TipoDocDigitosConsig) ? null : 'Nro. Digitos permitido $TipoDocDigitosConsig';
                      },
                      decoration: InputDecoration(
                        filled: true,
                        isDense: true,
                        fillColor: ClsColor.tipo4(),
                        border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        prefixIcon: Icon(Icons.numbers_rounded, color: ClsColor.tipo5()),
                      ),
                      onChanged: (value) async {
                        CConsignado.text = "";
                        vGlobal_transporte.ort_cons_telef = "";
                        vGlobal_transporte.ort_cons_doc = value;
                        vGlobal_transporte.ort_cons = "";
                        vGlobal_transporte.ort_cons_id = 0;
                        if (value.length == TipoDocDigitosConsig) {
                          final GetClienteBuscarPorNroDoc? Postlog = await getClienteBuscarPorNroDoc(CConsignadoDoc.text, 1);
                          var dataClienteBuscar = jsonEncode(Postlog);
                          var tJsonClienteBuscar = getClienteBuscarPorNroDocFromJson(dataClienteBuscar.toString());
                          if (tJsonClienteBuscar.data.length > 0) {
                            // ignore: use_build_context_synchronously
                            FocusScope.of(context).unfocus();
                            CConsignado.text = tJsonClienteBuscar.data[0].tNombre == null ? "" : tJsonClienteBuscar.data[0].tNombre;
                            vGlobal_transporte.ort_cons_id = tJsonClienteBuscar.data[0].iMCliente;
                            vGlobal_transporte.ort_cons_id = tJsonClienteBuscar.data[0].iMCliente;
                            vGlobal_transporte.ort_cons = tJsonClienteBuscar.data[0].tNombre == null ? "" : tJsonClienteBuscar.data[0].tNombre;
                            setState(() {
                              if (tJsonClienteBuscar.code != 200) {
                                vGlobal_transporte.ort_cons_tipoDoc = tJsonClienteBuscar.data[0].iMTipoDocumentoIdentidad.toString();
                              } else {
                                vGlobal_transporte.ort_cons_tipoDoc = "1";
                              }
                            });
                          } else {
                            Fluttertoast.showToast(msg: tJsonClienteBuscar.message, gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                          }
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                      child: Row(
                        children: [
                          Text('Nombres y Apellidos ', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                          // Text('Consignado', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                    TextField(
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      controller: CConsignado,
                      decoration: InputDecoration(
                        filled: true,
                        isDense: true,
                        enabled: false,
                        fillColor: ClsColor.tipo2(),
                        // disabledBorder: OutlineInputBorder(
                        //   borderRadius: const BorderRadius.all(Radius.circular(20)),
                        //   borderSide: BorderSide(color: ClsColor.tipo11(), width: 2),
                        // ),
                      ),
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Row(
                        children: [
                          Text('Teléfono ', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                          // Text('Consignado', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: CConsignadoTelef,
                      keyboardType: TextInputType.number,
                      maxLength: 9,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        return (value != null && value.length == 9) ? null : 'Nro. Digitos permitido 9';
                      },
                      decoration: InputDecoration(
                        filled: true,
                        isDense: true,
                        fillColor: ClsColor.tipo4(),
                        border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        prefixIcon: Icon(Icons.phone_android_rounded, color: ClsColor.tipo5()),
                      ),
                      onChanged: (value) {
                        vGlobal_transporte.ort_cons_telef = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              if (vGlobal_transporte.ort_origen == 0) {
                Fluttertoast.showToast(msg: "Seleccione Origen", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                return;
              }
              if (vGlobal_transporte.ort_destino == 0) {
                Fluttertoast.showToast(msg: "Seleccione Destido", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                return;
              }
              if (vGlobal_transporte.ort_origen == vGlobal_transporte.ort_destino) {
                Fluttertoast.showToast(msg: "Las sucursales no pueden ser las mismas", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                return;
              }
              if (vGlobal_transporte.ort_remi_doc.length != TipoDocDigitosRem || vGlobal_transporte.ort_remi == "") {
                Fluttertoast.showToast(msg: "Ingrese Remitente", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                return;
              }
              if (vGlobal_transporte.ort_cons_doc.length != TipoDocDigitosRem || vGlobal_transporte.ort_cons == "") {
                Fluttertoast.showToast(msg: "Ingrese Consignado", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                return;
              }
              if (vGlobal_transporte.ort_cons_telef.length != 9) {
                Fluttertoast.showToast(msg: "Ingrese Teléfono", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (context) => trans_ordenTrasladoNiv2()));
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
