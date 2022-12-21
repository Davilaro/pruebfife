import 'package:emart/_pideky/domain/estadistica/interface/i_estadistica_repository.dart';
import 'package:emart/_pideky/domain/estadistica/model/estadistica.dart';

class EstadisticaService {
  final IEstadisticaRepository estadisticaRepository;

  EstadisticaService(this.estadisticaRepository);

  Future<List<Estadistica>> consultarTopMarcas() async =>
      await estadisticaRepository.consultarTopMarcas();

  Future<List<Estadistica>> consultarTopSubCategorias() async =>
      await estadisticaRepository.consultarTopSubCategorias();

  Future<List<Estadistica>> consultarTopProductos() async =>
      await estadisticaRepository.consultarTopProductos();
}
