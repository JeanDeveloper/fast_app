import 'dart:convert';

import 'package:fast/models/Caja/m_GetCajaDiariaDetalle.dart';
import 'package:fast/models/Caja/m_GetCajaDiariaPorId.dart';
import 'package:fast/models/Caja/m_GetTerminalCajaDiariaImporte.dart';
import 'package:fast/providers/providers_Caja.dart';
import 'package:fast/screens/Caja/s_caja_cajaChica.dart';
import 'package:fast/screens/Caja/s_caja_cajaDiariaDetalle.dart';
import 'package:fast/screens/Transporte/s_trans_registrar.dart';
import 'package:fast/screens/Transporte/s_trans_seleccionarAsiento.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:fast/providers/global_Caja.dart' as vGlobal_caja;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class caja_cajaDiaria extends StatefulWidget {
  const caja_cajaDiaria({Key? key}) : super(key: key);
  @override
  _caja_cajaDiaria createState() => new _caja_cajaDiaria();
}

Future<bool> _onWillPop() async {
  return false; //<-- SEE HERE
}

class _caja_cajaDiaria extends State<caja_cajaDiaria> {
  var CResponsable = TextEditingController(text: vGlobal_caja.tMResponsable.toString());
  var CCaja = TextEditingController(text: vGlobal_caja.tMCaja.toString());
  var CApertura = TextEditingController(text: "S/ ${NumberFormat('#,##,##0.00').format(vGlobal_caja.nInicial)}");
  var Ingresos, Egresos, CajaChica, iEstado = 2;

  @override
  void initState() {
    super.initState();
    _asyncMethod();
  }

  _asyncMethod() async {
    final GetCajaDiariaPorId? postlog = await getCajaDiariaPorId();
    var dataCajDiariaData = jsonEncode(postlog);
    var tJsonCajDiariaData = getCajaDiariaPorIdFromJson(dataCajDiariaData.toString());
    setState(() {
      Ingresos = "S/ ${NumberFormat('#,##,##0.00').format(tJsonCajDiariaData.data[0].nTotalIngresos)}";
      Egresos = "S/ ${NumberFormat('#,##,##0.00').format(tJsonCajDiariaData.data[0].nTotalEgresos)}";
      CajaChica = "S/ ${NumberFormat('#,##,##0.00').format(tJsonCajDiariaData.data[0].nImporteFinal)}";
      CApertura.text = "S/ ${NumberFormat('#,##,##0.00').format(tJsonCajDiariaData.data[0].nInicial)}";
      iEstado = tJsonCajDiariaData.data[0].iEstado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: ClsDecoration.appBar(context, "navcaja_cajaChica"),
        drawer: NavDrawer(),
        backgroundColor: ClsColor.tipo1(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              ClsTextStyle.cabeceraBienvenida(
                titulo: 'Caja Chica',
                subtitulo: "Fecha: ${vGlobal_caja.fFecha.toString()}",
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
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _asyncMethod();
                            },
                            child: Icon(Icons.refresh_rounded, color: ClsColor.tipo1(), size: 30),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text('Responsable', style: TextStyle(color: ClsColor.tipo6(), fontSize: 12, fontWeight: FontWeight.w400)),
                    ),
                    TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      enabled: false,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      controller: CResponsable,
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: ClsColor.tipo4(), width: 2),
                        ),
                        filled: true,
                        isDense: true,
                        fillColor: ClsColor.tipo4(),
                        prefixIcon: Icon(Icons.man_rounded, color: ClsColor.tipo5()),
                      ),
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text('Caja', style: TextStyle(color: ClsColor.tipo6(), fontSize: 12, fontWeight: FontWeight.w400)),
                    ),
                    TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      enabled: false,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      controller: CCaja,
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: ClsColor.tipo4(), width: 2),
                        ),
                        filled: true,
                        isDense: true,
                        fillColor: ClsColor.tipo4(),
                        prefixIcon: Icon(Icons.fax_rounded, color: ClsColor.tipo5()),
                      ),
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text('Monto de Apertura', style: TextStyle(color: ClsColor.tipo6(), fontSize: 12, fontWeight: FontWeight.w400)),
                    ),
                    TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      enabled: false,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      controller: CApertura,
                      decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: ClsColor.tipo4(), width: 2),
                        ),
                        filled: true,
                        isDense: true,
                        fillColor: ClsColor.tipo4(),
                        prefixIcon: Icon(Icons.monetization_on_rounded, color: ClsColor.tipo5()),
                      ),
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const caja_cajaDiariaDetalle(iTipo: 1)));
                          },
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(const Size(150, 45)),
                            backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo6()),
                            padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(5)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                          ),
                          icon: Icon(Icons.arrow_circle_down_rounded, size: 25, color: ClsColor.tipo4()),
                          label: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Ver Ingresos", style: TextStyle(color: ClsColor.tipo4(), fontSize: 13, fontWeight: FontWeight.w700)),
                              Text(Ingresos.toString(), style: TextStyle(color: ClsColor.tipo4(), fontSize: 13, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const caja_cajaDiariaDetalle(iTipo: 2)));
                          },
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(const Size(150, 45)),
                            backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo6()),
                            padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(5)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0))),
                          ),
                          icon: Icon(Icons.arrow_circle_up_rounded, size: 25, color: ClsColor.tipo4()),
                          label: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Ver Egresos", style: TextStyle(color: ClsColor.tipo4(), fontSize: 13, fontWeight: FontWeight.w700)),
                              Text(Egresos.toString(), style: TextStyle(color: ClsColor.tipo4(), fontSize: 13, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<GetTerminalCajaDiariaImporte?>(
                      future: getlistTerminalCajaDiariaImporte(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator.adaptive());
                        }
                        final GetTerminalCajaDiariaImporte? Lista = snapshot.data;
                        return GridView.builder(
                          physics: const ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 3.5),
                          ),
                          itemCount: Lista?.data.length ?? 0,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                    child: Text("${Lista!.data[index].tBanco} - ${Lista.data[index].tNombre}", style: TextStyle(color: ClsColor.tipo6(), fontSize: 12, fontWeight: FontWeight.w400)),
                                  ),
                                  TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.center,
                                    enabled: false,
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                    initialValue: "S/ ${NumberFormat('#,##,##0.00').format(Lista.data[index].iImporte)}",
                                    decoration: InputDecoration(
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                                        borderSide: BorderSide(color: ClsColor.tipo4(), width: 2),
                                      ),
                                      filled: true,
                                      isDense: true,
                                      fillColor: ClsColor.tipo4(),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (iEstado == 1) ...[
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  Map<String, dynamic>? postReg = await CajaCerrar();
                  var codigo = postReg?["codigo"].toString();
                  var mensaje = postReg?["mensaje"];
                  var iMCajadiaria = postReg?["iMCajadiaria"];
                  Fluttertoast.showToast(msg: mensaje ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                  if (codigo == "0") {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => caja_cajaChica()));
                  }
                } catch (e) {
                  Fluttertoast.showToast(msg: "Error de Conexión", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                }
              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(300, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo3()),
                padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
              ),
              icon: Icon(Icons.save_rounded, size: 20, color: ClsColor.tipo1()),
              label: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Cerrar Caja", style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(CajaChica, style: TextStyle(color: ClsColor.tipo5(), fontSize: 20, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ]
        ],
      ),
    );
  }
}
