import 'package:emart/_pideky/domain/notification_push_in_app_slide_up/interface/i_notification_push_in_app_slide_up_repository.dart';
import 'package:emart/src/provider/db_provider.dart';
import '../../domain/notification_push_in_app_slide_up/model/notification_push_in_app_slide_up.dart';

class NotificationPushInUpAndSlideUpSql
    implements INotificationPushInAppSlideUpRepository {
  final dataBase = DBProvider.db;
  @override
  Future<List<NotificationPushInAppSlideUpModel>>
      consultNotificationPushInApp() async {
    throw UnimplementedError();
  }

  @override
  Future<List<NotificationPushInAppSlideUpModel>>
      consultNotificationsSlideUp() async {
    final db = await dataBase.baseAbierta;

    try {
      var sql = await db.rawQuery(
          """
      select s.Link as imageUrl, s.Texto as descripcion, s.Ubicacion as ubicacion, s.CategoriaUbicacion as categoriaUbicacion, 
      s.SubCategoriaUbicacion as subCategoriaUbicacion, s.Redireccion as redireccion, s.CategoriaRedireccion as categoriaRedireccion,
      s.SubCategoriaRedireccion as subCategoriaRedireccion  from SlideUp s
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
