import 'dart:io';
import 'package:emart/src/modelos/condiciones_entregas.dart';
import 'package:emart/src/modelos/datos_cliente.dart';
import 'package:emart/src/modelos/encuesta.dart';
import 'package:emart/src/modelos/linea_atencion.dart';
import 'package:emart/src/modelos/nombre_comercial.dart';
import 'package:emart/src/modelos/sugerido.dart';
import 'package:emart/_pideky/domain/mis_pedidos/model/historico.dart';
import 'package:emart/src/modelos/tablas_borrar.dart';
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
      print('cerre helper temp');
      await _temp!.close();
      _temp = null;
    }
  }

  Future<Database> get database async {
    if (_database != null) await _database!.close();

    _database = await initDB();

    return _database!;
  }

  Future<Database> get temp async {
    if (_temp != null) await _temp!.close();

    _temp = await initDBTemp();

    return _temp!;
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
      path = join(await androidPaht + 'Temp.db');
    }
    print('Lugar de carpeta temp ' + path);
    //Crear la base de datos
    return await openDatabase(
      path,
      version: 1,
      onCreate: ((db, version) => db.execute(
          'CREATE TABLE pedido (codigo_producto varchar(10), cantidad int)')),
      onOpen: (tmp) {},
    );
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
      await temp.delete('${element.tblName}');
    });
  }

  Future<List<Historico>> consultarDetallePedido(String numeroDoc) async {
    final db = await baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT h.codigoRef,max(h.nombreproducto)nombreproducto,sum(h.Cantidad)Cantidad,
      CAST(p.precio AS double) precio from Historico h inner join producto p on 
      p.codigo=h.codigoref where  h.NumeroDoc='$numeroDoc' GROUP BY h.codigoref
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
      print('Error al consultar sucursal $e');
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
      SELECT ce.fabricante, ce.tipo, ce.hora, ce.Texto1 as texto1, ce.Texto2 as texto2, ce.DiasEntrega as diasEntrega, ce.DiaVisita as diaVisita, ce.MontoMinimoFrecuencia 
      as montoMinimoFrecuencia, ce.MontoMinimoNoFrecuencia as montoMinimoNoFrecuencia FROM CondicionesEntrega ce LEFT JOIN Sucursales_Empresas se on ce.fabricante=se.empresa AND
      ce.tipo=se.tipoFabricante WHERE ce.fabricante='$fabricante' LIMIT 1
      
    ''');

      return CondicionesEntrega.fromJson(sql.first);
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> consultarTipoFabricanteDirectoOIndirecto(
      String fabricante) async {
    final db = await baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT ce.* FROM CondicionesEntrega ce LEFT JOIN Sucursales_Empresas se on ce.fabricante=se.empresa AND
      ce.tipo=se.tipoFabricante WHERE ce.fabricante='$fabricante' LIMIT 1
    ''');

      return sql.first['tipo'];
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
          ''' INSERT INTO EncuestasRealizadas (encuestaid, codigocliente, codigordv, codcigosdv) 
          VALUES(${encuesta.encuestaId}, '${prefs.codigoUnicoPideky}', '', '') ''');
    } catch (e) {
      print('ERROR CONSULTA ENCUESTA $e');
    }
  }

  Future<void> guardarLista(int idLista, String name) async {
    final db = await baseAbierta;
    try {
      await db.rawInsert(''' INSERT INTO ListaCompraEncabezado (Id, Nombre) 
          VALUES('$idLista', '$name' ) ''');
    } catch (e) {
      print('ERROR GUARDANDO LISTA $e');
    }
  }

  Future<void> eliminarLista(int idLista) async {
    final db = await baseAbierta;
    try {
      await db.delete(
        'ListaCompraEncabezado',
        where: '''Id = ?''',
        whereArgs: [idLista],
      );
    } catch (e) {
      print('ERROR AL ELIMINAR LISTA $e');
    }
  }

  Future<void> agregarProductoALista(int idLista, String nombre, String codigo,
      cantidad, String proveedor) async {
    final db = await baseAbierta;
    print('entre aqui ');
    try {
      // Verificar si el código ya existe en la tabla
      List<Map<String, dynamic>> result = await db.rawQuery(
          ''' SELECT * FROM ListaCompraDetalle WHERE Codigo = '$codigo' and Id = '$idLista' ''');

      if (result.isNotEmpty) {
        // El código ya existe, actualizar la cantidad en ese registro
        await db.rawUpdate(
            ''' UPDATE ListaCompraDetalle SET Cantidad = Cantidad + '$cantidad' 
          WHERE Codigo = '$codigo' and Id = '$idLista' ''');
      } else {
        // El código no existe, insertar un nuevo registro
        await db.rawInsert(
            ''' INSERT INTO ListaCompraDetalle (Id, Nombre, Codigo, Cantidad, Proveedor) 
          VALUES('$idLista', '$nombre', '$codigo', '$cantidad', '$proveedor' ) ''');
      }
    } catch (e) {
      print('ERROR AL AGREGAR PRODUCTO A LISTA $e');
    }
  }

  Future<void> eliminarProductoDeLista(String codigo, int id) async {
    final db = await baseAbierta;
    try {
      await db.delete(
        'ListaCompraDetalle',
        where: '''Id = ? and Codigo = ?''',
        whereArgs: [id, codigo],
      );
    } catch (e) {
      print('ERROR AL ELIMINAR PRODUCTO DE LISTA $e');
    }
  }

  Future<void> actualizarProductoDeLista(int idLista, cantidad) async {
    final db = await baseAbierta;
    try {
      await db.update('ListaCompraDetalle', {'Cantidad': cantidad},
          where: 'Id = ?', whereArgs: [idLista]);
    } catch (e) {
      print('ERROR AL ACTUALIZAR PRODUCTO DE LISTA $e');
    }
  }
}
