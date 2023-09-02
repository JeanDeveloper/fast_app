import 'package:fast/models/Restaurante/m_GetNiveles.dart';
import 'package:fast/providers/providers_Restaurante.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:flutter/material.dart';

class niveles extends StatefulWidget {
  const niveles({Key? key}) : super(key: key);

  @override
  _niveles createState() => new _niveles();
}

Future<bool> _onWillPop() async {
  return false; //<-- SEE HERE
}

class _niveles extends State<niveles> with TickerProviderStateMixin {
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
                titulo: 'PEDIDO PARA MESA',
                subtitulo: "Seleccione Salon",
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
                  Text('Salones', style: TextStyle(color: ClsColor.tipo1(), fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 15),
                  FutureBuilder<MGetNiveles?>(
                    future: getNiveles,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator.adaptive());
                      }
                      final MGetNiveles? Lista = snapshot.data;
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: Lista?.data.length ?? 0,
                        itemBuilder: (context, index) {
                          return ClsDecoration.listNiveles(lista: Lista, index: index, context: context);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
