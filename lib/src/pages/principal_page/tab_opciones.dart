import 'dart:async';
import 'package:emart/_pideky/domain/producto/service/producto_service.dart';
import 'package:emart/_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import 'package:emart/_pideky/presentation/mi_negocio/view/mi_negocio.dart';
import 'package:emart/_pideky/presentation/mis_pedidos/view/mis_pedidos.dart';
import 'package:emart/_pideky/presentation/mis_pedidos/view_model/mis_pedidos_view_model.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view/pedido_sugerido_page.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/drawer_sucursales.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/bannnersController.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/controllers/controller_historico.dart';
import 'package:emart/src/notificaciones/push_notification.dart';
import 'package:emart/src/pages/catalogo/tab_categorias_marcas.dart';
import 'package:emart/src/pages/principal_page/principal_page.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/routes/custonNavigatorBar.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';

import '../../../shared/widgets/new_app_bar.dart';

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

  late StreamSubscription<ConnectivityResult> subscription;

  final cargoControllerBase = Get.put(ControlBaseDatos());
  ProductoViewModel productViewModel = Get.find();

  final cargoConfirmar = Get.put(CambioEstadoProductos());
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
    print("dia actual ${prefs.diaActual}");
    _focusNode.dispose();
    hasInternet = true;
    cargarSecciones();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        hasInternet = result != ConnectivityResult.none;
      });
    });
    cargoConfirmar.cargarProductoNuevo(ProductoCambiante(), 1);
    preambuloBase();
    setState(() {});
  }

  dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    providerDatos = Provider.of<DatosListas>(context, listen: true);
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
                child: _HomePageBody()),
            bottomNavigationBar: Container(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: CustonNavigatorBar(),
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
      if (PedidoEmart.listaControllersPedido?.keys.length == null) {
        PedidoEmart.listaControllersPedido = new Map();
        PedidoEmart.listaValoresPedido = new Map();
        PedidoEmart.listaProductos = new Map();
        PedidoEmart.listaValoresPedidoAgregados = new Map();
      }
      final misPedidosViewModel = Get.find<MisPedidosViewModel>();
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
      String? token = PushNotificationServer.token as String;

      print('Token: $token');
      setState(() {});
    } catch (e) {
      print('error de descarga db $e');
    }
  }

  void cargarSecciones() async {
    cargoControllerBase
        .cargarSecciones(await DBProvider.db.consultarSecciones());

    var _tabControllerTemplate = new TabController(
        length: cargoControllerBase.seccionesDinamicas.length,
        vsync: this,
        initialIndex: cargoControllerBase.cambioTab.value);
    _tabControllerTemplate.addListener(() {
      cargoControllerBase.cargoBaseDatos(_tabControllerTemplate.index);
    });
    cargoControllerBase.initControllertabController(_tabControllerTemplate);
  }
}

class _HomePageBody extends StatelessWidget {
  final cargoConfirmar = Get.find<ControlBaseDatos>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OpcionesBard>(context);
    final currenIndex = provider.selectOptionMenu;

    switch (currenIndex) {
      case 0:
        return PrincipalPage();

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
          return TabCategoriaMarca();
        }

      case 2:
        return PedidoSugeridoPage();

      case 3:
        {
          //UXCam: Llamamos el evento selectFooter
          UxcamTagueo().selectFooter('Mis pedidos');
          return MisPedidosPage();
        }

      case 4:
        return MiNegocio();

      default:
        return Text('Prueba'); //PrincipalPage();
    }
  }

  void onClickVerMas(String ubicacion, provider) {
    for (var i = 0; i < cargoConfirmar.seccionesDinamicas.length; i++) {
      if (cargoConfirmar.seccionesDinamicas[i].descripcion.toLowerCase() ==
          ubicacion.toLowerCase()) {
        if (provider.selectOptionMenu != 1) {
          provider.selectOptionMenu = 1;
          provider.setIsLocal = 0;
        }
        cargoConfirmar.tabController.index = i;
        cargoConfirmar.cargoBaseDatos(i);
        break;
      }
    }
  }
}
