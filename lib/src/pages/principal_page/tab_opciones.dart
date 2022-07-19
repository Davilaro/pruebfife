import 'dart:async';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/notificaciones/push_notification.dart';
import 'package:emart/src/pages/catalogo/tab_categorias_marcas.dart';
import 'package:emart/src/pages/mi_negocio/mi_negocio.dart';
import 'package:emart/src/pages/principal_page/principal_page.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/routes/custonNavigatorBar.dart';
import 'package:emart/src/pages/historico/historico_pedidos.dart';
import 'package:emart/src/widget/pedido_rapido.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';

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

  final cargoConfirmar = Get.put(CambioEstadoProductos());

  @override
  void initState() {
    super.initState();
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
        child: Scaffold(
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
        ));
  }

  void preambuloBase() async {
    await _descarcarDB();
  }

  Future<void> _descarcarDB() async {
    PedidoEmart.listaControllersPedido = new Map();
    PedidoEmart.listaValoresPedido = new Map();
    PedidoEmart.listaProductos = new Map();
    PedidoEmart.listaValoresPedidoAgregados = new Map();

    providerDatos.guardarListaSugueridoHelper =
        await DBProviderHelper.db.consultarSugueridoHelper();
    providerDatos.guardarListaHistoricosHelper =
        await DBProviderHelper.db.consultarHistoricos('-1', '-1', '-1');

    PedidoEmart.listaFabricante =
        await DBProvider.db.consultarFricanteGeneral();

    var listaProductos =
        await DBProvider.db.cargarProductos('', 10, '', 0.0, 1000000000.0, "");
    for (var i = 0; i < listaProductos.length; i++) {
      PedidoEmart.listaProductos!
          .putIfAbsent(listaProductos[i].codigo, () => listaProductos[i]);
      PedidoEmart.listaValoresPedidoAgregados!
          .putIfAbsent(listaProductos[i].codigo, () => false);
      PedidoEmart.listaValoresPedido!
          .putIfAbsent(listaProductos[i].codigo, () => "1");
      PedidoEmart.listaControllersPedido!
          .putIfAbsent(listaProductos[i].codigo, () => TextEditingController());
    }

    String? token = PushNotificationServer.token as String;
    print('Token: $token');
    setState(() {});
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
          provider.getIisLocal == 0
              ? ''
              //FIREBASE: Llamamos el evento select_content
              : TagueoFirebase().sendAnalityticSelectContent(
                  "Footer", "Catalogo", "", "", "Catalogo", 'MainActivity');
          provider.getIisLocal == 0
              ? ''
              : onClickVerMas('Categorías', provider);

          return TabCategoriaMarca();
        }

      case 2:
        return PedidoRapido();

      case 3:
        return HistoricoPedidos();

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
