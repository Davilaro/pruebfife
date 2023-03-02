import 'dart:ui';

import 'package:emart/generated/l10n.dart';
import 'package:emart/src/provider/crear_file.dart';
import 'package:emart/src/provider/db_provider_helper.dart';

class LogicaActualizar {
  Future<void> actualizarDB() async {
    if (prefs.usurioLogin == null || prefs.usurioLogin == -1) {
      // await AppUtil.appUtil.downloadZip('1006120026', prefs.codCliente,
      //     prefs.sucursal, '10360653', '10426885', '10847893', '', true);
      await AppUtil.appUtil.downloadZip('1006120026', prefs.sucursal, true);
      await AppUtil.appUtil.abrirBases();
    } else {
      http: //186.147.143.44/SyncPidekySqlitePrd/CrearDB.aspx?nit=1006120026&cliente=10426885&clientenutresa=10360653&clientezenu=10426885&clientemeals=10847893&codigopadrepideky=
      // await AppUtil.appUtil.downloadZip(
      //     prefs.usurioLoginCedula,
      //     prefs.codCliente,
      //     prefs.sucursal,
      //     prefs.codigonutresa,
      //     prefs.codigozenu,
      //     prefs.codigomeals,
      //     prefs.codigopadrepideky,
      //     false);
      await AppUtil.appUtil
          .downloadZip(prefs.usurioLoginCedula, prefs.sucursal, false);
      await AppUtil.appUtil.abrirBases();
      await _cargarDataUsuario();
    }
  }

  _cargarDataUsuario() async {
    List datosCliente = await DBProviderHelper.db.consultarDatosCliente();

    prefs.usuarioRazonSocial = datosCliente[0].razonsocial;
    prefs.codCliente = datosCliente[0].codigo;
    prefs.codTienda = 'nutresa';
    prefs.codigonutresa = datosCliente[0].codigonutresa;
    prefs.codigozenu = datosCliente[0].codigozenu;
    prefs.codigomeals = datosCliente[0].codigomeals;
    prefs.codigopozuelo = datosCliente[0].codigopozuelo;
    prefs.codigoalpina = datosCliente[0].codigoalpina;
    prefs.paisUsuario = datosCliente[0].pais;
    prefs.sucursal = prefs.sucursal;
    prefs.ciudad = datosCliente[0].ciudad;

    S.load(datosCliente[0].pais == 'CR'
        ? Locale('es', datosCliente[0].pais)
        : datosCliente[0].pais != 'CO'
            ? Locale('es', 'CO')
            : Locale('es', 'CO'));
    print('vamos bien pais ${datosCliente[0].pais}');
  }
}
