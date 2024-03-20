import 'package:emart/_pideky/domain/winners_club_pideky/model/imagen_premios_model.dart';
import 'package:emart/_pideky/domain/winners_club_pideky/model/puntos_obtenidos.dart';

abstract class InterfaceWinnersClubGateWay {
  Future<List<ImagenPremios>> cosultarImagenPremios();
  Future<List<PuntosObtenidos>> consultarPuntos();
}
