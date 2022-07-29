import 'package:emart/src/provider/crear_file.dart';

import '../pages/login/login.dart';

class LogicaActualizar {
  Future<void> actualizarDB() async {
    var cargo = await AppUtil.appUtil.downloadZip(
        prefs.usurioLoginCedula,
        prefs.codCliente,
        prefs.codigonutresa,
        prefs.codigozenu,
        prefs.codigomeals,
        false);
    await AppUtil.appUtil.abrirBases();
  }
}
