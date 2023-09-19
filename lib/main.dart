
import 'dart:async';
import 'dart:io';
import 'package:fast/providers/providers.dart';
import 'package:fast/screens/Caja/s_caja_aperturar.dart';
import 'package:fast/screens/Caja/s_caja_cajaChica.dart';
import 'package:fast/screens/Caja/s_caja_cajaDiaria.dart';
import 'package:fast/screens/Caja/s_caja_cajaDiariaDetalle.dart';
import 'package:fast/screens/Restaurante/s_rest_cocina.dart';
import 'package:fast/screens/Restaurante/s_rest_delivery.dart';
import 'package:fast/screens/Restaurante/s_rest_llevar.dart';
import 'package:fast/screens/Restaurante/s_rest_mesaTransferir.dart';
import 'package:fast/screens/Restaurante/s_rest_mesaUnir.dart';
import 'package:fast/screens/Restaurante/s_rest_mesaUnirPrincipal.dart';
import 'package:fast/screens/Transporte/s_trans_anularComprobante.dart';
import 'package:fast/screens/Transporte/s_trans_cobrar.dart';
import 'package:fast/screens/Transporte/s_trans_ordenTrasladoLista.dart';
import 'package:fast/screens/Transporte/s_trans_ordenTrasladoNiv1.dart';
import 'package:fast/screens/Transporte/s_trans_ordenTrasladoNiv2.dart';
import 'package:fast/screens/Transporte/s_trans_pedidoPersonalizacion.dart';
import 'package:fast/screens/Transporte/s_trans_pedidoResultado.dart';
import 'package:fast/screens/Transporte/s_trans_registrar.dart';
import 'package:fast/screens/Transporte/s_trans_resultado.dart';
import 'package:fast/screens/Transporte/s_trans_seleccionarAsiento.dart';
import 'package:flutter/material.dart';
import 'package:fast/screens/Home/s_cargando.dart';
import 'package:fast/screens/Home/s_login.dart';
import 'package:fast/screens/Home/s_principal.dart';
import 'package:fast/providers/settings.dart';
import 'package:fast/screens/Restaurante/s_rest_niveles.dart';
import 'package:fast/screens/Restaurante/s_rest_mesaSeleccionar.dart';
import 'package:fast/screens/Restaurante/s_rest_pedidoInicio.dart';
import 'package:fast/screens/Restaurante/s_rest_consumo.dart';
import 'package:fast/screens/Restaurante/s_rest_productoSeleccionar.dart';
import 'package:fast/screens/Restaurante/s_rest_pedidoPersonalizacion.dart';
import 'package:fast/screens/Restaurante/s_rest_nuevaOrden.dart';
import 'package:fast/screens/Restaurante/s_rest_Print.dart';
import 'package:responsive_framework/responsive_framework.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fast/providers/options.dart' as vOptions;
import 'package:fast/providers/global.dart' as vGlobal;

Future<void> main()  async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String time = "";
  @override
  void initState() {
    try {
      _asyncConection();
      _asyncMethod();
    } on SocketException {
      print("Hay un error en el servicio");
    }

    super.initState();
  }

    _asyncMethod() async {
    Timer.periodic(const Duration(minutes: 10), (timer) async {
      await posToken();
    });
  }

  _asyncConection() async {
    final prefs = await SharedPreferences.getInstance();
    int tipoConexion = prefs.getInt('tipoConexion') ?? 1;
    String servidorConexion = prefs.getString('servidorConexion') ?? "";  
    String servidorConexionPuerto = prefs.getString('servidorConexionPuerto') ?? "";
    bool estado = false;
    setState(() {
      vOptions.tipoConexion = tipoConexion;
      vOptions.servidorConexion = servidorConexion;
      vOptions.servidorConexionPuerto = servidorConexionPuerto;
      if ( tipoConexion  == 1 ) {
        vGlobal.urlAPI = vGlobal.urlNube;
        estado = true;
        // await posToken();
      } else {
        if (servidorConexion.isNotEmpty && servidorConexionPuerto.isNotEmpty) {
          vGlobal.urlAPI = 'http://${vOptions.servidorConexion}:${vOptions.servidorConexionPuerto}';
          estado = true;
          // await posToken();
        }
      }
    });
    if (estado == true) {
      await posToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],           
      ),

      // localizationsDelegates: const [
      //   // GlobalMaterialLocalizations.delegate,
      //   // GlobalCupertinoLocalizations.delegate,
      //   DefaultWidgetsLocalizations.delegate,
      // ],
      // supportedLocales: const [Locale('en'), Locale('es')],

      debugShowCheckedModeBanner: false,
      routes: {
        //////////////////////////////////////////////////// INICIO
        'navcargando': (_) => const cargando(),
        'navlogin': (_) => const login(),
        'navprincipal': (_) => const principal(),
        'navSettings': (_) => settings(),
        'navPrint': (_) => Print(listPrecuentatemp: [],tMacImpresora: "", title: '',),
        //////////////////////////////////////////////////// RESTAURANTE
        'navniveles': (_) => const niveles(),
        'navmesaSeleccionar': (_) => const mesaSeleccionar(),
        'navpedidoInicio': (_) => const pedidoInicio(),
        'navconsumo': (_) => const consumo(),
        'navproductoSeleccionar': (_) => const productoSeleccionar(),
        'navpedidoPersonalizacion': (_) => const pedidoPersonalizacion(),
        'navnuevaOrden': (_) => const nuevaOrden(),
        'navmesaUnir': (_) => const mesaUnir(),
        'navmesaUnirPrincipal': (_) => const mesaUnirPrincipal(),
        'navmesaTransferir': (_) => const mesaTransferir(),
        'navllevar': (_) => const llevar(),
        'navdelivery': (_) => const delivery(),
        //////////////////////////////////////////////////// TRANSPORTE
        'navtrans_registrarBoleto': (_) => const trans_registrarBoleto(),
        'navtrans_resultadoBoleto': (_) => const trans_resultadoBoleto(),
        'navtrans_seleccionarAsiento': (_) => const trans_seleccionarAsiento(),
        'navtrans_pedidoPersonalizacion': (_) => const trans_pedidoPersonalizacion(TipoAcceso: '',),
        'navtrans_cobrar': (_) => const trans_cobrar(Origen: '',),
        'navtrans_anularComprobante': (_) => const trans_anularComprobante(Origen: '',),
        'navtrans_pedidoResultado': (_) => const trans_pedidoPResultado(Origen: '',),
        'navtrans_ordenTrasladoLista': (_) => const trans_ordenTrasladoLista(),
        'navtrans_ordenTrasladoNiv1': (_) => const trans_ordenTrasladoNiv1(),
        'navtrans_ordenTrasladoNiv2': (_) => const trans_ordenTrasladoNiv2(),
        //////////////////////////////////////////////////// CAJA
        'navcaja_cajaChica': (_) => const caja_cajaChica(),
        'navcaja_aperturar': (_) => const caja_aperturar(),
        'navcaja_cajaDiaria': (_) => const caja_cajaDiaria(),
        'navcaja_cajaDiariaDetalle': (_) => const caja_cajaDiariaDetalle(iTipo: 0),

        'navcocina': ( _ ) => const CocinaScreen(),
      },
      initialRoute: 'navcargando',
    );
  }

}
