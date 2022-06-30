import 'package:permission_handler/permission_handler.dart';

class Permisos {
  static final Permisos permisos = Permisos._();
  Permisos._();

  Future solicitarPermisos() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      //Permission.storage,
      Permission.notification,
      //Permission.camera,
    ].request();
  }
}
