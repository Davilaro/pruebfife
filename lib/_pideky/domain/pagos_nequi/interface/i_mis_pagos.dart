import 'package:emart/_pideky/domain/pagos_nequi/model/pagos_nequi_model.dart';

abstract class IMisPagos {
  Future<List<PagosNequiModel>> consultarPagos();
}
