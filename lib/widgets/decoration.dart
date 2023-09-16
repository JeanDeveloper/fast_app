import 'dart:convert';
import 'package:fast/core/utils.dart';
import 'package:fast/models/Restaurante/m_GetCartaProductos.dart';
import 'package:fast/models/Restaurante/m_GetMesas.dart';
import 'package:fast/models/Restaurante/m_GetNiveles.dart';
import 'package:fast/models/Restaurante/m_GetOrdenMesa.dart';
import 'package:fast/models/Restaurante/m_GetOrdenProductoMesa.dart';
import 'package:fast/models/Restaurante/m_GetParaLlevarDelivery.dart';
import 'package:fast/providers/providers.dart';
import 'package:fast/providers/providers_Restaurante.dart';
import 'package:fast/screens/Restaurante/s_rest_Print.dart';
import 'package:fast/screens/Restaurante/s_rest_pedidoPersonalizacion.dart';
import 'package:fast/screens/Transporte/s_trans_anularComprobante.dart';
import 'package:fast/screens/Transporte/s_trans_pedidoPersonalizacion.dart';
// import 'package:fast/screens/Restaurante/s_rest_consumo.dart';
// import 'package:fast/widgets/cambioEmpresa.dart';
import 'package:flutter/material.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Transporte.dart' as vGlobal_transporte;
import 'package:fast/providers/global_Comprobante.dart' as vGlobal_comprobante;
import 'package:fast/providers/global_Restaurante.dart' as vGlobal_Restaurante;
import 'package:fast/providers/options.dart' as vOptions;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
// import 'package:pdf/pdf.dart';
// import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_share/whatsapp_share.dart';
// import 'package:whatsapp_share2/whatsapp_share2.dart';

import '../screens/Restaurante/s_rest_consumo.dart';

