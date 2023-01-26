import 'package:emart/_pideky/domain/estadistica/model/estadistica.dart';

abstract class IEstadisticaRepository {
  Future<List<Estadistica>> consultarTopMarcas();
  Future<List<Estadistica>> consultarTopSubCategorias();
  Future<List<Estadistica>> consultarTopProductos();
}
