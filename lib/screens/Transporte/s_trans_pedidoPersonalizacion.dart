import 'dart:convert';
import 'package:fast/models/Comprobante/m_GetNumeroDoc.dart';
import 'package:fast/models/Comprobante/m_GetSerieByTipo.dart';
import 'package:fast/models/Maestro/m_GetClienteBuscarPorNroDoc.dart';
import 'package:fast/models/Maestro/m_GetTipoDocumentoIdentidad.dart';
import 'package:fast/models/Transporte/m_GetObtenerDatosBoleto.dart';
import 'package:fast/providers/providers.dart';
import 'package:fast/providers/providers_Comprobante.dart';
import 'package:fast/providers/providers_Transporte.dart';
import 'package:fast/screens/Transporte/s_trans_cobrar.dart';
import 'package:fast/screens/Transporte/s_trans_seleccionarAsiento.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:fast/providers/global_Transporte.dart' as vGlobal_transporte;
import 'package:fast/providers/global_Comprobante.dart' as vGlobal_comprobante;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:fast/providers/Funciones.dart';

class trans_pedidoPersonalizacion extends StatefulWidget {
  final String TipoAcceso;
  const trans_pedidoPersonalizacion({Key? key, required this.TipoAcceso}) : super(key: key);
  @override
  _trans_pedidoPersonalizacion createState() => new _trans_pedidoPersonalizacion();
}

Future<bool> _onWillPop() async {
  return false;
}

class _trans_pedidoPersonalizacion extends State<trans_pedidoPersonalizacion> {
  var CPasajeroDoc = TextEditingController();
  var CPasajero = TextEditingController();
  var CClienteDoc = TextEditingController();
  var CCliente = TextEditingController();
  var CClienteDir = TextEditingController();
  var CDescuento = TextEditingController();
  var CSerieNumero = TextEditingController();
  String dropdownvalueSeries = "";
  String dropdownvalueNumero = "";
  int iMPasajero = 0, iMCliente = 0;
  String dropdownTipoDoc = "1";
  int TipoDocDigitos = 8;
  String tDescuento = "0";
  bool aplica = false;
  bool iEstadoDescuento = true;
  int tipo = 1;
  late List<SerieData?>? aSeries;
  late List<NumeroData?>? aNumero;
  bool EnabledRuc = false;
  bool EnableReserva = false;
  var resultSerie;
  var resultNumero;
  bool precargaReserva = false;

  bool enabledPsjTipoDoc = true;
  bool enabledPsjNroDoc = true;
  bool enabledPsjBusqueda = true;
  bool enabledBoleta = true;
  bool enabledFactura = true;
  bool enabledReserva = true;

