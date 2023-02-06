import 'package:emart/src/provider/crear_file.dart';

import '../pages/login/login.dart';

class LogicaActualizar {
  Future<void> actualizarDB() async {
    if (prefs.usurioLogin == null || prefs.usurioLogin == -1) {
      await AppUtil.appUtil.downloadZip('1006120026', prefs.codCliente,
          prefs.sucursal, '10360653', '10426885', '10847893', '', true);
    } else {
      http: //186.147.143.44/SyncPidekySqlitePrd/CrearDB.aspx?nit=1006120026&cliente=10426885&clientenutresa=10360653&clientezenu=10426885&clientemeals=10847893&codigopadrepideky=
      await AppUtil.appUtil.downloadZip(
          prefs.usurioLoginCedula,
          prefs.codCliente,
          prefs.sucursal,
          prefs.codigonutresa,
          prefs.codigozenu,
          prefs.codigomeals,
          prefs.codigopadrepideky,
          false);
    }
    await AppUtil.appUtil.abrirBases();
  }
}
