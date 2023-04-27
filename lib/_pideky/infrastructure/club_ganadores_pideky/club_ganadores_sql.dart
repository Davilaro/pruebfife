import 'package:emart/_pideky/domain/club_ganadores_pideky/interface/I_club_ganadores_repository.dart';
import 'package:emart/_pideky/domain/club_ganadores_pideky/model/imagen_premios_model.dart';
import 'package:emart/_pideky/domain/club_ganadores_pideky/model/puntos_obtenidos.dart';
import 'package:emart/src/provider/db_provider_helper.dart';

class ClubGanadoresPidekySql implements IClubGanadoresRepository {
  @override
  Future<List<ImagenPremios>> cosultarImagenPremios() async {
    final db = await DBProviderHelper.db.baseAbierta;
    try {
      final sql = await db.rawQuery("""
    select url, orden from ImagenFidelizacion ORDER BY orden ASC;
    """);
      return sql.map((e) => ImagenPremios.fromJson(e)).toList();
    } catch (e) {
      print('-- Algo salio mal en la consulta de la imagen $e');
      return [];
    }
  }

  @override
  Future<List<PuntosObtenidos>> consultarPuntos() async {
    final db = await DBProviderHelper.db.baseAbierta;
    try {
      final sql = await db.rawQuery("""
    select PuntosDisponibles from PuntosFidelizacion;
    """);
      return sql.map((e) => PuntosObtenidos.fromJson(e)).toList();
    } catch (e) {
      print("-- algo salio mal en la consulta de los puntos $e");
      return [];
    }
  }
}
