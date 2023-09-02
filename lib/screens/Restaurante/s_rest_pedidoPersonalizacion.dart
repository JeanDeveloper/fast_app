import 'package:fast/models/Restaurante/m_GetCartaProductos.dart';
import 'package:fast/providers/global_Restaurante.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Restaurante.dart' as vGlobal_Restaurante;
import 'package:fast/widgets/counter.dart';
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class pedidoPersonalizacion extends StatefulWidget {
  const pedidoPersonalizacion({Key? key}) : super(key: key);

  @override
  _pedidoPersonalizacion createState() => new _pedidoPersonalizacion();
}

class _pedidoPersonalizacion extends State<pedidoPersonalizacion> with TickerProviderStateMixin {
  var result_ProductoDetalle = <Widget>[];
  final cObservaciones = TextEditingController();
  final cPrecioEdit = TextEditingController(text: vGlobal_Restaurante.nPrecioUnitario.toString());
  num _defaultValueCounter = 1;
  bool _obscureText = true;
  var CClave = TextEditingController();
  int? tipo = (vGlobal_Restaurante.TipoPedido == "LLEVAR" || vGlobal_Restaurante.TipoPedido == "DELIVERY") ? 2 : 1;
  bool? cortesia = false;
  int? radios1 = 0;
  int? radios2 = 0;
  int? radios3 = 0;
  String? radiosText1 = "";
  String? radiosText2 = "";
  String? radiosText3 = "";
  String? tCoccion = "";
  List multipleSelected = [];

