import 'package:emart/_pideky/domain/my_orders/interface/interface_mi_orders_gate_way.dart';
import 'package:emart/_pideky/domain/my_orders/model/historical_model.dart';
import 'package:emart/_pideky/domain/my_orders/model/order_tracking.dart';
import 'package:emart/src/modelos/pedido.dart';
import 'package:emart/src/provider/db_provider_helper.dart';

class MisPedidosQuery extends InterfaceMyOrdersGateWay {
  Future<List<HistoricalModel>> consultarHistoricos(
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
          '''   SELECT DISTINCT NumeroDoc, MAX(substr(fechatrans, 1, 2) || '/' || substr(fechatrans, 4, 2) || '/' || substr(fechatrans, 7, 4)) as fechatrans, 
       MAX(ordencompra)ordencompra, sum(precio*cantidad) as precio, MAX(substr(fechatrans,11, 6)) as horatrans FROM Historico
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
      //log(query);
      final sql = await db.rawQuery(query);
      return sql.map((e) => HistoricalModel.fromJson(e)).toList();
    } catch (e) {
      print('-----Error historico $e');
      return [];
    }
  }

  Future<List<HistoricalModel>> consultarGrupoHistorico(String numeroDoc) async {
    final db = await DBProviderHelper.db.baseAbierta;

    try {
      String query = '''
        SELECT h.NumeroDoc, h.fabricante, h.ordencompra ordencompra, f.ico, sum(precio) as precio 
        from Historico h LEFT JOIN fabricante f ON h.fabricante = f.nombrecomercial 
        where NumeroDoc='$numeroDoc' GROUP BY fabricante
      ''';
      final sql = await db.rawQuery(query);

      return sql.map((e) => HistoricalModel.fromJson(e)).toList();
    } catch (e) {
      print('-----Error grupo historico $e');
      return [];
    }
  }

  Future<List<HistoricalModel>> consultarDetalleGrupoHistorico(
      String numeroDoc, String fabricante) async {
    final db = await DBProviderHelper.db.baseAbierta;
    try {
      final query = '''
        SELECT 
            H.NumeroDoc, 
            H.codigoRef, 
            H.nombreproducto, 
            H.cantidad, 
            H.fabricante, 
            H.ordencompra, 
            MAX(substr(H.fechatrans,11, 6)) as horatrans, 
            MAX(substr(H.fechatrans, 1, 2) || '/' || substr(H.fechatrans, 4, 2) || '/' || substr(H.fechatrans, 7, 4)) as fechatrans, 
            IFNULL(tmp.descuento, 0.0) AS descuento,
          CAST(H.precio AS double) precio,
          CAST(
                ROUND(
                    (p.precio + ((p.precio * p.iva) / 100) + (
                                CASE
                                    WHEN p.ICUI = 0 THEN p.IBUA
                                    ELSE ((p.precio * p.ICUI) / 100)
                                END
                            ) ), 0
                ) AS FLOAT
            ) AS precioSinDescuento
        FROM 
            Historico H
        JOIN 
            Producto P ON H.codigoRef = P.codigo
        LEFT JOIN 
            (
                SELECT 
                    tmp.proveedor, 
                    tmp.material codigo, 
                    tmp.descuento 
                FROM 
                    (
                        SELECT 
                            (SELECT COUNT(*) FROM descuentos de WHERE de.rowid >= d.rowid AND de.material = d.material) identificador, * 
                        FROM 
                            descuentos d
                        INNER JOIN 
                            producto p ON p.codigo = d.material AND d.proveedor = p.fabricante
                    ) tmp 
                WHERE tmp.identificador = 1
            ) tmp ON p.fabricante = tmp.proveedor AND p.codigo = tmp.codigo
        WHERE 
            H.NumeroDoc = '$numeroDoc' 
            AND H.fabricante = '$fabricante'
        GROUP BY 
            H.codigoref;
      ''';
      final sql = await db.rawQuery(query);
      //log(query);
      return sql.map((e) => HistoricalModel.fromJson(e)).toList();
    } catch (e) {
      print('-----Error consultarDetalleGrupoHistorico $e');
      return [];
    }
  }

  Future<List<HistoricalModel>> consultarDetalleGrupo(
      String numeroDoc, String fabricante) async {
    final db = await DBProviderHelper.db.baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT max(h.nombreproducto)nombreproducto,sum(h.Cantidad)Cantidad,
       p.fabricante from Historico h inner join producto p on p.codigo=h.codigoref  
       where  h.NumeroDoc='$numeroDoc'  and  h.fabricante='$fabricante' 
       GROUP BY h.fabricante,h.codigoref
    ''');

      return sql.map((e) => HistoricalModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<OrderTracking>> consultarSeguimientoPedido(
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
          '''   SELECT DISTINCT NumeroDoc, MAX(substr(fechaServidor, 1, 2) || '/' || substr(fechaServidor, 4, 2) || '/' || substr(fechaServidor, 7, 4)) as fechaServidor, 
            MAX(consecutivo) consecutivo, sum(precio*cantidad) as precio, MAX(substr(fechaServidor,11, 6)) as horatrans FROM SeguimientoPedido
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
      return sql.map((e) => OrderTracking.fromJson(e)).toList();
    } catch (e) {
      print('-----Error SeguimientoPedido $e');
      return [];
    }
  }

  Future<List<OrderTracking>> consultarGrupoSeguimientoPedido(
      String numeroDoc, int tipo) async {
    final db = await DBProviderHelper.db.baseAbierta;

    try {
      String query = '''
        SELECT s.NumeroDoc, s.proveedor fabricante, s.Nombre, s.Cantidad, s.consecutivo, f.ico, 
        substr(s.fechaServidor, 1, 2) || '/' || substr(s.fechaServidor, 4, 2) || '/' || substr(s.fechaServidor, 7, 4) as fechaServidor, 
        substr(s.fechaServidor,11, 6) as horatrans, s.Precio as precio, s.CodigoProducto, s.estado     
        from SeguimientoPedido s JOIN fabricante f ON s.proveedor = f.empresa 
        where s.NumeroDoc='$numeroDoc'
      ''';

      final sql = await db.rawQuery(query);
      // log(query);
      return sql.map((e) => OrderTracking.fromJson(e)).toList();
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
          ' ${now.hour.toString().length > 1 ? now.hour : '0${now.hour}'}:${now.minute.toString().length > 1 ? now.minute : '0${now.minute}'}:${now.second}';

      var query = '''
        INSERT INTO SeguimientoPedido VALUES ('$numDoc','${miPedido.fabricante}','${miPedido.codigoProducto}','${miPedido.nombreProducto}',${miPedido.precio},${miPedido.cantidad},null,'$fechaActual',1)
      ''';
      // log(query);
      await db.rawInsert(query);
    } catch (e) {
      print('ERROR CONSULTA guardarSeguimientoPedido $e');
    }
  }
}
