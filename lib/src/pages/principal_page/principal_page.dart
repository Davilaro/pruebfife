import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/_pideky/presentation/mis_pagos_nequi/view_model/mis_pagos_nequi_view_model.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_view_model.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/card_notification_slide_up.dart';
import 'package:emart/shared/widgets/notification_push_in_app.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/controllers/controller_product.dart';
import 'package:emart/src/controllers/encuesta_controller.dart';
import 'package:emart/src/controllers/notifiactions_controllers.dart';
import 'package:emart/src/modelos/multimedia.dart';
import 'package:emart/src/pages/principal_page/widgets/categorias_card.dart';
import 'package:emart/src/pages/principal_page/widgets/encuesta_form.dart';
import 'package:emart/src/pages/principal_page/widgets/products_card.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:emart/src/provider/logica_actualizar.dart';
import 'package:emart/src/widget/search_fuzzy.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/util.dart';
import 'package:emart/src/pages/principal_page/widgets/ofertas_banner.dart';
import 'package:emart/src/pages/catalogo/widgets/opciones.dart';
import 'package:emart/src/widget/reproduct_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

final prefs = new Preferencias();

bool limpiar = false;

class PrincipalPage extends StatefulWidget {
  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage>
    with AutomaticKeepAliveClientMixin {
  final controllerEncuesta = Get.put(EncuestaControllers());
  final productViewModel = Get.find<ProductoViewModel>();

  final cargoControllerBase = Get.put(CambioEstadoProductos());
  final controllerProducto = Get.put(ControllerProductos());
  final cargoConfirmar = Get.find<ControlBaseDatos>();
  final viewModelPedidoSugerido = Get.find<PedidoSugeridoViewModel>();
  final viewModelNequi = Get.find<MisPagosNequiViewModel>();
  final controllerNotificaciones =
      Get.find<NotificationsSlideUpAndPushInUpControllers>();

  var nombreTienda = prefs.usuarioRazonSocial;

  @override
  void initState() {
    super.initState();
    print("entre aqui");
    //UXCAM: Se define el nombre de la pantalla
    FlutterUxcam.tagScreenName('HomePage');
    if (prefs.usurioLogin == 1) {
      controllerNotificaciones.llenarMapPushInUp("Home");
      controllerNotificaciones.llenarMapSlideUp("Home");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        validacionGeneralNotificaciones();
      });
    }
    controllerProducto.getAgotados();
    validarVersionActual(context);
    //FIREBASE: Llamamos el evento select_content
    TagueoFirebase().sendAnalityticSelectContent(
        "Footer", "Home", "", "", "Home", 'PrincipalPage');
    //UXCam: Llamamos el evento selectFooter
    UxcamTagueo().selectFooter('Inicio');
    productViewModel.cargarCondicionEntrega();
    prefs.diaActual = DateFormat.EEEE().format(DateTime.now());
    var tempDay = DateTime.now();
    var formatDay = tempDay.add(Duration(days: 1));
    var finalDay = DateFormat.EEEE().format(formatDay);
    prefs.nextDay = finalDay;
    print('next day : ${prefs.nextDay}');
  }

  void validacionGeneralNotificaciones() async {
    if (controllerNotificaciones.validacionMostrarPushInUp["Home"] == true) {
      await showPushInUp();
      if (controllerNotificaciones.listPushInUpHome.isNotEmpty) {
        int elapsedTime = 0;
        Timer.periodic(Duration(milliseconds: 10), (timer) {
          if (elapsedTime >= 530) {
            showSlideUp();
            timer.cancel();
          } else if (controllerNotificaciones.closePushInUp.value == true) {
            showSlideUp();
            timer.cancel();
          } else if (controllerNotificaciones.onTapPushInUp.value == true) {
            timer.cancel();
          }
          elapsedTime++;
        });
      }
    } else if (controllerNotificaciones.validacionMostrarSlideUp["Home"] ==
            true &&
        controllerNotificaciones.closeSlideUp.value == false) {
      showSlideUp();
    }
  }

  Future<void> showPushInUp() async {
    await controllerNotificaciones.getPushInUpByDataBaseHome("Home");
    if (controllerNotificaciones.listPushInUpHome.isNotEmpty) {
      controllerNotificaciones.validacionMostrarPushInUp["Home"] = false;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
                onWillPop: () async => false,
                child: NotificationPushInApp(
                    controllerNotificaciones.listPushInUpHome.first, "Home"));
          });
    }
  }

  void showSlideUp() async {
    await controllerNotificaciones.getSlideUpByDataBaseHome("Home");
    if (controllerNotificaciones.listSlideUpHome.isNotEmpty) {
      controllerNotificaciones.closeSlideUp.value = true;
      controllerNotificaciones.validacionMostrarSlideUp["Home"] = false;
      await Future.delayed(
          Duration(milliseconds: 100),
          () => showSlideUpNotification(
              context, controllerNotificaciones.listSlideUpHome.first, "Home"));
    }
  }

  @override
  void dispose() {
    Get.closeCurrentSnackbar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<OpcionesBard>(context);
    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: RefreshIndicator(
          color: ConstantesColores.azul_precio,
          backgroundColor: ConstantesColores.agua_marina.withOpacity(0.6),
          onRefresh: () async {
            if (prefs.usurioLogin != null && prefs.usurioLogin != -1) {
              await LogicaActualizar().actualizarDB();
              Navigator.pushReplacementNamed(
                context,
                'tab_opciones',
              ).timeout(Duration(seconds: 3));
              return Future<void>.delayed(const Duration(seconds: 3));
            }
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                //BUSCADOR
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: _buscadorPrincipal(context),
                ),
                //OPCIONES DINAMICAS
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: BtnOpciones(size: size, provider: provider),
                ),
                //OFERTAS QUE MUESTRA LOS BANNERS
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  height: Get.height * 0.22,
                  width: double.infinity,
                  child: OfertasBanner(),
                ),
                //IMPERDIBLES
                Container(
                    margin: EdgeInsets.only(top: 10),
                    height: Get.height * 0.4,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: FutureBuilder(
                                initialData: [],
                                future: DBProvider.db.consultarSucursal(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  var tituloImperdible =
                                      prefs.usurioLogin == -1 ||
                                              snapshot.data.length == []
                                          ? 'tí'
                                          : snapshot.data;
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        width: Get.width * 0.7,
                                        child: AutoSizeText(
                                          // 'Imperdibles para $tituloImperdible',
                                          '${S.current.imperdible} $tituloImperdible',
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: HexColor("#41398D"),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            onClickVerMas(
                                                'Imperdibles', provider);
                                          },
                                          child: Text(
                                            'Ver más',
                                            style: TextStyle(
                                                color: ConstantesColores
                                                    .agua_marina,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline),
                                          ))
                                    ],
                                  );
                                })),
                        Expanded(child: ProductsCard(2))
                      ],
                    )),
                //PROMOS
                Container(
                    height: Get.height * 0.4,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Promo de la semana',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: HexColor("#41398D"),
                                    fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                  onPressed: () {
                                    onClickVerMas('Promos', provider);
                                  },
                                  child: Text(
                                    'Ver más',
                                    style: TextStyle(
                                        color: ConstantesColores.agua_marina,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline),
                                  ))
                            ],
                          ),
                        ),
                        Expanded(child: ProductsCard(1))
                      ],
                    )),
                //MULTIMEDIA
                FutureBuilder(
                    initialData: [],
                    future: DBProvider.db.consultarMultimedia(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.data == null || snapshot.data.length == 0) {
                        return Container();
                      } else {
                        Multimedia multimedia = snapshot.data[0];
                        // cargoConfirmar.setUrlMultimedia(multimedia.link);
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          margin: EdgeInsets.only(top: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 15, left: 3),
                                child: Text(
                                  'Lo más visto por clientes vecinos',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: HexColor("#41398D"),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                height: Get.height * 0.25,
                                padding: EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: ReproductVideo(multimedia),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
                //CATEGORIAS DESTACAS
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: Get.width * 0.7,
                                child: Text(
                                  S.current.categories_for_you,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: HexColor("#41398D"),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    onClickVerMas('Categorías', provider);
                                  },
                                  child: Text(
                                    'Ver más',
                                    style: TextStyle(
                                        color: ConstantesColores.agua_marina,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline),
                                  ))
                            ],
                          ),
                        ),
                        Container(
                            height: Get.height * 0.2, child: CategoriasCard()),
                      ],
                    )),
                //ENCUESTA
                FutureBuilder(
                    initialData: [],
                    future: DBProvider.db.consultarEncuesta(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.data.length == 0) {
                        return Container();
                      } else {
                        controllerEncuesta.isVisibleEncuesta.value = true;
                        return Obx(() => Visibility(
                              visible:
                                  controllerEncuesta.isVisibleEncuesta.value,
                              child: Container(
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 15, bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: EncuestaForm(snapshot.data[0])),
                            ));
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
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
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchFuzzy()));
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

  void onClickVerMas(String ubicacion, provider) async {
    for (var i = 0; i < cargoConfirmar.seccionesDinamicas.length; i++) {
      if (cargoConfirmar.seccionesDinamicas[i].descripcion.toLowerCase() ==
          ubicacion.toLowerCase()) {
        //FIREBASE: Llamamos el evento select_content
        TagueoFirebase().sendAnalityticSelectContent(
            "SeeMore",
            "${cargoConfirmar.seccionesDinamicas[i].descripcion}",
            "",
            "",
            "${cargoConfirmar.seccionesDinamicas[i].descripcion}",
            'HomePage');
        //UXCam: Llamamos el evento seeMore
        UxcamTagueo().seeMore(
            "${cargoConfirmar.seccionesDinamicas[i].descripcion}", provider);
        provider.selectOptionMenu = 1;
        provider.setIsLocal = 0;
        cargoConfirmar.tabController.index = i;
        cargoConfirmar.cargoBaseDatos(i);
        break;
      }
    }
  }

  @override
  bool get wantKeepAlive => false;
}