class ClsDecoration {
  static GestureDetector ContainerMatrizTransporte({required int tipo, int? asiento, int? nivel, double? precio, int? status, Color? tcolor, BuildContext? context, int? iMVentaTransporte, String? tColorPunto}) {
    if (status == -1 || status == 1) {
      tcolor = const Color.fromARGB(255, 0, 105, 61);
    } else if (status == 0) {
      tcolor = const Color.fromARGB(255, 185, 19, 8);
    } else if (status == 4) {
      tcolor = const Color.fromARGB(255, 29, 46, 62);
    } else if (status == 5) {
      tcolor = const Color.fromARGB(100, 0, 105, 61);
    }

    vGlobal_comprobante.formatoPdf = "";
    vGlobal_comprobante.documentoSerie = "";

    if (tipo == 3) {
      return GestureDetector(
        onTap: () {
          if (status == -1 || status == 1) {
            vGlobal_transporte.iNivel = nivel!;
            vGlobal_transporte.iAsiento = asiento!;
            vGlobal_transporte.iAsientoStatus = status!;
            vGlobal_transporte.iPrecioInicial = precio;
            vGlobal_transporte.iPrecioFinal = precio;
            vGlobal_transporte.iMVentaTransporte = 0;
            Navigator.push(
              context!,
              MaterialPageRoute(
                builder: (context) => const trans_pedidoPersonalizacion(TipoAcceso: "Nuevo"),
              ),
            );
          }
          if (status == 4) {
            vGlobal_transporte.iNivel = nivel!;
            vGlobal_transporte.iAsiento = asiento!;
            vGlobal_transporte.iAsientoStatus = status!;
            vGlobal_transporte.iPrecioInicial = precio;
            vGlobal_transporte.iPrecioFinal = precio;
            vGlobal_transporte.iMVentaTransporte = iMVentaTransporte!;
            Navigator.push(
              context!,
              MaterialPageRoute(
                builder: (context) => const trans_pedidoPersonalizacion(TipoAcceso: "Reserva"),
              ),
            );
          }
          if (status == 0) {
            vGlobal_transporte.iNivel = nivel!;
            vGlobal_transporte.iAsiento = asiento!;
            vGlobal_transporte.iAsientoStatus = status!;
            vGlobal_transporte.iPrecioInicial = precio;
            vGlobal_transporte.iPrecioFinal = precio;
            vGlobal_transporte.iMVentaTransporte = iMVentaTransporte!;
            Navigator.push(
              context!,
              MaterialPageRoute(
                builder: (context) => const trans_anularComprobante(Origen: 'VentaBoleto'),
              ),
            );
          }
        },
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6.5),
              decoration: BoxDecoration(
                color: tcolor,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(Icons.airline_seat_recline_extra_rounded, color: Colors.white, size: 20),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Text(asiento.toString(), style: TextStyle(color: tcolor, fontSize: 12, fontWeight: FontWeight.w700)),
                      )
                    ],
                  ),
                  Text("S/ ${precio!.toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            if (tColorPunto!.isNotEmpty) ...[
              Transform(
                transform: Matrix4.translationValues(0.0, -3, 0.0),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Material(
                        type: MaterialType.transparency,
                        child: Ink(
                          decoration: BoxDecoration(border: Border.all(color: ClsColor.tipo2(), width: 2.5), color: Colors.black, borderRadius: BorderRadius.circular(50.0)), //<-- SEE HERE
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50.0),
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Icon(
                                Icons.circle,
                                size: 15.0,
                                color: tColorPunto.toColor(),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]
          ],
        ),
      );
    } else if (tipo == 2) {
      return GestureDetector(
        child: Container(
          color: ClsColor.tipo2(),
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.tv_rounded, color: ClsColor.tipo5(), size: 33),
            ],
          ),
        ),
      );
    } else if (tipo == 1) {
      return GestureDetector(
        child: Container(
          color: ClsColor.tipo2(),
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.stairs_outlined, color: ClsColor.tipo5(), size: 33),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        child: Container(
          color: ClsColor.tipo2(),
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
        ),
      );
    }
  }

  static OutlineInputBorder inputborder() {
    return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        borderSide: BorderSide(
          color: ClsColor.tipo1(),
          width: 2,
        ));
  }

  static OutlineInputBorder focusborder() {
    return OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        borderSide: BorderSide(
          color: ClsColor.tipo3(),
          width: 2,
        ));
  }

  static Padding botonPrincipal({required String titulo, required IconData icono, required Color ColorIcono}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(icono, size: 35, color: ColorIcono),
          ),
          const SizedBox(height: 10),
          Text(titulo, textAlign: TextAlign.center, style: TextStyle(color: ClsColor.tipo1(), fontSize: 14, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  static AppBar appBar(BuildContext context, String ruta) {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: ClsColor.tipo1(),
      title: ruta == ""
          ? Transform(
              transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('assets/images/FAST_BLANCO_2x.png', width: 40),
                ],
              ),
            )
          : Transform(
              transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_circle_left_rounded,
                      size: 25,
                      color: ClsColor.tipo4(),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, ruta);
                    },
                  ),
                ],
              ),
            ),
      elevation: 0,
      actions: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              vGlobal.tEmpresa == null ? "" : vGlobal.tEmpresa.toString().substring(0, vGlobal.tEmpresa!.length < 14 ? vGlobal.tEmpresa!.length : 14),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 16,
                overflow: TextOverflow.fade,
                fontWeight: FontWeight.w700,
                color: ClsColor.tipo4(),
              ),
            ),
            Text(
              vGlobal.tSucursal == null ? "" : vGlobal.tSucursal.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: ClsColor.tipo4(),
              ),
            ),
          ],
        ),
        // IconButton(
        //   icon: Icon(Icons.search),
        //   onPressed: () {
        //     print('Click search');
        //   },
        // ),

        IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
      ],
    );
  }

  static ListTile ListTileMenu({
    required String value,
    required String title,
    required BuildContext context,
    required String nav,
    required Icon icon,
  }) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      iconColor: const Color.fromARGB(255, 255, 255, 255),
      textColor: const Color.fromARGB(255, 255, 255, 255),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      onTap: () async {
        if (value == "vCerrar") {
          vGlobal.iMUsuario = 0;
          final prefs = await SharedPreferences.getInstance();
          prefs.remove('usuario');
          prefs.remove('password');
          Navigator.pushReplacementNamed(context, nav);
        } else if (value == "vSettings") {
          Navigator.pushReplacementNamed(context, nav);
        } else if (value == "vSoporte") {
          try {
            await WhatsappShare.share(
              package: Package.businessWhatsapp,
              text: "Hola! ",
              phone: "51919475719",
            );
          } catch (e) {
            await WhatsappShare.share(
              package: Package.whatsapp,
              text: "Hola! ",
              phone: "51919475719",
            );
          }
        } else {
          Navigator.pushReplacementNamed(context, nav);
        }
      },
    );
  }

  static ClipRRect ImageAvatar() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: //vGlobal.tFotoBase64.toString() == ''
            /*? */ Image.asset('assets/images/USER.png')
        /*: Image.memory(
              convertBase64Image(vGlobal.tFotoBase64.toString()),
              gaplessPlayback: true,
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),*/
        );
  }

  static Divider LineDivider() {
    return Divider(
      color: ClsColor.tipo2(),
      thickness: 0.5,
      endIndent: 50,
    );
  }

  static AlertDialog AlertDialogMessage({
    required BuildContext context,
    required String title,
    required String message,
    required String cierre,
  }) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: ListBody(
          children: [Text(message)],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(cierre),
        )
      ],
    );
  }

  static GestureDetector listProductos({ required List<CartaProductoData>? lista, required int index, required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        vGlobal_Restaurante.iMProducto = lista[index].iMProducto;
        vGlobal_Restaurante.tProducto = lista[index].tProducto;
        vGlobal_Restaurante.tSubCategoria = lista[index].tSubCategoria;
        vGlobal_Restaurante.tImagenProducto = lista[index].tImagenProducto;
        vGlobal_Restaurante.iPrecuentaPersonalizacion = lista[index].nPrecioUnitario;
        vGlobal_Restaurante.nPrecioUnitario = lista[index].nPrecioUnitario;
        vGlobal_Restaurante.nPrecioUnitarioBase = lista[index].nPrecioUnitario;
        vGlobal_Restaurante.indexProducto = lista[index].iMProducto;
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const pedidoPersonalizacion()));
        Navigator.pushNamed(context, "navpedidoPersonalizacion");
      },
      child: Card(
        margin: const EdgeInsets.all(5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        child: Column(
          children: [
            Flexible(
              child: Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          decoration: BoxDecoration(
                            color: ClsColor.tipo10(),
                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            child: Text(
                              "S/ ${lista?[index].nPrecioUnitario!.toStringAsFixed(2)}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: ClsColor.tipo5(),
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      width: double.infinity,
                      color: ClsColor.tipo4(),
                      child: lista?[index].tImagenProducto == ""
                          ? const Image(image: ExactAssetImage('assets/images/foodempty.jpg'), fit: BoxFit.fitHeight)
                          : Image(image: NetworkImage(lista?[index].tImagenProducto ?? ""), fit: BoxFit.fill),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                (lista![index].tSubCategoria.toString() == "" ? "" : "${lista[index].tSubCategoria} - ") + lista[index].tProducto.toString(),
                maxLines: 4,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: ClsColor.tipo5(), overflow: TextOverflow.fade),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Padding listMesas({
    required MGetMesas? lista,
    required int index,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: MaterialButton(
        onPressed: () {
          vGlobal_Restaurante.listPrecuenta = [];
          vGlobal_Restaurante.iMMesa = lista?.data[index].iMMesa ?? 0;
          vGlobal_Restaurante.tMesa = lista?.data[index].tMesa;
          vGlobal_Restaurante.tCliente = lista?.data[index].tCliente;
          vGlobal_Restaurante.iPax = lista?.data[index].iPax;
          vGlobal_Restaurante.iIDPedido = lista?.data[index].iDPedido;
          vGlobal_Restaurante.horaPedido = lista?.data[index].tHora;
          print(vGlobal_Restaurante.iIDPedido);
          if (lista?.data[index].tEstado == "DISPONIBLE") {
            Navigator.pushNamed(context, "navpedidoInicio");
          } else if (lista?.data[index].tEstado == "OCUPADO") {
            Navigator.pushNamed(context, "navconsumo");
          } else if (lista?.data[index].tEstado == "BLOQUEADO") {}
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Color(int.parse((lista?.data[index].tColor ?? "").replaceAll('#', '0xFF'))),
        splashColor: ClsColor.tipo4(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              lista?.data[index].tMesa.toString() ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(color: ClsColor.tipo4(), fontSize: 15, fontWeight: FontWeight.w700),
            ),
            if (lista?.data[index].tEstado == "DISPONIBLE") ...[
              Text(
                lista?.data[index].tEstado.toString() ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(color: ClsColor.tipo4(), fontSize: 13, fontWeight: FontWeight.w400),
              ),
            ] else if (lista?.data[index].tEstado == "BLOQUEADO") ...[
              Text(
                lista?.data[index].tEstado.toString() ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(color: ClsColor.tipo4(), fontSize: 13, fontWeight: FontWeight.w400),
              ),
              Text(
                "UNIDO A ${lista!.data[index].tMesaUnion}",
                textAlign: TextAlign.center,
                style: TextStyle(color: ClsColor.tipo3(), fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ] else if (lista?.data[index].tEstado == "OCUPADO") ...[
              //JEAN
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${lista?.data[index].tHora} " ?? "",
                      style: TextStyle(color: ClsColor.tipo4(), fontSize: 10, fontWeight: FontWeight.w400),
                    ),
                    TextSpan(
                      text: Utils.convertTime(lista!.data[index].tHora!.toLowerCase()) ?? "",
                      style: TextStyle(color: ClsColor.tipo4(), fontSize: 10, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),

              Text(
                'S/ ${lista.data[index].nImporte!.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: TextStyle(color: ClsColor.tipo3(), fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ]
          ],
        ),
      ),
    );
  }

  static Padding listMesasLlevarDelivery({
    required GetParaLlevarDelivery? lista,
    required int index,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: MaterialButton(
        onPressed: () {
          vGlobal_Restaurante.iMSalon = null;
          vGlobal_Restaurante.tSalon = "";
          vGlobal_Restaurante.iMMesa = null;
          vGlobal_Restaurante.tMesa = "";
          vGlobal_Restaurante.iPax = null;
          vGlobal_Restaurante.iIDPedido = 0;
          vGlobal_Restaurante.TipoPedido = "LLEVAR";
          vGlobal_Restaurante.listPrecuenta = [];
          vGlobal_Restaurante.tCliente = lista.data![index].tClienteResponsable;
          vGlobal_Restaurante.iIDPedido = lista.data![index].iDPedido;
          print(vGlobal_Restaurante.iIDPedido);
          Navigator.pushNamed(context, "navconsumo");
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: ClsColor.tipo6(), // const Color.fromARGB(255, 61, 131, 149),
        splashColor: ClsColor.tipo4(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              lista?.data![index].tClienteResponsable.toString() ?? "",
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: ClsColor.tipo4(), fontSize: 15, fontWeight: FontWeight.w700),
            ),
            Text(
              lista?.data![index].tHora ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(color: ClsColor.tipo4(), fontSize: 10, fontWeight: FontWeight.w400),
            ),
            Text(
              'S/ ${lista!.data![index].nTotal.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: TextStyle(color: ClsColor.tipo3(), fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  static Padding listMesasDelivery({
    required GetParaLlevarDelivery? lista,
    required int index,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: MaterialButton(
        onPressed: () {
          vGlobal_Restaurante.iMSalon = null;
          vGlobal_Restaurante.tSalon = "";
          vGlobal_Restaurante.iMMesa = null;
          vGlobal_Restaurante.tMesa = "";
          vGlobal_Restaurante.iPax = null;
          vGlobal_Restaurante.iIDPedido = 0;
          vGlobal_Restaurante.TipoPedido = "DELIVERY";
          vGlobal_Restaurante.listPrecuenta = [];
          vGlobal_Restaurante.tCliente = lista.data![index].tClienteResponsable;
          vGlobal_Restaurante.iIDPedido = lista.data![index].iDPedido;

          print(vGlobal_Restaurante.iIDPedido);
          if (lista.data![index].iEstadoPago == 0 && lista.data![index].iEstadoEnvio == 0) {
            Navigator.pushNamed(context, "navconsumo");
          } else {
            if (lista.data![index].iEstadoPago == 1) {
              Fluttertoast.showToast(msg: "El pedido ya está Cancelado", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
            }
            if (lista.data![index].iEstadoEnvio == 1) {
              Fluttertoast.showToast(msg: "El pedido ya fue enviado", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
            }
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: ClsColor.tipo1(), // Color.fromARGB(255, 45, 195, 232), // const Color.fromARGB(255, 61, 131, 149),
        splashColor: ClsColor.tipo4(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              lista?.data![index].tClienteResponsable.toString() ?? "",
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: ClsColor.tipo4(), fontSize: 15, fontWeight: FontWeight.w700),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      lista?.data![index].tHora ?? "",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: ClsColor.tipo4(), fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'S/ ${lista!.data![index].nTotal.toStringAsFixed(2)}',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: ClsColor.tipo3(), fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      type: MaterialType.transparency,
                      child: Ink(
                        decoration: BoxDecoration(
                            border: Border.all(color: ClsColor.tipo2(), width: 0.5),
                            color: lista.data![index].iEstadoPago == 1 ? ClsColor.tipo9() : ClsColor.tipo11(),
                            borderRadius: BorderRadius.circular(5.0)), //<-- SEE HERE
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () {},
                          child: Padding(padding: const EdgeInsets.all(5), child: Icon(Icons.attach_money_rounded, size: 18.0, color: ClsColor.tipo4())),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Material(
                      type: MaterialType.transparency,
                      child: Ink(
                        decoration: BoxDecoration(
                            border: Border.all(color: ClsColor.tipo2(), width: 0.5), color: lista.data![index].iEstadoEnvio == 1 ? ClsColor.tipo9() : ClsColor.tipo11(), borderRadius: BorderRadius.circular(5.0)),
                        child: InkWell(
                          onTap: () {},
                          child: Padding(padding: const EdgeInsets.all(5), child: Icon(Icons.delivery_dining_rounded, size: 18.0, color: ClsColor.tipo4())),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  static Padding listNiveles({required MGetNiveles? lista,required int index,required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: MaterialButton(
        onPressed: () {
          vGlobal_Restaurante.TipoPedido = "MESA";
          vGlobal_Restaurante.iMSalon = lista?.data[index].iMSalon;
          vGlobal_Restaurante.tSalon = lista?.data[index].tSalon;
          Navigator.pushNamed(context, "navmesaSeleccionar");
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(int.parse((lista?.data[index].tColor ?? "").replaceAll('#', '0xFF'))),
        splashColor: ClsColor.tipo4(),
        child: Container(
          constraints: const BoxConstraints(minHeight: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                lista?.data[index].tSalon ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(color: ClsColor.tipo4(), fontSize: 14, fontWeight: FontWeight.w700),
              ),
              if (lista?.data[index].tObservacion != "") ...[
                Text(
                  lista?.data[index].tObservacion ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ClsColor.tipo3(), fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  static showDialogLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 8,
                backgroundColor: ClsColor.tipo4(),
                color: ClsColor.tipo3(),
              ),
              const SizedBox(
                height: 80,
              ),
              const Text(" ")
            ],
          ),
        );
        ;
      },
    );
  }

//   static BoxDecoration groupboxDecoration() {
//     return BoxDecoration(
//       color: Colors.white,
//       border: Border.all(
//         color: const Color.fromARGB(255, 220, 220, 220),
//         width: 1.0,
//       ),
//       borderRadius: const BorderRadius.all(Radius.circular(10)),
//       boxShadow: const [
//         BoxShadow(
//           blurRadius: 0.2,
//           color: Color.fromARGB(255, 220, 220, 220),
//           offset: Offset(0.2, 0.2),
//         )
//       ],
//     );
//   }

//   static ListTile ListTileMenu({
//     required String title,
//     required BuildContext context,
//     required String nav,
//     required Icon icon,
//   }) {
//     return ListTile(
//       leading: icon,
//       title: Text(title),
//       iconColor: const Color.fromARGB(255, 255, 255, 255),
//       textColor: const Color.fromARGB(255, 255, 255, 255),
//       // tileColor: Color.fromARGB(255, 255, 80, 0),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topRight: Radius.circular(50),
//           bottomRight: Radius.circular(50),
//         ),
//       ),
//       onTap: () async {
//         if (title == "Mi QR") {
//           {
//             String title = 'Alerta';
//             String message = 'No cuenta con Fotocheck';
//             String cierre = 'Cerrar';
//             if (vGlobal.tNumeroFotocheck.toString() == "") {
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return ClsDecoration.AlertDialogMessage(context: context, title: title, message: message, cierre: cierre);
//                 },
//               );
//             } else {
//               Navigator.push(context, MaterialPageRoute(builder: (context) => qrScanner()));
//             }
//           }
//         } else if (title == "Soporte") {
//           final MSoporte PostSoporte = await getSoporte();
//           var dataSoporte = jsonEncode(PostSoporte);
//           var tJsonSoporte = mSoporteFromJson(dataSoporte.toString());
//           vGlobal.Sop_CorreoDho = tJsonSoporte.data.tCorreoDho;
//           vGlobal.Sop_tNumeroDho = tJsonSoporte.data.tNumeroDho;
//           vGlobal.Sop_tCorreoRc = tJsonSoporte.data.tCorreoRc;
//           vGlobal.Sop_tNumeroRc = tJsonSoporte.data.tNumeroRc;
//           vGlobal.Sop_tCorreoServicioMedico = tJsonSoporte.data.tCorreoServicioMedico;
//           vGlobal.Sop_tNumeroServicioMedico = tJsonSoporte.data.tNumeroServicioMedico;

//           Navigator.pushReplacementNamed(context, nav);
//         } else if (title == "Cerrar Sesión") {
//           vGlobal.iMUsuario = 0;
//           final prefs = await SharedPreferences.getInstance();
//           prefs.remove('usuario');
//           prefs.remove('password');
//           Navigator.pushReplacementNamed(context, nav);
//         } else {
//           Navigator.pushReplacementNamed(context, nav);
//         }
//       },
//     );
//   }

//   static Card cardDecoration({
//     required BuildContext context,
//     required String title,
//     required String subtitle,
//     required IconData iconleft,
//     IconData? iconright,
//   }) {
//     return Card(
//       color: ClsColor.textcolorBlanco(),
//       margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(13),
//       ),
//       child: ListTile(
//         trailing: Icon(
//           iconright,
//           size: 20,
//           color: Colors.black,
//         ),
//         title: Padding(
//           padding: const EdgeInsets.only(bottom: 5),
//           child: RichText(
//             text: TextSpan(
//               children: [
//                 WidgetSpan(
//                   alignment: PlaceholderAlignment.middle,
//                   child: Icon(iconleft, size: 13, color: Colors.black),
//                 ),
//                 TextSpan(
//                   text: " $title",
//                   style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: ClsColor.textcolorGrisClaro()),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         subtitle: Text(
//           subtitle,
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ClsColor.textcolorNegro()),
//         ),
//         onTap: iconright == null
//             ? () {}
//             : () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => actualizarDatos2(),
//                   ),
//                 );
//               },
//       ),
//     );
//   }

//   static Divider DividerLine() {
//     return Divider(
//       color: ClsColor.textcolorGris(),
//       height: 15,
//       thickness: 2,
//       endIndent: 0,
//     );
//   }

//   static Divider DividerLineNaranja() {
//     return Divider(
//       color: ClsColor.textcolorNaranja(),
//       height: 15,
//       thickness: 2,
//       endIndent: 0,
//     );
//   }

//   static Container BoxContainer({
//     required String title,
//     required String subtitle,
//     required Color color,
//   }) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: color, width: 1, style: BorderStyle.solid),
//       ),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(5),
//             child: Text(
//               title,
//               style: TextStyle(
//                 color: color,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(5),
//             child: Text(
//               subtitle,
//               style: TextStyle(
//                 color: color,
//                 fontSize: 11,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   static Container BoxContainerSoporte({
//     required String title,
//     required String subtitle,
//     required IconData icontitle,
//     required IconData iconsubtitle,
//   }) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: const Color.fromARGB(255, 220, 220, 220), width: 1, style: BorderStyle.solid),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(5),
//             child: RichText(
//               text: TextSpan(
//                 children: [
//                   WidgetSpan(alignment: PlaceholderAlignment.middle, child: Icon(icontitle, size: 18, color: const Color.fromARGB(255, 130, 130, 130))),
//                   TextSpan(
//                     text: " $title",
//                     style: const TextStyle(color: Color.fromARGB(255, 130, 130, 130), fontSize: 13, fontWeight: FontWeight.w700),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(5),
//             child: RichText(
//               text: TextSpan(
//                 children: [
//                   WidgetSpan(alignment: PlaceholderAlignment.middle, child: Icon(iconsubtitle, size: 18, color: const Color.fromARGB(255, 130, 130, 130))),
//                   TextSpan(
//                     text: " $subtitle",
//                     style: const TextStyle(color: Color.fromARGB(255, 130, 130, 130), fontSize: 13, fontWeight: FontWeight.w700),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   static ClipRRect ImageAvatarScaner() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(100),
//       child: vGlobal.SCtFotoBase64.toString() == ''
//           ? Image.asset('assets/images/USER.png')
//           : Image.memory(
//               convertBase64Image(vGlobal.SCtFotoBase64.toString()),
//               gaplessPlayback: true,
//               width: 200,
//               height: 200,
//               fit: BoxFit.cover,
//             ),
//     );
//   }

//   static AppBar AppBarNexa() {
//     return AppBar(
//       automaticallyImplyLeading: false,
//       backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//       foregroundColor: Colors.black,
//       elevation: 0,
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Image.asset('assets/images/NEXA_BLACK.png', width: 74),
//         ],
//       ),
//       iconTheme: const IconThemeData(size: 24),
//     );
//   }

//   static AppBar AppBarNexaGris() {
//     return AppBar(
//       automaticallyImplyLeading: false,
//       backgroundColor: ClsColor.textcolorPlataClaro(),
//       foregroundColor: Colors.black,
//       elevation: 0,
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           Image.asset('assets/images/NEXA_BLACK.png', width: 74),
//         ],
//       ),
//       iconTheme: const IconThemeData(size: 24),
//     );
//   }

//   static AppBar AppBarBack(BuildContext context, String Texto, String ruta) {
//     return AppBar(
//       automaticallyImplyLeading: false,
//       centerTitle: false,
//       titleSpacing: 0.0,
//       backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//       foregroundColor: Colors.black,
//       elevation: 0,
//       title: Transform(
//         transform: Matrix4.translationValues(5.0, 0.0, 0.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             IconButton(
//               icon: const Icon(
//                 Icons.arrow_back,
//                 size: 20,
//               ),
//               onPressed: () {
//                 Navigator.pushNamed(context, ruta);
//               },
//               color: Colors.black,
//             ),
//             Transform(
//               transform: Matrix4.translationValues(-5.0, 0.0, 0.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     Texto,
//                     style: TextStyle(
//                       color: ClsColor.textcolorPlata(),
//                       fontSize: 13,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       iconTheme: const IconThemeData(size: 24),
//     );
//   }

//   static AppBar AppBarBackGris(BuildContext context, String Texto, String ruta) {
//     return AppBar(
//       automaticallyImplyLeading: false,
//       centerTitle: false,
//       titleSpacing: 0.0,
//       backgroundColor: ClsColor.textcolorPlataClaro(),
//       foregroundColor: Colors.black,
//       elevation: 0,
//       title: Transform(
//         transform: Matrix4.translationValues(5.0, 0.0, 0.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             IconButton(
//               icon: const Icon(
//                 Icons.arrow_back,
//                 size: 20,
//               ),
//               onPressed: () {
//                 Navigator.pushNamed(context, ruta);
//               },
//               color: Colors.black,
//             ),
//             Transform(
//               transform: Matrix4.translationValues(-5.0, 0.0, 0.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     Texto,
//                     style: TextStyle(
//                       color: ClsColor.textcolorPlata(),
//                       fontSize: 13,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       iconTheme: const IconThemeData(size: 24),
//     );
//   }

//   static TabBar TabBarCursos(TabController tabcontroller, List<Widget> Tabs) {
//     return TabBar(
//       indicator: BoxDecoration(
//         color: ClsColor.textcolorGris(),
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: ClsColor.textcolorPlata(),
//             blurRadius: 10,
//             offset: const Offset(2, 2),
//           )
//         ],
//       ),
//       controller: tabcontroller,
//       labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
//       labelColor: ClsColor.textcolorBlanco(),
//       unselectedLabelColor: ClsColor.textcolorGris(),
//       labelPadding: const EdgeInsets.symmetric(horizontal: 5),
//       padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
//       tabs: Tabs,
//     );
//   }

//   static TabBar TabBarDoc(TabController tabcontroller, List<Widget> Tabs) {
//     return TabBar(
//       indicator: BoxDecoration(
//         color: ClsColor.textcolorGris(),
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: ClsColor.textcolorPlata(),
//             blurRadius: 10,
//             offset: const Offset(2, 2),
//           )
//         ],
//       ),
//       controller: tabcontroller,
//       labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//       unselectedLabelColor: ClsColor.textcolorGris(),
//       labelPadding: const EdgeInsets.symmetric(horizontal: 5),
//       padding: const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 5),
//       tabs: Tabs,
//     );
//   }

//   static Container BoxEstado({
//     required String text,
//     required Color color,
//     required String ubicacion,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
//       decoration: BoxDecoration(
//         borderRadius: ubicacion == "Left"
//             ? const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20))
//             : (ubicacion == "Right"
//                 ? const BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20))
//                 : const BorderRadius.all(Radius.circular(20))),
//         color: color,
//         border: Border.all(color: ClsColor.textcolorBlanco(), width: 0.4, style: BorderStyle.solid),
//       ),
//       child: Column(
//         children: [
//           Text(
//             text,
//             style: TextStyle(
//               color: ClsColor.textcolorBlanco(),
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   static Card CardCursoBusqueda({
//     required MmisHabilitacionesBusqueda? Lista,
//     required int index,
//     required BuildContext context,
//   }) {
//     return Card(
//       color: (Lista?.data[index].tEstado == "HABILITADO" || Lista?.data[index].tEstado == "APROBADO" || Lista?.data[index].tEstado == "APTO")
//           ? ClsColor.textcolorBlanco()
//           : ClsColor.textcolorRojoClaro(),
//       margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
//       child: ListTile(
//         leading: Transform(
//           transform: Matrix4.translationValues(-15.0, 0.0, 0.0),
//           child: Column(
//             children: [
//               IconButton(
//                 icon: Icon(
//                   Icons.circle,
//                   color: (Lista?.data[index].tEstado == "HABILITADO" || Lista?.data[index].tEstado == "APROBADO" || Lista?.data[index].tEstado == "APTO")
//                       ? Colors.green
//                       : Colors.red,
//                   size: 30,
//                   shadows: [BoxShadow(color: ClsColor.textcolorPlata(), blurRadius: 10, offset: const Offset(3, 3))],
//                 ),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//         ),
//         title: Transform(
//           transform: Matrix4.translationValues(-30.0, 0.0, 0.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text(
//                 (Lista?.data[index].tCurso).toString(),
//                 overflow: TextOverflow.fade,
//                 maxLines: 2,
//                 softWrap: false,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: ClsColor.textcolorNegro(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         subtitle: Transform(
//           transform: Matrix4.translationValues(-30.0, 0.0, 0.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text(
//                 overflow: TextOverflow.ellipsis,
//                 "Hasta ${Lista?.data[index].tFechaVto}", //Lista?.data[index].iTipoCurso == 1 ? "Hasta ${Lista?.data[index].tFechaVto}" : (Lista?.data[index].tRiesgo).toString(),
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w400,
//                   color: ClsColor.textcolorGrisClaro(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         trailing: Icon(vGlobal.iPerfilBusqueda == 1 ? Icons.chevron_right : null, color: Colors.black, size: 15),
//         onTap: () async {
//           if (vGlobal.iPerfilBusqueda == 1) {
//             bool alert = false;
//             String title = 'Alerta';
//             String message = '';
//             String cierre = 'Cerrar';
//             try {
//               String? iDCursoDetalle = Lista?.data[index].iDCapacitacionUsuario.toString() ?? "0";
//               final MHabCursoDetalle? Posthcd = await posHabCursoDetalle(iDCursoDetalle, vGlobal.SCiMUsuario.toString());
//               var datahcd = jsonEncode(Posthcd);
//               var tJsonhcd = mHabCursoDetalleFromJson(datahcd.toString());

//               vGlobal.tCurso = tJsonhcd.data?.tCurso;
//               vGlobal.tRiesgo = tJsonhcd.data?.tRiesgo;
//               vGlobal.iTipoCurso = tJsonhcd.data?.iTipoCurso;
//               vGlobal.tHabilitado = tJsonhcd.data?.tHabilitado;
//               vGlobal.tHabilitadoTexto = tJsonhcd.data?.tHabilitadoTexto;
//               vGlobal.tAutorizado = tJsonhcd.data?.tAutorizado;
//               vGlobal.tAutorizadoTexto = tJsonhcd.data?.tAutorizadoTexto;
//               vGlobal.tAptitudMedica = tJsonhcd.data?.tAptitudMedica;
//               vGlobal.tAptitudMedicaTexto = tJsonhcd.data?.tAptitudMedicaTexto;
//               vGlobal.tAptitudMedicaRiesgo = tJsonhcd.data?.tAptitudMedicaRiesgo;
//               vGlobal.tAptitudMedicaRiesgoTexto = tJsonhcd.data?.tAptitudMedicaRiesgoTexto;
//               vGlobal.tModalidadCapacitacion = tJsonhcd.data?.tModalidadCapacitacion;
//               vGlobal.nNota = tJsonhcd.data?.nNota;
//               vGlobal.nHoras = tJsonhcd.data?.nHoras;
//               vGlobal.tEmpresaCapacitadora = tJsonhcd.data?.tEmpresaCapacitadora;
//               vGlobal.tInstructor = tJsonhcd.data?.tInstructor;
//               vGlobal.tValidez = tJsonhcd.data?.tValidez;
//               vGlobal.tObservaciones = tJsonhcd.data?.tObservaciones;
//               vGlobal.tCertificadoBase64 = vGlobal.tCertificadoBase64;
//               vGlobal.iVigente = tJsonhcd.data?.iVigente;
//               vGlobal.tEstadoColor = tJsonhcd.data?.tEstadoColor;
//               vGlobal.tEstado = tJsonhcd.data?.tEstado;
//               if (tJsonhcd.data?.requisitos.length != 0) {
//                 var datahcdreqDetalle = jsonEncode(tJsonhcd.data?.requisitos);
//                 vGlobal.tRequisitos = mHabCursoDetalleReqFromJson(datahcdreqDetalle);
//               } else {
//                 vGlobal.tRequisitos = null;
//               }

//               //vGlobal.Requisitos = tJsonhcd.data.requisitos;
//               // ignore: use_build_context_synchronously
//               Navigator.push(
//                 context,
//                 Lista?.data[index].iTipoCurso == 1
//                     ? MaterialPageRoute(
//                         builder: (context) => induccion(Origen: 2),
//                       )
//                     : MaterialPageRoute(
//                         builder: (context) => habilitado(Origen: 2),
//                       ),
//               );
//             } catch (e) {
//               alert = true;
//               message = "Sin información disponible";
//             }
//             if (alert == true) {
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return ClsDecoration.AlertDialogMessage(context: context, title: title, message: message, cierre: cierre);
//                 },
//               );
//             }
//           }
//         },
//       ),
//     );
//   }

//   static Card CardEncuesta({
//     required MEncuesta? Lista,
//     required int index,
//     required BuildContext context,
//   }) {
//     return Card(
//       color: ClsColor.textcolorBlanco(),
//       margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//       child: ListTile(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text(
//               (Lista?.data[index].tEncuesta).toString(),
//               overflow: TextOverflow.fade,
//               maxLines: 2,
//               softWrap: false,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: ClsColor.textcolorNegro(),
//               ),
//             ),
//           ],
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text(
//               overflow: TextOverflow.ellipsis,
//               (Lista?.data[index].tVigencia).toString(),
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w400,
//                 color: ClsColor.textcolorGrisClaro(),
//               ),
//             ),
//           ],
//         ),
//         trailing: const Icon(Icons.chevron_right, color: Colors.black, size: 15),
//         onTap: () async {
//           // bool alert = false;
//           // String title = 'Alerta';
//           // String message = '';
//           // String cierre = 'Cerrar';
//           // try {
//           //   String? iDCursoDetalle = Lista?.data[index].iDCapacitacionUsuario.toString() ?? "0";
//           //   final MHabCursoDetalle? Posthcd = await posHabCursoDetalle(iDCursoDetalle, vGlobal.iMUsuario.toString());
//           //   var datahcd = jsonEncode(Posthcd);
//           //   var tJsonhcd = mHabCursoDetalleFromJson(datahcd.toString());
//           vGlobal.Enc_iDEncuesta = Lista?.data[index].iDEncuesta;
//           vGlobal.Enc_iDEncuestaUsuario = Lista?.data[index].iDEncuestaUsuario;
//           vGlobal.Enc_tEncuesta = Lista?.data[index].tEncuesta;
//           vGlobal.Enc_tVigencia = Lista?.data[index].tVigencia;
//           vGlobal.Enc_tIndicaciones = Lista?.data[index].tIndicaciones;
//           vGlobal.Enc_iEstado = Lista?.data[index].iEstado;
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => EncuestaIndicaciones()),
//           );

//           //   vGlobal.tAutorizadoTexto = tJsonhcd.data?.tAutorizadoTexto;
//           //   vGlobal.tAptitudMedica = tJsonhcd.data?.tAptitudMedica;
//           //   vGlobal.tAptitudMedicaTexto = tJsonhcd.data?.tAptitudMedicaTexto;
//           //   vGlobal.tAptitudMedicaRiesgo = tJsonhcd.data?.tAptitudMedicaRiesgo;
//           //   vGlobal.tAptitudMedicaRiesgoTexto = tJsonhcd.data?.tAptitudMedicaRiesgoTexto;
//           //   vGlobal.tModalidadCapacitacion = tJsonhcd.data?.tModalidadCapacitacion;
//           //   vGlobal.nNota = tJsonhcd.data?.nNota;
//           //   vGlobal.nHoras = tJsonhcd.data?.nHoras;
//           //   vGlobal.tEmpresaCapacitadora = tJsonhcd.data?.tEmpresaCapacitadora;
//           //   vGlobal.tInstructor = tJsonhcd.data?.tInstructor;
//           //   vGlobal.tValidez = tJsonhcd.data?.tValidez;
//           //   vGlobal.tObservaciones = tJsonhcd.data?.tObservaciones;
//           //   vGlobal.tCertificadoBase64 = vGlobal.tCertificadoBase64;
//           //   vGlobal.iVigente = tJsonhcd.data?.iVigente;
//           //   vGlobal.tEstadoColor = tJsonhcd.data?.tEstadoColor;
//           //   vGlobal.tEstado = tJsonhcd.data?.tEstado;
//           //   if (tJsonhcd.data?.requisitos.length != 0) {
//           //     var datahcdreqDetalle = jsonEncode(tJsonhcd.data?.requisitos);
//           //     vGlobal.tRequisitos = mHabCursoDetalleReqFromJson(datahcdreqDetalle);
//           //   } else {
//           //     vGlobal.tRequisitos = null;
//           //   }

//           //   //vGlobal.Requisitos = tJsonhcd.data.requisitos;
//           //   // ignore: use_build_context_synchronously
//           //   Navigator.push(
//           //     context,
//           //     Lista?.data[index].iTipoCurso == 1
//           //         ? MaterialPageRoute(
//           //             builder: (context) => induccion(),
//           //           )
//           //         : MaterialPageRoute(
//           //             builder: (context) => habilitado(),
//           //           ),
//           //   );
//           // } catch (e) {
//           //   alert = true;
//           //   message = "Sin información disponible";
//           // }
//           // if (alert == true) {
//           //   showDialog(
//           //     context: context,
//           //     builder: (BuildContext context) {
//           //       return ClsDecoration.AlertDialogMessage(context: context, title: title, message: message, cierre: cierre);
//           //     },
//           //   );
//           // }
//         },
//       ),
//     );
//   }
}
