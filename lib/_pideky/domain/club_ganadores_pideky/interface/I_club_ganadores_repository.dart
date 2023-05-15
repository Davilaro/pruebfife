import 'package:emart/_pideky/domain/club_ganadores_pideky/model/imagen_premios_model.dart';
import 'package:emart/_pideky/domain/club_ganadores_pideky/model/puntos_obtenidos.dart';

abstract class IClubGanadoresRepository {
  Future<List<ImagenPremios>> cosultarImagenPremios();
  Future<List<PuntosObtenidos>> consultarPuntos();
}
