// ignore_for_file: unnecessary_null_comparison

import 'dart:async';

import 'package:emart/_pideky/domain/producto/service/producto_service.dart';
import 'package:emart/_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/src/controllers/notifiactions_controllers.dart';
import 'package:emart/src/pages/catalogo/widgets/filtros_categoria_proveedores/filtro_categoria.dart';
import 'package:emart/src/pages/catalogo/widgets/filtros_categoria_proveedores/filtro_proveedor.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/routes/custonNavigatorBar.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:emart/src/widget/dounser.dart';
import 'package:emart/src/widget/filtro_precios.dart';
import 'package:emart/src/widget/input_valores_catalogo.dart';
import 'package:emart/src/provider/logica_actualizar.dart';
import 'package:emart/src/widget/ofertas_internas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class CustomBuscardorFuzzy extends StatefulWidget {
  final String? codCategoria;
  final String numEmpresa;
  final int tipoCategoria;
  final String? nombreCategoria;
  final String? img;
  final bool isActiveBanner;
  final bool isVisibilityAppBar;
  final String locasionBanner;
  final int? claseProducto;
  final String? codigoMarca;
  final String? codigoSubCategoria;
  final String? codigoCategoria;
  final String? locacionFiltro;
  final String codigoProveedor;
  final String? descripcionCategoria;
  final String? empresa;

  const CustomBuscardorFuzzy(
      {Key? key,
      this.codCategoria,
      required this.numEmpresa,
      required this.tipoCategoria,
      this.nombreCategoria,
      this.claseProducto,
      this.img,
      this.isActiveBanner = true,
      this.isVisibilityAppBar = true,
      this.locasionBanner = '',
      this.codigoMarca,
      this.codigoSubCategoria,
      this.codigoCategoria,
      required this.locacionFiltro,
      required this.codigoProveedor,
      this.descripcionCategoria,
      this.empresa})
      : super(key: key);

  @override
  State<CustomBuscardorFuzzy> createState() => _CustomBuscardorFuzzyState();
}

class _CustomBuscardorFuzzyState extends State<CustomBuscardorFuzzy> {
  ControllerProductos catalogSearchViewModel = Get.find();

  RxList<dynamic> listaProducto = <dynamic>[].obs;
  List<dynamic> listaAllProducts = [];
  final TextEditingController _controllerSearch = TextEditingController();
  final controlador = Get.find<ControlBaseDatos>();
  final controllerNotificaciones =
      Get.find<NotificationsSlideUpAndPushInUpControllers>();
  final prefs = Preferencias();
  Timer _timer = Timer(Duration(milliseconds: 1), () {});

