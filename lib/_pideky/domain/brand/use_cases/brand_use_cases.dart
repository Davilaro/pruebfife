import 'package:emart/_pideky/domain/brand/interface/interface_marca_gate_way.dart';
import 'package:emart/_pideky/domain/brand/model/brand.dart';

class BrandUseCases {
  final InterfaceBrandGateWay marcaRepository;

  BrandUseCases(this.marcaRepository);

  Future<List<Brand>> getAllMarcas() async =>
      await marcaRepository.getAllMarcas();
  Future<List<Brand>> consultaMarcas(String buscar) async =>
      await marcaRepository.consultarMarcas(buscar);

}