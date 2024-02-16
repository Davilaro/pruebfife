import 'dart:async';
import 'dart:developer';
import 'package:emart/_pideky/domain/producto/service/producto_service.dart';
import 'package:emart/_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import 'package:emart/_pideky/presentation/buscador_general/view/search_fuzzy_view.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/src/controllers/notifiactions_controllers.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/widget/acciones_carrito_bart.dart';
import 'package:emart/src/widget/boton_actualizar.dart';
import 'package:emart/src/widget/input_valores_catalogo.dart';
import 'package:emart/src/provider/logica_actualizar.dart';
import 'package:emart/src/widget/ofertas_internas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class CustomBuscardorFuzzy extends StatefulWidget {
  final String? codCategoria;
  final String numEmpresa;
  final int tipoCategoria;
  final String? nombreCategoria;
  final String? img;
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
  String? bannerToShow = '';
  bool isActiveBanner = false;
  List<dynamic> _listaBanners = [];

  @override
  void initState() {
    log(widget.numEmpresa + 'AQUI esta lo que necesito ver');
    if (prefs.usurioLogin == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _validacionGeneralNotificaciones();
      });
    }
    print('codigo proveedor ${widget.codigoProveedor}');
    _listaBanners = [];
    _cargarListaBanner();
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
    super.didUpdateWidget(super.widget);
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('${widget.nombreCategoria}Page');

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
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: _buscadorPrincipal(context),
                ),
                Visibility(
                  visible: isActiveBanner,
                  child: Container(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      height: size.height * 0.2,
                      width: double.infinity,
                      child: OfertasInterna(
                        nombreFabricante: widget.codCategoria,
                        listaBanners: _listaBanners,
                      )),
                ),
                Expanded(
                  child: Container(
                    height: isActiveBanner
                        ? MediaQuery.of(context).size.height * 0.5
                        : MediaQuery.of(context).size.height * 0.8,
                    child: GridView.count(
                        physics: BouncingScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing:
                            4.0, // espaciado entre ejes principales (horizontal)
                        childAspectRatio: 2 / 3.3, //entre mas cerca de cero
                        children:
                            _cargarProductosLista(listaProducto, context)),
                  ),
                ),
              ],
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
        isCategoriaPromos: false,
        index: i,
        //se realiza la busqueda epero a traves de la marca
        search: true,
      );

      opciones.add(widgetTemp);
    }

    return opciones;
  }

  Future<void> cargarProductos() async {
    ProductoService productService =
        ProductoService(ProductoRepositorySqlite());
    if (widget.claseProducto != null) {
      if (widget.claseProducto == 1) {
        print("tipo de producto 1");
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
        print("tipo de producto 2");
        listaAllProducts = await productService.cargarProductosInterno(
            2,
            "",
            catalogSearchViewModel.precioMinimo.value,
            catalogSearchViewModel.precioMaximo.value,
            0,
            widget.codigoMarca,
            widget.codigoProveedor);
        sortProductByOrder(listaAllProducts);
        listaProducto.value = listaAllProducts;
      }
      if (widget.claseProducto == 4) {
        print("tipo de producto 4");
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
        print("tipo de producto 3");
        listaAllProducts = await productService.cargarProductos(
            widget.codigoSubCategoria!,
            widget.tipoCategoria,
            '',
            catalogSearchViewModel.precioMinimo.value,
            catalogSearchViewModel.precioMaximo.value,
            widget.codigoMarca,
            widget.codigoProveedor);
        sortProductByOrder(listaAllProducts);
        listaProducto.value = listaAllProducts;
      }
      if (widget.claseProducto == 5) {
        print("tipo de producto 5");
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
        print("tipo de producto 6");
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
        print("tipo de producto 7");
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
        print("tipo de producto 8");
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
      print("tipo de producto otro");
      print("tipo ${widget.tipoCategoria}");

      listaAllProducts = await productService.cargarProductos(
          widget.codCategoria!,
          widget.tipoCategoria,
          '',
          catalogSearchViewModel.precioMinimo.value,
          catalogSearchViewModel.precioMaximo.value,
          widget.codigoMarca,
          widget.codigoProveedor);
      listaProducto.value = sortProductByOrder(listaAllProducts);
    }
  }

  sortProductByOrder(List productsList) {
    var allProducts = [];
    var nonZerosList = [];
    if (widget.tipoCategoria == 2) {
      nonZerosList = productsList.where((element) {
        return element.ordenSubcategoria != 0;
      }).toList();
      nonZerosList.sort((a, b) => a.ordenSubcategoria - b.ordenSubcategoria);
      allProducts.addAll(nonZerosList);

      allProducts.addAll(productsList
          .where((element) => element.ordenSubcategoria == 0)
          .toList());
    } else if (widget.tipoCategoria == 3) {
      nonZerosList = productsList.where((element) {
        return element.ordenMarca != 0;
      }).toList();
      nonZerosList.sort((a, b) => a.ordenMarca - b.ordenMarca);
      allProducts.addAll(nonZerosList);
      allProducts.addAll(
          productsList.where((element) => element.ordenMarca == 0).toList());
    } else {
      return productsList;
    }
    return allProducts;
  }

  _buscadorPrincipal(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: HexColor("#E4E3EC"),
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SearchFuzzyView()));
        },
        child: TextField(
          enabled: false,
          style: TextStyle(color: HexColor("#41398D"), fontSize: 13),
          decoration: InputDecoration(
            fillColor: HexColor("#41398D"),
            hintText: 'Encuentra aquí todo lo que necesitas',
            hintStyle: TextStyle(
              color: HexColor("#41398D"),
            ),
            suffixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Icon(
                  Icons.search,
                  color: HexColor("#41398D"),
                )),
            border: InputBorder.none,
            contentPadding: EdgeInsets.fromLTRB(10.0, 15, 10.0, 0),
          ),
        ),
      ),
    );
  }

  void _validacionGeneralNotificaciones() async {
    switch (widget.locacionFiltro) {
      case 'categoria':
        await controllerNotificaciones
            .getPushInUpByDataBaseCategorias('Categoría');
        await controllerNotificaciones
            .getSlideUpByDataBaseCategorias("Categoría");

        if (controllerNotificaciones.listPushInUpCategorias.isNotEmpty &&
            await controllerNotificaciones.showPushInUp(widget.locacionFiltro,
                    widget.descripcionCategoria, context) ==
                true) {
          controllerNotificaciones.closePushInUp.value = false;
          controllerNotificaciones.onTapPushInUp.value = false;
          int elapsedTime = 0;
          if (controllerNotificaciones.listSlideUpCategorias.isNotEmpty) {
            _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
              if (elapsedTime >=
                  controllerNotificaciones
                      .listPushInUpCategorias.first.tiempo!) {
                if (Get.isSnackbarOpen) {
                  await Get.closeCurrentSnackbar();
                }
                controllerNotificaciones.showSlideUp(widget.locacionFiltro,
                    widget.descripcionCategoria, context);
                timer.cancel();
              } else if (controllerNotificaciones.closePushInUp.value == true) {
                if (Get.isSnackbarOpen) {
                  await Get.closeCurrentSnackbar();
                }
                controllerNotificaciones.showSlideUp(widget.locacionFiltro,
                    widget.descripcionCategoria, context);
                timer.cancel();
              } else if (controllerNotificaciones.onTapPushInUp.value == true) {
                timer.cancel();
              }
              elapsedTime++;
            });
          }
        } else if (controllerNotificaciones.listSlideUpCategorias.isNotEmpty) {
          controllerNotificaciones.closeSlideUp.value = false;
          if (controllerNotificaciones
                      .validacionMostrarSlideUp[widget.descripcionCategoria] ==
                  true &&
              controllerNotificaciones.closeSlideUp.value == false) {
            if (Get.isSnackbarOpen) {
              await Get.closeCurrentSnackbar();
            }
            controllerNotificaciones.showSlideUp(
                widget.locacionFiltro, widget.descripcionCategoria, context);
          }
        }
        break;
      case 'marca':
        await controllerNotificaciones.getPushInUpByDataBaseMarcas('Marcas');
        await controllerNotificaciones.getSlideUpByDataBaseMarcas("Marcas");
        if (controllerNotificaciones.listPushInUpMarcas.isNotEmpty &&
            await controllerNotificaciones.showPushInUp(
                    widget.locacionFiltro, widget.nombreCategoria, context) ==
                true) {
          controllerNotificaciones.closePushInUp.value = false;
          controllerNotificaciones.onTapPushInUp.value = false;

          if (controllerNotificaciones.listSlideUpMarcas.isNotEmpty) {
            int elapsedTime = 0;
            _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
              if (elapsedTime >=
                  controllerNotificaciones.listPushInUpMarcas.first.tiempo) {
                if (Get.isSnackbarOpen) {
                  await Get.closeCurrentSnackbar();
                }
                controllerNotificaciones.showSlideUp(
                    widget.locacionFiltro, widget.nombreCategoria, context);
                timer.cancel();
              } else if (controllerNotificaciones.closePushInUp.value == true) {
                if (Get.isSnackbarOpen) {
                  await Get.closeCurrentSnackbar();
                }
                controllerNotificaciones.showSlideUp(
                    widget.locacionFiltro, widget.nombreCategoria, context);
                timer.cancel();
              } else if (controllerNotificaciones.onTapPushInUp.value == true) {
                timer.cancel();
              }
              elapsedTime++;
            });
          }
        } else if (controllerNotificaciones.listSlideUpMarcas.isNotEmpty) {
          controllerNotificaciones.closeSlideUp.value = false;
          if (controllerNotificaciones
                      .validacionMostrarSlideUp[widget.nombreCategoria] ==
                  true &&
              controllerNotificaciones.closeSlideUp.value == false) {
            if (Get.isSnackbarOpen) {
              await Get.closeCurrentSnackbar();
            }
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
        if (controllerNotificaciones.listPushInUpProveedores.isNotEmpty &&
            await controllerNotificaciones.showPushInUp(
                    widget.locacionFiltro, widget.nombreCategoria, context) ==
                true) {
          controllerNotificaciones.closePushInUp.value = false;
          controllerNotificaciones.onTapPushInUp.value = false;

          if (controllerNotificaciones.listSlideUpProveedores.isNotEmpty) {
            int elapsedTime = 0;
            _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
              if (elapsedTime >=
                  controllerNotificaciones
                      .listPushInUpProveedores.first.tiempo) {
                if (Get.isSnackbarOpen) {
                  await Get.closeCurrentSnackbar();
                }
                controllerNotificaciones.showSlideUp(
                    widget.locacionFiltro, widget.nombreCategoria, context);
                timer.cancel();
              } else if (controllerNotificaciones.closePushInUp.value == true) {
                if (Get.isSnackbarOpen) {
                  await Get.closeCurrentSnackbar();
                }
                controllerNotificaciones.showSlideUp(
                    widget.locacionFiltro, widget.nombreCategoria, context);
                timer.cancel();
              } else if (controllerNotificaciones.onTapPushInUp.value == true) {
                timer.cancel();
              }
              elapsedTime++;
            });
          }
        } else if (controllerNotificaciones.listSlideUpProveedores.isNotEmpty) {
          controllerNotificaciones.closeSlideUp.value = false;
          if (controllerNotificaciones
                      .validacionMostrarSlideUp[widget.nombreCategoria] ==
                  true &&
              controllerNotificaciones.closeSlideUp.value == false) {
            controllerNotificaciones.closeSlideUp.value = false;
            if (Get.isSnackbarOpen) {
              await Get.closeCurrentSnackbar();
            }
            controllerNotificaciones.showSlideUp(
                widget.locacionFiltro, widget.nombreCategoria, context);
          }
        }
        break;
      default:
    }
  }

  void _cargarListaBanner() async {
    switch (widget.locacionFiltro) {
      case 'categoria':
        _listaBanners = await DBProvider.db.cargarBannersCategoriasSql(
            widget.nombreCategoria, widget.descripcionCategoria);
        _listaBanners.map((e) {
          //FIREBASE: Llamamos el evento view_promotion
          TagueoFirebase().sendAnalityticViewPromotion("categoría", e);
        }).toList();
        break;
      case "marca":
        _listaBanners =
            await DBProvider.db.cargarBannersMarcasSql(widget.nombreCategoria);
        _listaBanners.map((e) {
          //FIREBASE: Llamamos el evento view_promotion
          TagueoFirebase().sendAnalityticViewPromotion("marca", e);
        }).toList();
        break;
      case "proveedor":
        print('widget.nombreCategoria: ${widget.empresa}');
        _listaBanners =
            await DBProvider.db.cargarBannersProveedoresSql(widget.empresa!);
        _listaBanners.map((e) {
          //FIREBASE: Llamamos el evento view_promotion
          TagueoFirebase().sendAnalityticViewPromotion("proveedor", e);
        }).toList();
        break;
    }

    if (_listaBanners.length > 0) {
      isActiveBanner = true;
    }
    _listaBanners.map((e) {
      //FIREBASE: Llamamos el evento view_promotion
      TagueoFirebase().sendAnalityticViewPromotion("proveedor", e);
    }).toList();
    setState(() {});
  }
}
