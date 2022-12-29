import 'dart:async';
import 'package:emart/_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_controller.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/notificaciones/push_notification.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/widget/alerta_actualizar.dart';
import 'package:emart/src/provider/logica_actualizar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../_pideky/domain/pagos_nequi/service/pagos_nequi_service.dart';
import '../../_pideky/domain/pedido_sugerdio/service/pedido_sugerido.dart';
import '../../_pideky/infrastructure/mis_pagos_nequi/mis_pagos_nequi_sqlite.dart';
import '../../_pideky/infrastructure/pedido_sugerdio/pedido_sugerido_query.dart';
import '../../_pideky/presentation/mis_pagos_nequi/view_model/mis_pagos_nequi_controller.dart';

class BotonActualizar extends StatefulWidget {
  @override
  State<BotonActualizar> createState() => _BotonActualizarState();
}

RxBool isActualizando = false.obs;

class _BotonActualizarState extends State<BotonActualizar> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OpcionesBard>(context, listen: false);
    final cargoConfirmar = Get.find<ControlBaseDatos>();
    return Visibility(
      visible: prefs.usurioLogin == 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 0),
        child: IconButton(
            onPressed: () async {
              await actualizarPagina(provider, context, cargoConfirmar);
            },
            icon: Icon(
              Icons.refresh_sharp,
              color: ConstantesColores.azul_precio,
              size: Get.height * 0.04,
            )),
      ),
    );
  }
}

Future<void> actualizarPagina(
    dynamic provider, BuildContext context, dynamic cargoConfirmar) async {
  final controller = Get.find<PedidoSugeridoController>();
  final controllerNequi = Get.find<MisPagosNequiController>();
  isActualizando.value = true;
  if (isActualizando.value) {
    AlertaActualizar().mostrarAlertaActualizar(context, true);
  }
  await LogicaActualizar().actualizarDB();
  isActualizando.value = false;
  controller.listaProductosPorFabricante.clear();
  controller.initController();
  controllerNequi.listaPagosPendientes.clear();
  controllerNequi.listaPagosRealizados.clear();
  controllerNequi.initData();
  if (isActualizando.value == false) {
    Navigator.pop(context);
    AlertaActualizar().mostrarAlertaActualizar(context, false);
    await new Future.delayed(new Duration(seconds: 1), () {
      Navigator.pop(context);
      //pop dialog
    });
    if (provider.selectOptionMenu == 1) {
      print("entro");
      cargoConfirmar.tabController.index = cargoConfirmar.cambioTab.value;
      cargoConfirmar.cargoBaseDatos(cargoConfirmar.cambioTab.value);
      provider.selectOptionMenu = 1;
      provider.setIsLocal = 0;
    }
    Navigator.pushReplacementNamed(
      context,
      'tab_opciones',
    ).timeout(Duration(seconds: 3));
  }
}
