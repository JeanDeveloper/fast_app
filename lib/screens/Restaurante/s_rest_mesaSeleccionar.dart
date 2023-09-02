import 'dart:async';

import 'package:fast/models/Restaurante/m_GetMesas.dart';
import 'package:fast/providers/providers_Restaurante.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Restaurante.dart' as vGlobal_Restaurante;
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:flutter/material.dart';

class mesaSeleccionar extends StatefulWidget {
  const mesaSeleccionar({Key? key}) : super(key: key);

  @override
  _mesaSeleccionar createState() => new _mesaSeleccionar();
}

Future<bool> _onWillPop() async {
  return false; //<-- SEE HERE
}

class _mesaSeleccionar extends State<mesaSeleccionar> with TickerProviderStateMixin {
  var result_CargaMesa = <Widget>[];

  @override
  void initState() {
    if (this.mounted) {
      _AsyncData();
      _GenerarCargaMesa();
      super.initState();
    }
  }

  _AsyncData() async {
    Timer mytimer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      if (this.mounted) {
        _GenerarCargaMesa();
      }
    });
  }

  void _GenerarCargaMesa() {
    setState(() {
      result_CargaMesa = <Widget>[];
      result_CargaMesa.add(
        FutureBuilder<MGetMesas?>(
          future: getMesas,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            final MGetMesas? Lista = snapshot.data;
            return GridView.builder(
              physics: const ScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              // physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2,
              ),
              itemCount: Lista?.data.length ?? 0,
              itemBuilder: (context, index) {
                return ClsDecoration.listMesas(lista: Lista, index: index, context: context);
              },
            );
          },
        ),
      );
    });
    // return result;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: ClsDecoration.appBar(context, "navniveles"),
        drawer: NavDrawer(),
        backgroundColor: ClsColor.tipo1(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              ClsTextStyle.cabeceraBienvenida(titulo: "${vGlobal_Restaurante.tSalon}", subtitulo: "", detalle: '', vistaIconos: ""),
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
              Text('Mesas', style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
              Row(
                children: [
                  Material(
                    type: MaterialType.transparency,
                    child: Ink(
                      decoration: BoxDecoration(border: Border.all(color: ClsColor.tipo2(), width: 2.5), color: ClsColor.tipo1(), borderRadius: BorderRadius.circular(50.0)), //<-- SEE HERE
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50.0),
                        onTap: () {
                          _GenerarCargaMesa();
                        },
                        child: Padding(padding: const EdgeInsets.all(7), child: Icon(Icons.refresh_rounded, size: 18.0, color: ClsColor.tipo4())),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "navmesaUnir");
                    },
                    style: ElevatedButton.styleFrom(fixedSize: const Size(120, 30), backgroundColor: ClsColor.tipo1(), splashFactory: InkSplash.splashFactory),
                    icon: Icon(Icons.widgets_rounded, size: 17.0, color: ClsColor.tipo4()),
                    label: Text('Unir Mesas', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: ClsColor.tipo4())),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Stack(children: result_CargaMesa),
            ),
          ),
        ],
      ),
    );
  }
}
