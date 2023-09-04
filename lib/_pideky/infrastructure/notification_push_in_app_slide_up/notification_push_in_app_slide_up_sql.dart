import 'package:emart/_pideky/domain/notification_push_in_app_slide_up/interface/i_notification_push_in_app_slide_up_repository.dart';
import 'package:emart/src/provider/db_provider.dart';
import '../../domain/notification_push_in_app_slide_up/model/notification_push_in_app_slide_up.dart';

class NotificationPushInUpAndSlideUpSql
    implements INotificationPushInAppSlideUpRepository {
  final dataBase = DBProvider.db;
  @override
  Future<List<NotificationPushInAppSlideUpModel>> consultNotificationPushInApp(
      String ubicacion) async {
    final db = await dataBase.baseAbierta;

    try {
      var sql = await db.rawQuery(
          """
      select p.Link as imageUrl, p.Ubicacion as ubicacion, p.CategoriaUbicacion as categoriaUbicacion, 
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
      var sql = await db.rawQuery(
          """
      select s.Link as imageUrl, s.Texto as descripcion, s.Ubicacion as ubicacion, s.CategoriaUbicacion as categoriaUbicacion, 
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
}
