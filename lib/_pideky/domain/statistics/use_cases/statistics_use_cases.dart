import 'package:emart/_pideky/domain/statistics/interface/interface_statistics_gate_way.dart';
import 'package:emart/_pideky/domain/statistics/model/estadistica.dart';

class StatisticsUseCases {
  final InterfaceStatisticsGateWay estadisticaRepository;

  StatisticsUseCases(this.estadisticaRepository);

  Future<List<Estadistica>> consultarTopMarcas() async =>
      await estadisticaRepository.consultarTopMarcas();

  Future<List<Estadistica>> consultarTopSubCategorias() async =>
      await estadisticaRepository.consultarTopSubCategorias();

  Future<List<Estadistica>> consultarTopProductos() async =>
      await estadisticaRepository.consultarTopProductos();
}
