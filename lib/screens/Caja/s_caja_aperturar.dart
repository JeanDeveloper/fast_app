import 'package:fast/providers/providers_Caja.dart';
import 'package:fast/screens/Caja/s_caja_cajaDiaria.dart';

import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Caja.dart' as vGlobal_caja;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class caja_aperturar extends StatefulWidget {
  const caja_aperturar({Key? key}) : super(key: key);
  @override
  _caja_aperturar createState() => new _caja_aperturar();
}

Future<bool> _onWillPop() async {
  return false; //<-- SEE HERE
}

class _caja_aperturar extends State<caja_aperturar> {
  var CImporte = TextEditingController();

  var dropdownEmpleado;
  var dropdowntEmpleado;
  var dropdownCaja;
  var dropdownSucursal;
  var dropdowntCaja;

  @override
  void initState() {
    super.initState();
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
                titulo: "FECHA: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}",
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text('FILTROS', style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
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
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text('Responsable', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: ClsDecoration.inputborder(),
                        enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        contentPadding: const EdgeInsets.all(0),
                        prefixIconColor: ClsColor.tipo5(),
                        prefixIcon: Icon(Icons.man_rounded, size: 16, color: ClsColor.tipo5()),
                      ),
                      items: vGlobal.listEmpleado.map((emp) => DropdownMenuItem<String>(value: "${emp.iMEmpleado}-|-${emp.tNombres}", child: Text(emp.tNombres.toString()))).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownEmpleado = value!.split('-|-')[0];
                          dropdowntEmpleado = value.split('-|-')[1];
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
                      hint: const Text('Seleccione Empleado'),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text('Caja', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: ClsDecoration.inputborder(),
                        enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        contentPadding: const EdgeInsets.all(0),
                        prefixIconColor: ClsColor.tipo5(),
                        prefixIcon: Icon(Icons.fax_rounded, size: 16, color: ClsColor.tipo5()),
                      ),
                      items: vGlobal.listCajas
                          .map(
                            (emp) => DropdownMenuItem<String>(
                              value: "${emp.iMCaja}-|-${emp.iDSucursal}-|-${emp.tNombre}",
                              child: Text(emp.tNombre.toString()),
                            ),
                          )
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownCaja = value!.split('-|-')[0];
                          dropdownSucursal = value.split('-|-')[1];
                          dropdowntCaja = value.split('-|-')[2];
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
                      hint: const Text('Seleccione Caja'),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text('Monto de Apertura', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                    ),
                    TextFormField(
                      controller: CImporte,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      decoration: InputDecoration(
                          filled: true,
                          isDense: true,
                          fillColor: ClsColor.tipo4(),
                          enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                          focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                          disabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo11(), width: 2)),
                          prefix: Text(" S/ ")),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              if (dropdownEmpleado == 0 || dropdownEmpleado == null) {
                Fluttertoast.showToast(msg: "Seleccione Responsable", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                return;
              }
              if (dropdownCaja == 0 || dropdownCaja == null) {
                Fluttertoast.showToast(msg: "Seleccione Caja", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                return;
              }
              if (CImporte.text == "" || CImporte.text == null) {
                Fluttertoast.showToast(msg: "Ingrese monto de apertura", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                return;
              }
              try {
                Map<String, dynamic>? postReg = await CajaAperturar(int.parse(dropdownEmpleado), int.parse(dropdownCaja), int.parse(dropdownSucursal), double.parse(CImporte.text));
                var codigo = postReg?["codigo"].toString();
                var mensaje = postReg?["mensaje"];
                var iMCajadiaria = postReg?["iMCajadiaria"];
                Fluttertoast.showToast(msg: mensaje ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                if (codigo == "0") {
                  vGlobal_caja.iMCaja = int.parse(dropdownCaja);
                  vGlobal_caja.iDCajaDiaria = iMCajadiaria;
                  vGlobal_caja.fFecha = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
                  vGlobal_caja.nInicial = double.parse(CImporte.text);
                  vGlobal_caja.tMResponsable = dropdowntEmpleado;
                  vGlobal_caja.tMCaja = dropdowntCaja;
                  vGlobal_caja.iEstado = 1;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const caja_cajaDiaria()));
                }
              } catch (e) {
                Fluttertoast.showToast(msg: "Error de Conexión", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
              }
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
            label: Text("Guardar", style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }
}
