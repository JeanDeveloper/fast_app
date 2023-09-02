import 'dart:convert';
import 'package:fast/screens/Transporte/s_trans_seleccionarAsiento.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Transporte.dart' as vGlobal_transporte;

class trans_resultadoBoleto extends StatefulWidget {
  const trans_resultadoBoleto({Key? key}) : super(key: key);
  @override
  _trans_resultadoBoleto createState() => new _trans_resultadoBoleto();
}

Future<bool> _onWillPop() async {
  return false; //<-- SEE HERE
}

class _trans_resultadoBoleto extends State<trans_resultadoBoleto> {
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
        appBar: ClsDecoration.appBar(context, "navtrans_registrarBoleto"),
        drawer: NavDrawer(),
        backgroundColor: ClsColor.tipo1(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              ClsTextStyle.cabeceraBienvenida(
                titulo: "FECHA: ${vGlobal_transporte.fecha}",
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
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          Text('RESULTADOS', style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
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
                    ListView.builder(
                      shrinkWrap: true,
                      // padding: const EdgeInsets.all(5.5),
                      itemCount: vGlobal_transporte.listProgramacion.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            vGlobal_transporte.iDProgramacionFecha = vGlobal_transporte.listProgramacion[index].iDProgramacionFecha;
                            vGlobal_transporte.iMModeloTransporte = vGlobal_transporte.listProgramacion[index].iMModeloTransporte;
                            vGlobal_transporte.hora = vGlobal_transporte.listProgramacion[index].fHoraSalida;
                            vGlobal_transporte.tPlaca = vGlobal_transporte.listProgramacion[index].tPlaca;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const trans_seleccionarAsiento(),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      color: ClsColor.tipo1(),
                                      width: 80,
                                      height: double.infinity,
                                      child: Center(
                                        child: Text(
                                          vGlobal_transporte.listProgramacion[index].fHoraSalida,
                                          style: TextStyle(color: ClsColor.tipo4(), fontSize: 15, fontWeight: FontWeight.w900),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 100,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            vGlobal_transporte.listProgramacion[index].tServicio,
                                            style: TextStyle(color: ClsColor.tipo6(), fontSize: 12, fontWeight: FontWeight.w600),
                                          ),
                                          // Text("PISO 1: 0", style: TextStyle(color: ClsColor.tipo6(), height: 2, fontSize: 12, fontWeight: FontWeight.w600)),
                                          // Text('PISO 2: 25', style: TextStyle(color: ClsColor.tipo6(), height: 2, fontSize: 12, fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Text("S/ ${vGlobal_transporte.listProgramacion[index].tPrecio}",
                                          textAlign: TextAlign.right, style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w900)),
                                    ),
                                    Icon(Icons.chevron_right_rounded, size: 25, color: ClsColor.tipo6()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, "navtrans_registrarBoleto");
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
            label: Text("Nueva Busqueda", style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }
}
