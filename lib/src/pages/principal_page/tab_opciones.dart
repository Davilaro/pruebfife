// ignore_for_file: deprecated_member_use
import 'package:emart/_pideky/presentation/general_search/view_model/search_fuzzy_view_model.dart';
import 'package:emart/_pideky/presentation/my_lists/view_model/my_lists_view_model.dart';
import 'package:emart/src/pages/catalogo/view_model/botones_proveedores_vm.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/utils/alertas.dart';

import '../../../shared/widgets/new_app_bar.dart';
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:emart/_pideky/domain/product/use_cases/producto_use_cases.dart';
import 'package:emart/_pideky/infrastructure/product/product_service.dart';
import 'package:emart/_pideky/presentation/my_business/view_model/my_business_view_model.dart';
import 'package:emart/_pideky/presentation/my_business/view/my_business_page.dart';
import 'package:emart/_pideky/presentation/my_orders/view_model/mis_pedidos_view_model.dart';
import 'package:emart/_pideky/presentation/my_orders/view/my_orders_page.dart';
import 'package:emart/_pideky/presentation/suggested_order/view/suggested_order_page.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/drawer_sucursales.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/bannners_controller.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/controllers/controller_historico.dart';
import 'package:emart/src/controllers/notifiactions_controllers.dart';
import 'package:emart/src/pages/catalogo/tab_categorias_marcas.dart';
import 'package:emart/src/pages/principal_page/principal_page.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/routes/custonNavigatorBar.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../preferences/metodo_ingresados.dart';

final prefs = new Preferencias();
DatosListas providerDatos = new DatosListas();

class TabOpciones extends StatefulWidget {
  @override
  State<TabOpciones> createState() => _TabOpcionesState();
}

class _TabOpcionesState extends State<TabOpciones>
    with SingleTickerProviderStateMixin {
  late bool hasInternet;
  late bool cargandoDatos = true;
  late final cartProvider = Provider.of<CartViewModel>(context, listen: false);

  late StreamSubscription<ConnectivityResult> subscription;

  final cargoControllerBase = Get.put(ControlBaseDatos());
  final MyBusinessVieModel viewModelNegocio = Get.find();
  final botonesController = Get.find<BotonesProveedoresVm>();
  ProductViewModel productViewModel = Get.find();
  ProductViewModel productoViewModel = Get.find();

  final cargoConfirmar = Get.put(CambioEstadoProductos());
  final searchController = Get.find<SearchFuzzyViewModel>();
  final controllerNotificaciones =
      Get.find<NotificationsSlideUpAndPushInUpControllers>();
  final catalogSearchViewModel = Get.put(ControllerHistorico());

  final bannerPut = Get.put(BannnerControllers());
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();
  FocusNode _focusNode = FocusNode();
  SystemUiOverlayStyle _currentStyle = SystemUiOverlayStyle(
    statusBarColor: ConstantesColores.color_fondo_gris,
    statusBarIconBrightness: Brightness.dark,
  );

  @override
  void initState() {
    super.initState();
    if (prefs.usurioLogin == 1) {
      Get.find<MyListsViewModel>().getMisListas();
    }

    _focusNode.dispose();
    hasInternet = true;

    cargarSecciones();
    viewModelNegocio.cargarArchivos(prefs);
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        hasInternet = result != ConnectivityResult.none;
      });
    });

    preambuloBase();
    verPopUp();
  }

  dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    providerDatos = Provider.of<DatosListas>(context, listen: true);
    final provider = Provider.of<OpcionesBard>(context, listen: true);

    return WillPopScope(
        onWillPop: () async => false,
        child: AnnotatedRegion(
          value: _currentStyle,
          child: Scaffold(
            backgroundColor: ConstantesColores.color_fondo_gris,
            key: drawerKey,
            drawerEnableOpenDragGesture: prefs.usurioLogin == 1 ? true : false,
            drawer: DrawerSucursales(drawerKey),
            appBar: PreferredSize(
              preferredSize: prefs.usurioLogin == 1
                  ? const Size.fromHeight(118)
                  : const Size.fromHeight(70),
              child: SafeArea(child: NewAppBar(drawerKey)),
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: _HomePageBody(
                provider: provider,
              ),
            ),
            bottomNavigationBar: Container(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: CustomNavigatonBar(),
              ),
            ),
          ),
        ));
  }

  void preambuloBase() async {
    await _descarcarDB();
  }

  Future<void> _descarcarDB() async {
    try {
      PedidoEmart.listaControllersPedido = new Map();
      PedidoEmart.listaValoresPedido = new Map();
      PedidoEmart.listaProductos = new Map();
      PedidoEmart.listaValoresPedidoAgregados = new Map();
      final misPedidosViewModel = Get.find<MyOrdersViewModel>();
      ProductoService productService =
          ProductoService(ProductoRepositorySqlite());

      providerDatos.guardarListaSugueridoHelper =
          await DBProviderHelper.db.consultarSugueridoHelper();
      providerDatos.guardarListaHistoricosHelper = await misPedidosViewModel
          .misPedidosService
          .consultarHistoricos('-1', '-1', '-1');

      PedidoEmart.listaFabricante =
          await DBProvider.db.consultarFricanteGeneral();

      var listaProductos = await productService.cargarProductos(
          '', 10, '', 0.0, 1000000000.0, "", "");
      for (var i = 0; i < listaProductos.length; i++) {
        PedidoEmart.listaProductos!
            .putIfAbsent(listaProductos[i].codigo, () => listaProductos[i]);
        PedidoEmart.listaValoresPedidoAgregados!
            .putIfAbsent(listaProductos[i].codigo, () => false);
        PedidoEmart.listaValoresPedido!
            .putIfAbsent(listaProductos[i].codigo, () => "1");
        PedidoEmart.listaControllersPedido!.putIfAbsent(
            listaProductos[i].codigo, () => TextEditingController());
      }
      await productViewModel.cargarTemporal();
      setState(() {});
    } catch (e) {
      print('error de descarga db $e');
    }
    botonesController.listaFabricantesBloqueados.clear();
  }

  void cargarSecciones() async {
    await searchController.initState();
    final sesiones = await DBProvider.db.consultarSecciones();
    cargoConfirmar.cargarProductoNuevo(ProductoCambiante(), 1);
    cargoControllerBase.cargarSecciones(sesiones);

    var _tabControllerTemplate = new TabController(
        length: cargoControllerBase.seccionesDinamicas.length,
        vsync: this,
        initialIndex: cargoControllerBase.cambioTab.value);
    _tabControllerTemplate.addListener(() {
      cargoControllerBase.cargoBaseDatos(_tabControllerTemplate.index);
    });

    cargoControllerBase.initControllertabController(_tabControllerTemplate);
  }

  void verPopUp() async {
    var listaMora = '';
    List listabloqueo = [];
    List<Map> listaProveedores = [];
    final fabricantes = await DBProvider.db.consultarFabricanteBloqueo();
    fabricantes.forEach((element) {
      if (element.verPopUp == 0) {
        listaMora = listaMora + element.nombrecomercial + ', ';
        listaProveedores
            .add({'Codigo': element.codigo, 'Proveedor': element.empresa});
      }
      if (element.bloqueoCartera == 1) {
        listabloqueo.add(element.empresa);
      }
    });
    if (listaMora != '') {
      listaMora = listaMora.substring(0, listaMora.length - 2);
      mostrarAlertaPopUpVisto(context, listaMora, listaProveedores);
    }
    if (listabloqueo.isNotEmpty) {
      PedidoEmart.listaProductos!.forEach((key, value) {
        PedidoEmart.listaControllersPedido![value.codigo]!.text = "0";
        PedidoEmart.registrarValoresPedido(value, "1", false);
        //eliminamos el pedido de la temporal
        productoViewModel.eliminarProductoTemporal(value.codigo);
        PedidoEmart.iniciarProductosPorFabricante();
        cargoConfirmar.mapaHistoricos.updateAll((key, value) => value = false);
        MetodosLLenarValores().calcularValorTotal(cartProvider);
      });
    }
  }
}

