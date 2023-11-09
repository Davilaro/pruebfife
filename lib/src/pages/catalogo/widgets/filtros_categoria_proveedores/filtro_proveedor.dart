// ignore_for_file: invalid_use_of_protected_member

import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/src/pages/catalogo/widgets/dropDownFiltroProveedores.dart';
import 'package:emart/src/pages/catalogo/widgets/filtros_categoria_proveedores/icono_limpiar_filtro.dart';
import 'package:emart/src/pages/catalogo/widgets/sliderPrecios.dart';
import 'package:emart/src/pages/principal_page/widgets/custom_buscador_fuzzy.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class FiltroProveedor extends StatefulWidget {
  final String codCategoria;
  final String nombreCategoria;
  final String? urlImagen;
  final String codigoProveedor;
  FiltroProveedor(
      {Key? key,
      required this.codCategoria,
      required this.nombreCategoria,
      required this.urlImagen,
      required this.codigoProveedor})
      : super(key: key);

  @override
  _FiltroProveedorState createState() => _FiltroProveedorState();
}

class _FiltroProveedorState extends State<FiltroProveedor> {
  ControllerProductos catalogSearchViewModel = Get.find();
  RangeValues values = RangeValues(0, 500000);
  int valorRound = 3;
  String? dropdownValueCategoria;
  String? dropdownValueSubCategoria;
  String? dropdownValueMarca;
  RxList<String> listCategorias = ['Todas'].obs;
  RxList<String> listSubCategorias = ['Todas'].obs;
  RxList<String> listMarcas = ['Todas'].obs;
  @override
  void initState() {
    cargarCategorias();
    cargarMarca();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final providerDatos = Provider.of<DatosListas>(context);
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
                          titulo: "Categoría",
                          listaItems: listCategorias.value,
                          value: dropdownValueCategoria,
                          onChange: (String? value) async {
                            setState(() {
                              dropdownValueMarca = "Todas";
                              listSubCategorias.value = ['Todas'];
                              dropdownValueSubCategoria = "Todas";
                              dropdownValueCategoria = value!;
                            });
                            if (dropdownValueCategoria != null &&
                                dropdownValueCategoria != "Todas") {
                              await cargarSubCategorias();
                              await cargarMarcasPorCategoria(1);
                            } else {
                              cargarMarca();
                            }
                          })),
                      SizedBox(
                        height: 5,
                      ),
                      Obx(() => DropDownFiltroProveedores(
                          titulo: "Subcategoría",
                          listaItems: listSubCategorias.value,
                          hin: "Todas",
                          onChange: (String? value) async {
                            setState(() {
                              dropdownValueMarca = "Todas";
                              dropdownValueSubCategoria = value!;
                            });
                            if ((dropdownValueSubCategoria == "Todas" ||
                                        dropdownValueSubCategoria == null) &&
                                    dropdownValueCategoria == "Todas" ||
                                dropdownValueCategoria == null) {
                              await cargarMarca();
                            } else {
                              await cargarMarcasPorCategoria(2);
                            }
                          },
                          value: dropdownValueSubCategoria)),
                      SizedBox(
                        height: 5,
                      ),
                      Obx(() => DropDownFiltroProveedores(
                          titulo: "Marcas",
                          listaItems: listMarcas.value,
                          hin: "Todas",
                          onChange: (String? value) {
                            setState(() {
                              dropdownValueMarca = value!;
                            });
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
                    await _cargarPrecios(values, providerDatos);
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
        .consultarCategoriasPorFabricante(widget.codCategoria.toUpperCase(), '');
    for (var i = 0; i < resQuery.length; i++) {
      listCategorias.add(resQuery[i].descripcion);
    }
  }

  cargarMarca() async {
    var resQuery = await DBProvider.db
        .consultarMarcasPorFabricante(widget.codCategoria.toUpperCase(), '');
    for (var i = 0; i < resQuery.length; i++) {
      listMarcas.add(resQuery[i].titulo);
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
    listSubCategorias.value = ['Todas'];
    dropdownValueMarca = "Todas";
    values = RangeValues(0, 500000);
  }

  _cargarPrecios(RangeValues values, providerDatos) async {
    String? codigoMarca =
        await DBProvider.db.consultarCodigoMarcaPorNombre(dropdownValueMarca);
    //para imperdibles, categoira y subcate
    if (valorRound == 2 &&
        ((dropdownValueCategoria != "Todas" &&
                dropdownValueCategoria != null) ||
            (dropdownValueSubCategoria != "Todas" &&
                dropdownValueSubCategoria != null))) {
      String? codigo = await DBProvider.db
          .consultarCodigoCategoriaaPorNombre(dropdownValueCategoria);
      String? codigoSubCategoria = await DBProvider.db
          .consultarCodigoSubCategoriaPorNombre(dropdownValueSubCategoria);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codigoCategoria: codigo,
                    numEmpresa: 'nutresa',
                    // debo evaluar el tipo de categoria
                    tipoCategoria: 1,
                    nombreCategoria: widget.nombreCategoria,
                    img: widget.urlImagen,
                    claseProducto: 6,
                    codCategoria: codigo,
                    codigoSubCategoria: codigoSubCategoria,
                    locacionFiltro: "proveedor",
                    codigoMarca: codigoMarca,
                    codigoProveedor: widget.codigoProveedor,
                  )));
    }
    //para promo, categoria y subcategoria
    if (valorRound == 1 &&
        ((dropdownValueCategoria != "Todas" &&
                dropdownValueCategoria != null) ||
            (dropdownValueSubCategoria != "Todas" &&
                dropdownValueSubCategoria != null))) {
      String? codigo = await DBProvider.db
          .consultarCodigoCategoriaaPorNombre(dropdownValueCategoria);
      String? codigoSubCategoria = await DBProvider.db
          .consultarCodigoSubCategoriaPorNombre(dropdownValueSubCategoria);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codigoCategoria: codigo,
                    numEmpresa: 'nutresa',
                    // debo evaluar el tipo de categoria
                    tipoCategoria: 2,
                    nombreCategoria: widget.nombreCategoria,
                    img: widget.urlImagen,
                    claseProducto: 6,
                    codCategoria: codigo,
                    codigoSubCategoria: codigoSubCategoria,
                    locacionFiltro: "proveedor",
                    codigoMarca: codigoMarca,
                    codigoProveedor: widget.codigoProveedor,
                  )));
    }
    //para subcategoria y categoria
    if ((dropdownValueSubCategoria != "Todas" &&
            dropdownValueSubCategoria != null) &&
        (valorRound == 3)) {
      String? codigo = await DBProvider.db
          .consultarCodigoSubCategoriaPorNombre(dropdownValueSubCategoria);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codCategoria: widget.codCategoria,
                    numEmpresa: 'nutresa',
                    // debo evaluar el tipo de categoria
                    tipoCategoria: 2,
                    nombreCategoria: dropdownValueSubCategoria,
                    img: widget.urlImagen,
                    claseProducto: 3,
                    codigoSubCategoria: codigo,
                    locacionFiltro: "proveedor",
                    codigoMarca: codigoMarca,
                    codigoProveedor: widget.codigoProveedor,
                  )));
    }
    //para marca
    if ((dropdownValueMarca != "Todas" && dropdownValueMarca != null) &&
        valorRound == 3 &&
        ((dropdownValueCategoria == "Todas" ||
                dropdownValueCategoria == null) &&
            (dropdownValueSubCategoria == "Todas" ||
                dropdownValueSubCategoria == null))) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codCategoria: dropdownValueMarca,
                    numEmpresa: 'nutresa',
                    tipoCategoria: 3,
                    nombreCategoria: dropdownValueMarca,
                    claseProducto: 4,
                    codigoMarca: codigoMarca,
                    locacionFiltro: "proveedor",
                    codigoProveedor: widget.codigoProveedor,
                  )));
    }
    //para de todo tipo
    if ((valorRound == 3) &&
        (dropdownValueMarca == "Todas" || dropdownValueMarca == null) &&
        (dropdownValueSubCategoria == "Todas" ||
            dropdownValueSubCategoria == null) &&
        (dropdownValueCategoria == "Todas" || dropdownValueCategoria == null)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codCategoria: widget.codCategoria,
                    numEmpresa: 'nutresa',
                    tipoCategoria: 4,
                    nombreCategoria: widget.nombreCategoria,
                    claseProducto: 4,
                    codigoCategoria: "",
                    locacionFiltro: "proveedor",
                    codigoMarca: widget.codCategoria,
                    codigoProveedor: widget.codigoProveedor,
                  )));
    }
    //para categoria sola
    if ((dropdownValueCategoria != "Todas" &&
            dropdownValueCategoria != null &&
            (dropdownValueSubCategoria == "Todas" ||
                dropdownValueSubCategoria == null)) &&
        (valorRound == 3)) {
      String? codigo = await DBProvider.db
          .consultarCodigoCategoriaaPorNombre(dropdownValueCategoria);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codCategoria: dropdownValueCategoria,
                    numEmpresa: 'nutresa',
                    tipoCategoria: 5,
                    nombreCategoria: dropdownValueCategoria,
                    claseProducto: 5,
                    codigoCategoria: codigo,
                    locacionFiltro: "proveedor",
                    codigoMarca: codigoMarca,
                    codigoProveedor: widget.codigoProveedor,
                  )));
    }
    //para marca y promo
    if ((dropdownValueMarca != "Todas" && dropdownValueMarca != null) &&
        valorRound == 1 &&
        ((dropdownValueCategoria == null ||
                dropdownValueCategoria == "Todas") &&
            (dropdownValueSubCategoria == null ||
                dropdownValueSubCategoria == "Todas"))) {
      String? codigo =
          await DBProvider.db.consultarCodigoMarcaPorNombre(dropdownValueMarca);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codCategoria: codigo,
                    codigoCategoria: codigo,
                    numEmpresa: 'nutresa',
                    tipoCategoria: 4,
                    nombreCategoria: dropdownValueMarca,
                    claseProducto: 6,
                    codigoMarca: codigo,
                    locacionFiltro: "proveedor",
                    codigoProveedor: widget.codigoProveedor,
                  )));
    }
    //para marca e imperdible
    if ((dropdownValueMarca != "Todas" && dropdownValueMarca != null) &&
        valorRound == 2 &&
        ((dropdownValueCategoria == null ||
                dropdownValueCategoria == "Todas") &&
            (dropdownValueSubCategoria == null ||
                dropdownValueSubCategoria == "Todas"))) {
      String? codigo =
          await DBProvider.db.consultarCodigoMarcaPorNombre(dropdownValueMarca);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codCategoria: codigo,
                    codigoCategoria: codigo,
                    numEmpresa: 'nutresa',
                    tipoCategoria: 3,
                    nombreCategoria: dropdownValueMarca,
                    claseProducto: 6,
                    codigoMarca: codigo,
                    locacionFiltro: "proveedor",
                    codigoProveedor: widget.codigoProveedor,
                  )));
    }

    if ((valorRound == 1) &&
        ((dropdownValueCategoria == "Todas" ||
                dropdownValueCategoria == null) &&
            (dropdownValueMarca == "Todas" || dropdownValueMarca == null))) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codCategoria: widget.codCategoria,
                    numEmpresa: 'nutresa',
                    nombreCategoria: "Promociones",
                    tipoCategoria: 1,
                    img: widget.urlImagen,
                    claseProducto: 1,
                    locacionFiltro: "proveedor",
                    codigoMarca: codigoMarca,
                    codigoProveedor: widget.codigoProveedor,
                  )));
    }
    //para imperdible sola
    if ((valorRound == 2) &&
        ((dropdownValueCategoria == "Todas" ||
                dropdownValueCategoria == null) &&
            (dropdownValueMarca == "Todas" || dropdownValueMarca == null))) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codCategoria: widget.codCategoria,
                    numEmpresa: 'nutresa',
                    nombreCategoria: "Imperdibles",
                    tipoCategoria: 2,
                    img: widget.urlImagen,
                    claseProducto: 2,
                    locacionFiltro: "proveedor",
                    codigoMarca: codigoMarca,
                    codigoProveedor: widget.codigoProveedor,
                  )));
    }
  }
}
