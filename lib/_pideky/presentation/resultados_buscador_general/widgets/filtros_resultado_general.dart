import 'package:emart/_pideky/presentation/buscador_general/view_model/search_fuzzy_view_model.dart';
import 'package:emart/_pideky/presentation/resultados_buscador_general/view/resultado_buscador_general.dart';
import 'package:emart/_pideky/presentation/resultados_buscador_general/view_model/resultado_buscador_general_view_model.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/src/modelos/fabricantes.dart';
import 'package:emart/src/pages/catalogo/widgets/dropDownFiltroProveedores.dart';
import 'package:emart/src/pages/catalogo/widgets/filtros_categoria_proveedores/icono_limpiar_filtro.dart';
import 'package:emart/src/pages/catalogo/widgets/sliderPrecios.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class FiltrosResultadoGeneral extends StatefulWidget {
  final String codCategoria;
  final String nombreCategoria;
  final String? urlImagen;
  final String codigoProveedor;
  FiltrosResultadoGeneral(
      {Key? key,
      required this.codCategoria,
      required this.nombreCategoria,
      required this.urlImagen,
      required this.codigoProveedor})
      : super(key: key);

  @override
  _FiltrosResultadoGeneralState createState() =>
      _FiltrosResultadoGeneralState();
}

class _FiltrosResultadoGeneralState extends State<FiltrosResultadoGeneral> {
  ControllerProductos catalogSearchViewModel = Get.find();
  final searchFuzzyViewModel = Get.put(SearchFuzzyViewModel());
  final resultadoBuscadorGeneralVm = Get.put(ResultadoBuscadorGeneralVm());
  RangeValues values = RangeValues(0, 500000);
  int valorRound = 3;

  String? dropdownValueCategoria;
  String? dropdownValueSubCategoria;
  String? dropdownValueMarca;
  String? dropdownValueProveedor;

  RxList<String> listCategorias = ['Todas'].obs;
  RxList<String> listSubCategorias = ['Todas'].obs;
  RxList<String> listMarcas = ['Todas'].obs;
  RxList<String> listProveedor = ['Todas'].obs;

  Color buttonColor = ConstantesColores.color_fondo_gris;
  Color textColor = ConstantesColores.azul_precio;