  @override
  void initState() {
    if (prefs.usurioLogin == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _validacionGeneralNotificaciones();
      });
    }
    cargarProductos();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _controllerSearch.dispose();
    Get.closeCurrentSnackbar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OpcionesBard>(context);
    final cargoConfirmar = Get.find<ControlBaseDatos>();
    super.didUpdateWidget(super.widget);
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('${widget.nombreCategoria}Page');

    final Debouncer onSearchDebouncer =
        new Debouncer(delay: new Duration(milliseconds: 500));

    final size = MediaQuery.of(context).size;
    setState(() {
      if (catalogSearchViewModel.isFilter) {
        cargarProductos();
      }
      catalogSearchViewModel.setIsFilter(false);
    });

    return Obx(() => Scaffold(
          backgroundColor: ConstantesColores.color_fondo_gris,
          appBar: widget.isVisibilityAppBar
              ? AppBar(
                  leading: new IconButton(
                      icon: new Icon(Icons.arrow_back_ios,
                          color: HexColor("#30C3A3")),
                      onPressed: () {
                        controlador.isDisponibleFiltro.value = true;
                        Get.back();
                        catalogSearchViewModel.setPrecioMinimo(0);
                        catalogSearchViewModel.setPrecioMaximo(100000);
                      }),
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: ConstantesColores.color_fondo_gris,
                    statusBarIconBrightness: Brightness.dark,
                  ),
                  title: Text(
                    '${widget.nombreCategoria}',
                    style: TextStyle(color: HexColor("#41398D")),
                  ),
                  elevation: 0,
                  actions: <Widget>[
                    Visibility(
                        visible: controlador.isDisponibleFiltro.value,
                        child: BotonActualizar()),
                    AccionesBartCarrito(esCarrito: false),
                  ],
                )
              : null,
          body: RefreshIndicator(
            color: ConstantesColores.azul_precio,
            backgroundColor: ConstantesColores.agua_marina.withOpacity(0.6),
            onRefresh: () async {
              await LogicaActualizar().actualizarDB();
              setState(() {
                cargarProductos();
              });
              return Future<void>.delayed(const Duration(seconds: 3));
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      height: size.height * 0.1,
                      width: size.width * 1,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _buscador(context, onSearchDebouncer),
                            ),
                            Visibility(
                              visible:
                                  controlador.isDisponibleFiltro.value == true,
                              child: GestureDetector(
                                onTap: () => {_irFiltro()},
                                child: Container(
                                  margin:
                                      EdgeInsets.only(right: 30, bottom: 10),
                                  child: GestureDetector(
                                    child: SvgPicture.asset(
                                        'assets/image/filtro_btn.svg'),
                                  ),
                                ),
                              ),
                            )
                          ])),
                  //Banner
                  Visibility(
                    visible: widget.isActiveBanner,
                    child: Container(
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        height: size.height * 0.2,
                        width: double.infinity,
                        child: OfertasInterna(
                            nombreFabricante: widget.codCategoria)),
                  ),
                  Container(
                    height: Get.height * 0.8,
                    width: size.width * 1,
                    padding: EdgeInsets.fromLTRB(
                        10, 10, 10, widget.isActiveBanner ? 140 : 50),
                    child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing:
                            4.0, // espaciado entre ejes principales (horizontal)
                        childAspectRatio: 2 / 3.3, //entre mas cerca de cero
                        children:
                            _cargarProductosLista(listaProducto, context)),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  HexColor colorItems() => HexColor("#43398E");

  _cargarProductosLista(List<dynamic> data, BuildContext context) {
    final List<Widget> opciones = [];

    for (var i = 0; i < data.length; i++) {
      Producto productos = data[i];
      final widgetTemp = InputValoresCatalogo(
        element: productos,
        numEmpresa: widget.numEmpresa,
        isCategoriaPromos: false,
        index: i,
      );

      opciones.add(widgetTemp);
    }

    return opciones;
  }

  _buscador(BuildContext context, Debouncer onSearchDebouncer) {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: HexColor("#E4E3EC"),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
          controller: _controllerSearch,
          style: TextStyle(color: HexColor("#41398D"), fontSize: 13),
          decoration: InputDecoration(
            fillColor: HexColor("#41398D"),
            hintText: 'Encuentra tus productos',
            hintStyle: TextStyle(
              color: HexColor("#41398D"),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Icon(
                Icons.search,
                color: HexColor("#41398D"),
              ),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.fromLTRB(10.0, 15, 10.0, 0),
          ),
          onChanged: (val) => onSearchDebouncer.debounce(() {
                if (val.length > 3) {
                  //FIREBASE: Llamamos el evento search
                  TagueoFirebase().sendAnalityticsSearch(val);
                  //UXCam: Llamamos el evento search
                  UxcamTagueo().search(val);
                }
                runFilter(_controllerSearch.text);
              })),
    );
  }

  void cargarProductos() async {
    ProductoService productService =
        ProductoService(ProductoRepositorySqlite());
    if (widget.claseProducto != null) {
      if (widget.claseProducto == 1) {
        listaAllProducts = await productService.cargarProductosInterno(
            1,
            "",
            catalogSearchViewModel.precioMinimo.value,
            catalogSearchViewModel.precioMaximo.value,
            0,
            widget.codigoMarca,
            widget.codigoProveedor);
        listaProducto.value = listaAllProducts;
      }
      if (widget.claseProducto == 2) {
        listaAllProducts = await productService.cargarProductosInterno(
            2,
            "",
            catalogSearchViewModel.precioMinimo.value,
            catalogSearchViewModel.precioMaximo.value,
            0,
            widget.codigoMarca,
            widget.codigoProveedor);
        listaProducto.value = listaAllProducts;
      }
      if (widget.claseProducto == 4) {
        listaAllProducts = await productService.cargarProductos(
            widget.codigoMarca!,
            widget.tipoCategoria,
            '',
            catalogSearchViewModel.precioMinimo.value,
            catalogSearchViewModel.precioMaximo.value,
            widget.codigoMarca,
            widget.codigoProveedor);
        listaProducto.value = listaAllProducts;
      }
      if (widget.claseProducto == 3) {
        listaAllProducts = await productService.cargarProductos(
            widget.codigoSubCategoria!,
            widget.tipoCategoria,
            '',
            catalogSearchViewModel.precioMinimo.value,
            catalogSearchViewModel.precioMaximo.value,
            widget.codigoMarca,
            widget.codigoProveedor);
        listaProducto.value = listaAllProducts;
      }
      if (widget.claseProducto == 5) {
        listaAllProducts = await productService.cargarProductos(
            widget.codigoCategoria!,
            widget.tipoCategoria,
            '',
            catalogSearchViewModel.precioMinimo.value,
            catalogSearchViewModel.precioMaximo.value,
            widget.codigoMarca,
            widget.codigoProveedor);
        listaProducto.value = listaAllProducts;
      }
      if (widget.claseProducto == 6) {
        listaAllProducts =
            await productService.cargarProductosFiltroProveedores(
                widget.codCategoria,
                widget.tipoCategoria,
                '',
                catalogSearchViewModel.precioMinimo.value,
                catalogSearchViewModel.precioMaximo.value,
                widget.codigoSubCategoria,
                widget.codigoMarca,
                widget.codigoProveedor);
        listaProducto.value = listaAllProducts;
      }
      if (widget.claseProducto == 7) {
        listaAllProducts = await productService.cargarProductos(
            widget.codigoMarca,
            7,
            '',
            catalogSearchViewModel.precioMinimo.value,
            catalogSearchViewModel.precioMaximo.value,
            widget.codigoMarca,
            widget.codigoProveedor);

        listaProducto.value = listaAllProducts;
      }
      //para el filtro de categorias
      if (widget.claseProducto == 8) {
        listaAllProducts = await productService.cargarProductosFiltroCategoria(
            widget.codigoCategoria,
            widget.tipoCategoria,
            catalogSearchViewModel.precioMinimo.value,
            catalogSearchViewModel.precioMaximo.value,
            widget.codigoSubCategoria,
            widget.codigoMarca);
        listaProducto.value = listaAllProducts;
      }
    } else {
      listaAllProducts = await productService.cargarProductos(
          widget.codCategoria!,
          widget.tipoCategoria,
          '',
          catalogSearchViewModel.precioMinimo.value,
          catalogSearchViewModel.precioMaximo.value,
          widget.codigoMarca,
          widget.codigoProveedor);
      listaProducto.value = listaAllProducts;
    }
  }

  void runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      listaProducto.value = listaAllProducts;
    } else {
      List listaAux = [];
      listaProducto.value = [];
      listaAllProducts.forEach((element) {
        if (element.codigo
            .toLowerCase()
            .contains(enteredKeyword.toLowerCase())) {
          listaProducto.add(element);
        }
        listaAux.add(element.nombre);
      });
      final fuse = Fuzzy(listaAux);
      final result = fuse.search(enteredKeyword);
      result
          .map((r) => listaProducto.add(listaAllProducts
              .firstWhere((element) => element.nombre == r.item)))
          .forEach(print);
    }
  }

  _irFiltro() async {
    if (widget.locacionFiltro == "proveedor") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FiltroProveedor(
                  codCategoria: widget.codCategoria!,
                  nombreCategoria: widget.nombreCategoria!,
                  urlImagen: widget.img,
                  codigoProveedor: widget.codigoProveedor,
                )),
      );
    }
    if (widget.locacionFiltro == "marca") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FiltroPrecios(
                  codMarca: widget.codigoMarca,
                  nombreMarca: widget.nombreCategoria,
                  urlImagen: widget.img,
                )),
      );
    }
    if (widget.locacionFiltro == "categoria") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FiltroCategoria(
                  codCategoria: widget.codCategoria,
                  nombreCategoria: widget.nombreCategoria,
                  urlImagen: widget.img,
                  codSubCategoria: widget.codCategoria,
                )),
      );
    }
  }

  void _validacionGeneralNotificaciones() async {
    switch (widget.locacionFiltro) {
      case 'categoria':
        await controllerNotificaciones
            .getPushInUpByDataBaseCategorias('Categoría');
        await controllerNotificaciones
            .getSlideUpByDataBaseCategorias("Categoría");

        if (controllerNotificaciones.listPushInUpCategorias.isNotEmpty) {
          controllerNotificaciones.closePushInUp.value = false;
          controllerNotificaciones.onTapPushInUp.value = false;
          if (controllerNotificaciones
                  .validacionMostrarPushInUp[widget.descripcionCategoria] ==
              true) {
            await controllerNotificaciones.showPushInUp(
                widget.locacionFiltro, widget.descripcionCategoria, context);
            int elapsedTime = 0;
            if (controllerNotificaciones.listSlideUpCategorias.isNotEmpty) {
              _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
                if (elapsedTime >= 530) {
                  controllerNotificaciones.showSlideUp(widget.locacionFiltro,
                      widget.descripcionCategoria, context);
                  timer.cancel();
                } else if (controllerNotificaciones.closePushInUp.value ==
                    true) {
                  controllerNotificaciones.showSlideUp(widget.locacionFiltro,
                      widget.descripcionCategoria, context);
                  timer.cancel();
                } else if (controllerNotificaciones.onTapPushInUp.value ==
                    true) {
                  timer.cancel();
                }
                elapsedTime++;
              });
            }
          }
        } else if (controllerNotificaciones.listSlideUpCategorias.isNotEmpty) {
          controllerNotificaciones.closeSlideUp.value = false;
          if (controllerNotificaciones
                      .validacionMostrarSlideUp[widget.descripcionCategoria] ==
                  true &&
              controllerNotificaciones.closeSlideUp.value == false) {
            controllerNotificaciones.showSlideUp(
                widget.locacionFiltro, widget.descripcionCategoria, context);
          }
        }
        break;
      case 'marca':
        await controllerNotificaciones.getPushInUpByDataBaseMarcas('Marcas');
        await controllerNotificaciones.getSlideUpByDataBaseMarcas("Marcas");
        if (controllerNotificaciones.listPushInUpMarcas.isNotEmpty) {
          controllerNotificaciones.closePushInUp.value = false;
          controllerNotificaciones.onTapPushInUp.value = false;
          if (controllerNotificaciones
                  .validacionMostrarPushInUp[widget.nombreCategoria] ==
              true) {
            await controllerNotificaciones.showPushInUp(
                widget.locacionFiltro, widget.nombreCategoria, context);
            if (controllerNotificaciones.listSlideUpMarcas.isNotEmpty) {
              int elapsedTime = 0;
              _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
                if (elapsedTime >= 530) {
                  controllerNotificaciones.showSlideUp(
                      widget.locacionFiltro, widget.nombreCategoria, context);
                  timer.cancel();
                } else if (controllerNotificaciones.closePushInUp.value ==
                    true) {
                  controllerNotificaciones.showSlideUp(
                      widget.locacionFiltro, widget.nombreCategoria, context);
                  timer.cancel();
                } else if (controllerNotificaciones.onTapPushInUp.value ==
                    true) {
                  timer.cancel();
                }
                elapsedTime++;
              });
            }
          }
        } else if (controllerNotificaciones.listSlideUpMarcas.isNotEmpty) {
          controllerNotificaciones.closeSlideUp.value = false;
          if (controllerNotificaciones
                      .validacionMostrarSlideUp[widget.nombreCategoria] ==
                  true &&
              controllerNotificaciones.closeSlideUp.value == false) {
            controllerNotificaciones.showSlideUp(
                widget.locacionFiltro, widget.nombreCategoria, context);
          }
        }
        break;
      case 'proveedor':
        await controllerNotificaciones
            .getPushInUpByDataBaseProveedores('Proveedor');
        await controllerNotificaciones
            .getSlideUpByDataBaseProveedores("Proveedor");
        if (controllerNotificaciones.listPushInUpProveedores.isNotEmpty) {
          controllerNotificaciones.closePushInUp.value = false;
          controllerNotificaciones.onTapPushInUp.value = false;
          if (controllerNotificaciones
                  .validacionMostrarPushInUp[widget.nombreCategoria] ==
              true) {
            await controllerNotificaciones.showPushInUp(
                widget.locacionFiltro, widget.nombreCategoria, context);
            if (controllerNotificaciones.listSlideUpProveedores.isNotEmpty) {
              int elapsedTime = 0;
              _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
                if (elapsedTime >= 530) {
                  controllerNotificaciones.showSlideUp(
                      widget.locacionFiltro, widget.nombreCategoria, context);
                  timer.cancel();
                } else if (controllerNotificaciones.closePushInUp.value ==
                    true) {
                  controllerNotificaciones.showSlideUp(
                      widget.locacionFiltro, widget.nombreCategoria, context);
                  timer.cancel();
                } else if (controllerNotificaciones.onTapPushInUp.value ==
                    true) {
                  timer.cancel();
                }
                elapsedTime++;
              });
            }
          }
        } else if (controllerNotificaciones.listSlideUpProveedores.isNotEmpty) {
          if (controllerNotificaciones
                      .validacionMostrarSlideUp[widget.nombreCategoria] ==
                  true &&
              controllerNotificaciones.closeSlideUp.value == false) {
            controllerNotificaciones.closeSlideUp.value = false;
            controllerNotificaciones.showSlideUp(
                widget.locacionFiltro, widget.nombreCategoria, context);
          }
        }
        break;
      default:
    }
  }
}