class _HomePageBody extends StatelessWidget {
  final provider;
  final cargoConfirmar = Get.find<ControlBaseDatos>();
  final controllerNotificaciones =
      Get.find<NotificationsSlideUpAndPushInUpControllers>();

  _HomePageBody({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currenIndex = provider.selectOptionMenu;

    return PageView(
      controller: provider.pageController,
      physics: NeverScrollableScrollPhysics(),
      onPageChanged: (value) {
        switch (currenIndex) {
          case 0:
            return UxcamTagueo().selectFooter('Principal Page');

          case 1:
            {
              if (provider.getIisLocal != 0) {
                //FIREBASE: Llamamos el evento select_content
                TagueoFirebase().sendAnalityticSelectContent(
                    "Footer",
                    "${S.current.catalog}",
                    "",
                    "",
                    "${S.current.catalog}",
                    'MainActivity');
                //UXCam: Llamamos el evento selectFooter
                UxcamTagueo().selectFooter('${S.current.catalog}');

                onClickVerMas('Categorías', provider);
              }
              return UxcamTagueo().selectFooter('Tab Categoria Marca');
            }

          case 2:
            return UxcamTagueo().selectFooter('Pedido Sugerido');

          case 3:
            {
              //UXCam: Llamamos el evento selectFooter
              return UxcamTagueo().selectFooter('Mis pedidos');
            }

          case 4:
            return UxcamTagueo().selectFooter('Mis Negocio');
        }
      },
      children: [
        PrincipalPage(),
        TabCategoriaMarca(),
        SuggestedOrderPage(),
        MyOrdersPage(),
        MyBusinessPage()
      ],
    );

    // switch (currenIndex) {
    //   case 0:
    //     return PrincipalPage();

    //   case 1:
    //     {
    //       if (provider.getIisLocal != 0) {
    //         //FIREBASE: Llamamos el evento select_content
    //         TagueoFirebase().sendAnalityticSelectContent(
    //             "Footer",
    //             "${S.current.catalog}",
    //             "",
    //             "",
    //             "${S.current.catalog}",
    //             'MainActivity');
    //         //UXCam: Llamamos el evento selectFooter
    //         UxcamTagueo().selectFooter('${S.current.catalog}');

    //         onClickVerMas('Categorías', provider);
    //       }
    //       return TabCategoriaMarca();
    //     }

    //   case 2:
    //     return PedidoSugeridoPage();

    //   case 3:
    //     {
    //       //UXCam: Llamamos el evento selectFooter
    //       UxcamTagueo().selectFooter('Mis pedidos');
    //       return MisPedidosPage();
    //     }

    //   case 4:
    //     return MiNegocio();

    //   default:
    //     return Text('Prueba'); //PrincipalPage();
    // }
  }

  void onClickVerMas(String ubicacion, provider) {
    for (var i = 0; i < cargoConfirmar.seccionesDinamicas.length; i++) {
      if (cargoConfirmar.seccionesDinamicas[i].descripcion.toLowerCase() ==
          ubicacion.toLowerCase()) {
        if (provider.selectOptionMenu != 1) {
          provider.paginaActual = 1;
          provider.setIsLocal = 0;
        }
        cargoConfirmar.tabController.index = i;
        cargoConfirmar.cargoBaseDatos(i);
        break;
      }
    }
  }
}
