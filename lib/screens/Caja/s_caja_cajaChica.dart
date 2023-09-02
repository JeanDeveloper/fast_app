import 'dart:convert';
import 'package:fast/models/Caja/m_GetCajaDiaria.dart';
import 'package:fast/providers/providers_Caja.dart';
import 'package:fast/screens/Transporte/s_trans_seleccionarAsiento.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Caja.dart' as vGlobal_caja;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class caja_cajaChica extends StatefulWidget {
  const caja_cajaChica({Key? key}) : super(key: key);
  @override
  _caja_cajaChica createState() => new _caja_cajaChica();
}

Future<bool> _onWillPop() async {
  return false; //<-- SEE HERE
}

class _caja_cajaChica extends State<caja_cajaChica> {
  final tTrabajador = TextEditingController();
  final CDocumento = TextEditingController();
  final CFecha = TextEditingController();
  int selectedValue = 1;
  int iDTrabajador = 0;
  var result_CargaCaja = <Widget>[];
  final DateRangePickerController _dateRangePicker = DateRangePickerController();
  DateTime desde = DateTime.now().add(const Duration(days: -5)), hasta = DateTime.now();

  @override
  void initState() {
    super.initState();
    _GenerarListaCajas();
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
            children: [
              ClsTextStyle.cabeceraBienvenida(
                titulo: "CAJA CHICA",
                subtitulo: "",
                detalle: '',
              ),
              Expanded(child: form_recuperar(context)),
            ],
          ),
        ),
      ),
    );
  }

  void _GenerarListaCajas() {
    setState(
      () {
        result_CargaCaja = <Widget>[];
        result_CargaCaja.add(
          Container(
            // decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
            child: FutureBuilder<GetCajaDiaria?>(
              future: getlistCajaDiaria(desde, hasta),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator.adaptive());
                }
                final GetCajaDiaria? Lista = snapshot.data;
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: Lista?.data.length ?? 0,
                  itemBuilder: (context, index) {
                    //if (Lista!.data.isNotEmpty) {
                    return GestureDetector(
                      onTap: () {
                        vGlobal_caja.iMCaja = Lista.data[index].iMCaja;
                        vGlobal_caja.iDCajaDiaria = Lista.data[index].iDCajaDiaria;
                        vGlobal_caja.fFecha = Lista.data[index].fFecha;
                        vGlobal_caja.nInicial = Lista.data[index].nInicial;
                        vGlobal_caja.tMResponsable = Lista.data[index].tMResponsable;
                        vGlobal_caja.tMCaja = Lista.data[index].tMCaja;
                        vGlobal_caja.iEstado = Lista.data[index].iEstado;
                        Navigator.pushReplacementNamed(context, 'navcaja_cajaDiaria');
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 60,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  color: Lista!.data[index].iEstado == 1 ? ClsColor.tipo1() : ClsColor.tipo7(),
                                  width: 75,
                                  height: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(Lista.data[index].fFecha, style: TextStyle(color: ClsColor.tipo4(), fontSize: 12, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
                                      // Text("CI-01-9289", style: TextStyle(color: ClsColor.tipo4(), fontSize: 10, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
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
                                      Text(Lista.data[index].tMResponsable, style: TextStyle(color: ClsColor.tipo5(), fontSize: 11, fontWeight: FontWeight.w500)),
                                      Text(Lista.data[index].tDSucursal, style: TextStyle(color: ClsColor.tipo5(), fontSize: 11, fontWeight: FontWeight.w400)),
                                      Text("Apertura : S/ ${NumberFormat('#,##,##0.00').format(Lista.data[index].nInicial)}", style: TextStyle(color: ClsColor.tipo5(), fontSize: 10, fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      // Text(Lista.data[index].fFecha == "0" ? "Pendiente" : "Vinculado", style: TextStyle(color: ClsColor.tipo1(), fontSize: 12, fontWeight: FontWeight.w400)),
                                      Icon(Icons.chevron_right_rounded, size: 25.0, color: ClsColor.tipo5()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //DateFormat('dd/MM/yyyy').format(_selectedDate!).toString();
                        Text("${DateFormat("dd/MM/yyyy").format(desde).toString()} - ${DateFormat("dd/MM/yyyy").format(hasta).toString()}",
                            style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
                        IconButton(
                          icon: Icon(Icons.calendar_month_rounded),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: SfDateRangePicker(
                                      view: DateRangePickerView.month,
                                      selectionMode: DateRangePickerSelectionMode.range,
                                      showActionButtons: true,
                                      controller: _dateRangePicker,
                                      initialSelectedRange: PickerDateRange(DateTime.now(), DateTime.now()),
                                      cancelText: "Cancelar",
                                      confirmText: "Ok",
                                      onSubmit: (p0) {
                                        if (_dateRangePicker.selectedRange!.startDate == null || _dateRangePicker.selectedRange!.endDate == null) {
                                          Fluttertoast.showToast(
                                            msg: "Seleccione rango de Fechas",
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor: ClsColor.tipo6(),
                                            textColor: ClsColor.tipo4(),
                                          );
                                          return;
                                        }
                                        setState(() {
                                          desde = _dateRangePicker.selectedRange!.startDate!;
                                          hasta = _dateRangePicker.selectedRange!.endDate!;
                                          _GenerarListaCajas();
                                        });
                                        Navigator.pop(context);
                                      },
                                      onCancel: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          iconSize: 20,
                          color: ClsColor.tipo1(),
                        ),
                      ],
                    ),
                    Column(children: result_CargaCaja),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'navcaja_aperturar');
            },
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(Size(300, 50)),
              backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )),
            ),
            icon: Icon(Icons.add, size: 20, color: ClsColor.tipo4()),
            label: Text("Nueva Apertura", style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w400)),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
