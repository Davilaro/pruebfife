import 'package:emart/_pideky/domain/compra_vende_gana/interface/compra_vende_gana_interface.dart';
import 'package:emart/_pideky/domain/compra_vende_gana/model/compra_vende_gana_model.dart';

class CompraVendeGanaService {

  final CompraVendeGanaInterface _compraVendeGanaInterface;

  CompraVendeGanaService(this._compraVendeGanaInterface);

  Future<List<CompraVendeGanaModel?>> getCompraVendeGana() async {
    return await _compraVendeGanaInterface.getCompraVendeGana();
  }
}