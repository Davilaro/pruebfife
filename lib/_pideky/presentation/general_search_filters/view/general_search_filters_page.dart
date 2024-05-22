// ignore_for_file: invalid_use_of_protected_member

import 'package:emart/_pideky/domain/brand/model/brand.dart';
import 'package:emart/_pideky/presentation/general_search/view_model/search_fuzzy_view_model.dart';
import 'package:emart/_pideky/presentation/general_search_filters/view_model/general_search_filters_view_model.dart';
import 'package:emart/_pideky/presentation/general_search_reponse/view_model/general_search_response_view_model.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/src/modelos/categorias.dart';
import 'package:emart/src/modelos/fabricante.dart';
import 'package:emart/src/pages/catalogo/widgets/dropDownFiltroProveedores.dart';
import 'package:emart/src/pages/catalogo/widgets/sliderPrecios.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class GeneralSearchFiltersPage extends StatefulWidget {
  final String codCategoria;
  final String nombreCategoria;
  final String? urlImagen;
  final String codigoProveedor;
  GeneralSearchFiltersPage(
      {Key? key,
      required this.codCategoria,
      required this.nombreCategoria,
      required this.urlImagen,
      required this.codigoProveedor})
      : super(key: key);

  @override
  _GeneralSearchFiltersPageState createState() =>
      _GeneralSearchFiltersPageState();
}

class _GeneralSearchFiltersPageState extends State<GeneralSearchFiltersPage> {
  ControllerProductos catalogSearchViewModel = Get.find();
  final searchFuzzyViewModel = Get.find<SearchFuzzyViewModel>();
  final resultadoBuscadorGeneralVm = Get.put(GeneralSearchResponseViewModel());
  final filtrosResultadoGeneralVm = Get.put(FiltrosResultadoGeneralVm());
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

  RxList<Fabricante> listObjectoProveedor = <Fabricante>[].obs;
  RxList<Categorias> listObjectoSubCategoria = <Categorias>[].obs;
  RxList<Categorias> listObjectoCategoria = <Categorias>[].obs;
  RxList<Brand> listObjectoMarca = <Brand>[].obs;

  String? codigoProveedor;
  String? codigoSubCategoria;
  String? codigoMarca;
  String? codigoCategoria;

  Color buttonColor = ConstantesColores.color_fondo_gris;
  Color textColor = ConstantesColores.azul_precio;

  @override
  void initState() {
    cargarCategorias();
    cargarMarca();
    cargarProveedor();
    super.initState();
  }

