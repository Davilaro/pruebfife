import 'package:emart/_pideky/domain/compra_vende_gana/model/compra_vende_gana_model.dart';

abstract class CompraVendeGanaInterface {
  Future<List<CompraVendeGanaModel?>> getCompraVendeGana();
}