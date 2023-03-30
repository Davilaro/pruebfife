import 'package:emart/_pideky/domain/mis_pedidos/interface/i_mis_pedidos_repository.dart';
import 'package:emart/_pideky/domain/mis_pedidos/model/historico.dart';
import 'package:emart/_pideky/domain/mis_pedidos/model/seguimiento_pedido.dart';
import 'package:emart/src/modelos/pedido.dart';
import 'package:emart/src/provider/db_provider_helper.dart';

class MisPedidosQuery extends IMisPedidosRepository {
  Future<List<Historico>> consultarHistoricos(
      String filtro, String fechaInicio, String fechaFin) async {
    var fechaInicioFor = fechaInicio;
    var fechaFinFor = fechaFin;
    var isFormat = false;

    if (fechaInicio != '-1' && fechaFin != '-1') {
      var fechaInicioF = DateTime.parse(fechaInicio);
      var fechaFinF = DateTime.parse(fechaFin);

      fechaInicioFor =
          '${fechaInicioF.day.toString().length > 1 ? fechaInicioF.day : '0${fechaInicioF.day}'}/${fechaInicioF.month.toString().length > 1 ? fechaInicioF.month : '0${fechaInicioF.month}'}/${fechaInicioF.year}';

      fechaFinFor =
          '${fechaFinF.day.toString().length > 1 ? fechaFinF.day : '0${fechaFinF.day}'}/${fechaFinF.month.toString().length > 1 ? fechaFinF.month : '0${fechaFinF.month}'}/${fechaFinF.year}';
      isFormat = true;
    } else {
      isFormat = false;
    }

    final db = await DBProviderHelper.db.baseAbierta;

    try {
      String query =
          '''   SELECT DISTINCT NumeroDoc, MAX(substr(fechatrans, 1, 2) || '/' || substr(fechatrans, 4, 2) || '/' || substr(fechatrans, 7, 4)) as fechatrans, MAX(fabricante)fabricante,
       MAX(ordencompra)ordencompra, sum(precio) as precio, MAX(substr(fechatrans,11, 6)) as horatrans FROM Historico
      WHERE NumeroDoc LIKE CASE WHEN '$filtro'='-1' THEN NumeroDoc ELSE '%$filtro%' END
      AND
      substr(fechatrans, 7, 4) || '/' || substr(fechatrans, 4, 2) || '/' || substr(fechatrans, 1, 2)
      >= CASE WHEN ${isFormat == true ? ''' substr('$fechaInicioFor', 7, 4) || '/' || substr('$fechaInicioFor', 4, 2) || '/' || substr('$fechaInicioFor', 1, 2) ''' : "'-1'"} ='-1'
      THEN substr(fechatrans, 7, 4) || '/' || substr(fechatrans, 4, 2) || '/' || substr(fechatrans, 1, 2)
      ELSE substr('$fechaInicioFor', 7, 4) || '/' || substr('$fechaInicioFor', 4, 2) || '/' || substr('$fechaInicioFor', 1, 2) END
      AND
      substr(fechatrans, 7, 4) || '/' || substr(fechatrans, 4, 2) || '/' || substr(fechatrans, 1, 2)
      <= CASE WHEN ${isFormat == true ? ''' substr('$fechaFinFor', 7, 4) || '/' || substr('$fechaFinFor', 4, 2) || '/' || substr('$fechaFinFor', 1, 2) ''' : "'-1'"} ='-1'
      THEN substr(fechatrans, 7, 4) || '/' || substr(fechatrans, 4, 2) || '/' || substr(fechatrans, 1, 2)
      ELSE substr('$fechaFinFor', 7, 4) || '/' || substr('$fechaFinFor', 4, 2) || '/' || substr('$fechaFinFor', 1, 2) END
      GROUP BY NumeroDoc
      ORDER BY cast(substr(fechatrans, 7, 4) || '/' || substr(fechatrans, 4, 2) || '/' || substr(fechatrans, 1, 2) as INT) DESC ''';
      // log(query);
      final sql = await db.rawQuery(query);
      return sql.map((e) => Historico.fromJson(e)).toList();
    } catch (e) {
      print('-----Error historico $e');
      return [];
    }
  }