  @override
  void initState() {
    cargarCategorias();
    cargarMarca();
    cargarProveedor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controlador = Get.find<ControlBaseDatos>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Proveedor',
            style: TextStyle(
                color: ConstantesColores.azul_precio,
                fontWeight: FontWeight.bold)),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ConstantesColores.color_fondo_gris,
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
            onPressed: () {
              controlador.isDisponibleFiltro.value = true;
              Navigator.pop(context);
              catalogSearchViewModel.setPrecioMinimo(0);
              catalogSearchViewModel.setPrecioMaximo(1000000000);
            }),
        actions: <Widget>[
          AccionesBartCarrito(esCarrito: true),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(20.0),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text("Mejora tu búsqueda",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: HexColor("#41398D")),
                          textAlign: TextAlign.left),
                    ),
                    Spacer(),
                    IconoLimpiarFiltro().iconLimpiarFiltro((() {
                      setState(() {
                        limpiarFiltro();
                      });
                    }))
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: OverflowBar(
                    children: [
                      // Filtro de categorias
                      Obx(() => DropDownFiltroProveedores(
                          hin: "Todas",
                          titulo: "Proveedor",
                          listaItems: listProveedor.value,
                          value: dropdownValueProveedor,
                          color: buttonColor,
                          textcolor: textColor,
                          onChange: (String? value) async {
                            setState(() {
                              dropdownValueProveedor = value!;
                            });
                            if (dropdownValueProveedor != null &&
                                dropdownValueProveedor != "Todas") {
                              await cargarProveedor();
                            }
                          })),
                      SizedBox(
                        height: 5,
                      ),
                      Obx(() => DropDownFiltroProveedores(
                          hin: "Todas",
                          titulo: "Categoría",
                          listaItems: listCategorias.value,
                          value: dropdownValueCategoria,
                          color: buttonColor,
                          textcolor: textColor,
                          onChange: (String? value) async {
                            setState(() {
                              dropdownValueCategoria = value!;
                            });
                            if (dropdownValueCategoria != null &&
                                dropdownValueCategoria != "Todas") {
                              await cargarSubCategorias();
                              await cargarMarcasPorCategoria(1);
                            } 
                            
                          })),
                      SizedBox(
                        height: 5,
                      ),
                      Obx(() => DropDownFiltroProveedores(
                          titulo: "Subcategoría",
                          listaItems: listSubCategorias.value,
                          hin: "Todas",
                          color: buttonColor,
                          textcolor: textColor,
                          onChange: (String? value) async {
                            setState(() {
                              dropdownValueMarca = "Todas";
                              dropdownValueSubCategoria = value!;
                            });
                            if ((dropdownValueSubCategoria == "Todas" ||
                                        dropdownValueSubCategoria == null) &&
                                    dropdownValueCategoria == "Todas" ||
                                dropdownValueCategoria == null) {
                              
                              await cargarMarcasPorCategoria(2);
                            }
                          },
                          value: dropdownValueSubCategoria)),
                      SizedBox(
                        height: 5,
                      ),
                      Obx(() => DropDownFiltroProveedores(
                          titulo: "Marca",
                          listaItems: listMarcas.value,
                          color: buttonColor,
                          textcolor: textColor,
                          hin: "Todas",
                          onChange: (String? value) async {
                            setState(() {
                              dropdownValueMarca = value!;
                            });

                            if (dropdownValueMarca != null &&
                                dropdownValueMarca != "Todas") {
                              await cargarProveedor();
                            }
                          },
                          value: dropdownValueMarca))
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 40),
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () => {
                                      if (valorRound == 1)
                                        {
                                          _cambiarValor(3),
                                        }
                                      else
                                        {
                                          _cambiarValor(1),
                                        }
                                    },
                                child: valorRound == 2
                                    ? Icon(
                                        Icons.brightness_1_outlined,
                                        color: ConstantesColores.azul_precio,
                                      )
                                    : valorRound == 3
                                        ? Icon(
                                            Icons.brightness_1_outlined,
                                            color:
                                                ConstantesColores.azul_precio,
                                          )
                                        : Icon(
                                            Icons.task_alt_outlined,
                                            color:
                                                ConstantesColores.agua_marina,
                                          )),
                            SizedBox(width: 10),
                            Text("Promociones",
                                style: TextStyle(
                                    color: ConstantesColores.azul_precio))
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => {
                              if (valorRound == 2)
                                {
                                  _cambiarValor(3),
                                }
                              else
                                {
                                  _cambiarValor(2),
                                }
                            },
                            child: valorRound == 1
                                ? Icon(
                                    Icons.brightness_1_outlined,
                                    color: ConstantesColores.azul_precio,
                                  )
                                : valorRound == 3
                                    ? Icon(Icons.brightness_1_outlined,
                                        color: ConstantesColores.azul_precio)
                                    : Icon(
                                        Icons.task_alt_outlined,
                                        color: ConstantesColores.agua_marina,
                                      ),
                          ),
                          SizedBox(width: 10),
                          Text("Imperdibles",
                              style: TextStyle(
                                  color: ConstantesColores.azul_precio))
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(5.0),
                  child: Text("Rango de precios",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: ConstantesColores.azul_precio),
                      textAlign: TextAlign.left),
                ),
                SizedBox(
                  height: 20,
                ),
                SliderPrecios(
                  values: values,
                  onChange: (() => {this.values = values}),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    controlador.isDisponibleFiltro.value = false;

                    await resultadoBuscadorGeneralVm.cargarPrecios(
                        values: values,
                        dropdownValueMarca: dropdownValueMarca ?? 'Todo',
                        valorRound: valorRound,
                        dropdownValueCategoria: dropdownValueCategoria ?? 'Todo',
                        dropdownValueSubCategoria: dropdownValueCategoria ?? 'Todo',
                        dropdownValueProveedor: dropdownValueProveedor ?? 'Todo');

                    Navigator.pop(context);
                  },
                  child: Container(
                    width: size.width * 0.9,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      color: ConstantesColores.agua_marina,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Filtrar',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _cambiarValor(int i) {
    setState(() {
      valorRound = i;
    });
  }

  cargarCategorias() async {
    //validar por el provedor
    var resQuery = await DBProvider.db.consultarCategorias('', 0);
    for (var i = 0; i < resQuery.length; i++) {
      listCategorias.add(resQuery[i].descripcion);
    }
  }

  cargarMarca() async {
    var resQuery = await searchFuzzyViewModel.marcaService.getAllMarcas();
    for (var i = 0; i < resQuery.length; i++) {
      listMarcas.add(resQuery[i].nombre);
    }
  }

  cargarProveedor() async {
    var resQuery = await DBProvider.db.consultarFricante("");
    for (var i = 0; i < resQuery.length; i++) {
      listProveedor.add((resQuery[i] as Fabricantes).nombrecomercial!);
    }
  }

  cargarSubCategorias() async {
    listSubCategorias.value = ['Todas'];
    String? codigoCategoria = await DBProvider.db
        .consultarCodigoCategoriaaPorNombre(dropdownValueCategoria);
    var resQuery =
        await DBProvider.db.consultarCategoriasSubCategorias(codigoCategoria);
    for (var i = 0; i < resQuery.length; i++) {
      listSubCategorias.add(resQuery[i].descripcion);
    }
  }

  cargarMarcasPorCategoria(int tipo) async {
    String? codigoCategoria = await DBProvider.db
        .consultarCodigoCategoriaaPorNombre(dropdownValueCategoria);
    listMarcas.value = ['Todas'];

    if (tipo == 1) {
      var resQuery =
          await DBProvider.db.consultarMarcasFiltro(codigoCategoria, "", 1);
      for (var i = 0; i < resQuery.length; i++) {
        listMarcas.add(resQuery[i].nombreMarca);
      }
    } else {
      String? codigoSubCategoria = await DBProvider.db
          .consultarCodigoSubCategoriaPorNombre(dropdownValueSubCategoria);
      var resQuery = await DBProvider.db
          .consultarMarcasFiltro(codigoCategoria, codigoSubCategoria, 2);
      for (var i = 0; i < resQuery.length; i++) {
        listMarcas.add(resQuery[i].nombreMarca);
      }
    }
  }

  limpiarFiltro() {
    valorRound = 3;
    dropdownValueCategoria = "Todas";
    dropdownValueSubCategoria = "Todas";
    dropdownValueMarca = "Todas";
    dropdownValueProveedor = "Todas";
    listSubCategorias.value = ['Todas'];
    listCategorias.value = ['Todas'];
    listMarcas.value = ['Todas'];
    listProveedor.value = ['Todas'];
    values = RangeValues(0, 500000);
  }
}
