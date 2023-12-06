// ignore_for_file: invalid_use_of_protected_member

import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/src/pages/catalogo/widgets/dropDownFiltroProveedores.dart';
import 'package:emart/src/pages/catalogo/widgets/filtros_categoria_proveedores/icono_limpiar_filtro.dart';
import 'package:emart/src/pages/catalogo/widgets/sliderPrecios.dart';
import 'package:emart/src/pages/principal_page/widgets/custom_buscador_fuzzy.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class FiltroCategoria extends StatefulWidget {
  final String? codCategoria;
  final String? nombreCategoria;
  final String? urlImagen;
  final String? codSubCategoria;
  FiltroCategoria(
      {Key? key,
      required this.codCategoria,
      required this.nombreCategoria,
      required this.urlImagen,
      required this.codSubCategoria})
      : super(key: key);
  @override
  State<FiltroCategoria> createState() => _FiltroCategoriaState();
}

class _FiltroCategoriaState extends State<FiltroCategoria> {
  ControllerProductos catalogSearchViewModel = Get.find();
  RangeValues values = RangeValues(0, 500000);
  String? dropdownValueMarca;
  RxList<String> listMarcas = ['Todas'].obs;
  int valorRound = 3;
  @override
  void initState() {
    super.initState();
    cargarMarca();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controlador = Get.find<ControlBaseDatos>();
    return Scaffold(
        appBar: AppBar(
          title: Text('Categoría',
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
                      Row(children: [
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
                        })),
                      ]),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        child: OverflowBar(
                          children: [
                            // Filtro de categorias
                            Obx(() => DropDownFiltroProveedores(
                                  hin: "Todas",
                                  titulo: "Marca",
                                  listaItems: listMarcas.value,
                                  value: dropdownValueMarca,
                                  onChange: (String? value) async {
                                    setState(() {
                                      dropdownValueMarca = value!;
                                    });
                                  },
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
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
                                              color:
                                                  ConstantesColores.azul_precio,
                                            )
                                          : valorRound == 3
                                              ? Icon(
                                                  Icons.brightness_1_outlined,
                                                  color: ConstantesColores
                                                      .azul_precio,
                                                )
                                              : valorRound == 4
                                                  ? Icon(
                                                      Icons
                                                          .brightness_1_outlined,
                                                      color: ConstantesColores
                                                          .azul_precio,
                                                    )
                                                  : Icon(
                                                      Icons.task_alt_outlined,
                                                      color: ConstantesColores
                                                          .agua_marina,
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
                                              color:
                                                  ConstantesColores.azul_precio)
                                          : valorRound == 4
                                              ? Icon(
                                                  Icons.brightness_1_outlined,
                                                  color: ConstantesColores
                                                      .azul_precio)
                                              : Icon(
                                                  Icons.task_alt_outlined,
                                                  color: ConstantesColores
                                                      .agua_marina,
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
                        height: 25,
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 40),
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () => {
                                      if (valorRound == 4)
                                        {
                                          _cambiarValor(3),
                                        }
                                      else
                                        {
                                          _cambiarValor(4),
                                        }
                                    },
                                child: valorRound == 1
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
                                        : valorRound == 2
                                            ? Icon(
                                                Icons.brightness_1_outlined,
                                                color: ConstantesColores
                                                    .azul_precio,
                                              )
                                            : Icon(
                                                Icons.task_alt_outlined,
                                                color: ConstantesColores
                                                    .agua_marina,
                                              )),
                            SizedBox(width: 10),
                            Text("Producto más vendidos ",
                                style: TextStyle(
                                    color: ConstantesColores.azul_precio))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
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
                      //chevrolet aveo rojo 717
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
                          await _cargarPrecios(values);
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
                ))));
  }

  limpiarFiltro() {
    valorRound = 3;
    dropdownValueMarca = "Todas";
    values = RangeValues(0, 500000);
  }

  cargarMarca() async {
    var resQuery = await DBProvider.db
        .consultarMarcasFiltro("", widget.codSubCategoria, 3);
    for (var i = 0; i < resQuery.length; i++) {
      listMarcas.add(resQuery[i].nombreMarca);
    }
  }

  _cambiarValor(int i) {
    setState(() {
      valorRound = i;
    });
  }

  _cargarPrecios(RangeValues values) async {
    String? codigoMarca =
        await DBProvider.db.consultarCodigoMarcaPorNombre(dropdownValueMarca);
    String? codigoCategoria = await DBProvider.db
        .consultarCodigoCategoriaaPorNombre(widget.nombreCategoria);

    if (valorRound == 1 &&
        (dropdownValueMarca == "Todas" || dropdownValueMarca == null)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codCategoria: codigoCategoria,
                    numEmpresa: 'nutresa',
                    tipoCategoria: 2,
                    nombreCategoria: "Promociones",
                    img: widget.urlImagen,
                    codigoSubCategoria: widget.codSubCategoria,
                    claseProducto: 6,
                    locacionFiltro: "categoria",
                    codigoProveedor: "",
                  )));
    }
    if (valorRound == 2 &&
        (dropdownValueMarca == "Todas" || dropdownValueMarca == null)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codigoCategoria: widget.codCategoria,
                    numEmpresa: 'nutresa',
                    tipoCategoria: 1,
                    nombreCategoria: "Imperdibles",
                    codigoSubCategoria: widget.codSubCategoria,
                    img: widget.urlImagen,
                    claseProducto: 6,
                    locacionFiltro: "categoria",
                    codigoProveedor: "",
                  )));
    }
    if (valorRound == 1 &&
        (dropdownValueMarca != null && dropdownValueMarca != "Todas")) {
      String? codigo =
          await DBProvider.db.consultarCodigoMarcaPorNombre(dropdownValueMarca);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codCategoria: codigoCategoria,
                    codigoCategoria: codigoCategoria,
                    numEmpresa: 'nutresa',
                    tipoCategoria: 2,
                    nombreCategoria: dropdownValueMarca,
                    codigoSubCategoria: widget.codSubCategoria,
                    claseProducto: 6,
                    codigoMarca: codigo,
                    locacionFiltro: "categoria",
                    codigoProveedor: "",
                  )));
    }
    if ((dropdownValueMarca != "Todas" && dropdownValueMarca != null) &&
        valorRound == 2) {
      String? codigo =
          await DBProvider.db.consultarCodigoMarcaPorNombre(dropdownValueMarca);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codCategoria: codigoCategoria,
                    codigoCategoria: codigoCategoria,
                    numEmpresa: 'nutresa',
                    tipoCategoria: 3,
                    nombreCategoria: dropdownValueMarca,
                    codigoSubCategoria: widget.codSubCategoria,
                    claseProducto: 8,
                    codigoMarca: codigo,
                    locacionFiltro: "categoria",
                    codigoProveedor: "",
                  )));
    }
    if ((dropdownValueMarca != null && dropdownValueMarca != "Todas") &&
        valorRound == 3) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codCategoria: codigoCategoria,
                    numEmpresa: 'nutresa',
                    tipoCategoria: 1,
                    nombreCategoria: widget.nombreCategoria,
                    claseProducto: 8,
                    codigoMarca: codigoMarca,
                    codigoCategoria: codigoCategoria,
                    codigoSubCategoria: widget.codSubCategoria,
                    locacionFiltro: "categoria",
                    codigoProveedor: "",
                  )));
    }
    if ((dropdownValueMarca == null || dropdownValueMarca == "Todas") &&
        valorRound == 3) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codigoCategoria: codigoCategoria,
                    numEmpresa: 'nutresa',
                    nombreCategoria: widget.nombreCategoria,
                    tipoCategoria: 5,
                    codigoSubCategoria: widget.codSubCategoria,
                    img: widget.urlImagen,
                    claseProducto: 6,
                    locacionFiltro: "categoria",
                    codigoMarca: codigoMarca,
                    codigoProveedor: "",
                    codCategoria: codigoCategoria,
                  )));
    }
    if (valorRound == 4) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomBuscardorFuzzy(
                    codigoCategoria: codigoCategoria,
                    numEmpresa: 'nutresa',
                    nombreCategoria: "Producto más vendidos",
                    tipoCategoria: 2,
                    codigoSubCategoria: widget.codSubCategoria,
                    img: widget.urlImagen,
                    claseProducto: 8,
                    locacionFiltro: "categoria",
                    codigoMarca: codigoMarca,
                    codigoProveedor: "",
                  )));
    }
  }
}
