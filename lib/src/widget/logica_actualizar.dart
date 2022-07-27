import 'package:emart/src/provider/crear_file.dart';

import '../pages/login/login.dart';

class LogicaActualizar {
  Future<void> actualizarDB() async {
    var cargo = false;
    if (prefs.usurioLogin == -1) {
      cargo = await AppUtil.appUtil.downloadZip('1006120026', prefs.codCliente,
          '10360653', '10426885', '10847893', true);
      await AppUtil.appUtil.abrirBases();
    } else {
      cargo = await AppUtil.appUtil.downloadZip(
          prefs.usurioLoginCedula,
          prefs.codCliente,
          prefs.codigonutresa,
          prefs.codigozenu,
          prefs.codigomeals,
          false);
      await AppUtil.appUtil.abrirBases();
    }
  }
}
