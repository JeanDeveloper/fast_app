import 'package:fast/core/utils.dart';
import 'package:fast/providers/providers_Restaurante.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Restaurante.dart' as vGlobal_Restaurante;
import 'package:fast/widgets/counter.dart';
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class pedidoInicio extends StatefulWidget {
  const pedidoInicio({Key? key}) : super(key: key);

  @override
  _pedidoInicio createState() => new _pedidoInicio();
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

Future<bool> _onWillPop() async {
  return false; //<-- SEE HERE
}

class _pedidoInicio extends State<pedidoInicio> with TickerProviderStateMixin {
  num _defaultValueCounter = 1;
  final cCliente = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: ClsDecoration.appBar(context, "navmesaSeleccionar"),
        drawer: NavDrawer(),
        backgroundColor: ClsColor.tipo1(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              ClsTextStyle.cabeceraBienvenida(
                titulo: vGlobal_Restaurante.tMesa.toString(),
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
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  Text('CLIENTE', style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 20),
                  TextFormField(
                    textAlign: TextAlign.center,
                    controller: cCliente,
                    autofocus: true,
                    inputFormatters: [
                      UpperCaseTextFormatter(),
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ClsColor.tipo4(),
                      enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: ClsColor.tipo2(), width: 2)),
                      focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: ClsColor.tipo1(), width: 2)),
                      labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: ClsColor.tipo5()),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text('PAX', style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Counter(
                    initialValue: _defaultValueCounter,
                    minValue: 1,
                    maxValue: 10,
                    step: 1,
                    decimalPlaces: 0,
                    onChanged: (value) {
                      setState(() {
                        _defaultValueCounter = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              // if (cCliente.text.trim() == "") {
              //   Fluttertoast.showToast(msg: "Ingrese Cliente", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
              //   return;
              // }
              if (_defaultValueCounter < 1) {
                Fluttertoast.showToast(msg: "Cantidad Minima 1", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                return;
              }
              ClsDecoration.showDialogLoading(context);
              if (cCliente.text == "") {
                cCliente.text = " ";
              }
              Map<String, dynamic>? postReg = await postGenerarOrden(cCliente.text, (_defaultValueCounter) as int);
              final codigo = postReg?["codigo"].toString();
              final mensaje = postReg?["mensaje"];
              Fluttertoast.showToast(msg: mensaje ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
              if (codigo == "0") {
                vGlobal_Restaurante.tCliente = cCliente.text;
                vGlobal_Restaurante.iPax = (_defaultValueCounter) as int?;
                vGlobal_Restaurante.iIDPedido = postReg?["iDDetalle"];
                vGlobal_Restaurante.horaPedido = Utils.getDateFormat();
                Navigator.of(context).pop();
                Navigator.pushNamed(context, "navconsumo");
              } else {
                Navigator.of(context).pop();
              }
            },
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(300, 50)),
              backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo3()),
              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )),
            ),
            icon: Icon(Icons.chevron_right_sharp, size: 20, color: ClsColor.tipo1()),
            label: Text("Continuar", style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
