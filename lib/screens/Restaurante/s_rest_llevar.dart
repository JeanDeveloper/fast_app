import 'dart:async';

import 'package:fast/models/Restaurante/m_GetMesas.dart';
import 'package:fast/models/Restaurante/m_GetParaLlevarDelivery.dart';
import 'package:fast/providers/providers_Restaurante.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Restaurante.dart' as vGlobal_Restaurante;
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:flutter/material.dart';

class llevar extends StatefulWidget {
  const llevar({Key? key}) : super(key: key);

  @override
  _llevar createState() => new _llevar();
}

Future<bool> _onWillPop() async {
  return false; //<-- SEE HERE
}

class _llevar extends State<llevar> with TickerProviderStateMixin {
  var result_CargaLlevar = <Widget>[];

  @override
  void initState() {
    if (this.mounted) {
      _AsyncData();
      _GenerarCargaLlevar();
      super.initState();
    }
  }

  _AsyncData() async {
    Timer mytimer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      if (this.mounted) {
        _GenerarCargaLlevar();
      }
    });
  }

  void _GenerarCargaLlevar() {
    setState(() {
      result_CargaLlevar = <Widget>[];
      result_CargaLlevar.add(
        FutureBuilder<GetParaLlevarDelivery?>(
          future: getParaLlevarDelivery(2),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            final GetParaLlevarDelivery? Lista = snapshot.data;
            return GridView.builder(
              physics: const ScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2),
              itemCount: Lista?.data!.length ?? 0,
              itemBuilder: (context, index) {
                return ClsDecoration.listMesasLlevarDelivery(lista: Lista, index: index, context: context);
              },
            );
          },
        ),
      );
    });
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
                    Navigator.pushNamed(context, "navprincipal");
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
                    "PARA LLEVAR",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 14, overflow: TextOverflow.fade, fontWeight: FontWeight.w700, color: ClsColor.tipo4()),
                  ),
                  const SizedBox(height: 5),
                  Text(vGlobal.tUsuario!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: ClsColor.tipo4())),
                ],
              ),
            ),
          ],
        ),
        drawer: NavDrawer(),
        backgroundColor: ClsColor.tipo1(),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Material(
                type: MaterialType.transparency,
                child: Ink(
                  decoration: BoxDecoration(border: Border.all(color: ClsColor.tipo2(), width: 1), color: ClsColor.tipo1(), borderRadius: BorderRadius.circular(50.0)), //<-- SEE HERE
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50.0),
                    onTap: () {
                      _GenerarCargaLlevar();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Icon(
                        Icons.refresh_rounded,
                        size: 18.0,
                        color: ClsColor.tipo4(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Stack(children: result_CargaLlevar),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              vGlobal_Restaurante.iMSalon = null;
              vGlobal_Restaurante.tSalon = "";
              vGlobal_Restaurante.iMMesa = null;
              vGlobal_Restaurante.tMesa = "";
              vGlobal_Restaurante.tCliente = null;
              vGlobal_Restaurante.iPax = null;
              vGlobal_Restaurante.iIDPedido = 0;
              vGlobal_Restaurante.listPrecuenta = [];
              vGlobal_Restaurante.delTelefono = null;
              vGlobal_Restaurante.delCliente = null;
              vGlobal_Restaurante.delDireccion = null;
              vGlobal_Restaurante.delReferencia = null;
              vGlobal_Restaurante.iMProductoDelivery = null;
              vGlobal_Restaurante.TipoPedido = "LLEVAR";
              Navigator.pushNamed(context, "navproductoSeleccionar");
            },
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(300, 50)),
              backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
              padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )),
            ),
            icon: Icon(Icons.add, size: 20, color: ClsColor.tipo4()),
            label: Text("Nuevo Pedido", style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }
}