  List<bool> booleans = List.filled(4000, false);
  List<String> textoAgregado = List.filled(4000, "|");
  List<double> montoAgregado = List.filled(4000, 0);

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: ClsColor.tipo1(),
          title: Transform(
            transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_circle_left_rounded, size: 25, color: ClsColor.tipo4()),
                  onPressed: () {
                    Navigator.pushNamed(context, "navproductoSeleccionar");
                  },
                ),
              ],
            ),
          ),
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    vGlobal_Restaurante.TipoPedido == "LLEVAR"
                        ? "PARA LLEVAR"
                        : vGlobal_Restaurante.TipoPedido == "DELIVERY"
                            ? "DELIVERY"
                            : ("${vGlobal_Restaurante.tSalon!} - ${vGlobal_Restaurante.tMesa!}"),
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 14, overflow: TextOverflow.fade, fontWeight: FontWeight.w700, color: ClsColor.tipo4()),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    vGlobal.tUsuario!,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: ClsColor.tipo4()),
                  ),
                ],
              ),
            ),
          ],
        ),
        drawer: NavDrawer(),
        backgroundColor: ClsColor.tipo2(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Expanded(child: form_recuperar(context)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    vGlobal_Restaurante.montoAgregadoSum == null;
    final List<bool> booleans = List.filled(4000, false);
    final List<String> textoAgregado = List.filled(4000, "|");
    final List<double> montoAgregado = List.filled(4000, 0);
    super.initState();

    GenerarPersonalizacion();
  }

  void GenerarPersonalizacion() {
    setState(() {
      result_ProductoDetalle = <Widget>[];
      List<CartaProductoData>? jsonProducto = mGetCartaProductosFromJson(vGlobal_Restaurante.tProductosJson).data;
      int recorreRadio = 0;
      int index1 = jsonProducto!.indexWhere((element) => element.iMProducto == vGlobal_Restaurante.indexProducto);
      if (index1 != -1) {
        vGlobal_Restaurante.indexProducto = index1;
      }
      final int operadores = jsonProducto[vGlobal_Restaurante.indexProducto!].operadores!.length;
      for (int i = 1; i <= operadores; i++) {
        if (jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].iSeleccion == 2) {
          result_ProductoDetalle.add(
            Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].tOperador.toString(),
                  style: TextStyle(
                    color: ClsColor.tipo1(),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                // SingleChildScrollView(
                //   child: Expanded(
                //     child:
                GridView.count(
                  physics: const ScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 4,
                  shrinkWrap: true,
                  children: List.generate(
                    jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades!.length,
                    (index) => CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                      activeColor: ClsColor.tipo1(),
                      dense: true,
                      title: Transform(
                        transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                        child: Text(
                            jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades![index].tPropiedad.toString() +
                                (jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades![index].nPrecioAdicional == 0.00
                                    ? ""
                                    : " (S/ ${jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades![index].nPrecioAdicional!.toStringAsFixed(2)})"),
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: ClsColor.tipo5())),
                      ),
                      value: booleans[index + (i * 100)],
                      onChanged: (value) {
                        setState(() {
                          booleans[index + (i * 100)] = value!;
                          if (multipleSelected.contains(booleans[index + (i * 100)])) {
                            multipleSelected.remove(booleans[index + (i * 100)]);
                          } else {
                            multipleSelected.add(booleans[index + (i * 100)]);
                          }
                          if (booleans[index + (i * 100)] == true) {
                            textoAgregado[index + (i * 100)] = (jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades![index].tPropiedad! +
                                    (jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades![index].nPrecioAdicional! == 0.00
                                        ? ""
                                        : " (S/ ${jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades![index].nPrecioAdicional!.toStringAsFixed(2)})"))
                                .trim();
                            montoAgregado[index + (i * 100)] = jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades![index].nPrecioAdicional!;
                          } else {
                            textoAgregado[index + (i * 100)] = "|";
                            montoAgregado[index + (i * 100)] = 0;
                          }
                          double montoAgregadoSum = montoAgregado.sum;
                          vGlobal_Restaurante.montoAgregadoSum = montoAgregadoSum;
                          if (cortesia == true) {
                            vGlobal_Restaurante.iPrecuentaPersonalizacion = 0.00;
                          } else {
                            vGlobal_Restaurante.iPrecuentaPersonalizacion = ((vGlobal_Restaurante.nPrecioUnitario! + montoAgregadoSum) * _defaultValueCounter);
                          }
                          GenerarPersonalizacion();
                        });
                      },
                    ),
                  ),
                ),
                //   ),
                // ),
              ],
            ),
          );
        }
        if (jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].iSeleccion == 1) {
          if (recorreRadio == 0) {
            result_ProductoDetalle.add(
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].tOperador.toString(),
                    style: TextStyle(
                      color: ClsColor.tipo1(),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // SingleChildScrollView(
                  //   child: Expanded(
                  //     child:
                  GridView.count(
                    physics: const ScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 3.5,
                    // childAspectRatio: MediaQuery.of(context).size.height / 200,
                    shrinkWrap: true,
                    children: List.generate(
                      jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades!.length,
                      (index) => RadioListTile<int>(
                        activeColor: ClsColor.tipo1(),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                        groupValue: radios1,
                        value: jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades![index].iMPropiedad!,
                        title: Transform(
                          transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                          child: Text(
                            jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades![index].tPropiedad.toString(),
                          ),
                        ),
                        onChanged: (newvalue) {
                          setState(() {
                            radios1 = newvalue!;
                            radiosText1 =
                                ("${jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].tOperador!}: ${jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades![index].tPropiedad!}");
                            GenerarPersonalizacion();
                          });
                        },
                      ),
                    ),
                  ),
                  //   ),
                  // ),
                ],
              ),
            );
          }
          if (recorreRadio == 1) {
            result_ProductoDetalle.add(
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].tOperador.toString(),
                    style: TextStyle(
                      color: ClsColor.tipo1(),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // SingleChildScrollView(
                  //   child: Expanded(
                  //     child:
                  GridView.count(
                    physics: const ScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 3.5,
                    // childAspectRatio: MediaQuery.of(context).size.height / 200,
                    shrinkWrap: true,
                    children: List.generate(
                      jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades!.length,
                      (index) => RadioListTile<int>(
                        activeColor: ClsColor.tipo1(),
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                        groupValue: radios2,
                        value: jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades![index].iMPropiedad!,
                        title: Transform(
                          transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                          child: Text(
                            jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades![index].tPropiedad.toString(),
                          ),
                        ),
                        onChanged: (newvalue) {
                          setState(() {
                            radios2 = newvalue!;
                            radiosText2 =
                                ("${jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].tOperador!}: ${jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades![index].tPropiedad!}");
                            GenerarPersonalizacion();
                          });
                        },
                      ),
                    ),
                  ),
                  //   ),
                  // ),
                ],
              ),
            );
          }
          if (recorreRadio == 2) {
            result_ProductoDetalle.add(
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].tOperador.toString(),
                    style: TextStyle(
                      color: ClsColor.tipo1(),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // SingleChildScrollView(
                  //   child: Expanded(
                  //     child:
                  GridView.count(
                    physics: const ScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 4,
                    // childAspectRatio: MediaQuery.of(context).size.height / 200,
                    shrinkWrap: true,
                    children: List.generate(
                      jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades!.length,
                      (index) => RadioListTile<int>(
                        activeColor: ClsColor.tipo1(),
                        dense: true,
                        groupValue: radios3,
                        value: jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades![index].iMPropiedad!,
                        title: Transform(
                          transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
                          child: Text(
                            jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades![index].tPropiedad.toString(),
                          ),
                        ),
                        onChanged: (newvalue) {
                          setState(() {
                            radios3 = newvalue!;
                            radiosText3 =
                                ("${jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].tOperador!}: ${jsonProducto[vGlobal_Restaurante.indexProducto!].operadores![i - 1].propiedades![index].tPropiedad!}");
                            GenerarPersonalizacion();
                          });
                        },
                      ),
                    ),
                  ),
                  //   ),
                  // ),
                ],
              ),
            );
          }
          recorreRadio = recorreRadio + 1;
        }
      }
    });
  }

  _aprobar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                        child: Text('Clave de Validación', style: TextStyle(color: ClsColor.tipo5(), fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Container(
                          width: 250,
                          child: TextFormField(
                            controller: CClave,
                            autofocus: true,
                            maxLength: 4,
                            obscureText: _obscureText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 24, letterSpacing: 5, fontWeight: FontWeight.w500),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                                filled: true,
                                isDense: true,
                                fillColor: ClsColor.tipo4(),
                                suffixIconColor: ClsColor.tipo5(),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureText == false ? Icons.visibility : Icons.visibility_off, size: 16, color: ClsColor.tipo5()),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                      Navigator.pop(context);
                                      _aprobar(context);
                                    });
                                  },
                                ),
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
                        _EditarPrecio(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: ClsColor.tipo4(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(100, 30),
                      ),
                      icon: Icon(Icons.keyboard_return_rounded, size: 15, color: ClsColor.tipo5()),
                      label: Text("Cerrar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: ClsColor.tipo5())),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (CClave.text != vGlobal.tCodigoValidacion) {
                          Fluttertoast.showToast(
                            msg: "Clave de Anulación Incorrecta",
                            gravity: ToastGravity.CENTER,
                            backgroundColor: ClsColor.tipo6(),
                            textColor: ClsColor.tipo4(),
                          );
                          return;
                        }
                        setState(() {
                          vGlobal_Restaurante.nPrecioUnitario = double.parse(cPrecioEdit.text);

                          double montoAgregadoSum = montoAgregado.sum;
                          vGlobal_Restaurante.montoAgregadoSum == montoAgregado.sum;
                          if (cortesia == true) {
                            vGlobal_Restaurante.iPrecuentaPersonalizacion = 0.00;
                          } else {
                            vGlobal_Restaurante.iPrecuentaPersonalizacion = ((vGlobal_Restaurante.nPrecioUnitario! + montoAgregadoSum) * _defaultValueCounter);
                          }
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: ClsColor.tipo1(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(100, 30),
                      ),
                      icon: const Icon(Icons.check, size: 15),
                      label: const Text("Aprobar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
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

  _EditarPrecio(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text("Precio Unitario: ", textAlign: TextAlign.center, style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
                    Expanded(
                      child: TextFormField(
                        controller: cPrecioEdit,
                        autofocus: true,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                        decoration: const InputDecoration(isDense: true, prefix: Text(" S/ ")),
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
                        foregroundColor: Colors.white,
                        backgroundColor: ClsColor.tipo8(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(100, 30),
                      ),
                      icon: const Icon(Icons.close_outlined, size: 15),
                      label: const Text("Cerrar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          if (cPrecioEdit.text.length == 0) {
                            Fluttertoast.showToast(
                              msg: "Ingrese Precio",
                              gravity: ToastGravity.CENTER,
                              backgroundColor: ClsColor.tipo6(),
                              textColor: ClsColor.tipo4(),
                            );
                            return;
                          }

                          if (vGlobal_Restaurante.nPrecioUnitarioBase! > double.parse(cPrecioEdit.text)) {
                            Navigator.pop(context);
                            CClave.text = "";
                            _aprobar(context);
                            // Fluttertoast.showToast(
                            //   msg: "Precio debe ser mayor o igual al precio base",
                            //   gravity: ToastGravity.CENTER,
                            //   backgroundColor: ClsColor.tipo6(),
                            //   textColor: ClsColor.tipo4(),
                            // );
                            return;
                          }
                          vGlobal_Restaurante.nPrecioUnitario = double.parse(cPrecioEdit.text);

                          double montoAgregadoSum = montoAgregado.sum;
                          vGlobal_Restaurante.montoAgregadoSum == montoAgregado.sum;
                          if (cortesia == true) {
                            vGlobal_Restaurante.iPrecuentaPersonalizacion = 0.00;
                          } else {
                            vGlobal_Restaurante.iPrecuentaPersonalizacion = ((vGlobal_Restaurante.nPrecioUnitario! + montoAgregadoSum) * _defaultValueCounter);
                          }
                          Navigator.pop(context);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: ClsColor.tipo1(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(100, 30),
                      ),
                      icon: const Icon(Icons.save_rounded, size: 15),
                      label: const Text("Guardar", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  ],
                )
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
              child: Column(
                children: [ 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text((vGlobal_Restaurante.tSubCategoria == "" ? "" : "${vGlobal_Restaurante.tSubCategoria} - ") + vGlobal_Restaurante.tProducto.toString(),
                          style: TextStyle(color: ClsColor.tipo5(), fontSize: 16, fontWeight: FontWeight.w700)),
                      Row(
                        children: [
                          Text("S/ ${(vGlobal_Restaurante.nPrecioUnitario)?.toStringAsFixed(2)}", style: TextStyle(color: ClsColor.tipo1(), fontSize: 25, fontWeight: FontWeight.w700)),
                          if (vGlobal_Restaurante.nPrecioUnitarioBase == vGlobal_Restaurante.nPrecioUnitario) ...[
                            IconButton(
                              onPressed: () {
                                cPrecioEdit.text = "";
                                _EditarPrecio(context);
                              },
                              icon: const Icon(Icons.edit, size: 22),
                              //color: ClsColor.tipo3(),
                            )
                          ] else ...[
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  vGlobal_Restaurante.nPrecioUnitario = vGlobal_Restaurante.nPrecioUnitarioBase;

                                  double montoAgregadoSum = montoAgregado.sum;
                                  vGlobal_Restaurante.montoAgregadoSum == montoAgregado.sum;
                                  if (cortesia == true) {
                                    vGlobal_Restaurante.iPrecuentaPersonalizacion = 0.00;
                                  } else {
                                    vGlobal_Restaurante.iPrecuentaPersonalizacion = ((vGlobal_Restaurante.nPrecioUnitario! + montoAgregadoSum) * _defaultValueCounter);
                                  }
                                });
                              },
                              icon: const Icon(Icons.replay_circle_filled_rounded, size: 20),
                            )
                          ],
                        ],
                      ),
                      // const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            margin: const EdgeInsets.only(right: 10, top: 0, bottom: 0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            // elevation: 3,
                            // child: Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (vGlobal_Restaurante.tImagenProducto == "" || vGlobal_Restaurante.tImagenProducto == null) ...[
                                  Container(
                                    width: 160,
                                    color: ClsColor.tipo4(),
                                    padding: const EdgeInsets.all(5),
                                    child: const Image(image: ExactAssetImage('assets/images/foodempty.jpg'), fit: BoxFit.fitHeight),
                                  ),
                                ] else ...[
                                  Container(
                                    width: 160,
                                    color: ClsColor.tipo4(),
                                    padding: const EdgeInsets.all(5),
                                    child: Image(image: NetworkImage(vGlobal_Restaurante.tImagenProducto ?? ""), fit: BoxFit.fill),
                                  ),
                                ],
                              ],
                            ),
                            // ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (vGlobal_Restaurante.TipoPedido == "MESA") ...[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: tipo == 1 ? ClsColor.tipo1() : ClsColor.tipo4(),
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      ),
                                      // child: Expanded(
                                      child: RadioListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                        activeColor: tipo == 1 ? ClsColor.tipo4() : ClsColor.tipo1(),
                                        title: Text(
                                          "Mesa",
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: tipo == 1 ? ClsColor.tipo4() : ClsColor.tipo1()),
                                        ),
                                        value: 1,
                                        groupValue: tipo,
                                        onChanged: (value) {
                                          setState(() {
                                            tipo = value as int?;
                                          });
                                        },
                                      ),
                                      // ),
                                    ),
                                  ),
                                ],
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: tipo == 2 ? ClsColor.tipo1() : ClsColor.tipo4(),
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    ),
                                    // child: Expanded(
                                    child: RadioListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                      activeColor: tipo == 2 ? ClsColor.tipo4() : ClsColor.tipo1(),
                                      title: Text(
                                        "Para Llevar",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: tipo == 2 ? ClsColor.tipo4() : ClsColor.tipo1(),
                                        ),
                                      ),
                                      value: 2,
                                      groupValue: tipo,
                                      onChanged: (value) {
                                        setState(() {
                                          tipo = value;
                                        });
                                      },
                                    ),
                                    // ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: cortesia == true ? ClsColor.tipo1() : ClsColor.tipo4(),
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  ),
                                  // child: Expanded(
                                  child: CheckboxListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity, vertical: VisualDensity.minimumDensity),
                                    activeColor: ClsColor.tipo1(),
                                    title: Text(
                                      "Cortesia",
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: cortesia == true ? ClsColor.tipo4() : ClsColor.tipo1()),
                                    ),
                                    value: cortesia,
                                    onChanged: (newValue) {
                                      setState(() {
                                        cortesia = newValue;
                                        double montoAgregadoSum = montoAgregado.sum;
                                        vGlobal_Restaurante.montoAgregadoSum == montoAgregado.sum;
                                        if (cortesia == true) {
                                          vGlobal_Restaurante.iPrecuentaPersonalizacion = 0.00;
                                        } else {
                                          vGlobal_Restaurante.iPrecuentaPersonalizacion = ((vGlobal_Restaurante.nPrecioUnitario! + montoAgregadoSum) * _defaultValueCounter);
                                        }
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                                  ),
                                  // ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Counter(
                        initialValue: _defaultValueCounter,
                        minValue: 1,
                        maxValue: 20,
                        step: 1,
                        decimalPlaces: 0,
                        onChanged: (value) {
                          setState(() {
                            _defaultValueCounter = value;
                            double montoAgregadoSum = montoAgregado.sum;
                            vGlobal_Restaurante.montoAgregadoSum == montoAgregado.sum;

                            if (cortesia == true) {
                              vGlobal_Restaurante.iPrecuentaPersonalizacion = 0.00;
                            } else {
                              vGlobal_Restaurante.iPrecuentaPersonalizacion = ((vGlobal_Restaurante.nPrecioUnitario! + montoAgregadoSum) * _defaultValueCounter);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  // Column(children: result_ProductoDetalle),
                  SizedBox(child: Column(children: result_ProductoDetalle)),
                  const SizedBox(height: 10),
                  Text("OBSERVACIONES", style: TextStyle(color: ClsColor.tipo1(), fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: cObservaciones,
                    maxLines: 2,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: ClsColor.tipo4(),
                      enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: ClsColor.tipo2(), width: 2)),
                      focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(10)), borderSide: BorderSide(color: ClsColor.tipo1(), width: 2)),
                      hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 20, color: ClsColor.tipo6()),
                      labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: ClsColor.tipo5()),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              // ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () async {
              // Navigator.pushNamed(context, "navnuevaOrden");
              String tAgregado = "";
              String tRadio = "";
              String tObservacion = "";
              String totalObservacion = "";
              tAgregado = textoAgregado.join(", ").toString().replaceAll("|,", "").replaceAll("|", "").trim();
              if (tAgregado != "") {
                tAgregado = "AGREGADOS: ${textoAgregado.join(", ").toString().replaceAll("|,", "").replaceAll("|", "").trim()}\n";
              } else {
                tAgregado = "";
              }
              tRadio =
                  (radiosText1 == "" ? "" : ("${radiosText1.toString().trim()}\n")) + (radiosText2 == "" ? "" : ("${radiosText2.toString().trim()}\n")) + (radiosText3 == "" ? "" : ("${radiosText3.toString().trim()}\n"));
              tObservacion = cObservaciones.text.trim();
              if (tObservacion != "") {
                tObservacion = "OBSERVACION: ${cObservaciones.text.trim()}";
              } else {
                tObservacion = "";
              }
              totalObservacion = tAgregado + tRadio + tObservacion;
              String tProductoExtra = "";

              if (cortesia == true && tipo == 1) {
                tProductoExtra = "(CORTESIA)";
              }
              if (vGlobal_Restaurante.TipoPedido == "MESA") {
                if (cortesia == false && tipo == 2) {
                  tProductoExtra = "(PARA LLEVAR)";
                }
                if (cortesia == true && tipo == 2) {
                  tProductoExtra = "(PARA LLEVAR + CORTESIA)";
                }
              } else {
                if (cortesia == false && tipo == 2) {
                  tProductoExtra = "";
                }
                if (cortesia == true && tipo == 2) {
                  tProductoExtra = "(CORTESIA)";
                }
              }

              double nPrecioAdicional = 0.00;
              vGlobal_Restaurante.montoAgregadoSum = montoAgregado.sum;
              if (vGlobal_Restaurante.montoAgregadoSum == null) {
                nPrecioAdicional = 0.00;
              } else {
                nPrecioAdicional = vGlobal_Restaurante.montoAgregadoSum!;
              }

              Map<String, dynamic> detalle = {
                "iMProducto": vGlobal_Restaurante.iMProducto,
                "tProducto": "${vGlobal_Restaurante.tProducto} $tProductoExtra",
                "nPrecioUnitario": vGlobal_Restaurante.nPrecioUnitario!.toStringAsFixed(2),
                "nPrecioAdicional": nPrecioAdicional.toStringAsFixed(2),
                "nCantidad": _defaultValueCounter,
                "nTotal": ((vGlobal_Restaurante.nPrecioUnitario! + nPrecioAdicional) * _defaultValueCounter).toStringAsFixed(2), // vGlobal_Restaurante.iPrecuentaPersonalizacion!.toStringAsFixed(2),
                "lCortesia": cortesia,
                "iTipoConsumo": tipo,
                "tObservacion": totalObservacion.toString().trim()
              };
              vGlobal_Restaurante.listPrecuenta.add(detalle);
              print(vGlobal_Restaurante.listPrecuenta);
              Navigator.pushNamed(context, "navnuevaOrden");
            },
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(300, 50)),
              backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo3()),
              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )),
            ),
            icon: Icon(Icons.chevron_right_rounded, size: 20, color: ClsColor.tipo1()),
            label: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Continuar", style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text("S/ ${vGlobal_Restaurante.iPrecuentaPersonalizacion!.toStringAsFixed(2)}", style: TextStyle(color: ClsColor.tipo5(), fontSize: 20, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