  void setStatePage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controlador = Get.find<ControlBaseDatos>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscador',
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
                    TextButton(
                      // borderSide: BorderSide(style: BorderStyle.none),
                      onPressed: () {
                        setState(() {
                          valorRound = 3;
                          dropdownValueCategoria = null;
                          dropdownValueSubCategoria = null;
                          dropdownValueMarca = null;
                          dropdownValueProveedor = null;
                          values = RangeValues(0, 500000);
                        });
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/image/limpiar_filtro_img.png',
                            width: Get.width * 0.07,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Limpiar',
                                style: TextStyle(
                                  color: HexColor("#43398E"),
                                ),
                              ),
                              Text(
                                'Filtro',
                                style: TextStyle(
                                  color: HexColor("#43398E"),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: OverflowBar(
                    children: [
                      // Filtro de categorias
                      Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Proveedor",
                                style: TextStyle(color: HexColor("#41398D")),
                              ),
                              DropDownFiltroProveedores(
                                  hin: "Todas",
                                  listaItems: listProveedor.value,
                                  value: dropdownValueProveedor,
                                  color: buttonColor,
                                  textcolor: textColor,
                                  onChange: (String? value) async {
                                    setState(() {
                                      dropdownValueProveedor = value!;
                                      codigoProveedor = listObjectoProveedor
                                          .where((element) =>
                                              element.nombrecomercial ==
                                              dropdownValueProveedor)
                                          .first
                                          .empresa!;
                                    });

                                    if (dropdownValueProveedor != null &&
                                        dropdownValueProveedor != "Todas") {
                                      await cargarCategorias();
                                    }
                                  }),
                            ],
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Categoría",
                                style: TextStyle(color: HexColor("#41398D")),
                              ),
                              DropDownFiltroProveedores(
                                  hin: "Todas",
                                  listaItems: listCategorias.value,
                                  value: dropdownValueCategoria,
                                  color: buttonColor,
                                  textcolor: textColor,
                                  onChange: (String? value) async {
                                    setState(() {
                                      dropdownValueCategoria = value!;
                                      codigoCategoria = listObjectoCategoria
                                          .where((element) =>
                                              element.descripcion ==
                                              dropdownValueCategoria)
                                          .first
                                          .codigo;
                                    });
                                    if (dropdownValueCategoria != null &&
                                        dropdownValueCategoria != "Todas") {
                                      await cargarSubCategorias();
                                      await cargarMarcasPorCategoria(1);
                                    }
                                  }),
                            ],
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Subcategoría",
                                style: TextStyle(color: HexColor("#41398D")),
                              ),
                              DropDownFiltroProveedores(
                                listaItems: listSubCategorias.value,
                                hin: "Todas",
                                color: buttonColor,
                                value: dropdownValueSubCategoria,
                                textcolor: textColor,
                                onChange: (String? value) async {
                                  setState(() {
                                    dropdownValueMarca = "Todas";
                                    dropdownValueSubCategoria = value!;
                                    codigoSubCategoria = listObjectoSubCategoria
                                        .where((element) =>
                                            element.descripcion ==
                                            dropdownValueSubCategoria)
                                        .first
                                        .codigo;
                                  });
                                  if ((dropdownValueSubCategoria == "Todas" ||
                                              dropdownValueSubCategoria ==
                                                  null) &&
                                          dropdownValueCategoria == "Todas" ||
                                      dropdownValueCategoria == null) {
                                    await cargarMarcasPorCategoria(2);
                                  }
                                },
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Marca",
                                style: TextStyle(color: HexColor("#41398D")),
                              ),
                              DropDownFiltroProveedores(
                                listaItems: listMarcas.value,
                                color: buttonColor,
                                textcolor: textColor,
                                value: dropdownValueMarca,
                                hin: "Todas",
                                onChange: (String? value) async {
                                  setState(() {
                                    dropdownValueMarca = value!;
                                    codigoMarca = listObjectoMarca
                                        .where((element) =>
                                            element.nombre ==
                                            dropdownValueMarca)
                                        .first
                                        .codigo;
                                  });
                                },
                              ),
                            ],
                          ))
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

                    // resultadoBuscadorGeneralVm.cargarProductosImperdibles();
                    // resultadoBuscadorGeneralVm.cargarProductosPromo();

                    if (valorRound == 1) {
                      resultadoBuscadorGeneralVm
                          .setSelectedButton('Promociones');
                      resultadoBuscadorGeneralVm.cargarProductosPromo();
                    } else if (valorRound == 2) {
                      resultadoBuscadorGeneralVm
                          .setSelectedButton('Imperdibles');
                      resultadoBuscadorGeneralVm.cargarProductosImperdibles();
                    }
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
    var resQuery = await DBProvider.db
        .consultarCategoriasPorFabricante(codigoProveedor ?? "", '');

    listCategorias.clear();
    for (var i = 0; i < resQuery.length; i++) {
      listCategorias.add(resQuery[i].descripcion);
      listObjectoCategoria.add(resQuery[i]);
    }
  }

  cargarMarca() async {
    var resQuery = await searchFuzzyViewModel.marcaService.getAllMarcas();
    for (var i = 0; i < resQuery.length; i++) {
      listMarcas.add(resQuery[i].nombre);
      listObjectoMarca.add(resQuery[i]);
    }
  }

  cargarProveedor() async {
    var resQuery = await DBProvider.db.consultarFabricante("");
    for (var i = 0; i < resQuery.length; i++) {
      listProveedor.add(resQuery[i].nombrecomercial!);
      listObjectoProveedor.add(resQuery[i]);
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
      listObjectoSubCategoria.add(resQuery[i]);
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

  limpiarFiltro() {}
}
