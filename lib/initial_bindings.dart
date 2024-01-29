import 'package:emart/_pideky/presentation/buscador_general/view_model/search_fuzzy_view_model.dart';
import 'package:emart/_pideky/presentation/club_ganadores/view_mdel/club_ganadores_view_model.dart';
import 'package:emart/_pideky/presentation/compra_vende_gana/view_model/compra_vende_gana_view_model.dart';
import 'package:emart/_pideky/presentation/mi_negocio/view_model/mi_negocio_view_model.dart';
import 'package:emart/_pideky/presentation/mis_estadisticas/view_model/mis_estadisticas_view_model.dart';
import 'package:emart/_pideky/presentation/mis_listas/view_model/mis_listas_view_model.dart';
import 'package:emart/_pideky/presentation/mis_pagos_nequi/view_model/mis_pagos_nequi_view_model.dart';
import 'package:emart/_pideky/presentation/mis_pedidos/view_model/mis_pedidos_view_model.dart';
import 'package:emart/_pideky/presentation/mis_pedidos/view_model/transito_view_model.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_view_model.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/controllers/controller_multimedia.dart';
import 'package:emart/src/controllers/notifiactions_controllers.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:emart/src/pages/catalogo/view_model/botones_proveedores_vm.dart';
import 'package:emart/src/pages/pedido_rapido/view_model/repetir_orden_view_model.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    ControllerMultimedia.findOrInitialize;
    ControlBaseDatos.findOrInitialize;
    MisPedidosViewModel.findOrInitialize;
    TransitoViewModel.findOrInitialize;
    MiNegocioViewModel.findOrInitialize;
    MisEstadisticasViewModel.findOrInitialize;
    PedidoSugeridoViewModel.findOrInitialize;
    MisPagosNequiViewModel.findOrInitialize;
    ProductoViewModel.findOrInitialize;
    RepetirOrdenViewModel.findOrInitialize;
    ClubGanadoresViewModel.findOrInitialize;
    NotificationsSlideUpAndPushInUpControllers.findOrInitialize;
    ValidationForms.findOrInitialize;
    BotonesProveedoresVm.findOrInitialize;
    SearchFuzzyViewModel.findOrInitialize;
    MyListsViewModel.findOrInitialize;
    CompraVendeGanaViewModel.findOrInitialize;
  }
}