  Future<List<Historico>> consultarGrupoHistorico(String numeroDoc) async {
    final db = await DBProviderHelper.db.baseAbierta;

    try {
      final sql = await db.rawQuery('''
        SELECT h.NumeroDoc, h.fabricante, h.ordencompra ordencompra, f.ico, sum(precio) as precio 
        from Historico h LEFT JOIN fabricante f ON h.fabricante = f.nombrecomercial 
        where NumeroDoc='$numeroDoc' GROUP BY fabricante
      ''');

      return sql.map((e) => Historico.fromJson(e)).toList();
    } catch (e) {
      print('-----Error grupo historico $e');
      return [];
    }
  }

  Future<List<Historico>> consultarDetalleGrupoHistorico(
      String numeroDoc, String fabricante) async {
    final db = await DBProviderHelper.db.baseAbierta;
    try {
      final query = '''
        SELECT NumeroDoc, codigoRef, nombreproducto , cantidad , fabricante, ordencompra, MAX(substr(fechatrans,11, 6)) as horatrans, 
        MAX(substr(fechatrans, 1, 2) || '/' || substr(fechatrans, 4, 2) || '/' || substr(fechatrans, 7, 4)) as fechatrans, 
        CAST(precio AS double) precio from Historico where NumeroDoc='$numeroDoc' 
        and fabricante ='$fabricante' GROUP BY codigoref 
      ''';
      final sql = await db.rawQuery(query);
      // log(query);
      return sql.map((e) => Historico.fromJson(e)).toList();
    } catch (e) {
      print('-----Error consultarDetalleGrupoHistorico $e');
      return [];
    }
  }

