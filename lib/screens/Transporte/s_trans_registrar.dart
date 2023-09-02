import 'dart:convert';
import 'package:fast/models/Transporte/m_GetCiudad.dart';
import 'package:fast/models/Transporte/m_GetProgramacion.dart';
import 'package:fast/providers/providers_Transporte.dart';
import 'package:fast/screens/Transporte/s_trans_resultado.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fast/providers/providers_Restaurante.dart';
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Transporte.dart' as vGlobal_transporte;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class trans_registrarBoleto extends StatefulWidget {
  const trans_registrarBoleto({Key? key}) : super(key: key);
  @override
  _trans_registrarBoleto createState() => new _trans_registrarBoleto();
}

Future<bool> _onWillPop() async {
  return false; //<-- SEE HERE
}

class _trans_registrarBoleto extends State<trans_registrarBoleto> {
  final CFecha = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  var dropdownCiudadOrigen;
  var dropdownCiudadDestino;
  var selectedValue = 1;

  @override
  void initState() {
    super.initState();
    vGlobal_transporte.fecha = _selectedDate.toString().substring(0, 10);
    CFecha.text = DateFormat('dd-MM-yyyy').format(_selectedDate!).toString();
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
                titulo: 'Registrar Boleto de Viaje',
                subtitulo: "Seleccione los filtros",
                detalle: '',
              ),
              Expanded(child: form_recuperar(context)),
            ],
          ),
        ),
      ),
    );
  }

  selectDate() async {
    DateTime? pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 250,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoButton(
                    child: const Text('Aceptar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      vGlobal_transporte.fecha = _selectedDate.toString().substring(0, 10);
                      CFecha.text = DateFormat('dd-MM-yyyy').format(_selectedDate!).toString();
                    },
                  ),
                ],
              ),
              const Divider(
                height: 0,
                thickness: 1,
              ),
              Expanded(
                child: Container(
                  child: CupertinoDatePicker(
                    initialDateTime: _selectedDate,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (DateTime dateTime) {
                      _selectedDate = dateTime;
                    },
                  ),
                ),
              ),
            ],
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
          Text('FILTROS', style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text('Fecha', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                    ),
                    TextField(
                      onTap: () => selectDate(),
                      controller: CFecha,
                      enabled: true,
                      keyboardType: TextInputType.none,
                      enableInteractiveSelection: false,
                      focusNode: FocusNode(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: ClsDecoration.inputborder(),
                        enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        contentPadding: const EdgeInsets.all(0),
                        labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: ClsColor.tipo1()),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        prefixIconColor: ClsColor.tipo5(),
                        prefixIcon: Icon(Icons.calendar_month_rounded, size: 16, color: ClsColor.tipo5()),
                        suffixIconColor: ClsColor.tipo5(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text('Origen', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
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
                        prefixIcon: Icon(Icons.directions_bus_rounded, size: 16, color: ClsColor.tipo5()),
                      ),
                      items: vGlobal_transporte.listCiudad
                          .map((ciudad) => DropdownMenuItem<String>(
                                value: "${ciudad.iMCiudad}|${ciudad.tDescripcion}",
                                child: Text(ciudad.tDescripcion.toString()),
                              ))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownCiudadOrigen = value!.split("|")[0];
                          vGlobal_transporte.tCiudadOrigen = value.split("|")[1];
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
                      hint: const Text('Seleccione Origen'),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text('Destino', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
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
                        prefixIcon: Icon(Icons.directions_bus_rounded, size: 16, color: ClsColor.tipo5()),
                      ),
                      items: vGlobal_transporte.listCiudad
                          .map((ciudad) => DropdownMenuItem<String>(
                                value: "${ciudad.iMCiudad}|${ciudad.tDescripcion}",
                                child: Text(ciudad.tDescripcion.toString()),
                              ))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownCiudadDestino = value!.split("|")[0];
                          vGlobal_transporte.tCiudadDestino = value.split("|")[1];
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
                      hint: const Text('Seleccione Destino'),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () async {
              if (CFecha == "" || CFecha == null) {
                Fluttertoast.showToast(msg: "Seleccione Fecha", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                return;
              }
              if (dropdownCiudadOrigen == 0 || dropdownCiudadOrigen == null) {
                Fluttertoast.showToast(msg: "Seleccione Ciudad Origen", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                return;
              }
              if (dropdownCiudadDestino == 0 || dropdownCiudadDestino == null) {
                Fluttertoast.showToast(msg: "Seleccione Ciudad Destino", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                return;
              }
              try {
                final GetProgramacion? getProgramacion = await getlistProgramacion(vGlobal_transporte.fecha.toString(), int.parse(dropdownCiudadOrigen), int.parse(dropdownCiudadDestino));
                var datagetProgramacion = jsonEncode(getProgramacion);
                var tJsongetProgramacion = getProgramacionFromJson(datagetProgramacion.toString());
                if (tJsongetProgramacion.code == 0) {
                  if (tJsongetProgramacion.data.isNotEmpty) {
                    vGlobal_transporte.listProgramacion = tJsongetProgramacion.data;
                    vGlobal_transporte.fecha = tJsongetProgramacion.data[0].tFecha;
                    vGlobal_transporte.ruta = tJsongetProgramacion.data[0].tRuta;
                    vGlobal_transporte.iCiudadOrigen = int.parse(dropdownCiudadOrigen);
                    vGlobal_transporte.iCiudadDestino = int.parse(dropdownCiudadDestino);
                    Fluttertoast.showToast(msg: tJsongetProgramacion.message, gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const trans_resultadoBoleto(),
                      ),
                    );
                  } else {
                    Fluttertoast.showToast(msg: tJsongetProgramacion.message /* "No se encontraron registros"*/, gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                  }
                } else {
                  Fluttertoast.showToast(msg: tJsongetProgramacion.message, gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
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
            icon: Icon(Icons.search, size: 20, color: ClsColor.tipo4()),
            label: Text("Buscar Disponibilidad", style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }
}
