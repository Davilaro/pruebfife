import 'package:emart/_pideky/domain/compra_vende_gana/interface/i_compra_vende_gana.dart';
import 'package:emart/_pideky/infrastructure/compra_vende_gana/compra_vende_gana_repository.dart';

class CompraVendeGanaService {
  final InterfaceCompraVendeGana _iCompraVendeGana =
      ComprarVendeGanaRespository();

  Future getCupons() {
    return _iCompraVendeGana.getCupons();
  }
}
