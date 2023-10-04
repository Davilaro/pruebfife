import 'package:emart/_pideky/domain/marca/model/marca.dart';

abstract class IMarcaResporsitory {
  Future<List<Marca>> getAllMarcas();
  Future<List<Marca>> consultarMarcas(String buscar);
}
