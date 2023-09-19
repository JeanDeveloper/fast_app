import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_widget/ticket_widget.dart';

class CocinaScreen extends StatefulWidget {
  const CocinaScreen({super.key});
  @override
  State<CocinaScreen> createState() => _CocinaScreenState();
}

Future<bool> _onWillPop() async {
  return false; 
  _setOrientation(DeviceOrientation.portraitUp);
}


  void _setOrientation(DeviceOrientation orientation) {
    SystemChrome.setPreferredOrientations([orientation]);
  }

class _CocinaScreenState extends State<CocinaScreen> {

  @override
  void initState() {
    super.initState();
    _setOrientation(DeviceOrientation.landscapeLeft);
  }

  @override
  void dispose() {
    super.dispose();
    _setOrientation(DeviceOrientation.portraitUp);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: ClsDecoration.appBar(context, "navprincipal", isBoth: true),
        drawer: NavDrawer(),
        backgroundColor: ClsColor.tipo1(),
        body: SizedBox.expand(
          child: SingleChildScrollView(
            child: Column(
              children: [
          
                // ClsTextStyle.cabeceraBienvenida(
                //   titulo: 'PEDIDO EN COCINA',
                //   subtitulo: "Estado de pedidos",
                //   detalle: '',
                // ),
                Expanded(child: form_recuperar(context)),
              ],
            ),
          ),
        ),

        // bottomNavigationBar: const CustomBottomNavigatorBar(),
      ),
    );
  }

  Container form_recuperar(BuildContext context){

    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: ClsColor.tipo2(),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),

      padding: const EdgeInsets.all(20),

      child: ListView.builder(
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => TicketWidget(

          margin: const EdgeInsets.all(10),
          width: 300,
          height: 1000,
          isCornerRounded: true,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Mesa 4 / Piso 1"),
                  Row(
                    children: [
                      Icon(Icons.access_time),
                      Text("10:07"),
                    ],
                  )
                ],
              ),

              const Text("Orden # 91"),
              const Text("Mozo: Jean Chunga"),
              const Text("Obs: Este pedido es de alta urgencia"),
              const SizedBox(height: 10),

              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey,
                    width: 2.0
                  ),
                ),
              ),

              // Container(
              //   height: 100,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     border: Border.all(
              //       color: Colors.grey,
              //       width: 2.0
              //       )
              //   ),
              // ),

              // Container(
              //   height: 100,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     border: Border.all(
              //       color: Colors.grey,
              //       width: 2.0
              //       )
              //   ),
              // )
            ],
          ),
        ),

      ),

    );


  }


}

class CustomBottomNavigatorBar extends StatelessWidget {
  const CustomBottomNavigatorBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Recientes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Preparando',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Atendido',
        ),
      ],
    );
  }
}