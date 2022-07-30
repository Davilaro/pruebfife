import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:emart/src/modelos/acceso_rapido.dart';
import 'package:emart/src/modelos/bannner.dart';
import 'package:emart/src/modelos/categorias.dart';
import 'package:emart/src/modelos/encuesta.dart';
import 'package:emart/src/modelos/fabricantes.dart';
import 'package:emart/src/modelos/marcaFiltro.dart';
import 'package:emart/src/modelos/marcas.dart';
import 'package:emart/src/modelos/multimedia.dart';
import 'package:emart/src/modelos/productos.dart';
import 'package:emart/src/modelos/respuesta.dart';
import 'package:emart/src/modelos/seccion.dart';
import 'package:emart/src/modelos/vendedor.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/utils/util.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final prefs = new Preferencias();

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<void> cerrarBases() async {
    if (_database != null) {
      print('cerre provider');
      await _database!.close();
      _database = null;
    }
  }

  Future<Database> get database async {
    if (_database != null) {
      if (_database!.isOpen) return _database!;
    }

    _database = await initDB();

    return _database!;
  }

  Future<Database> get baseAbierta async {
    /*if (_database != null) {
      return _database!;
    }*/
    if (_database != null) {
      if (_database!.isOpen) return _database!;
    }

    _database = await initDB();

    return _database!;
  }

  Future<Database> initDB() async {
    String path = '';
    if (Platform.isIOS) {
      path = join(await iosPaht + 'DB7001.db');
    } else {
      path = join(await androidPaht + 'DB7001.db');
      // path = join('/sdcard', 'PIDEKY/DB7001.db');
    }

    print('Lugar de carpeta ' + path);

    return await openDatabase(path, onOpen: (db) {});
  }

  Future<dynamic> consultarExistenciaModulo(codigoCliente, codigoModulo) async {
    final db = await baseAbierta;
    try {
      final res1 = await db.rawQuery('''
        SELECT codModulo FROM ModuloRespuestas WHERE codModulo=$codigoModulo and codCliente='$codigoCliente'
    ''');
      return res1.isEmpty ? false : true;
    } catch (e) {
      print('ERROR EXISTENCIA MODULO : $e');
      return false;
    }
  }

  Future<dynamic> consultarMarcas(String buscar) async {
    final db = await baseAbierta;

    try {
      var sql = await db.rawQuery('''
      
      SELECT m.codigo, m.descripcion, m.ico  
      FROM Marca m
      INNER JOIN Producto p ON m.codigo = p.marcacodigopideki
      WHERE m.codigo LIKE '%$buscar%' OR m.descripcion LIKE '%$buscar%'
      GROUP BY p.marcacodigopideki 
      ORDER BY m.orden ASC 
       
    ''');
      if (sql.length > 1) {
        sql = await db.rawQuery('''
      
      SELECT m.codigo, m.descripcion, m.ico  
      FROM Marca m
      INNER JOIN Producto p ON m.codigo = p.marcacodigopideki
      WHERE m.codigo LIKE '%$buscar%' OR m.descripcion LIKE '$buscar'
      GROUP BY p.marcacodigopideki 
      ORDER BY m.orden ASC 
       
    ''');
      }

      return sql.isNotEmpty ? sql.map((e) => Marcas.fromJson(e)).toList() : [];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> consultarCategorias(String buscar, int limit) async {
    final db = await baseAbierta;

    try {
      final isLimit = limit != 0 ? "LIMIT $limit" : "";

      final sql = await db.rawQuery('''
      
      SELECT c.codigo, c.descripcion, c.ico2 as ico
      FROM Categoria c
      INNER JOIN Producto p ON c.codigo = p.categoriacodigopideki 
      WHERE c.codigo LIKE '%$buscar%'  OR c.descripcion LIKE '%$buscar%'

      GROUP BY p.categoriacodigopideki
      ORDER BY c.orden ASC $isLimit 
      
    ''');

      return sql.isNotEmpty
          ? sql.map((e) => Categorias.fromJson(e)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> consultarCategoriasDestacadas(
      String buscar, int limit) async {
    final db = await baseAbierta;

    try {
      final isLimit = limit != 0 ? "LIMIT $limit" : "";

      final sql = await db.rawQuery('''
      
      SELECT c.codigo, c.descripcion, c.ico2 as ico
      FROM CategoriaDestacada c
      INNER JOIN Producto p ON c.codigo = p.categoriacodigopideki 
      WHERE c.codigo LIKE '%$buscar%' OR c.descripcion LIKE '%$buscar%'
      GROUP BY p.categoriacodigopideki
      ORDER BY c.orden ASC $isLimit 
      
    ''');

      return sql.isNotEmpty
          ? sql.map((e) => Categorias.fromJson(e)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> consultarCategoriasSubCategorias(String? buscar) async {
    final db = await baseAbierta;

    try {
      final sql = await db.rawQuery('''
      
      SELECT s.codigo, s.descripcion, '' as ico, '' as fabricante
      FROM SubCategoria s 
      INNER JOIN Producto p ON s.codigo = p.subcategoriacodigopideki 
      WHERE s.cod_categoria = '$buscar'
      GROUP BY p.subcategoriacodigopideki
      ORDER BY s.orden ASC
      
    ''');

      return sql.isNotEmpty
          ? sql.map((e) => Categorias.fromJson(e)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> consultarSubCategoria(
      String codCategoria, String buscador) async {
    final db = await baseAbierta;

    try {
      var condicion = buscador != '' ? ' and s.descripcion = "$buscador" ' : '';

      final sql = await db.rawQuery('''
      
      SELECT s.codigo, s.descripcion, '' as ico, '' as fabricante
      FROM SubCategoria s 
      INNER JOIN Producto p ON s.codigo = p.subcategoriacodigopideki 
      WHERE s.cod_categoria = "$codCategoria" $condicion 
      GROUP BY p.subcategoriacodigopideki
      ORDER BY s.orden ASC
      
    ''');

      return sql.isNotEmpty
          ? sql.map((e) => Categorias.fromJson(e)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> consultarSuguerido() async {
    final db = await baseAbierta;

    try {
      final sql = await db.rawQuery('''
       
        SELECT p.codigo , p.nombre , 
         round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, 0.0 as descuento, 
        0.0 as preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
        ,activopromocion, activoprodnuevo
        FROM Producto p
        inner join Ofertas pn ON p.codigo = pn.codigo
        left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        GROUP BY p.codigo 
        ORDER BY p.nombre ASC

    ''');

      return sql.isNotEmpty
          ? sql.map((e) => Productos.fromJson(e)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> cargarProductos(
      String? codigo,
      int tipo,
      String buscador,
      double precioMinimo,
      double precioMaximo,
      String? codigoMarca,
      String codigoProveedor) async {
    final db = await baseAbierta;
    try {
      var query = '';
      final sql;
      String? consulta;
      if (codigoMarca != "" && codigoMarca != null) {
        consulta = "   and  p.marcacodigopideki=$codigoMarca";
      } else {
        consulta = "";
      }

      if (tipo == 2) {
        query = '''
      SELECT p.codigo , p.nombre , 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, cast(ifnull(tmp.descuento,0.0) as float) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo
        FROM Producto p left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  (p.fabricante like '%$codigoProveedor%') AND
         p.subcategoriacodigopideki = '$codigo'  AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%')
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo

        $consulta
        ORDER BY p.orden ASC
        
    ''';
      } else if (tipo == 3) {
        query = '''
       SELECT p.codigo , p.nombre , 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, ifnull(tmp.descuento,0.0) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo
        FROM Producto p left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  (p.fabricante like '%$codigoProveedor%') AND
        p.marcacodigopideki = $codigo  AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%' )
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo 
        $consulta
        ORDER BY p.orden ASC
         
       ''';
      } else if (tipo == 4) {
        query = '''
      SELECT p.codigo , p.nombre , 
       round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, ifnull(tmp.descuento,0.0) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float)  precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
        ,activopromocion, activoprodnuevo
        FROM Producto p left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  (p.fabricante like '%$codigoProveedor%') 
         AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%' ) 
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
       
        ORDER BY p.orden ASC
         
      ''';
      } else if (tipo == 5) {
        query = '''
      SELECT p.codigo , p.nombre , 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, cast(ifnull(tmp.descuento,0.0) as float) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo
        FROM Producto p left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  (p.fabricante like '%$codigoProveedor%') AND
         p.categoriacodigopideki = '$codigo'  AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%')
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
        $consulta
        ORDER BY p.orden ASC
         
      ''';
      } else if (tipo == 7) {
        //tipo para productos mas vendidos
        query = '''
       SELECT p.codigo , p.nombre , 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, ifnull(tmp.descuento,0.0) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
          ,activopromocion, activoprodnuevo
        FROM Producto p left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  (p.fabricante like '%$codigoProveedor%') AND
        p.marcacodigopideki = $codigo  AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%' )
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo 
        $consulta
        
        and p.codigo in (select distinct codigoref from Historico  )
        ORDER BY p.orden ASC
         
      ''';
      } else {
        query = '''
       SELECT p.codigo , p.nombre , 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, ifnull(tmp.descuento,0.0) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float)  precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo
        FROM Producto p left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  (p.fabricante like '%$codigoProveedor%') AND
        (p.codigo like '%$buscador%' OR p.nombre like '%$buscador%' )
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
        $consulta
        ORDER BY p.orden ASC
         
        ''';
      }

      log(query);
      sql = await db.rawQuery(query);

      return sql.isNotEmpty
          ? sql.map((e) => Productos.fromJson(e)).toList()
          : [];
    } catch (e) {
      print('Error consulta cargarProductos $e');
      return [];
    }
  }

  Future<List<dynamic>> cargarProductosInterno(
      int tipoProducto,
      String buscador,
      double precioMinimo,
      double precioMaximo,
      int limit,
      String? codigoMarca,
      String codigoProveedor) async {
    final db = await baseAbierta;

    try {
      final isLimit = limit != 0 ? "LIMIT $limit" : "";

      final sql;
      String? consulta;
      if (codigoMarca != "" && codigoMarca != null) {
        consulta = "   and  p.marcacodigopideki=$codigoMarca";
      } else {
        consulta = "";
      }

      if (tipoProducto == 2) {
        sql = await db.rawQuery('''
        SELECT p.codigo , p.nombre , round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio  , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, pn.orden_imperdible as orden, 0.0 as descuento, 
        0.0 as  preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) as precioinicial
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
        ,activopromocion, activoprodnuevo
        FROM Producto p
        left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select count(p.codigo) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante group by material
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        inner join ProductosNuevos pn ON p.codigo = pn.codigo 
        WHERE (p.fabricante like '%$codigoProveedor%') AND 
        (p.codigo LIKE '%$buscador%' OR p.nombre LIKE '%$buscador%')
          and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
        $consulta
        ORDER BY pn.orden_imperdible ASC $isLimit 
         
    ''');
      } else {
        sql = await db.rawQuery('''
      SELECT p.codigo , p.nombre , 
     round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
      p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
      p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
      p.codIndirecto , p.marcacodigopideki , 
      p.categoriacodigopideki , 
      p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, pn.orden_oferta as orden, cast(ifnull(tmp.descuento,0) as float) descuento, 
      round((p.precio - p.precio * ifnull(tmp.descuento,0) /100),0) preciodescuento,
      cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial
      , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
       ,activopromocion, activoprodnuevo
      FROM Producto p
      left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
      select count(p.codigo) identificador,* 
      from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante group by material
      ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
      inner join Ofertas pn ON p.codigo = pn.codigo 
      WHERE  (p.fabricante like '%$codigoProveedor%') AND
      (p.codigo LIKE '%$buscador%' OR p.nombre LIKE '%$buscador%')
      and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
      $consulta
      UNION 
      SELECT p.codigo , p.nombre , 
     round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
      p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
      p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
      p.codIndirecto , p.marcacodigopideki , 
      p.categoriacodigopideki , 
      p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, pn.orden_oferta as orden, cast(ifnull(tmp.descuento,0) as float) descuento, 
      round((p.precio - p.precio * ifnull(tmp.descuento,0) /100),0) preciodescuento,
      cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
, substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
        ,activopromocion, activoprodnuevo
      FROM Producto p left join Ofertas pn ON p.codigo = pn.codigo left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
      select count(p.codigo) identificador,* 
      from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante group by material
      ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
      WHERE  (p.fabricante like '%$codigoProveedor%') AND
      (p.codigo like '%$buscador%' OR p.nombre like '%$buscador%') AND tmp.descuento > 0 
      and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
      
      ORDER BY pn.orden_oferta ASC
         
     ''');
      }

      return sql.isNotEmpty
          ? sql.map((e) => Productos.fromJson(e)).toList()
          : [];
    } catch (e) {
      print('Error consulta cargarProductosInterno $e');
      return [];
    }
  }

  Future<dynamic> consultarAccesosRapidos() async {
    final db = await baseAbierta;

    try {
      final sql = await db.rawQuery('''
      
      Select a.codigo, a.descripcion, a.ico, a.fabricante
      from AccesosRapidos a
      INNER JOIN Producto p ON a.codigo = p.marcacodigopideki
      GROUP BY a.codigo 
      ORDER BY p.orden ASC

    ''');

      return sql.isNotEmpty
          ? sql.map((e) => AccesosRapido.fromJson(e)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> consultarFricante(String buscar) async {
    final db = await baseAbierta;

    try {
      final sql = await db.rawQuery('''
      SELECT f.empresa, f.ico, f.codIndirecto, cast((SELECT pedidominimo FROM CondicionesEntrega
      WHERE Fabricante = f.empresa) as float) as pedidominimo,cast((SELECT topeminimo FROM CondicionesEntrega
      WHERE Fabricante = f.empresa ) as float) as topeMinimo, f.nombrecomercial, f.tipofabricante 
      FROM Fabricante f 
      WHERE f.empresa LIKE '%$buscar%' OR f.nombrecomercial LIKE '%$buscar%'
      GROUP BY f.empresa
      ORDER BY f.orden ASC 

    ''');

      return sql.isNotEmpty
          ? sql.map((e) => Fabricantes.fromJson(e)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> consultarProveedores() async {
    final db = await baseAbierta;

    try {
      final sql = await db.rawQuery('''
	    SELECT empresa, ico, tipofabricante, codIndirecto, Estado, nombrecomercial, pedidominimo, NitCliente, RazonSocial 
      FROM ProveedoresActivos ORDER by Estado ASC
    ''');

      return sql.isNotEmpty
          ? sql.map((e) => Fabricantes.fromJson(e)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> cargarVendedores() async {
    final db = await baseAbierta;

    try {
      final sql = await db.rawQuery('''
      SELECT fa.empresa, fa.nombrecomercial, la.descripcion, la.telefonovendedor, 
      la.nombrevendedor, la.codigovendedor, fa.ico FROM fabricante as fa 
      JOIN LineaAtencion as la ON fa.empresa = la.fabricante ORDER BY fa.empresa ASC
    ''');

      return sql.isNotEmpty
          ? sql.map((e) => Vendedor.fromJson(e)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> consultarFricanteGeneral() async {
    final db = await baseAbierta;

    try {
      final sql = await db.rawQuery('''
      SELECT f.empresa, f.ico, f.codIndirecto, cast((SELECT pedidominimo FROM CondicionesEntrega
      WHERE Fabricante = f.empresa ) as float) as pedidominimo,cast((SELECT topeminimo FROM CondicionesEntrega
      WHERE Fabricante = f.empresa ) as float) as topeMinimo, f.nombrecomercial, f.tipofabricante 
      FROM Fabricante f
      GROUP BY f.empresa
      ORDER BY f.orden ASC 

    ''');

      return sql.isNotEmpty
          ? sql.map((e) => Fabricantes.fromJson(e)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> cargarBannersSql(String? tipo) async {
    final db = await baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT b.fabricante_x as fabricante, f.empresa as empresa, f.nombrecomercial as nombrecomercial, 
      f.tipofabricante as tipofabricante, b.Link as Ico, b.Id, b.nombrefoto_x as nombrebanner, 
      b.redireccion as tipoSeccion, subdireccion as seccion, categoria as subSeccion  
      FROM Banner b
      inner join Fabricante f ON b.fabricante_x =f.empresa
      WHERE b.tipo = '$tipo'
    ''');
      return sql.isNotEmpty ? sql.map((e) => Banners.fromJson(e)).toList() : [];
    } catch (e) {
      return [];
    }
  }

  Future<String> consultarVersion(String? tipo) async {
    final db = await baseAbierta;

    try {
      List<Map> list = await db.rawQuery('''
       SELECT version version
       FROM version WHERE tipo = "$tipo" 
    ''');

      if (list.isNotEmpty) {
        return list[0]['version'];
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  Future<int> consultarVersionObligatoria() async {
    final db = await baseAbierta;

    try {
      List<Map> list = await db.rawQuery('''
       SELECT obligatorio obligatorio
       FROM version
    ''');

      if (list.isNotEmpty) {
        return list[0]['obligatorio'];
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  Future<List<Productos>> cargarProductosFiltro(
      String? buscar, String codigoProveedor) async {
    final db = await baseAbierta;

    try {
      List<Productos> lista = [];
      var condicion = buscar != '' ? ' WHERE p.codigo LIKE "%$buscar%" ' : ' ';

      List<Map> sql = await db.rawQuery('''
        SELECT p.codigo , p.nombre , round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio  , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, 0.0 as descuento, 
        0.0 as  preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) as precioinicial
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo
        FROM Producto p
        left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select count(p.codigo) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante group by material
        ) tmp where  (p.fabricante like '%$codigoProveedor%') AND
         tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo 
        $condicion 
        ORDER BY p.orden ASC 
         
    ''');

      lista = List<Productos>.from(sql.map((x) => Productos.fromJson2(x)));

      return lista;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> consultarAgotados() async {
    final db = await baseAbierta;
    try {
      List<Respuesta> lista = [];

      final sql = await db.rawQuery('''
      SELECT codigosku as respuesta FROM Agotados
    ''');

      lista = List<Respuesta>.from(sql.map((x) => Respuesta.fromJson(x)));
      return lista;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> consultarSecciones() async {
    final db = await baseAbierta;
    try {
      List<Seccion> lista = [];

      final sql = await db.rawQuery('''
      SELECT id, descripcion, orden_componente as orden FROM Secciones ORDER by orden_componente ASC
    ''');

      lista = List<Seccion>.from(sql.map((x) => Seccion.fromJson(x)));
      return lista;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> consultarEncuesta() async {
    try {
      final db = await baseAbierta;
      List<Encuesta> lista = [];

      final sql = await db.rawQuery('''
        SELECT pre.encuestaId, enc.titulo as encuestaTitulo, pre.id as preguntaid, pre.tipopreguntaid, pre.pregunta,
        par.id as paramPreguntaId, par.valor, par.parametro FROM Pregunta pre
        INNER JOIN Encuesta enc ON pre.encuestaid = enc.id INNER JOIN ParamPregunta par ON par.preguntaid = pre.id
        left join EncuestasRealizadas e on e.encuestaId = pre.encuestaId
        WHERE pre.orden = 1 and e.encuestaid is null
      ''');

      if (sql.length > 1) {
        List<dynamic> parametros =
            List<dynamic>.from(sql.map((e) => e['parametro']));
        var encuesta = Encuesta.fromJson2(sql[0]);
        encuesta.parametro = parametros;
        lista.add(encuesta);
      } else {
        lista = List<Encuesta>.from(sql.map((x) => Encuesta.fromJson(x)));
      }
      return lista;
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> consultarMultimedia() async {
    final db = await baseAbierta;

    try {
      final sql = await db.rawQuery('''
       SELECT link, orientacion
       FROM Multimedia first_value 
    ''');

      return sql.isNotEmpty
          ? sql.map((e) => Multimedia.fromJson(e)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<String> consultarSucursal() async {
    final db = await baseAbierta;
    try {
      List<Map> list = await db.rawQuery('''
       SELECT razonsocial 
       FROM Sucursales limit 1 
    ''');

      if (list.isNotEmpty) {
        return list[0]['razonsocial'];
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  Future<void> editarTelefonoWhatsapp(String telefono) async {
    final db = await baseAbierta;
    try {
      await db.rawUpdate(''' 
          UPDATE Sucursales SET telefonowhatsapp = "$telefono" 
          ''');
    } catch (e) {
      print('ERROR CONSULTA $e');
    }
  }

  Future<String?> consultarCodigoMarcaPorNombre(String? nombre) async {
    final db = await baseAbierta;
    try {
      List<Map> list = await db.rawQuery('''
         SELECT codigo FROM Marca where descripcion = '$nombre'
    ''');

      if (list.isNotEmpty) {
        return list[0]['codigo'];
      } else {
        return '';
      }
    } catch (e) {
      return "";
    }
  }

  Future<String?> consultarCodigoSubCategoriaPorNombre(String? nombre) async {
    final db = await baseAbierta;
    try {
      List<Map> list = await db.rawQuery('''
           SELECT codigo FROM subCategoria where descripcion='$nombre'
    ''');

      if (list.isNotEmpty) {
        return list[0]['codigo'];
      } else {
        return '';
      }
    } catch (e) {
      return "";
    }
  }

  Future<String?> consultarCodigoCategoriaaPorNombre(String? nombre) async {
    final db = await baseAbierta;
    try {
      List<Map> list = await db.rawQuery('''
          SELECT codigo FROM Categoria where descripcion='$nombre'
    ''');

      if (list.isNotEmpty) {
        return list[0]['codigo'];
      } else {
        return '';
      }
    } catch (e) {
      return "";
    }
  }

  Future<dynamic> consultarMarcasPorFabricante(String fabricante) async {
    final db = await baseAbierta;

    try {
      final sql = await db.rawQuery('''
         select * from marca where 
         codigo in 
         (select marcacodigopideki from producto where fabricante = '$fabricante')
    ''');

      return sql.isNotEmpty ? sql.map((e) => Marcas.fromJson(e)).toList() : [];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> consultarCategoriasPorFabricante(String fabricante) async {
    final db = await baseAbierta;

    try {
      final sql = await db.rawQuery('''
      
      select codigo, descripcion from categoria WHERE CODIGO 
      IN (select categoriacodigopideki from producto where fabricante = '$fabricante')
      
    ''');

      return sql.isNotEmpty
          ? sql.map((e) => Categorias.fromJson(e)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> cargarProductosFiltroProveedores(
      String? codigo,
      int tipo,
      String buscador,
      double precioMinimo,
      double precioMaximo,
      String? codigoSubCategoria,
      String? codigoMarca,
      String codigoProveedor) async {
    final db = await baseAbierta;
    print('$tipo');
    try {
      final sql;
      String? consulta;
      if (codigoMarca != "" && codigoMarca != null) {
        consulta = "   and  p.marcacodigopideki=$codigoMarca";
      } else {
        consulta = "";
      }
      String? consulta2;
      if (codigoSubCategoria != "" && codigoSubCategoria != null) {
        consulta2 = " and p.subcategoriacodigopideki = $codigoSubCategoria";
      } else {
        consulta2 = "";
      }
      String? consulta3;
      if (codigo != "" && codigo != null) {
        consulta3 = " and p.categoriacodigopideki = $codigo  ";
      } else {
        consulta3 = "";
      }

      if (tipo == 5) {
        sql = await db.rawQuery('''
      SELECT p.codigo , p.nombre , 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, cast(ifnull(tmp.descuento,0.0) as float) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo
        FROM Producto p left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  (p.fabricante like '%$codigoProveedor%') 
        $consulta3
        $consulta2 
         AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%')
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo

        $consulta
        ORDER BY p.orden ASC
        
    ''');
        return sql.isNotEmpty
            ? sql.map((e) => Productos.fromJson(e)).toList()
            : [];
      }
      if (tipo == 1) {
        //tipo 1 para imperdibles
        sql = await db.rawQuery('''
  SELECT p.codigo , p.nombre , 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, cast(ifnull(tmp.descuento,0.0) as float) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo
        FROM Producto p left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        inner join ProductosNuevos pn ON p.codigo = pn.codigo 
        WHERE  (p.fabricante like '%$codigoProveedor%') 
        $consulta3  
        $consulta2
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
        $consulta
        ORDER BY p.orden ASC
        
    ''');

        return sql.isNotEmpty
            ? sql.map((e) => Productos.fromJson(e)).toList()
            : [];
      }
      if (tipo == 3) {
        //tipo 3 para marca e imperdible
        sql = await db.rawQuery('''
       SELECT p.codigo , p.nombre , 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, ifnull(tmp.descuento,0.0) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo
        FROM Producto p left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
           inner join ProductosNuevos pn ON p.codigo = pn.codigo 
        WHERE  (p.fabricante like '%$codigoProveedor%') 
        $consulta3
        $consulta2
        AND
        p.marcacodigopideki = '$codigo'
         AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%' )
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
        ORDER BY p.orden ASC
         
       ''');
        return sql.isNotEmpty
            ? sql.map((e) => Productos.fromJson(e)).toList()
            : [];
      }
      if (tipo == 6) {
        //tipo 6 para productos del dia
        String date = DateTime.now().toString();
        print(date);
        sql = await db.rawQuery('''
       SELECT p.codigo , p.nombre , 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, ifnull(tmp.descuento,0.0) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
          ,activopromocion, activoprodnuevo
         FROM Producto p left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  (p.fabricante like '%$codigoProveedor%') AND
        p.marcacodigopideki = '$codigo'  AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%' )
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo 
        and CAST(p.fechatrans AS date) = CAST('$date' AS date)
        ORDER BY p.orden ASC
         
       ''');
        return sql.isNotEmpty
            ? sql.map((e) => Productos.fromJson(e)).toList()
            : [];
      }
      if (tipo == 4) {
        //tipo 4 para marca  y promo
        sql = await db.rawQuery('''
       SELECT p.codigo , p.nombre , 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, ifnull(tmp.descuento,0.0) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
        ,activopromocion, activoprodnuevo
        FROM Producto p left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
          inner join Ofertas pn ON p.codigo = pn.codigo 
        WHERE  (p.fabricante like '%$codigoProveedor%') AND
        p.marcacodigopideki = '$codigo' AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%' )
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo 
        $consulta
        ORDER BY p.orden ASC
         
       ''');
        return sql.isNotEmpty
            ? sql.map((e) => Productos.fromJson(e)).toList()
            : [];
      } else {
        sql = await db.rawQuery('''
 SELECT p.codigo , p.nombre , 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, cast(ifnull(tmp.descuento,0.0) as float) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
        ,activopromocion, activoprodnuevo
        FROM Producto p left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
         inner join Ofertas pn ON p.codigo = pn.codigo 
        WHERE  (p.fabricante like '%$codigoProveedor%') 
        $consulta3
        $consulta2
        $consulta
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
        
        
    ''');
        return sql.isNotEmpty
            ? sql.map((e) => Productos.fromJson(e)).toList()
            : [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<String?> consultarProductoEnOfertaPorCodigo(String? codigo) async {
    final db = await baseAbierta;
    try {
      List<Map> list = await db.rawQuery('''
         SELECT codigo FROM Ofertas where codigo='$codigo'
    ''');

      if (list.isNotEmpty) {
        return list[0]['codigo'];
      } else {
        return '';
      }
    } catch (e) {
      return "";
    }
  }

  Future<dynamic> consultarMarcasFiltro(
    String? codigoCategoria,
    String? codigoSubcateegoria,
    int tipo,
  ) async {
    final db = await baseAbierta;
    //tipo 1 para filtrar por marca  y categoria
    // tipo 2 para filtrar por catergoria subcategoria y marca
    //tipo 3 para filtrar por subcategoria y marca
    try {
      dynamic sql;
      if (tipo == 1) {
        sql = await db.rawQuery('''
   select distinct marcapideki  as nombreMarca   
   from Producto where categoriacodigopideki=$codigoCategoria
      
    ''');
      } else if (tipo == 2) {
        sql = await db.rawQuery('''
   select distinct marcapideki  as nombreMarca  from Producto where categoriacodigopideki=$codigoCategoria and subcategoriacodigopideki=$codigoSubcateegoria
      
    ''');
      }
      if (tipo == 3) {
        sql = await db.rawQuery('''
   select distinct marcapideki  as nombreMarca  from Producto where subcategoriacodigopideki=$codigoSubcateegoria
      
    ''');
      }
      return sql.isNotEmpty
          ? sql.map((e) => MarcaFiltro.fromJson(e)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> cargarProductosFiltroCategoria(
      String? codigoCategoria,
      int tipo,
      double precioMinimo,
      double precioMaximo,
      String? codigoSubCategoria,
      String? codigoMarca) async {
    final db = await baseAbierta;
    try {
      final sql;
      String? consulta;
      if (codigoMarca != "" && codigoMarca != null) {
        consulta = "   and  p.marcacodigopideki=$codigoMarca";
      } else {
        consulta = "";
      }

      if (tipo == 1) {
        //tipo 1 para filtrar solo por marca, categoria y subcategoria
        sql = await db.rawQuery('''
            SELECT p.codigo , p.nombre , 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, cast(ifnull(tmp.descuento,0.0) as float) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo
        FROM Producto p left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  
      
        (p.categoriacodigopideki = $codigoCategoria  )
       and (p.subcategoriacodigopideki = $codigoSubCategoria)
         $consulta
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
        ORDER BY p.orden ASC
         
       ''');
        return sql.isNotEmpty
            ? sql.map((e) => Productos.fromJson(e)).toList()
            : [];
        //tipo 2 para productos mas vendidos
      } else if (tipo == 2) {
        sql = await db.rawQuery('''
         SELECT p.codigo , p.nombre , 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, ifnull(tmp.descuento,0.0) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
          ,activopromocion, activoprodnuevo
        FROM Producto p left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  
          (p.categoriacodigopideki = $codigoCategoria  )
       and (p.subcategoriacodigopideki = $codigoSubCategoria)
             $consulta
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo 
    
        
        and p.codigo in (select distinct codigoref from Historico  )
        ORDER BY p.orden ASC
         
       ''');
        return sql.isNotEmpty
            ? sql.map((e) => Productos.fromJson(e)).toList()
            : [];
      } else {
        //tipo 3 para imperdibles marcas, categorias y subc
        sql = await db.rawQuery('''
      SELECT p.codigo , p.nombre , 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, ifnull(tmp.descuento,0.0) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo
        FROM Producto p left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
           inner join ProductosNuevos pn ON p.codigo = pn.codigo 
        WHERE  
        (p.categoriacodigopideki = $codigoCategoria  )
       and (p.subcategoriacodigopideki = $codigoSubCategoria)
             $consulta
        AND
        p.marcacodigopideki = '$codigoMarca'
      
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
        ORDER BY p.orden ASC
        ''');
        return sql.isNotEmpty
            ? sql.map((e) => Productos.fromJson(e)).toList()
            : [];
      }
    } catch (e) {
      return [];
    }
  }
}
