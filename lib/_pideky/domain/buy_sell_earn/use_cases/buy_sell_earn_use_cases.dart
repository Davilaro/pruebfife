import 'package:emart/_pideky/domain/buy_sell_earn/interface/interface_buy_sell_earn_gate_way.dart';
import 'package:emart/_pideky/infrastructure/buy_sell_earn/buy_sell_earn_service.dart';

class CompraVendeGanaService {
  final InterfaceBuySellEarnGateWay _iCompraVendeGana =
      ComprarVendeGanaRespository();

  Future getCupons() {
    return _iCompraVendeGana.getCupons();
  }
}
