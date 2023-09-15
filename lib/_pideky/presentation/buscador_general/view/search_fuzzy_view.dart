import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/presentation/buscador_general/view_model/search_fuzzy_view_model.dart';
import 'package:emart/_pideky/presentation/buscador_general/widgets/busquedas_recientes.dart';
import 'package:emart/shared/widgets/buscador_general.dart';
import 'package:emart/shared/widgets/drawer_sucursales.dart';
import 'package:emart/shared/widgets/new_app_bar.dart';
import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/controllers/notifiactions_controllers.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SearchFuzzyView extends StatelessWidget {

  //  locacionFiltro

  
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  final searchFuzzyViewModel = Get.put(SearchFuzzyViewModel());

  final cargoConfirmar = Get.find<CambioEstadoProductos>();

  final Timer timer = Timer(Duration(milliseconds: 1), () {});

  final controllerNotificaciones =
      Get.find<NotificationsSlideUpAndPushInUpControllers>();

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CarroModelo>(context);

    // if (prefs.usurioLogin == 1) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     validacionGeneralNotificaciones(context);
    //   });
    // }


    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      key: drawerKey,
      drawerEnableOpenDragGesture:
          searchFuzzyViewModel.prefs.usurioLogin == 1 ? true : false,
      drawer: DrawerSucursales(drawerKey),
      appBar: PreferredSize(
        preferredSize: searchFuzzyViewModel.prefs.usurioLogin == 1
            ? const Size.fromHeight(118)
            : const Size.fromHeight(70),
        child: SafeArea(child: NewAppBar(drawerKey)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FittedBox(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: ConstantesColores.agua_marina,
                          size: 30,
                        ),
                      ),
                      BuscadorGeneral(),
                    ],
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Obx(() => Text(
                  searchFuzzyViewModel.searchInput.value.isEmpty
                      ? 'Estás buscando en todas las secciones'
                      : 'Estás buscando "${searchFuzzyViewModel.searchInput.value}" en todas las secciones',
                  style: TextStyle(
                      color: Colors.black.withOpacity(.5),
                      fontSize: 13,
                      fontWeight: FontWeight.bold))),
            ),
            SingleChildScrollView(
                child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Obx(
                    () => searchFuzzyViewModel.allResultados.isNotEmpty
                        ? Container(
                            height: 300,
                            child: ListView.builder(
                              itemCount: 10,
                              itemBuilder:
                                  (BuildContext context, int position) {
                                return Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        searchFuzzyViewModel.logicaSeleccion(
                                            searchFuzzyViewModel
                                                .allResultados[position],
                                            cargoConfirmar,
                                            cartProvider,
                                            context);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: Row(
                                              children: [
                                                CachedNetworkImage(
                                                  height: Get.height * 0.07,
                                                  imageUrl: searchFuzzyViewModel
                                                      .iconoSugeridos(
                                                          palabrabuscada:
                                                              searchFuzzyViewModel
                                                                      .allResultados[
                                                                  position])!,
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image.asset(
                                                    'assets/image/logo_login.png',
                                                    width: Get.width * 0.05,
                                                  ),
                                                  fit: BoxFit.fill,
                                                ),
                                                SizedBox(
                                                  width: Get.width * 0.05,
                                                ),
                                                SizedBox(
                                                  width: Get.width * 0.4,
                                                  child: AutoSizeText(
                                                    searchFuzzyViewModel
                                                        .nombreSugeridos(
                                                            palabrabuscada:
                                                                searchFuzzyViewModel
                                                                        .allResultados[
                                                                    position],
                                                            conDistintivo:
                                                                true)!,
                                                    minFontSize: 12,
                                                    style: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(.4),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: Get.width * 0.05,
                                                vertical: Get.height * 0.05),
                                            child: Icon(
                                              Icons.search,
                                              color:
                                                  Colors.black.withOpacity(.4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider()
                                  ],
                                );
                              },
                            ))
                        : SizedBox.shrink(),
                  ),
                  Divider(),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Busquedas recientes",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Divider(),
                  BusquedasRecientes(),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// void validacionGeneralNotificaciones(context) async {
//   switch (widget.locacionFiltro) {
//     case 'categoria':
//       await controllerNotificaciones
//           .getPushInUpByDataBaseCategorias('Categoría');
//       await controllerNotificaciones
//           .getSlideUpByDataBaseCategorias("Categoría");

//       if (controllerNotificaciones.listPushInUpCategorias.isNotEmpty) {
//         controllerNotificaciones.closePushInUp.value = false;
//         controllerNotificaciones.onTapPushInUp.value = false;
//         if (controllerNotificaciones
//                 .validacionMostrarPushInUp[widget.descripcionCategoria] ==
//             true) {
//           await controllerNotificaciones.showPushInUp(
//               widget.locacionFiltro, widget.descripcionCategoria, context);
//           int elapsedTime = 0;
//           if (controllerNotificaciones.listSlideUpCategorias.isNotEmpty) {
//             timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
//               if (elapsedTime >= 530) {
//                 controllerNotificaciones.showSlideUp(widget.locacionFiltro,
//                     widget.descripcionCategoria, context);
//                 timer.cancel();
//               } else if (controllerNotificaciones.closePushInUp.value == true) {
//                 controllerNotificaciones.showSlideUp(widget.locacionFiltro,
//                     widget.descripcionCategoria, context);
//                 timer.cancel();
//               } else if (controllerNotificaciones.onTapPushInUp.value == true) {
//                 timer.cancel();
//               }
//               elapsedTime++;
//             });
//           }
//         }
//       } else if (controllerNotificaciones.listSlideUpCategorias.isNotEmpty) {
//         controllerNotificaciones.closeSlideUp.value = false;
//         if (controllerNotificaciones
//                     .validacionMostrarSlideUp[widget.descripcionCategoria] ==
//                 true &&
//             controllerNotificaciones.closeSlideUp.value == false) {
//           controllerNotificaciones.showSlideUp(
//               widget.locacionFiltro, widget.descripcionCategoria, context);
//         }
//       }
//       break;
//     case 'marca':
//       await controllerNotificaciones.getPushInUpByDataBaseMarcas('Marcas');
//       await controllerNotificaciones.getSlideUpByDataBaseMarcas("Marcas");
//       if (controllerNotificaciones.listPushInUpMarcas.isNotEmpty) {
//         controllerNotificaciones.closePushInUp.value = false;
//         controllerNotificaciones.onTapPushInUp.value = false;
//         if (controllerNotificaciones
//                 .validacionMostrarPushInUp[widget.nombreCategoria] ==
//             true) {
//           await controllerNotificaciones.showPushInUp(
//               widget.locacionFiltro, widget.nombreCategoria, context);
//           if (controllerNotificaciones.listSlideUpMarcas.isNotEmpty) {
//             int elapsedTime = 0;
//             timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
//               if (elapsedTime >= 530) {
//                 controllerNotificaciones.showSlideUp(
//                     widget.locacionFiltro, widget.nombreCategoria, context);
//                 timer.cancel();
//               } else if (controllerNotificaciones.closePushInUp.value == true) {
//                 controllerNotificaciones.showSlideUp(
//                     widget.locacionFiltro, widget.nombreCategoria, context);
//                 timer.cancel();
//               } else if (controllerNotificaciones.onTapPushInUp.value == true) {
//                 timer.cancel();
//               }
//               elapsedTime++;
//             });
//           }
//         }
//       } else if (controllerNotificaciones.listSlideUpMarcas.isNotEmpty) {
//         controllerNotificaciones.closeSlideUp.value = false;
//         if (controllerNotificaciones
//                     .validacionMostrarSlideUp[widget.nombreCategoria] ==
//                 true &&
//             controllerNotificaciones.closeSlideUp.value == false) {
//           controllerNotificaciones.showSlideUp(
//               widget.locacionFiltro, widget.nombreCategoria, context);
//         }
//       }
//       break;
//     case 'proveedor':
//       await controllerNotificaciones
//           .getPushInUpByDataBaseProveedores('Proveedor');
//       await controllerNotificaciones
//           .getSlideUpByDataBaseProveedores("Proveedor");
//       if (controllerNotificaciones.listPushInUpProveedores.isNotEmpty) {
//         controllerNotificaciones.closePushInUp.value = false;
//         controllerNotificaciones.onTapPushInUp.value = false;
//         if (controllerNotificaciones
//                 .validacionMostrarPushInUp[widget.nombreCategoria] ==
//             true) {
//           await controllerNotificaciones.showPushInUp(
//               widget.locacionFiltro, widget.nombreCategoria, context);
//           if (controllerNotificaciones.listSlideUpProveedores.isNotEmpty) {
//             int elapsedTime = 0;
//             timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
//               if (elapsedTime >= 530) {
//                 controllerNotificaciones.showSlideUp(
//                     widget.locacionFiltro, widget.nombreCategoria, context);
//                 timer.cancel();
//               } else if (controllerNotificaciones.closePushInUp.value == true) {
//                 controllerNotificaciones.showSlideUp(
//                     widget.locacionFiltro, widget.nombreCategoria, context);
//                 timer.cancel();
//               } else if (controllerNotificaciones.onTapPushInUp.value == true) {
//                 timer.cancel();
//               }
//               elapsedTime++;
//             });
//           }
//         }
//       } else if (controllerNotificaciones.listSlideUpProveedores.isNotEmpty) {
//         if (controllerNotificaciones
//                     .validacionMostrarSlideUp[widget.nombreCategoria] ==
//                 true &&
//             controllerNotificaciones.closeSlideUp.value == false) {
//           controllerNotificaciones.closeSlideUp.value = false;
//           controllerNotificaciones.showSlideUp(
//               widget.locacionFiltro, widget.nombreCategoria, context);
//         }
//       }
//       break;
//     default:
//   }
// }
