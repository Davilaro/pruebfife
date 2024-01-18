import 'dart:convert';

import 'package:emart/_pideky/domain/notification_push_in_app_slide_up/interface/i_notification_push_in_app_slide_up_repository.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/utils/util.dart';
import '../../domain/notification_push_in_app_slide_up/model/notification_push_in_app_slide_up.dart';
import 'package:http/http.dart' as http;

class NotificationPushInUpAndSlideUpSql
    implements INotificationPushInAppSlideUpRepository {
  final dataBase = DBProvider.db;
  final prefs = Preferencias();
  @override
  Future<List<NotificationPushInAppSlideUpModel>> consultNotificationPushInApp(
      String ubicacion) async {
    final db = await dataBase.baseAbierta;

    try {
      var sql = await db.rawQuery("""
      select p.Link as imageUrl, p.Ubicacion as ubicacion, p.CategoriaUbicacion as categoriaUbicacion, p.Tiempo as tiempo, 
      p.SubCategoriaUbicacion as subCategoriaUbicacion, p.Redireccion as redireccion, p.CategoriaRedireccion as categoriaRedireccion,
      p.SubCategoriaRedireccion as subCategoriaRedireccion  from PushInApp p where p.Ubicacion = "$ubicacion" limit 1
      """);
      return sql.isNotEmpty
          ? sql
              .map((e) => NotificationPushInAppSlideUpModel.fromJson(e))
              .toList()
          : [];
    } catch (e) {
      print('----Error consulta notificacines $e');
      return [];
    }
  }

  @override
  Future<List<NotificationPushInAppSlideUpModel>> consultNotificationsSlideUp(
      String ubicacion) async {
    final db = await dataBase.baseAbierta;

    try {
      var sql = await db.rawQuery("""
      select s.Link as imageUrl, s.Texto as descripcion, s.Ubicacion as ubicacion, s.CategoriaUbicacion as categoriaUbicacion, 
      s.Tiempo as tiempo,
      s.SubCategoriaUbicacion as subCategoriaUbicacion, s.Redireccion as redireccion, s.CategoriaRedireccion as categoriaRedireccion,
      s.SubCategoriaRedireccion as subCategoriaRedireccion  from SlideUp s where s.Ubicacion = "$ubicacion" limit 1
      """);
      return sql.isNotEmpty
          ? sql
              .map((e) => NotificationPushInAppSlideUpModel.fromJson(e))
              .toList()
          : [];
    } catch (e) {
      print('----Error consulta notificacines $e');
      return [];
    }
  }

  @override
  Future<List<NotificationPushInAppSlideUpModel>> getAutomaticSlideUp() async {
    final db = await dataBase.baseAbierta;

    try {
      var sql = await db.rawQuery("""
  select s.Link as imageUrl, s.Texto as descripcion, s.Tiempo as tiempo ,s.Negocio as negocio  from SlideUp s where s.TipoSlide = 1 
          """);
      return sql.isNotEmpty
          ? sql
              .map((e) => NotificationPushInAppSlideUpModel.fromJson(e))
              .toList()
          : [];
    } catch (e) {
      print('----Error consulta slide up automatica $e');
      return [];
    }
  }

  @override
  Future<int> showSlideUpValidation(String negocio) async {
    try {
      final url =
          Uri.parse(Constantes().urlPrincipal + 'SlideAutomatizada/Read');
      final request = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode({
            "CCUP": prefs.codigoUnicoPideky,
            "Sucursal": prefs.sucursal,
            "Negocio": negocio
          }));
      final decodedData = json.decode(request.body);
      if (request.statusCode == 200) {
        return toInt(decodedData);
      } else {
        throw Exception('Error al consultar slide up automatica');
      }
    } catch (e) {
      print('----Error consulta slide up automatica $e');
      return -1;
    }
  }

  @override
  Future sendShowedSlideUp(String negocio) async {
    try {
      final url =
          Uri.parse(Constantes().urlPrincipal + 'SlideAutomatizada/Create');
      final request = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode({
            "CCUP": prefs.codigoUnicoPideky,
            "Sucursal": prefs.sucursal,
            "Negocio": negocio
          }));
      final decodedData = json.decode(request.body);
      if (request.statusCode == 200 && decodedData.toLowerCase() == 'ok') {
        return true;
      } else {
        throw Exception('Error al consultar slide up automatica');
      }
    } catch (e) {
      print('----Error consulta slide up automatica $e');
      return false;
    }
  }
}
