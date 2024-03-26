import 'package:emart/_pideky/domain/brand/model/brand.dart';

abstract class InterfaceBrandGateWay {
  Future<List<Brand>> getAllMarcas();
  Future<List<Brand>> consultarMarcas(String buscar);
}
