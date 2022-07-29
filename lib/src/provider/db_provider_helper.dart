import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:emart/src/modelos/condiciones_entregas.dart';
import 'package:emart/src/modelos/datos_cliente.dart';
import 'package:emart/src/modelos/encuesta.dart';
import 'package:emart/src/modelos/linea_atencion.dart';
import 'package:emart/src/modelos/nombre_comercial.dart';
import 'package:emart/src/modelos/pedido.dart';
import 'package:emart/src/modelos/sugerido.dart';
import 'package:emart/src/modelos/historico.dart';
import 'package:emart/src/modelos/marcas.dart';
import 'package:emart/src/modelos/productos.dart';
import 'package:emart/src/modelos/tablas_borrar.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/utils/util.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final prefs = new Preferencias();

class DBProviderHelper {
  static Database? _database;
  static Database? _temp;
  static final DBProviderHelper db = DBProviderHelper._();
  DBProviderHelper._();

  Future<void> cerrarBases() async {
    if (_database != null) {
      print('cerre helper');
      await _database!.close();
      _database = null;
    }
    if (_temp != null) {
      await _temp!.close();
      _temp = null;
    }
  }

  Future<Database> get database async {
    if (_database != null) await _database!.close();

    _database = await initDB();

    return _database!;
  }

  Future<Database> get baseAbierta async {
    if (_database != null) {
      if (_database!.isOpen) return _database!;
    }

    _database = await initDB();

    return _database!;
  }

  Future<Database> get tempAbierta async {
    if (_temp != null) {
      if (_temp!.isOpen == true) {
        return _temp!;
      }
    }

    _temp = await initDBTemp();

    return _temp!;
  }

  Future<Database> get temp async {
    if (_temp != null) {
      await _temp!.close();
    }

    _temp = await initDBTemp();
    return _temp!;
  }

  Future<Database> initDB() async {
    //String ruta = '/Users/victormanuelgarcihurtado/Library/Developer/CoreSimulator/Devices/F3F3BF8A-646D-46B0-84A2-14DC53F4D5C0/data/Containers/Data/Application/290165B1-F0A9-455D-A958-78A14DD96449/Documents/sdcard/EAGLE/DataBase.db';
    String path = '';
    if (Platform.isIOS) {
      path = join(await iosPaht + '/DB7001.db');
    } else {
      path = join(await androidPaht + '/DB7001.db');
    }

    return await openDatabase(path, onOpen: (db) {});
  }

  Future<Database> initDBTemp() async {
    //String ruta = '/Users/victormanuelgarcihurtado/Library/Developer/CoreSimulator/Devices/F3F3BF8A-646D-46B0-84A2-14DC53F4D5C0/data/Containers/Data/Application/290165B1-F0A9-455D-A958-78A14DD96449/Documents/sdcard/EAGLE/Temp.db';
    String path = '';
    if (Platform.isIOS) {
      path = join(await iosPaht + '/Temp.db');
    } else {
      path = join(await androidPaht + '/Temp.db');
    }

    //Crear la base de datos
    return await openDatabase(path, onOpen: (tmp) {});
  }

  Future<dynamic> consultarExistenciaModulo(codigoCliente, codigoModulo) async {
    final db = await baseAbierta;
    try {
      final res1 = await db.rawQuery('''
        SELECT codModulo FROM ModuloRespuestas WHERE codModulo=$codigoModulo and codCliente='$codigoCliente'
    ''');

      return res1.isEmpty ? false : true;
    } catch (e) {
      return false;
    }
  }

  Future eliminarBasesDeDatosTemporal() async {
    final temp = await DBProviderHelper.db.tempAbierta;
    final res = await temp.rawQuery('''
        SELECT tbl_name FROM sqlite_master
        WHERE tbl_name <> 'android_metadata'
    ''');

    List<dynamic> listaTablas = [];

    if (res.isNotEmpty) {
      listaTablas = res.map((e) => BorrarTablas.fromJson(e)).toList();
    }
    listaTablas.forEach((element) async {
      final res2 = await temp.delete('${element.tblName}');
      print(res2);
    });
  }

  Future<dynamic> consultarMarcas() async {
    final db = await baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT codigo, descripcion, ico  
      FROM Marca
    ''');

      return sql.isEmpty ? sql.map((e) => Marcas.fromJson(e)).toList() : [];
    } catch (e) {
      return [];
    }
  }

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

    final db = await baseAbierta;

    try {
      //   final sql = await db.rawQuery('''
      //   SELECT DISTINCT NumeroDoc,MAX((substr(fechatrans, 4, 2) || '/' || substr(fechatrans, 1, 2) || '/' || substr(fechatrans, 7, 4))) fechatrans,
      //   MAX(fabricante)fabricante,MAX(ordencompra)ordencompra FROM Historico WHERE NumeroDoc LIKE CASE WHEN '$filtro'='-1' THEN NumeroDoc ELSE '%$filtro%' END
      //   AND Cast( fechatrans as DATE )>=Cast( CASE WHEN '$fechaInicioFor'='-1' THEN fechatrans ELSE '$fechaInicioFor' END  as DATE ) AND  Cast( fechatrans as DATE )<=Cast( CASE WHEN '$fechaFinFor'='-1' THEN fechatrans ELSE '$fechaFinFor' END as DATE )
      //   GROUP BY NumeroDoc
      //   ORDER BY fechatrans DESC
      // ''');

      String query =
          '''   SELECT DISTINCT NumeroDoc, MAX(substr(fechatrans, 1, 2) || '/' || substr(fechatrans, 4, 2) || '/' || substr(fechatrans, 7, 4)) as fechatrans, MAX(fabricante)fabricante, 
	   MAX(ordencompra)ordencompra FROM Historico 
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

      final sql = await db.rawQuery(query);
      log(jsonEncode(sql));
      return sql.map((e) => Historico.fromJson(e)).toList();
    } catch (e) {
      print('error historico $e');
      return [];
    }
  }

  Future<List<Historico>> consultarGrupoHistorico(int numeroDoc) async {
    final db = await baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT fabricante,ordencompra ordencompra from Historico where NumeroDoc=$numeroDoc GROUP BY fabricante
    ''');

