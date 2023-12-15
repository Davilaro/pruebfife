import 'dart:async';
import 'package:emart/_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_view_model.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/pages/catalogo/view_model/botones_proveedores_vm.dart';
import 'package:emart/src/pages/principal_page/tab_opciones.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/widget/alerta_actualizar.dart';
import 'package:emart/src/provider/logica_actualizar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../_pideky/presentation/mis_pagos_nequi/view_model/mis_pagos_nequi_view_model.dart';

class BotonActualizar extends StatefulWidget {
  @override
  State<BotonActualizar> createState() => _BotonActualizarState();
}

RxBool isActualizando = false.obs;
final productViewModel = Get.find<ProductoViewModel>();

class _BotonActualizarState extends State<BotonActualizar> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OpcionesBard>(context, listen: false);
    final cargoConfirmar = Get.find<ControlBaseDatos>();
    final prefs = Preferencias();
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
    OpcionesBard provider, BuildContext context, dynamic cargoConfirmar) async {
  final botonesController = Get.find<BotonesProveedoresVm>();
  final controllerPedidoSugerido = Get.find<PedidoSugeridoViewModel>();
  final controllerNequi = Get.find<MisPagosNequiViewModel>();
  final productViewModel = Get.find<ProductoViewModel>();
  isActualizando.value = true;
  if (isActualizando.value) {
    AlertaActualizar().mostrarAlertaActualizar(context, true);
  }
  await LogicaActualizar().actualizarDB();
  isActualizando.value = false;
  controllerPedidoSugerido.initController();
  controllerNequi.initData();
  if (isActualizando.value == false) {
    Navigator.pop(context);
    AlertaActualizar().mostrarAlertaActualizar(context, false);
    await new Future.delayed(new Duration(seconds: 1), () {
      Navigator.pop(context);
      //pop dialog
    });

    productViewModel.cargarCondicionEntrega();
    await botonesController.cargarListaProovedor();
    botonesController.listaFabricantesBloqueados.isNotEmpty
        ? null
        : productViewModel.eliminarBDTemporal();
    provider.selectOptionMenu = 0;
    Get.offAll(() => TabOpciones());
  }
}
