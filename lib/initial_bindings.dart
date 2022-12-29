import 'package:emart/_pideky/presentation/mi_negocio/view_model/mi_negocio_view_model.dart';
import 'package:emart/_pideky/presentation/mis_estadisticas/view_model/mis_estadisticas_view_model.dart';
import 'package:emart/_pideky/presentation/mis_pagos_nequi/view_model/mis_pagos_nequi_controller.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_controller.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    MiNegocioViewModel.findOrInitialize;
    MisEstadisticasViewModel.findOrInitialize;
    MisPagosNequiController.findOrInitialize;
    PedidoSugeridoController.findOrInitialize;
  }
}
