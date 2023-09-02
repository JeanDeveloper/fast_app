import 'package:fast/models/Restaurante/m_GetMesas.dart';
import 'package:fast/providers/providers_Restaurante.dart';
import 'package:fast/screens/Restaurante/s_rest_Print.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Restaurante.dart' as vGlobal_Restaurante;
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:printing/printing.dart';

class mesaUnirPrincipal extends StatefulWidget {
  const mesaUnirPrincipal({Key? key}) : super(key: key);

  @override
  _mesaUnirPrincipal createState() => new _mesaUnirPrincipal();
}

Future<bool> _onWillPop() async {
  return false; //<-- SEE HERE
}

class _mesaUnirPrincipal extends State<mesaUnirPrincipal> with TickerProviderStateMixin {
  var result_CargaMesas = <Widget>[];
  int iPrincipal = 0;

  @override
  void initState() {
    vGlobal_Restaurante.ListaMesasNivel = vGlobal_Restaurante.ListaMesasNivel..removeWhere((element) => element.lUnion != true);
    CargarMesas();
    super.initState();
  }

  CargarMesas() async {
    _GenerarCargaProducto();

    //vGlobal_Restaurante.ListaMesasNivel = sde;
  }

  void _GenerarCargaProducto() {
    setState(() {
      result_CargaMesas = <Widget>[];
      result_CargaMesas.add(
        GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 2,
          physics: const ScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            for (int i = 0; i < vGlobal_Restaurante.ListaMesasNivel.length; i++) ...[
              Card(
                color: Color(int.parse((vGlobal_Restaurante.ListaMesasNivel[i].tColor ?? "").replaceAll('#', '0xFF'))),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: RadioListTile(
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                  activeColor: ClsColor.tipo4(),
                  title: Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(vGlobal_Restaurante.ListaMesasNivel[i].tMesa.toString(), style: TextStyle(color: ClsColor.tipo4(), fontSize: 15, fontWeight: FontWeight.w700)),
                        if (vGlobal_Restaurante.ListaMesasNivel[i].tEstado == "DISPONIBLE" || vGlobal_Restaurante.ListaMesasNivel[i].tEstado == "BLOQUEADO") ...[
                          Text(vGlobal_Restaurante.ListaMesasNivel[i].tEstado.toString(), style: TextStyle(color: ClsColor.tipo4(), fontSize: 12, fontWeight: FontWeight.w400)),
                        ] else if (vGlobal_Restaurante.ListaMesasNivel[i].tEstado == "OCUPADO") ...[
                          Text(vGlobal_Restaurante.ListaMesasNivel[i].tHora.toString(), style: TextStyle(color: ClsColor.tipo4(), fontSize: 10, fontWeight: FontWeight.w400)),
                          Text('S/ ${vGlobal_Restaurante.ListaMesasNivel[i].nImporte!.toStringAsFixed(2)}', style: TextStyle(color: ClsColor.tipo3(), fontSize: 12, fontWeight: FontWeight.w700)),
                        ]
                      ],
                    ),
                  ),
                  groupValue: iPrincipal,
                  value: vGlobal_Restaurante.ListaMesasNivel[i].iMMesa,
                  onChanged: (value) {
                    setState(() {
                      iPrincipal = value!;
                      _GenerarCargaProducto();
                      print(value);
                    });
                  },
                ),
              ),
            ]
          ],
        ),
      );
    });
  }

  _Confimar(BuildContext context) async {
    showModalBottomSheet(
      backgroundColor: ClsColor.tipo4(),
      context: context,
      builder: (context) {
        return SizedBox(
          height: 160,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text('¿Estas Seguro(a) de unir las mesas?', style: TextStyle(color: ClsColor.tipo6(), fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(const Size(130, 45)),
                            backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo4()),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)))),
                        icon: Icon(Icons.cancel, size: 16.0, color: ClsColor.tipo5()),
                        label: Text('No', style: TextStyle(color: ClsColor.tipo5(), fontSize: 16, fontWeight: FontWeight.w700))),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Map<String, dynamic>? postReg = await postUnirMesas(iPrincipal);
                        final codigo = postReg?["codigo"].toString();
                        final mensaje = postReg?["mensaje"];
                        Fluttertoast.showToast(msg: mensaje ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                        if (codigo == "0") {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, "navmesaSeleccionar");
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(const Size(130, 45)),
                        backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        ),
                      ),
                      icon: Icon(Icons.check, size: 20.0, color: ClsColor.tipo4()),
                      label: Text('Si', style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w700)),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: ClsDecoration.appBar(context, "navmesaUnir"),
        drawer: NavDrawer(),
        backgroundColor: ClsColor.tipo1(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              ClsTextStyle.cabeceraBienvenida(titulo: "UNIR MESAS", subtitulo: "Seleccione mesa principal", detalle: ''),
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
          Text('Mesas', style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: result_CargaMesas),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () async {
              _Confimar(context);
            },
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(300, 50)),
              backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )),
            ),
            icon: Icon(Icons.widgets_rounded, size: 20, color: ClsColor.tipo4()),
            label: Text("Unir Mesas", style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }
}
