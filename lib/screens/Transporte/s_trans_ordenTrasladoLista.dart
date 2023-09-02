import 'package:fast/models/Caja/m_GetCajaDiaria.dart';
import 'package:fast/models/Restaurante/m_GetOrdenTraslado.dart';
import 'package:fast/providers/providers_Caja.dart';
import 'package:fast/providers/providers_Transporte.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Caja.dart' as vGlobal_caja;
import 'package:fast/providers/global_Transporte.dart' as vGlobal_transporte;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class trans_ordenTrasladoLista extends StatefulWidget {
  const trans_ordenTrasladoLista({Key? key}) : super(key: key);
  @override
  _trans_ordenTrasladoLista createState() => new _trans_ordenTrasladoLista();
}

Future<bool> _onWillPop() async {
  return false; //<-- SEE HERE
}

class _trans_ordenTrasladoLista extends State<trans_ordenTrasladoLista> {
  var result_CargaProducto = <Widget>[];
  DateRangePickerController _dateRangePicker = DateRangePickerController();

  DateTime desde = DateTime.now(), hasta = DateTime.now();

  void _GenerarOrden() {
    setState(
      () {
        result_CargaProducto = <Widget>[];
        result_CargaProducto.add(
          Container(
            // decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.white),
            child: FutureBuilder<GetOrdenTraslado?>(
              future: getlistOrdenTraslado(DateFormat("yyyy-MM-dd").format(desde).toString(), DateFormat("yyyy-MM-dd").format(hasta).toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator.adaptive());
                }
                final GetOrdenTraslado? Lista = snapshot.data;
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: Lista?.data.length ?? 0,
                  itemBuilder: (context, index) {
                    //if (Lista!.data.isNotEmpty) {
                    return GestureDetector(
                      onTap: () {},
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 55,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  color: Lista!.data[index].lPAnticipado == true ? ClsColor.tipo1() : ClsColor.tipo7(),
                                  width: 65,
                                  height: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        NumberFormat("OT000000").format(Lista.data[index].iNumero).toString(),
                                        style: TextStyle(color: ClsColor.tipo4(), fontSize: 10, fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(Lista.data[index].tHora, style: TextStyle(color: ClsColor.tipo4(), fontSize: 12, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
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
                                      Text(
                                        Lista.data[index].tSerie == "" ? (NumberFormat("OT000000").format(Lista.data[index].iNumero).toString()) : "${Lista.data[index].tSerie}-${Lista.data[index].tNumero}",
                                        style: TextStyle(color: ClsColor.tipo5(), fontSize: 11, fontWeight: FontWeight.w500),
                                      ),
                                      Text(Lista.data[index].tConsignado, style: TextStyle(color: ClsColor.tipo5(), fontSize: 10, fontWeight: FontWeight.w700)),
                                      Text("DESTINO: ${Lista.data[index].tDestino}", style: TextStyle(color: ClsColor.tipo6(), fontSize: 11, fontWeight: FontWeight.w400)),
                                      //Text("Apertura : S/ ${NumberFormat('#,##,###.00').format(Lista.data[index].nInicial)}", style: TextStyle(color: ClsColor.tipo5(), fontSize: 10, fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 75,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(NumberFormat('S/ #,##,##0.00').format(Lista.data[index].iImporteTotal),
                                          style: TextStyle(
                                            color: ClsColor.tipo6(),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          )),
                                      Icon(Icons.chevron_right_rounded, size: 20.0, color: ClsColor.tipo5()),
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

  @override
  void initState() {
    super.initState();
    _GenerarOrden();
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
                titulo: "Orden de Traslado",
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
          Text('Listado', style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //DateFormat('dd/MM/yyyy').format(_selectedDate!).toString();
              Text("${DateFormat("dd/MM/yyyy").format(desde).toString()} - ${DateFormat("dd/MM/yyyy").format(hasta).toString()}", style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
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
                                _GenerarOrden();
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
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(children: result_CargaProducto),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              vGlobal_transporte.listProductoTraslado = [];
              vGlobal_transporte.ort_remi_doc = "";
              vGlobal_transporte.ort_remi = "";
              vGlobal_transporte.ort_cons_doc = "";
              vGlobal_transporte.ort_cons = "";
              vGlobal_transporte.ort_cons_telef = "";
              vGlobal_transporte.ort_origen = vGlobal_transporte.listCiudad[0].iMCiudad;
              vGlobal_transporte.ort_destino = vGlobal_transporte.listCiudad[0].iMCiudad;
              vGlobal_transporte.pInicial = 0;
              vGlobal_transporte.pFinal = 0;
              vGlobal_transporte.Letra = "";
              vGlobal_transporte.pDescuento = 0;
              vGlobal_transporte.pPorDescuento = 0;
              vGlobal_transporte.tDescripcion = "";
              vGlobal_transporte.iMCliente = 0;
              vGlobal_transporte.tClienteDoc = "";
              vGlobal_transporte.tCliente = "";
              vGlobal_transporte.tClienteDireccion = "";
              vGlobal_transporte.PlacaVehiculo = "";
              vGlobal_transporte.ModalidaPago = "";
              vGlobal_transporte.tSerie = "";
              vGlobal_transporte.tNumeracion = "";
              vGlobal_transporte.iTipoFac = "";
              vGlobal_transporte.tTipoDocCliente = "";
              Navigator.pushReplacementNamed(context, 'navtrans_ordenTrasladoNiv1');
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
            label: Text("Nueva Orden de Traslado", style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w400)),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
