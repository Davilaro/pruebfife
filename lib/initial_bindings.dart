import 'package:emart/_pideky/presentation/mi_negocio/view_model/mi_negocio_view_model.dart';
import 'package:emart/_pideky/presentation/mis_estadisticas/view_model/mis_estadisticas_view_model.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    MiNegocioViewModel.findOrInitialize;
    MisEstadisticasViewModel.findOrInitialize;
  }
}
