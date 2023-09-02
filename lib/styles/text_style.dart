import 'package:flutter/material.dart';
import 'color_style.dart';

class ClsTextStyle {
  static Container cabeceraBienvenida({
    required String titulo,
    required String subtitulo,
    required String detalle,
    String? vistaIconos,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: ClsColor.tipo1(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (titulo != "") ...[
            ClsTextStyle.textTitulo(text: titulo),
            const SizedBox(height: 5),
          ],
          if (vistaIconos == null) ...[
            if (subtitulo != "") ...[
              ClsTextStyle.textSubTitulo(text: subtitulo),
              const SizedBox(height: 5),
            ],
            if (detalle != "") ...[
              ClsTextStyle.textSubTitulo(text: detalle),
              const SizedBox(height: 5),
            ],
          ],
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  static Text textTitulo({required String text}) {
    return Text(text, style: TextStyle(color: ClsColor.tipo4(), fontSize: 16, fontWeight: FontWeight.w700));
  }

  static Text textSubTitulo({required String text}) {
    return Text(text, textAlign: TextAlign.justify, style: TextStyle(color: ClsColor.tipo4(), fontSize: 12, fontWeight: FontWeight.w400));
  }

  static Text textTituloDetalle({required String text}) {
    return Text(text, textAlign: TextAlign.justify, style: TextStyle(color: ClsColor.tipo4(), fontSize: 10, fontWeight: FontWeight.w400));
  }
}