  Future<List<Historico>> consultarDetalleGrupo(
      String numeroDoc, String fabricante) async {
    final db = await DBProviderHelper.db.baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT max(h.nombreproducto)nombreproducto,sum(h.Cantidad)Cantidad,
       p.fabricante from Historico h inner join producto p on p.codigo=h.codigoref  
       where  h.NumeroDoc='$numeroDoc'  and  h.fabricante='$fabricante' 
       GROUP BY h.fabricante,h.codigoref
    ''');

      return sql.map((e) => Historico.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<SeguimientoPedido>> consultarSeguimientoPedido(
      String filtro, String fechaInicio, String fechaFin) async {
    var fechaInicioFor = fechaInicio;
    var fechaFinFor = fechaFin;
    var isFormat = false;

    if (fechaInicio != '-1' && fechaFin != '-1') {
      var fechaInicioF = DateTime.parse(fechaInicio);
      var fechaFinF = DateTime.parse(fechaFin);

      fechaInicioFor =
          '${fechaInicioF.day.toString().length > 1 ? fechaInicioF.day : '0${fechaInicioF.day}'}/${fechaInicioF.month.toString().length > 1 ? fechaInicioF.month : '0${fechaInicioF.month}'}/${fechaInicioF.year}';

      fechaFinFor =
          '${fechaFinF.day.toString().length > 1 ? fechaFinF.day : '0${fechaFinF.day}'}/${fechaFinF.month.toString().length > 1 ? fechaFinF.month : '0${fechaFinF.month}'}/${fechaFinF.year}';
      isFormat = true;
    }

    final db = await DBProviderHelper.db.baseAbierta;

    try {
      String query =
          '''   SELECT DISTINCT NumeroDoc, MAX(substr(fechaServidor, 1, 2) || '/' || substr(fechaServidor, 4, 2) || '/' || substr(fechaServidor, 7, 4)) as fechaServidor, MAX(proveedor) fabricante, 
            MAX(consecutivo) consecutivo, sum(precio) as precio, MAX(substr(fechaServidor,11, 6)) as horatrans FROM SeguimientoPedido 
            WHERE NumeroDoc LIKE CASE WHEN '$filtro'='-1' THEN NumeroDoc ELSE '%$filtro%' END
            AND
            substr(fechaServidor, 7, 4) || '/' || substr(fechaServidor, 4, 2) || '/' || substr(fechaServidor, 1, 2)
            >= CASE WHEN ${isFormat == true ? ''' substr('$fechaInicioFor', 7, 4) || '/' || substr('$fechaInicioFor', 4, 2) || '/' || substr('$fechaInicioFor', 1, 2) ''' : "'-1'"} ='-1'
            THEN substr(fechaServidor, 7, 4) || '/' || substr(fechaServidor, 4, 2) || '/' || substr(fechaServidor, 1, 2)
            ELSE substr('$fechaInicioFor', 7, 4) || '/' || substr('$fechaInicioFor', 4, 2) || '/' || substr('$fechaInicioFor', 1, 2) END
            AND
            substr(fechaServidor, 7, 4) || '/' || substr(fechaServidor, 4, 2) || '/' || substr(fechaServidor, 1, 2)
            <= CASE WHEN ${isFormat == true ? ''' substr('$fechaFinFor', 7, 4) || '/' || substr('$fechaFinFor', 4, 2) || '/' || substr('$fechaFinFor', 1, 2) ''' : "'-1'"} ='-1'
            THEN substr(fechaServidor, 7, 4) || '/' || substr(fechaServidor, 4, 2) || '/' || substr(fechaServidor, 1, 2)
            ELSE substr('$fechaFinFor', 7, 4) || '/' || substr('$fechaFinFor', 4, 2) || '/' || substr('$fechaFinFor', 1, 2) END
            GROUP BY NumeroDoc
            ORDER BY cast(substr(fechaServidor, 7, 4) || '/' || substr(fechaServidor, 4, 2) || '/' || substr(fechaServidor, 1, 2) as INT) DESC 
        ''';
      // log(query);
      final sql = await db.rawQuery(query);
      return sql.map((e) => SeguimientoPedido.fromJson(e)).toList();
    } catch (e) {
      print('-----Error SeguimientoPedido $e');
      return [];
    }
  }

  Future<List<SeguimientoPedido>> consultarGrupoSeguimientoPedido(
      String numeroDoc) async {
    final db = await DBProviderHelper.db.baseAbierta;

    try {
      String query = '''
        SELECT s.NumeroDoc, s.proveedor fabricante, s.consecutivo, f.ico, 
        MAX(substr(s.fechaServidor, 1, 2) || '/' || substr(s.fechaServidor, 4, 2) || '/' || substr(s.fechaServidor, 7, 4)) as fechaServidor, 
        MAX(substr(s.fechaServidor,11, 6)) as horatrans, sum(s.precio) as precio, s.estado     
        from SeguimientoPedido s LEFT JOIN fabricante f ON s.proveedor = f.empresa 
        where NumeroDoc='$numeroDoc' GROUP BY fabricante
      ''';
      final sql = await db.rawQuery(query);
      // log(query);
      return sql.map((e) => SeguimientoPedido.fromJson(e)).toList();
    } catch (e) {
      print('-----Error consultarGrupoSeguimientoPedido $e');
      return [];
    }
  }

  Future<void> guardarSeguimientoPedido(Pedido miPedido, String numDoc) async {
    final db = await DBProviderHelper.db.baseAbierta;

    try {
      DateTime now = new DateTime.now();
      var fechaActual = now.day.toString() +
          '/' +
          '${now.month.toString().length > 1 ? now.month : '0${now.month}'}' +
          '/' +
          now.year.toString() +
          ' ${now.hour}:${now.minute}:${now.second}';

      var query = '''
        INSERT INTO SeguimientoPedido VALUES ('$numDoc','${miPedido.fabricante}', null,${miPedido.precio},'$fechaActual',1)
      ''';
      // log(query);
      await db.rawInsert(query);
    } catch (e) {
      print('ERROR CONSULTA guardarSeguimientoPedido $e');
    }
  }
}
