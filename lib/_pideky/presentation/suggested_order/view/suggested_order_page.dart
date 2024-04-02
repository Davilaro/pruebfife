import 'package:emart/_pideky/presentation/my_lists/view/my_lists_page.dart';
import 'package:emart/shared/widgets/popups.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';

import 'package:get/get.dart';

import 'package:emart/_pideky/presentation/suggested_order/view_model/suggested_order_view_model.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import '../../../../src/utils/util.dart';
import 'widgets/body_pedido_sugerido.dart';

class SuggestedOrderPage extends StatefulWidget {
  const SuggestedOrderPage({Key? key}) : super(key: key);

  @override
  State<SuggestedOrderPage> createState() => _SuggestedOrderPageState();
}

class _SuggestedOrderPageState extends State<SuggestedOrderPage> {
  final pedidoSugeridoViewModel = Get.find<SuggestedOrderViewModel>();
  final prefs = Preferencias();
  @override
  void initState() {
    pedidoSugeridoViewModel.tabActual.value = 0;
    if (prefs.usurioLogin == -1) {
      pedidoSugeridoViewModel.initController();
      Future.delayed(Duration(seconds: 0)).then((value) {
        alertCustom(context);
      });
    }
    validarVersionActual(context);
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('SuggestedOrderPage');
    //UXCam: Llamamos el evento selectFooter
    UxcamTagueo().selectFooter('Pedido Sugerido');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = Colors.yellow;
    return Obx(() => DefaultTabController(
          length: pedidoSugeridoViewModel.titulosSeccion.length,
          child: Scaffold(
            backgroundColor: ConstantesColores.color_fondo_gris,
            body: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  children: [
                    TabBar(
                        controller: pedidoSugeridoViewModel.tabController,
                        labelPadding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 15),
                        indicatorColor: Colors.transparent,
                        unselectedLabelColor: Colors.black,
                        splashFactory: NoSplash.splashFactory,
                        onTap: (index) {
                          //UXCam: Llamamos el evento selectSectionPedidoSugerido
                          UxcamTagueo().selectSectionPedidoSugerido(
                              pedidoSugeridoViewModel.titulosSeccion[index]);
                          pedidoSugeridoViewModel.cambiarTab(index);
                        },
                        tabs: List<Widget>.generate(
                            pedidoSugeridoViewModel.titulosSeccion.length,
                            (index) {
                          return Tab(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              height: 50,
                              decoration: BoxDecoration(
                                color:
                                    pedidoSugeridoViewModel.tabActual.value ==
                                            index
                                        ? selectedColor
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  pedidoSugeridoViewModel.titulosSeccion[index],
                                  style: TextStyle(
                                      color: ConstantesColores.azul_precio,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        })),
                    Expanded(
                      child: PageView(
                        controller: pedidoSugeridoViewModel.pageController,
                        onPageChanged: (index) {
                          pedidoSugeridoViewModel.cambiarTab(index);
                        },
                        children: [
                          BodyPedidoSugerido(
                              controller: pedidoSugeridoViewModel),
                          MyListsPage()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
