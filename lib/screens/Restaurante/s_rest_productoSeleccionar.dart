import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:fast/models/Restaurante/m_GetCartaCategoria.dart';
import 'package:fast/models/Restaurante/m_GetCartaProductos.dart';
import 'package:fast/providers/providers_Restaurante.dart';
import 'package:fast/styles/color_style.dart';
import 'package:fast/styles/text_style.dart';
import 'package:fast/providers/global.dart' as vGlobal;
import 'package:fast/providers/global_Restaurante.dart' as vGlobal_Restaurante;
import 'package:fast/widgets/decoration.dart';
import 'package:fast/widgets/navRight.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class productoSeleccionar extends StatefulWidget {
  const productoSeleccionar({Key? key}) : super(key: key);

  @override
  _productoSeleccionar createState() => new _productoSeleccionar();
}

class _productoSeleccionar extends State<productoSeleccionar> with TickerProviderStateMixin {
  var resultProductos = <Widget>[];
  var resultSubcategoria = <Widget>[];
  String textButton = "TODOS";
  bool visiblebutton = true;
  bool visibleSubCategoria = false;
  final _textfilterController = TextEditingController(text: "");
  //final CTipo = TextEditingController(text: vGlobal_Restaurante.valuesCategoriaList![0].toString());
  int iMCategoria = 0;
  int iMSubCategoria = 0;
  @override
  void initState() {
    _asyncMethod(textButton, visiblebutton);
    super.initState();
  }

  void updateText(String tvalor, bool ivalor) {
    generarProductos();
    setState(() {
      textButton = tvalor;
      visiblebutton = ivalor;
    });
  }

  _asyncMethod(String tvalor, bool ivalor) async {
    updateText(tvalor, ivalor);
  }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  _AsyncData() async {
    ClsDecoration.showDialogLoading(context);
    Fluttertoast.showToast(msg: "Actualizando Lista de Productos", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
    vGlobal_Restaurante.valuesCategoriaList = [];
    vGlobal_Restaurante.labelCategoriaList = [];
    await loadProductos();
    String? listCategoria = await loadCategoria;

    for (int i = 0; i < mGetCartaCategoriaFromJson(listCategoria.toString()).data.length; i++) {
      vGlobal_Restaurante.valuesCategoriaList![i] = mGetCartaCategoriaFromJson(listCategoria.toString()).data[i].iMCategoria!;
      vGlobal_Restaurante.labelCategoriaList![i] = mGetCartaCategoriaFromJson(listCategoria.toString()).data[i].tCategoria!;
    }
    vGlobal_Restaurante.valuesCategoriaList![mGetCartaCategoriaFromJson(listCategoria.toString()).data.length] = 0;
    vGlobal_Restaurante.labelCategoriaList![mGetCartaCategoriaFromJson(listCategoria.toString()).data.length] = "TODOS";
    generarProductos();
    Navigator.of(context).pop();
    Fluttertoast.showToast(msg: "Productos Actualizados", gravity: ToastGravity.CENTER, backgroundColor: ClsColor.tipo6(), textColor: ClsColor.tipo4());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: AppBar(automaticallyImplyLeading: false, backgroundColor: ClsColor.tipo2()),
        ),
        backgroundColor: ClsColor.tipo2(),
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

  void generarProductos() {
    setState(() {
      resultProductos = [];
      resultProductos.add(FutureBuilder<List<CartaProductoData>?>(
        future: getProductos(iMCategoria, iMSubCategoria, _textfilterController.text),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          final List<CartaProductoData>? Lista = snapshot.data;
          return GridView.builder(
            padding: const EdgeInsets.all(0),
            physics: const ScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            // ignore: prefer_const_constructors
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: Lista?.length ?? 0,
            itemBuilder: (context, index) {
              return ClsDecoration.listProductos(lista: Lista, index: index, context: context);
            },
          );
        },
      ));
    });
  }

