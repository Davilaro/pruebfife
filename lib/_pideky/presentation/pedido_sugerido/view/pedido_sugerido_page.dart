import 'package:emart/src/pages/pedido_rapido/pedido_rapido.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';

import 'package:get/get.dart';

import 'package:emart/_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_view_model.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import '../../../../src/utils/util.dart';
import 'widgets/body_pedido_sugerido.dart';

class PedidoSugeridoPage extends StatefulWidget {
  const PedidoSugeridoPage({Key? key}) : super(key: key);

  @override
  State<PedidoSugeridoPage> createState() => _PedidoSugeridoPageState();
}

class _PedidoSugeridoPageState extends State<PedidoSugeridoPage> {
  final pedidoSugeridoViewModel = Get.find<PedidoSugeridoViewModel>();
  final prefs = Preferencias();
  @override
  void initState() {
    if (prefs.usurioLogin == -1) {
      Future.delayed(Duration(seconds: 0)).then((value) {
        alertCustom(context);
      });
    }
    validarVersionActual(context);
    //Se define el nombre de la pantalla para UXCAM
    FlutterUxcam.tagScreenName('SuggestedOrderPage');
    //UXCam: Llamamos el evento selectFooter
    UxcamTagueo().selectFooter('Pedido Sugerido');
    if (prefs.usurioLogin == -1) {
      pedidoSugeridoViewModel.initController();
    }

    super.initState();
  }

  @override
  void dispose() {
    pedidoSugeridoViewModel.tabActual.value = 0;
    super.dispose();
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
                          PedidoRapido()
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
