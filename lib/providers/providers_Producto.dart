import 'dart:convert';
import 'package:fast/models/Producto/m_GetCajaListar.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:fast/providers/global.dart' as vGlobal;

Future<GetProductoPorNombre?> getistProductoPorNombre(String tNombre) async {
  final response = await http.get(
    Uri.parse('${vGlobal.urlAPI}/Producto/GetProductoPorNombre?tNombre=$tNombre&tEmpresaRuc=${vGlobal.tEmpresaRuc.toString()}'),
    headers: {
      "Authorization": "Bearer ${vGlobal.token}",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "content-type": "application/json",
      "Accept": "application/json",
    },
  );
  if (response.statusCode == 200) {
    return compute(getProductoPorNombreFromJson, response.body);
  }

  return null;
}