  void generarSubCategoria(int index) {
    var Categoria = mGetCartaCategoriaFromJson(vGlobal_Restaurante.tCategoriaJson.toString());
    try {
      List<String> tSubCategoriaList = List.filled(Categoria.data[index].subCategoria!.length + 1, "");
      List<int> iSubCategoriaList = List.filled(Categoria.data[index].subCategoria!.length + 1, 0);
      for (int i = 0; i < Categoria.data[index].subCategoria!.length; i++) {
        iSubCategoriaList[i] = Categoria.data[index].subCategoria![i].iMSubCategoria!;
        tSubCategoriaList[i] = Categoria.data[index].subCategoria![i].tSubCategoria!;
      }
      iSubCategoriaList[Categoria.data[index].subCategoria!.length] = 0;
      tSubCategoriaList[Categoria.data[index].subCategoria!.length] = "TODOS";
      setState(() {
        resultSubcategoria = [];
        iMSubCategoria = 0;
        if (Categoria.data[index].subCategoria!.length > 0) {
          resultSubcategoria.add(
            CustomRadioButton(
              selectedBorderColor: ClsColor.tipo9(),
              unSelectedBorderColor: ClsColor.tipo11(),
              elevation: 2,
              absoluteZeroSpacing: false,
              enableButtonWrap: true,
              // enableShape: true,
              width: 140,
              unSelectedColor: ClsColor.tipo11(),
              buttonLables: tSubCategoriaList,
              buttonValues: iSubCategoriaList,
              buttonTextStyle: const ButtonTextStyle(selectedColor: Colors.white, unSelectedColor: Colors.black, textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
              defaultSelected: 0,
              radioButtonValue: (value) {
                setState(() {
                  iMSubCategoria = value;
                  _textfilterController.text = "";
                  generarProductos();
                });
              },
              selectedColor: ClsColor.tipo9(),
            ),
          );
        }
      });
    } catch (e) {
      resultSubcategoria = [];
      iMSubCategoria = 0;
    }
  }

  Container form_recuperar(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ClsColor.tipo2(),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Material(
                        type: MaterialType.transparency,
                        child: Ink(
                          decoration: BoxDecoration(border: Border.all(color: ClsColor.tipo2(), width: 1), color: ClsColor.tipo1(), borderRadius: BorderRadius.circular(50.0)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50.0),
                            onTap: () {
                              Navigator.pushNamed(context, "navnuevaOrden");
                            },
                            child: Padding(padding: const EdgeInsets.all(6), child: Icon(Icons.keyboard_arrow_left_rounded, size: 20.0, color: ClsColor.tipo4())),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Material(
                        type: MaterialType.transparency,
                        child: Ink(
                          decoration: BoxDecoration(border: Border.all(color: ClsColor.tipo2(), width: 1), color: ClsColor.tipo1(), borderRadius: BorderRadius.circular(50.0)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50.0),
                            onTap: () {
                              setState(() {
                                _AsyncData();
                              });
                            },
                            child: Padding(padding: const EdgeInsets.all(7), child: Icon(Icons.refresh_rounded, size: 18.0, color: ClsColor.tipo4())),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: TextFormField(
                          controller: _textfilterController,
                          decoration: InputDecoration(
                            hintText: "Buscar Producto",
                            filled: true,
                            isDense: true,
                            fillColor: ClsColor.tipo4(),
                            enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                            focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20)), borderSide: BorderSide(color: ClsColor.tipo4(), width: 2)),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search_rounded, size: 25, color: ClsColor.tipo1()),
                              onPressed: () {
                                setState(() {
                                  generarProductos();
                                });
                              },
                            ),
                          ),
                          onChanged: (value) {
                            if (_textfilterController.text.isEmpty) {
                              setState(() {
                                generarProductos();
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 5),
                      Material(
                        type: MaterialType.transparency,
                        child: Ink(
                          decoration: BoxDecoration(border: Border.all(color: ClsColor.tipo2(), width: 1), color: ClsColor.tipo1(), borderRadius: BorderRadius.circular(50.0)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50.0),
                            onTap: () {
                              setState(() {
                                _textfilterController.text = "";
                                generarProductos();
                              });
                            },
                            child: Padding(padding: const EdgeInsets.all(7), child: Icon(Icons.clear_all_sharp, size: 18.0, color: ClsColor.tipo4())),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (visiblebutton == true) ...[
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            iMCategoria = 0;
                            _textfilterController.text = "";
                            _asyncMethod("TODOS", false);
                            resultSubcategoria = [];
                            iMCategoria = 0;
                            generarProductos();
                          });
                        },
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(const TextStyle(overflow: TextOverflow.ellipsis)),
                          fixedSize: MaterialStateProperty.all(const Size(300, 40)),
                          backgroundColor: MaterialStateProperty.all<Color>(ClsColor.tipo1()),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(textButton, textAlign: TextAlign.center, overflow: TextOverflow.fade, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, overflow: TextOverflow.ellipsis)),
                                const SizedBox(width: 5),
                                const Icon(Icons.cancel, size: 20.0)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      child: CustomRadioButton(
                        selectedBorderColor: ClsColor.tipo1(),
                        unSelectedBorderColor: ClsColor.tipo11(),
                        elevation: 2,
                        absoluteZeroSpacing: false,
                        enableButtonWrap: true,
                        enableShape: true,
                        width: 140,
                        unSelectedColor: ClsColor.tipo11(),
                        buttonLables: vGlobal_Restaurante.labelCategoriaList!,
                        buttonValues: vGlobal_Restaurante.valuesCategoriaList!,
                        buttonTextStyle: const ButtonTextStyle(selectedColor: Colors.white, unSelectedColor: Colors.black, textStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, overflow: TextOverflow.fade)),
                        defaultSelected: 0,
                        radioButtonValue: (value) {
                          setState(() {
                            //CTipo.text = value.toString();
                            iMCategoria = value;
                            final int index1 = vGlobal_Restaurante.valuesCategoriaList!.indexWhere(((book) => book == value));
                            if (index1 != -1) {
                              textButton = vGlobal_Restaurante.labelCategoriaList![index1];
                            }
                            iMSubCategoria = 0;
                            _textfilterController.text = "";
                            _asyncMethod(textButton, true);
                            generarSubCategoria(index1);
                          });
                        },
                        selectedColor: ClsColor.tipo1(),
                      ),
                    ),
                  ],
                  Column(
                    children: resultSubcategoria,
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: resultProductos,
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
