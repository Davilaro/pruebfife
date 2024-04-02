import 'package:emart/_pideky/domain/winners_club_pideky/interface/interface_winner_club_gate_way.dart';
import 'package:emart/_pideky/domain/winners_club_pideky/model/imagen_premios_model.dart';
import 'package:emart/_pideky/domain/winners_club_pideky/model/puntos_obtenidos.dart';

class WinnersClubUseCases {
  final InterfaceWinnersClubGateWay clubGanadoresRepository;

  WinnersClubUseCases(this.clubGanadoresRepository);

  Future<List<ImagenPremios>> consultarImagenPremios() {
    return clubGanadoresRepository.cosultarImagenPremios();
  }

  Future<List<PuntosObtenidos>> consultarPuntos() {
    return clubGanadoresRepository.consultarPuntos();
  }
}
