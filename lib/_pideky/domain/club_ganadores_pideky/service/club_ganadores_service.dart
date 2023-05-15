import 'package:emart/_pideky/domain/club_ganadores_pideky/interface/I_club_ganadores_repository.dart';
import 'package:emart/_pideky/domain/club_ganadores_pideky/model/imagen_premios_model.dart';
import 'package:emart/_pideky/domain/club_ganadores_pideky/model/puntos_obtenidos.dart';

class ClubGandoresService {
  final IClubGanadoresRepository clubGanadoresRepository;

  ClubGandoresService(this.clubGanadoresRepository);

  Future<List<ImagenPremios>> consultarImagenPremios() {
    return clubGanadoresRepository.cosultarImagenPremios();
  }

  Future<List<PuntosObtenidos>> consultarPuntos() {
    return clubGanadoresRepository.consultarPuntos();
  }
}
