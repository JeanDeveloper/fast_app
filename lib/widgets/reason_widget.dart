import 'package:fast/models/Restaurante/m_GetReason.dart';
import 'package:fast/providers/providers_Restaurante.dart';
import 'package:fast/styles/color_style.dart';
import 'package:flutter/material.dart';
import 'package:fast/providers/global_Restaurante.dart' as vGlobal_Restaurante;

class ReasonWidget extends StatefulWidget {

  final String ruc;
  const ReasonWidget({super.key, required this.ruc});

  @override
  State<ReasonWidget> createState() => _ReasonWidgetState();
}

class _ReasonWidgetState extends State<ReasonWidget> {

  // late Data _selectedItem = Data(iMMotivoBajaPedido: 1, tDescripcion: );
  late Future<GetReason?> _dropDownItemsFuture;
  Data? _selectedItem;

  @override
  void initState() {
    super.initState();
    _dropDownItemsFuture = getReason(widget.ruc);
  }

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future: _dropDownItemsFuture,

      builder: ( _ , AsyncSnapshot<GetReason?> snapshot ) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); 
        } else if (snapshot.hasError) {
          return const Text('Error al cargar los datos');
        } else if (!snapshot.hasData ) {
          return const Text('No hay datos disponibles');
        } else {
          List<Data> list = snapshot.data!.data;
          return Container(
            width: 250,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: ClsColor.tipo1(),width: 2),
            ),
        
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<Data>(
              isExpanded: true,
              value: (_selectedItem == null) ?  null : _selectedItem,
              hint: const Text("Seleccione el motivo"),
              onChanged: (newValue) {                
                setState(() {
                  _selectedItem = newValue!;
                  vGlobal_Restaurante.tMotivoAnulacion = _selectedItem;
                });
              },

              items: list.map((data) {
                return DropdownMenuItem<Data>(
                  value: data,
                  child: Text(data.tDescripcion.toLowerCase()),
                );
              }).toList(),

            ),
          );

        }     

      },
      
    );

  }
}