import 'dart:convert';
import 'package:fast/models/Caja/m_GetCajaDiaria.dart';
import 'package:fast/models/Caja/m_GetCajaDiariaDetalle.dart';
import 'package:fast/providers/providers_Caja.dart';
import 'package:fast/screens/Transporte/s_trans_seleccionarAsiento.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Caja.dart' as vGlobal_caja;

import 'package:intl/intl.dart';

class caja_cajaDiariaDetalle extends StatefulWidget {
  final int iTipo;
  const caja_cajaDiariaDetalle({Key? key, required this.iTipo}) : super(key: key);
  @override
  _caja_cajaDiariaDetalle createState() => new _caja_cajaDiariaDetalle();
}

Future<bool> _onWillPop() async {
  return false; //<-- SEE HERE
}

class _caja_cajaDiariaDetalle extends State<caja_cajaDiariaDetalle> {
  final tTrabajador = TextEditingController();
  final CDocumento = TextEditingController();
  final CFecha = TextEditingController();
  int selectedValue = 1;
  int iDTrabajador = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: ClsDecoration.appBar(context, "navcaja_cajaDiaria"),
        drawer: NavDrawer(),
        backgroundColor: ClsColor.tipo1(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              ClsTextStyle.cabeceraBienvenida(
                titulo: "CAJA CHICA",
                subtitulo: "FECHA: ${vGlobal_caja.fFecha.toString()}",
                detalle: widget.iTipo == 1 ? "Ingresos" : "Egresos",
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
                    FutureBuilder<GetCajaDiariaDetalle?>(
                      future: getlistCajaDiariaDetalle(widget.iTipo),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator.adaptive());
                        }
                        final GetCajaDiariaDetalle? Lista = snapshot.data;
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: Lista?.data.length ?? 0,
                          itemBuilder: (context, index) {
                            //if (Lista!.data.isNotEmpty) {
                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  height: 80,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        color: Lista!.data[index].iEstado == 1 ? ClsColor.tipo1() : ClsColor.tipo7(),
                                        width: 55,
                                        height: double.infinity,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(Lista.data[index].iDCajaDiariaDetalle.toString(), style: TextStyle(color: ClsColor.tipo4(), fontSize: 10, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                                            Text(Lista.data[index].fFecha.toString(), style: TextStyle(color: ClsColor.tipo4(), fontSize: 15, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        //width: 180,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(Lista.data[index].tMotivo.toString(), style: TextStyle(color: ClsColor.tipo5(), fontSize: 10, fontWeight: FontWeight.w700)),
                                            Text(Lista.data[index].tDescripcion.toString(), style: TextStyle(color: ClsColor.tipo5(), fontSize: 10, fontWeight: FontWeight.w400)),
                                            Text("${Lista.data[index].tTipoComprobante}- ${Lista.data[index].tNombreCliente.toString()}",
                                                style: TextStyle(color: ClsColor.tipo5(), fontSize: 10, fontWeight: FontWeight.w400)),
                                            Text("EFEC: ${NumberFormat('#,##,###.00').format(Lista.data[index].nEfectivo)}  -  TARJ: ${NumberFormat('#,##,###.00').format(Lista.data[index].nTarjeta)}",
                                                style: TextStyle(color: ClsColor.tipo5(), fontSize: 10, fontWeight: FontWeight.w400)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 100,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text("S/ ${NumberFormat('#,##,###.00').format(Lista.data[index].nImporte)}", style: TextStyle(color: ClsColor.tipo5(), fontSize: 12, fontWeight: FontWeight.w700)),
                                          ],
                                        ),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
