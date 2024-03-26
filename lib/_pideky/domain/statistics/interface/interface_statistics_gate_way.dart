import 'package:emart/_pideky/domain/statistics/model/estadistica.dart';

abstract class InterfaceStatisticsGateWay {
  Future<List<Estadistica>> consultarTopMarcas();
  Future<List<Estadistica>> consultarTopSubCategorias();
  Future<List<Estadistica>> consultarTopProductos();
}
