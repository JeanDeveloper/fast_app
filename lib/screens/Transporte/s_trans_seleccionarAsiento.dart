import 'package:fast/models/Transporte/m_%20getNiveles.dart';
import 'package:fast/models/Transporte/m_GetModeloAsientoBuscar.dart';
import 'package:fast/providers/providers_Transporte.dart';
import 'package:fast/screens/Transporte/s_trans_resultado.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:fast/providers/global_Transporte.dart' as vGlobal_transporte;
import 'package:fluttertoast/fluttertoast.dart';

class trans_seleccionarAsiento extends StatefulWidget {
  const trans_seleccionarAsiento({Key? key}) : super(key: key);
  @override
  _trans_seleccionarAsiento createState() => new _trans_seleccionarAsiento();
}

Future<bool> _onWillPop() async {
  return false; //<-- SEE HERE
}

class _trans_seleccionarAsiento extends State<trans_seleccionarAsiento> with TickerProviderStateMixin {
  int niveles = 2;
  // late final TabController tabcontroller = TabController(length: niveles, initialIndex: 0, vsync: this);
  var result_CargaAsientos;
  TabController? tabcontroller;
  List<NivelesData>? getNivel;

  @override
  void initState() {
    loadNivel();
    super.initState();
    Fluttertoast.showToast(msg: "Elegir Asiento", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
  }

  Future<void> loadNivel() async {
    getNivel = await getListNiveles();
    niveles = getNivel!.length;
    final tabcontroller = TabController(length: niveles, initialIndex: 0, vsync: this);
    setState(() {
      _GenerarAsientos(tabcontroller, niveles);
    });
  }

  void _GenerarAsientos(TabController Controller, int iNiveles) {
    List<Tab> tabs = [];
    for (var i = 1; i <= iNiveles; i++) {
      tabs.add(Tab(text: "Nivel $i"));
    }
    result_CargaAsientos = null;
    result_CargaAsientos = Column(
      children: [
        Container(
          height: 30,
          child: TabBar(
            indicator: BoxDecoration(
              color: ClsColor.tipo3(),
              borderRadius: BorderRadius.circular(20),
            ),
            controller: Controller,
            labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            labelColor: ClsColor.tipo1(),
            //unselectedLabelColor: ClsColor.textcolorGris(),
            labelPadding: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
            tabs: tabs,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: Controller,
            children: [
              for (int i = 1; i <= iNiveles; i++) ...[
                // Expanded(
                // child:
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FutureBuilder<GetModeloAsientoBuscar?>(
                        future: getlistModeloAsiento(i),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator.adaptive());
                          }
                          final GetModeloAsientoBuscar? Lista = snapshot.data;
                          return GridView.builder(
                            physics: const ScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                            itemCount: Lista?.data.length ?? 0,
                            itemBuilder: (context, index) {
                              return ClsDecoration.ContainerMatrizTransporte(
                                context: context,
                                tipo: Lista!.data[index].iTipo!,
                                asiento: Lista.data[index].iAsiento,
                                nivel: Lista.data[index].inivel,
                                precio: Lista.data[index].iPrecio,
                                status: Lista.data[index].iEstado,
                                iMVentaTransporte: Lista.data[index].iMVentaTransporte,
                                tColorPunto: Lista.data[index].tColor,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => trans_resultadoBoleto(),
              ),
            );
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
    );
    return result_CargaAsientos;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: ClsDecoration.appBar(context, "navtrans_resultadoBoleto"),
        drawer: NavDrawer(),
        backgroundColor: ClsColor.tipo1(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              ClsTextStyle.cabeceraBienvenida(
                titulo: "FECHA: ${vGlobal_transporte.fecha} - ${vGlobal_transporte.hora}",
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
      child: result_CargaAsientos,
    );
  }
}