  @override
  void initState() {
    super.initState();
    if (widget.TipoAcceso == "Nuevo") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        LoadSerie();
      });
    }
    if (widget.TipoAcceso == "Reserva") {
      EnableReserva = true;
      aplica = false;
      CDescuento.text = "";
      tDescuento = "0";
      iEstadoDescuento = true;
      EnabledRuc = false;
      resultSerie = null;
      resultNumero = null;
      tipo = 3;
      LoadDatosBoleto();
      precargaReserva = true;
      enabledPsjTipoDoc = false;
      enabledPsjNroDoc = false;
      enabledPsjBusqueda = false;
      enabledBoleta = false;
      enabledFactura = false;
      enabledReserva = false;
    }
  }

  LoadDatosBoleto() async {
    final GetObtenerDatosBoleto? Postlog = await getDatosBoleto();
    var dataData = jsonEncode(Postlog);
    var tJsonData = getObtenerDatosBoletoFromJson(dataData.toString());
    if (tJsonData.code == 0) {
      dropdownTipoDoc = tJsonData.data[0].tPasajeroTipoDoc;
      CPasajeroDoc.text = tJsonData.data[0].tPasajeroDoc;
      CPasajero.text = tJsonData.data[0].tPasajero;
      iMPasajero = tJsonData.data[0].iMPasajero;
    }
  }

  LoadSerie() async {
    aSeries = await getSerieComprobante((tipo == 1 ? "03" : "01"), true);
    if (aSeries != null) {
      if (aSeries!.length > 0) {
        GenerarSerie();
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          if (aSeries![0]!.documentoSerie != "") {
            LoadNumero();
          }
        });
      }
    }
  }

  LoadNumero() async {
    aNumero = await getNumeroComprobante((tipo == 1 ? "03" : "01"), vGlobal_comprobante.documentoSerie);
    setState(() {
      if (aNumero != null) {
        if (aNumero!.length > 0) {
          final result = GenerarNumero();
        }
      }
    });
  }

  Widget GenerarSerie() {
    resultSerie = Flexible(
      child: Container(
        //padding: const EdgeInsets.symmetric(horizontal: 15),
        child: FutureBuilder<List<SerieData>?>(
          future: getSerieComprobante((tipo == 1 ? "03" : "01"), true),
          builder: (BuildContext context, AsyncSnapshot<List<SerieData>?> snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            return DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: ClsDecoration.inputborder(),
                  enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                  focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                  contentPadding: const EdgeInsets.all(0),
                  prefixIconColor: ClsColor.tipo5(),
                  prefixIcon: Icon(Icons.format_list_numbered_rtl_rounded, size: 16, color: ClsColor.tipo5()),
                ),
                value: snapshot.data![0].documentoSerie ?? "",
                items: snapshot.data?.map((Serie) => DropdownMenuItem<String>(value: Serie.documentoSerie, child: Text(Serie.documentoSerie.toString()))).toList(),
                isExpanded: true,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  decorationStyle: TextDecorationStyle.dotted,
                  decorationColor: Colors.white,
                  color: ClsColor.tipo1(),
                  backgroundColor: ClsColor.tipo4(),
                ),
                onChanged: (String? value) async {
                  setState(() {
                    dropdownvalueSeries = value!;
                    vGlobal_comprobante.documentoSerie = dropdownvalueSeries;
                    vGlobal_comprobante.formatoPdf = snapshot.data![0].formatoPdf!;
                    LoadNumero();
                  });
                  //tipoNumero();
                },
              ),
            );
          },
        ),
      ),
    );
    return resultSerie;
  }

  Widget GenerarNumero() {
    resultNumero = Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: FutureBuilder<List<NumeroData>?>(
          future: getNumeroComprobante((tipo == 1 ? "03" : "01"), vGlobal_comprobante.documentoSerie),
          builder: (BuildContext context, AsyncSnapshot<List<NumeroData>?> snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            NumberFormat formatter = NumberFormat("00000000");
            int numero = int.parse(snapshot.data![0].codigo ?? "0");
            CSerieNumero.text = formatter.format(numero).toString();
            vGlobal_comprobante.documentoNumero = formatter.format(numero).toString();
            return TextFormField(
              controller: CSerieNumero,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                filled: true,
                isDense: true,
                enabled: false,
                fillColor: ClsColor.tipo2(),
                disabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo11(), width: 2)),
              ),
            );
          },
        ),
      ),
    );
    return resultNumero;
  }

  void updateText(String descuento, bool gratuita) {
    setState(() {
      double iDescuento = double.parse(descuento);
      if (gratuita == true) {
        vGlobal_transporte.iPrecioFinal = 0;
        vGlobal_transporte.iDescuento = 0;
        iEstadoDescuento = false;
        CDescuento.text = "";
      } else {
        if (vGlobal_transporte.iPrecioInicial < iDescuento) {
          CDescuento.text = vGlobal_transporte.iPrecioInicial.toStringAsFixed(0);
          iDescuento = vGlobal_transporte.iPrecioInicial;
          vGlobal_transporte.iDescuento = vGlobal_transporte.iPrecioInicial;
        }
        vGlobal_transporte.iDescuento = iDescuento;
        vGlobal_transporte.iPrecioFinal = vGlobal_transporte.iPrecioInicial - iDescuento;
        iEstadoDescuento = true;
      }
    });
  }

  static _AnularReserva(BuildContext context) async {
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
                child: Text('¿Esta seguro de Anular la Reserva?', style: TextStyle(color: ClsColor.tipo6(), fontSize: 12, fontWeight: FontWeight.w700)),
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
                        Map<String, dynamic>? postReg = await AnularReserva();
                        final codigo = postReg?["codigo"].toString();
                        final mensaje = postReg?["mensaje"];
                        Fluttertoast.showToast(msg: mensaje ?? "Error Interno", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                        if (codigo == "0") {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => trans_seleccionarAsiento()));
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
        appBar: ClsDecoration.appBar(context, "navtrans_seleccionarAsiento"),
        drawer: NavDrawer(),
        backgroundColor: ClsColor.tipo1(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              ClsTextStyle.cabeceraBienvenida(
                titulo: 'FECHA : ${vGlobal_transporte.fecha}',
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          Text('Completar Datos', style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
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
                      child: Text('Tipo de Documento', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                    ),
                    FutureBuilder<List<TipoDocumentoIdentidadData>?>(
                      future: loadTipoDocumentoIdentidad('RUC'),
                      builder: (BuildContext context, AsyncSnapshot<List<TipoDocumentoIdentidadData>?> snapshot) {
                        if (!snapshot.hasData) return const CircularProgressIndicator();
                        return DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: ClsDecoration.inputborder(),
                              enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                              focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                              contentPadding: const EdgeInsets.all(0),
                              prefixIconColor: ClsColor.tipo5(),
                              prefixIcon: Icon(Icons.badge_rounded, size: 16, color: ClsColor.tipo5()),
                            ),
                            value: dropdownTipoDoc,
                            items: snapshot.data
                                ?.map((tipodoc) => DropdownMenuItem<String>(
                                      value: tipodoc.iMTipoDocumentoIdentidad.toString(),
                                      child: Text(tipodoc.tDescripcion.replaceAll("\r\n", "").toString()),
                                    ))
                                .toList(),
                            onChanged: enabledPsjTipoDoc == false
                                ? null
                                : (String? value) {
                                    setState(
                                      () {
                                        dropdownTipoDoc = value!;
                                        if (dropdownTipoDoc == "0") {
                                          TipoDocDigitos = 15; // OTROS
                                        }
                                        if (dropdownTipoDoc == "1") {
                                          TipoDocDigitos = 8; // DNI
                                        }
                                        if (dropdownTipoDoc == "4") {
                                          TipoDocDigitos = 12; // CARNET DE EXTRANJERIA
                                        }
                                        if (dropdownTipoDoc == "7") {
                                          TipoDocDigitos = 12; // PASAPORTE
                                        }
                                        CPasajeroDoc.text = "";
                                        CPasajero.text = "";
                                        vGlobal_transporte.tPasajeroDoc = "";
                                        vGlobal_transporte.tPasajero = "";
                                        iMPasajero = 0;
                                      },
                                    );
                                  },
                            isExpanded: true,
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              decorationStyle: TextDecorationStyle.dotted,
                              decorationColor: Colors.white,
                              color: ClsColor.tipo1(),
                              backgroundColor: ClsColor.tipo4(),
                            ),
                            hint: const Text('Seleccione Tipo de Documento'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Text('Nro. Documento Pasajero', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: TextFormField(
                            enabled: enabledPsjNroDoc,
                            controller: CPasajeroDoc,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            maxLength: TipoDocDigitos,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              return (value != null && value.length == TipoDocDigitos) ? null : 'Nro. Digitos permitido $TipoDocDigitos';
                            },
                            decoration: InputDecoration(
                              filled: true,
                              isDense: true,
                              fillColor: ClsColor.tipo4(),
                              border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                              enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                              focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                              prefixIcon: Icon(Icons.numbers_rounded, color: ClsColor.tipo5()),
                            ),
                            onChanged: (value) async {
                              CPasajero.text = "";
                              vGlobal_transporte.tPasajeroDoc = "";
                              vGlobal_transporte.tPasajero = "";
                              iMPasajero = 0;
                              if (value.length == TipoDocDigitos) {
                                final GetClienteBuscarPorNroDoc? Postlog = await getClienteBuscarPorNroDoc(CPasajeroDoc.text, 1);
                                var dataClienteBuscar = jsonEncode(Postlog);
                                var tJsonClienteBuscar = getClienteBuscarPorNroDocFromJson(dataClienteBuscar.toString());
                                if (tJsonClienteBuscar.data.length > 0) {
                                  // ignore: use_build_context_synchronously
                                  FocusScope.of(context).unfocus();
                                  iMPasajero = tJsonClienteBuscar.data[0].iMCliente;
                                  CPasajero.text = tJsonClienteBuscar.data[0].tNombre == null ? "" : tJsonClienteBuscar.data[0].tNombre;
                                  vGlobal_transporte.tPasajero = tJsonClienteBuscar.data[0].tNombre.toString();
                                  vGlobal_transporte.tPasajeroDoc = tJsonClienteBuscar.data[0].tNroDocumento.toString();
                                  setState(() {
                                    if (tJsonClienteBuscar.code != 200) {
                                      dropdownTipoDoc = tJsonClienteBuscar.data[0].iMTipoDocumentoIdentidad.toString();
                                    } else {
                                      dropdownTipoDoc = "1";
                                    }
                                  });
                                  if (tipo == 1) {
                                    iMCliente = tJsonClienteBuscar.data[0].iMCliente;
                                    CClienteDoc.text = CPasajeroDoc.text;
                                    CCliente.text = tJsonClienteBuscar.data[0].tNombre.toString() == null ? "" : tJsonClienteBuscar.data[0].tNombre.toString();
                                    CClienteDir.text = tJsonClienteBuscar.data[0].tDireccion.toString() == null ? "" : tJsonClienteBuscar.data[0].tDireccion.toString();
                                  } else {
                                    iMCliente = 0;
                                    CClienteDoc.text = "";
                                    CCliente.text = "";
                                    CClienteDir.text = "";
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                    msg: tJsonClienteBuscar.message,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: ClsColor.tipo6(),
                                    textColor: ClsColor.tipo4(),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: enabledPsjBusqueda == false
                              ? null
                              : () async {
                                  if (CPasajeroDoc.text.length >= 8) {
                                    final GetClienteBuscarPorNroDoc? Postlog = await getClienteBuscarPorNroDoc(CPasajeroDoc.text, 1);
                                    var dataClienteBuscar = jsonEncode(Postlog);
                                    var tJsonClienteBuscar = getClienteBuscarPorNroDocFromJson(dataClienteBuscar.toString());
                                    if (tJsonClienteBuscar.data.length > 0) {
                                      // ignore: use_build_context_synchronously
                                      FocusScope.of(context).unfocus();
                                      iMPasajero = tJsonClienteBuscar.data[0].iMCliente;
                                      CPasajero.text = tJsonClienteBuscar.data[0].tNombre == null ? "" : tJsonClienteBuscar.data[0].tNombre;
                                      vGlobal_transporte.tPasajero = tJsonClienteBuscar.data[0].tNombre.toString();
                                      vGlobal_transporte.tPasajeroDoc = tJsonClienteBuscar.data[0].tNroDocumento.toString();
                                      setState(() {
                                        if (tJsonClienteBuscar.code != 200) {
                                          dropdownTipoDoc = tJsonClienteBuscar.data[0].iMTipoDocumentoIdentidad.toString();
                                        } else {
                                          dropdownTipoDoc = "1";
                                        }
                                      });
                                      if (tipo == 1) {
                                        iMCliente = tJsonClienteBuscar.data[0].iMCliente;
                                        CClienteDoc.text = CPasajeroDoc.text;
                                        CCliente.text = tJsonClienteBuscar.data[0].tNombre.toString() == null ? "" : tJsonClienteBuscar.data[0].tNombre.toString();
                                        CClienteDir.text = tJsonClienteBuscar.data[0].tDireccion.toString() == null ? "" : tJsonClienteBuscar.data[0].tDireccion.toString();
                                      } else {
                                        iMCliente = 0;
                                        CClienteDoc.text = "";
                                        CCliente.text = "";
                                        CClienteDir.text = "";
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: tJsonClienteBuscar.message,
                                        gravity: ToastGravity.CENTER,
                                        backgroundColor: ClsColor.tipo6(),
                                        textColor: ClsColor.tipo4(),
                                      );
                                    }
                                  } else {
                                    Fluttertoast.showToast(msg: "Nro. Digitos minimo $TipoDocDigitos", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                  }
                                },
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(Size(20, 50)),
                            backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
                            padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.only(left: 5)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                          ),
                          icon: Icon(Icons.search, size: 25, color: ClsColor.tipo4()),
                          label: const Text(""),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                      child: Text('Nombres y Apellidos del Pasajero', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                    ),
                    TextField(
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      controller: CPasajero,
                      decoration: InputDecoration(
                        filled: true,
                        isDense: true,
                        enabled: false,
                        fillColor: ClsColor.tipo2(),
                        // disabledBorder: OutlineInputBorder(
                        //   borderRadius: const BorderRadius.all(Radius.circular(20)),
                        //   borderSide: BorderSide(color: ClsColor.tipo11(), width: 2),
                        // ),
                      ),
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 10),
                    if (EnableReserva == false) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Venta Gratuita', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                          Text('Descuento', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                color: aplica == true ? ClsColor.tipo1() : ClsColor.tipo4(),
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                              ),
                              child: CheckboxListTile(
                                dense: true,
                                activeColor: ClsColor.tipo1(),
                                title: Text(
                                  "Si Aplica",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: aplica == true ? ClsColor.tipo4() : ClsColor.tipo1()),
                                ),
                                value: aplica,
                                onChanged: (newValue) {
                                  setState(() {
                                    aplica = newValue!;
                                    updateText(tDescuento, aplica);
                                  });
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: TextFormField(
                              controller: CDescuento,
                              enabled: iEstadoDescuento,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              decoration: InputDecoration(
                                  filled: true,
                                  isDense: true,
                                  fillColor: iEstadoDescuento == true ? ClsColor.tipo4() : ClsColor.tipo2(),
                                  enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                                  focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                                  disabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo11(), width: 2)),
                                  hintText: "S/"),
                              onChanged: (value) {
                                if (CDescuento.text == "" || CDescuento.text == null) {
                                  tDescuento = "0";
                                } else {
                                  tDescuento = value;
                                }
                                updateText(tDescuento, aplica);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: tipo == 1 ? ClsColor.tipo1() : ClsColor.tipo4(),
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: RadioListTile(
                              visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity),
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              activeColor: tipo == 1 ? ClsColor.tipo4() : ClsColor.tipo1(),
                              title: Text(
                                "Boleta",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: tipo == 1 ? ClsColor.tipo4() : ClsColor.tipo1()),
                              ),
                              value: 1,
                              groupValue: tipo,
                              onChanged: (value) {
                                enabledBoleta == false
                                    ? null
                                    : setState(() {
                                        tipo = value!;
                                        iMCliente = 0;
                                        CClienteDoc.text = "";
                                        CCliente.text = "";
                                        CClienteDir.text = "";
                                        EnableReserva = false;
                                        EnabledRuc = false;
                                        resultSerie = null;
                                        resultNumero = null;
                                        LoadSerie();
                                      });
                                //tipoSerie();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Container(
                            // height: 80,
                            decoration: BoxDecoration(
                              color: tipo == 2 ? ClsColor.tipo1() : ClsColor.tipo4(),
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: RadioListTile(
                              visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity),
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              activeColor: tipo == 2 ? ClsColor.tipo4() : ClsColor.tipo1(),
                              title: Text(
                                "Factura",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: tipo == 2 ? ClsColor.tipo4() : ClsColor.tipo1()),
                              ),
                              value: 2,
                              groupValue: tipo,
                              onChanged: (value) {
                                enabledFactura == false
                                    ? null
                                    : setState(() {
                                        iMCliente = 0;
                                        CClienteDoc.text = "";
                                        CCliente.text = "";
                                        CClienteDir.text = "";
                                        tipo = value!;
                                        EnabledRuc = true;
                                        EnableReserva = false;
                                        resultSerie = null;
                                        resultNumero = null;
                                        LoadSerie();
                                      });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: tipo == 3 ? ClsColor.tipo1() : ClsColor.tipo4(),
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: RadioListTile(
                              visualDensity: const VisualDensity(horizontal: VisualDensity.minimumDensity),
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              activeColor: tipo == 3 ? ClsColor.tipo4() : ClsColor.tipo1(),
                              title: Text(
                                "Reserva",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: tipo == 3 ? ClsColor.tipo4() : ClsColor.tipo1()),
                              ),
                              value: 3,
                              groupValue: tipo,
                              onChanged: (value) async {
                                enabledReserva == false
                                    ? null
                                    : setState(
                                        () {
                                          iMCliente = 0;
                                          CClienteDoc.text = "";
                                          CCliente.text = "";
                                          CClienteDir.text = "";
                                          tipo = value!;
                                          EnableReserva = true;
                                          aplica = false;
                                          CDescuento.text = "";
                                          tDescuento = "0";
                                          iEstadoDescuento = true;
                                          EnabledRuc = false;
                                          resultSerie = null;
                                          resultNumero = null;
                                        },
                                      );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (EnableReserva == false) ...[
                      Row(
                        children: [
                          Container(
                            child: resultSerie,
                          ),
                          const SizedBox(width: 10),
                          Container(
                            child: resultNumero,
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 10),
                    if (EnabledRuc == true) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        child: Text('RUC', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: TextFormField(
                              enabled: EnabledRuc,
                              maxLength: 11,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), FilteringTextInputFormatter.digitsOnly],
                              validator: (value) {
                                return (value != null) ? null : 'Nro. Digitos Permitidos 11';
                              },
                              controller: CClienteDoc,
                              decoration: InputDecoration(
                                filled: true,
                                isDense: true,
                                fillColor: ClsColor.tipo4(),
                                enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                                focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                                prefixIcon: Icon(Icons.badge_rounded, color: ClsColor.tipo5()),
                              ),
                              onChanged: (value) {
                                CCliente.text = "";
                                CClienteDir.text = "";
                                iMCliente = 0;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (CClienteDoc.text.length == 11) {
                                final GetClienteBuscarPorNroDoc? Postlog = await getClienteBuscarPorNroDoc(CClienteDoc.text, 2);
                                var dataClienteBuscar = jsonEncode(Postlog);
                                var tJsonClienteBuscar = getClienteBuscarPorNroDocFromJson(dataClienteBuscar.toString());
                                if (tJsonClienteBuscar.code == 2) {
                                  Fluttertoast.showToast(msg: tJsonClienteBuscar.message, gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                                } else {
                                  // ignore: use_build_context_synchronously
                                  FocusScope.of(context).unfocus();
                                  iMCliente = tJsonClienteBuscar.data[0].iMCliente;
                                  CCliente.text = tJsonClienteBuscar.data[0].tNombre == null ? "" : tJsonClienteBuscar.data[0].tNombre;
                                  CClienteDir.text = tJsonClienteBuscar.data[0].tDireccion == null ? "" : tJsonClienteBuscar.data[0].tDireccion;
                                }
                              } else {
                                Fluttertoast.showToast(msg: "Nro. Digitos Permitidos 11", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                              }
                            },
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(Size(20, 50)),
                              backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
                              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.only(left: 5)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                            ),
                            icon: Icon(Icons.search, size: 25, color: ClsColor.tipo4()),
                            label: const Text(""),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        child: Text('Razón Social', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                      ),
                      TextField(
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        enabled: false, // EnabledRuc,
                        controller: CCliente,
                        decoration: InputDecoration(
                          filled: true,
                          isDense: true,
                          fillColor: ClsColor.tipo2(),
                        ),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                        child: Text('Dirección', style: TextStyle(color: ClsColor.tipo6(), fontSize: 14, fontWeight: FontWeight.w400)),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        enabled: true, //EnabledRuc,
                        controller: CClienteDir,
                        decoration: InputDecoration(
                          filled: true,
                          isDense: true,
                          fillColor: ClsColor.tipo4(),
                          enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                          focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                        ),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (precargaReserva == true) ...[
            ElevatedButton.icon(
              onPressed: () async {
                _AnularReserva(context);
              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(300, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo8()),
                padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
              ),
              icon: Icon(Icons.do_disturb_alt_rounded, size: 20, color: ClsColor.tipo4()),
              label: Text("Anular Reserva", style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                setState(() {
                  precargaReserva = false;
                  enabledPsjTipoDoc = true;
                  enabledPsjNroDoc = true;
                  enabledPsjBusqueda = true;
                  enabledBoleta = true;
                  enabledFactura = true;
                  tipo = 1;
                  iMCliente = 0;
                  CClienteDoc.text = "";
                  CCliente.text = "";
                  CClienteDir.text = "";
                  EnableReserva = false;
                  EnabledRuc = false;
                  resultSerie = null;
                  resultNumero = null;
                  LoadSerie();
                });
              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(300, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo3()),
                padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
              ),
              icon: Icon(Icons.transform_rounded, size: 20, color: ClsColor.tipo1()),
              label: Text("Transformar en Boleto", style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ],
          if (precargaReserva == false) ...[
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                ClsDecoration.showDialogLoading(context);

                if (iMPasajero == 0 && CPasajero.text.length == 0) {
                  Fluttertoast.showToast(msg: "Ingrese Pasajero", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                  Navigator.of(context).pop();
                  return;
                }
                if (tipo == 2 || tipo == 1) {
                  if (vGlobal_comprobante.documentoSerie == "" || vGlobal_comprobante.documentoSerie == null || vGlobal_comprobante.documentoNumero == "" || vGlobal_comprobante.documentoNumero == "00000000") {
                    Fluttertoast.showToast(msg: "No tiene serie para la emision de Comprobante", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                    Navigator.of(context).pop();
                    return;
                  }
                  if (tipo == 2) {
                    if (iMCliente == 0 && CCliente.text.length == 0) {
                      Fluttertoast.showToast(msg: "Ingrese Cliente", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());

                      Navigator.of(context).pop();
                      return;
                    }

                    if (CClienteDir.text == "" && CClienteDir.text == null) {
                      Fluttertoast.showToast(msg: "Ingrese Dirección", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());

                      Navigator.of(context).pop();
                      return;
                    }
                  }
                }

                if (tipo == 2 || tipo == 1) {
                  Fluttertoast.showToast(msg: "Registrando Datos", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                  vGlobal_transporte.TipoAcceso = widget.TipoAcceso;
                  vGlobal_transporte.iMCliente = iMCliente;
                  vGlobal_transporte.CClienteDoc = CClienteDoc.text;
                  vGlobal_transporte.CCliente = CCliente.text;
                  vGlobal_transporte.CClienteDir = CClienteDir.text;
                  vGlobal_transporte.iMPasajero = iMPasajero;
                  vGlobal_transporte.tPasajeroTipoDoc = dropdownTipoDoc;
                  vGlobal_transporte.CPasajeroDoc = CPasajeroDoc.text;
                  vGlobal_transporte.CPasajero = CPasajero.text;
                  vGlobal_transporte.TipoComprobante = (tipo == 1 ? "BOLETA" : "FACTURA");
                  vGlobal_transporte.descuento = double.parse(tDescuento);
                  vGlobal_transporte.aplica = aplica;

                  LoadNumero();
                  await Future.delayed(const Duration(seconds: 2));
                  double pInicial = vGlobal_transporte.iPrecioInicial;
                  double pFinal = vGlobal_transporte.iPrecioFinal;
                  double pDescuento = vGlobal_transporte.iDescuento;
                  double pPorDescuento = (vGlobal_transporte.iDescuento == 0 ? 0 : (vGlobal_transporte.iDescuento / vGlobal_transporte.iPrecioInicial));
                  String tPlaca = vGlobal_transporte.tPlaca;
                  String Letra = (Funciones.numeroALetras(vGlobal_transporte.iPrecioFinal.toString(), 'SOLES')).toUpperCase();
                  String tDescripcion =
                      "${vGlobal_transporte.ruta}|ASIENTO : ${vGlobal_transporte.iAsiento}|PAJ : ${vGlobal_transporte.tPasajero}|DNI : ${vGlobal_transporte.tPasajeroDoc}|F.VIAJE : ${vGlobal_transporte.fecha}|H.VIAJE : ${vGlobal_transporte.hora}|";
                  vGlobal_transporte.letra = Letra;
                  vGlobal_transporte.descripcion = tDescripcion;

                  vGlobal_transporte.pInicial = pInicial;
                  vGlobal_transporte.pFinal = pFinal;
                  vGlobal_transporte.Letra = Letra;
                  vGlobal_transporte.pDescuento = pDescuento;
                  vGlobal_transporte.pPorDescuento = pPorDescuento;
                  vGlobal_transporte.tDescripcion = tDescripcion;
                  vGlobal_transporte.CClienteDoc = CClienteDoc.text;
                  vGlobal_transporte.CCliente = CCliente.text;
                  vGlobal_transporte.CClienteDir = CClienteDir.text;
                  vGlobal_transporte.PlacaVehiculo = tPlaca;
                  vGlobal_transporte.ModalidaPago = 'Contado';
                  vGlobal_transporte.tSerie = vGlobal_comprobante.documentoSerie;
                  vGlobal_transporte.tNumeracion = vGlobal_comprobante.documentoNumero;
                  vGlobal_transporte.iTipoFac = (tipo == 1 ? "03" : "01");
                  vGlobal_transporte.tTipoDocCliente = (tipo == 1 ? "0${dropdownTipoDoc.toString()}" : "06");
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const trans_cobrar(Origen: "VentaBoleto")));
                } else {
                  Map<String, dynamic>? postReg = await ReservaBoletoRegistrar(
                    iMPasajero,
                    dropdownTipoDoc,
                    CPasajeroDoc.text,
                    CPasajero.text,
                  );
                  final codigo = postReg?["codigo"].toString();
                  final mensaje = postReg?["mensaje"];

                  Fluttertoast.showToast(msg: mensaje, gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
                  if (codigo == "0") {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const trans_seleccionarAsiento()));
                  }
                }
              },
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all(const Size(300, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo3()),
                padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
              ),
              icon: Icon(Icons.local_print_shop_rounded, size: 20, color: ClsColor.tipo1()),
              label: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Continuar", style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text("S/ ${vGlobal_transporte.iPrecioFinal.toStringAsFixed(2)}", style: TextStyle(color: ClsColor.tipo5(), fontSize: 20, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
