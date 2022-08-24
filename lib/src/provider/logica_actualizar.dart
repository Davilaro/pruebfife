import 'package:emart/src/provider/crear_file.dart';

import '../pages/login/login.dart';

class LogicaActualizar {
  Future<void> actualizarDB() async {
    if (prefs.usurioLogin == null || prefs.usurioLogin == -1) {
      await AppUtil.appUtil.downloadZip('1006120026',
          prefs.codCliente, '10360653', '10426885', '10847893', '', true);
    } else {
      await AppUtil.appUtil.downloadZip(
          prefs.usurioLoginCedula,
          prefs.codCliente,
          prefs.codigonutresa,
          prefs.codigozenu,
          prefs.codigomeals,
          prefs.codigopadrepideky,
          false);
    }
    await AppUtil.appUtil.abrirBases();
  }

}
