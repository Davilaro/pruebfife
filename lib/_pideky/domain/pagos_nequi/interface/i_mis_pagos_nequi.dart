import 'package:emart/_pideky/domain/pagos_nequi/model/pagos_nequi_model.dart';

abstract class IMisPagosNequi {
  Future<List<PagosNequiModel>> consultarPagosNequi();
}