      return sql.map((e) => Historico.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Historico>> consultarDetalleGrupo(
      int numeroDoc, String fabricante) async {
    final db = await baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT max(h.nombreproducto)nombreproducto,sum(h.Cantidad)Cantidad from Historico h inner join producto p on p.codigo=h.codigoref  where  h.NumeroDoc=$numeroDoc  and  h.fabricante='$fabricante' GROUP BY h.fabricante,h.codigoref
    ''');

      return sql.map((e) => Historico.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Historico>> consultarDetallePedido(String numeroDoc) async {
    final db = await baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT h.codigoRef,max(h.nombreproducto)nombreproducto,sum(h.Cantidad)Cantidad,CAST(p.precio AS double) precio 
      from Historico h inner join producto p on p.codigo=h.codigoref where  h.NumeroDoc='$numeroDoc' GROUP BY h.codigoref
    ''');

      return sql.map((e) => Historico.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Sugerido>> consultarPedidoSugerido() async {
    final db = await baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT s.codigo,s.descripcion,s.Cantidad FROM Sugerido s INNER JOIN Producto p on p.codigo=s.codigo
    ''');

      return sql.map((e) => Sugerido.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Productos> consultarDatosProducto(String producto) async {
    final db = await baseAbierta;

    final sql = await db.rawQuery('''
      SELECT * FROM Producto where codigo='$producto' limit 1
    ''');

    return Productos.fromJson(sql.first);
  }

  Future<List<Productos>> consultarProductos() async {
    final db = await baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT * FROM Producto
    ''');

      return sql.map((e) => Productos.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> consultarSugueridoHelper() async {
    final db = await baseAbierta;

    try {
      final sql = await db.rawQuery('''
       SELECT s.*
       FROM Producto p
       INNER JOIN Sugerido s ON p.codigo = s.Codigo 
    ''');

      return sql.isNotEmpty
          ? sql.map((e) => Sugerido.fromJson(e)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> consultarDatosCliente() async {
    final db = await baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT * FROM Sucursales limit 1
    ''');

      return sql.isNotEmpty
          ? sql.map((e) => DatosCliente.fromJson(e)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> cargarTelefotosSoporte(int tipo) async {
    final db = await baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT * FROM LineaAtencion where Tipo=$tipo
    ''');

      return sql.isNotEmpty
          ? sql.map((e) => LineaAtencion.fromJson(e)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> consultarCondicionEntrega(String fabricante) async {
    final db = await baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT ce.* FROM CondicionesEntrega ce LEFT JOIN Sucursales_Empresas se on ce.fabricante=se.empresa AND
      ce.tipo=se.tipoFabricante WHERE ce.fabricante='$fabricante' LIMIT 1
    ''');

      return CondicionesEntrega.fromJson(sql.first);
    } catch (e) {
      return [];
    }
  }

  Future<String> consultarCodigoClienteProducto(String? codigoProducto) async {
    final db = await baseAbierta;
    try {
      final sql = await db.rawQuery('''
       SELECT p.codigocliente
       FROM Producto p
       WHERE codigo='$codigoProducto' limit 1
    ''');

      return sql.toString();
    } catch (e) {
      return '';
    }
  }

  Future<void> guardarHistorico(Pedido miPedido, int documento) async {
    final db = await baseAbierta;
    String nombreFabricante = '';
    try {
      for (var i = 0; i < PedidoEmart.listaFabricante!.length; i++) {
        if (PedidoEmart.listaFabricante![i].empresa == miPedido.fabricante) {
          nombreFabricante = PedidoEmart.listaFabricante![i].nombrecomercial;
        }
      }

      DateTime now = new DateTime.now();
      var fechaActual = now.day.toString() +
          '/' +
          now.month.toString() +
          '/' +
          now.year.toString();

      await db.rawInsert('''
      INSERT INTO Historico VALUES ($documento,'${miPedido.codigoProducto}','${miPedido.nombreProducto}',${miPedido.cantidad},${miPedido.precio},'$fechaActual','$nombreFabricante',$documento)
    ''');
    } catch (e) {
      print('ERROR CONSULTA $e');
    }
  }

  Future<String> consultarNombreComercial(fabricantes) async {
    final db = await baseAbierta;
    var cadenaFabricante = "";
    var sql;

    List<String> cadena = fabricantes.split(",");
    for (int i = 0; i < cadena.length; i++) {
      sql = await db.rawQuery('''
       SELECT ce.nombrecomercial
       FROM CondicionesEntrega ce
       WHERE ce.fabricante='${cadena[i]}'
    ''');

      NombreComercial nuevo = new NombreComercial.fromJson(sql.first);
      cadenaFabricante += nuevo.nombreComercial + ", ";
    }
    return cadenaFabricante;
  }

  Future<void> guardarRespuesta(Encuesta encuesta) async {
    final db = await baseAbierta;
    try {
      await db.rawInsert(
          ''' INSERT INTO EncuestasRealizadas (encuestaid, codigocliente, codigordv, codigosdv) VALUES(${encuesta.encuestaId}, '${prefs.codClienteLogueado}', '', '') ''');
    } catch (e) {
      print('ERROR CONSULTA ENCUESTA $e');
    }
  }
}
