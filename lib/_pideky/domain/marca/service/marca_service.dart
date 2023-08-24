import 'package:emart/_pideky/domain/marca/interface/i_marca_repository.dart';
import 'package:emart/_pideky/domain/marca/model/marca.dart';

class MarcaService {
  final IMarcaResporsitory marcaRepository;

  MarcaService(this.marcaRepository);

  Future<List<Marca>> getAllMarcas() async =>
      await marcaRepository.getAllMarcas();

}