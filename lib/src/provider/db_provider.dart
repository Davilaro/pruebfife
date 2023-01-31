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
import 'package:emart/_pideky/domain/producto/model/producto.dart';
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

      //   var query = '''

      //   SELECT c.codigo, c.descripcion, c.ico2 as ico
      //   FROM Categoria c
      //   INNER JOIN Producto p ON c.codigo = p.categoriacodigopideki
      //   WHERE c.codigo LIKE '%$buscar%'  OR c.descripcion LIKE '%$buscar%'

      //   GROUP BY p.categoriacodigopideki
      //   ORDER BY c.orden ASC $isLimit

      // ''';
      var query = ''' SELECT c.codigo, c.descripcion, c.ico2 as ico, c.orden 
            FROM Categoria c 
            INNER JOIN Producto p ON c.codigo = p.categoriacodigopideki 
            WHERE c.codigo LIKE '%$buscar%'  OR c.descripcion LIKE '%$buscar%'
            GROUP BY p.categoriacodigopideki
			UNION
			SELECT c.codigo, c.descripcion, c.ico2 as ico, c.orden 
            FROM Categoria c 
            INNER JOIN Producto p ON c.codigo = p.categoriaId2 
            WHERE c.codigo LIKE '%$buscar%'  OR c.descripcion LIKE '%$buscar%'
            GROUP BY p.categoriaId2
			ORDER by c.orden ASC ''';
      final sql = await db.rawQuery(query);

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
      var query = '''
SELECT s.codigo, s.descripcion, '' as ico, '' as fabricante, s.orden 
      FROM SubCategoria s 
      INNER JOIN Producto p ON s.codigo = p.subcategoriacodigopideki 
      WHERE s.cod_categoria = '$buscar' 
      GROUP BY p.subcategoriacodigopideki 
	  UNION 
	  SELECT s.codigo, s.descripcion, '' as ico, '' as fabricante , s.orden 
      FROM SubCategoria s 
      INNER JOIN Producto p ON s.codigo = p.subcategoriaId2 
      WHERE s.cod_categoria = '$buscar' 
      GROUP BY p.subcategoriaId2 ORDER by s.orden ASC
''';
      final sql = await db.rawQuery(query);

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
      var query = '''
      SELECT f.empresa, f.ico, f.codIndirecto, cast((SELECT pedidominimo FROM CondicionesEntrega
      WHERE Fabricante = f.empresa) as float) as pedidominimo,cast((SELECT topeminimo FROM CondicionesEntrega
      WHERE Fabricante = f.empresa ) as float) as topeMinimo, f.nombrecomercial, f.tipofabricante 
      FROM Fabricante f 
      WHERE f.empresa LIKE '%$buscar%' OR f.nombrecomercial LIKE '%$buscar%'
      GROUP BY f.empresa
      ORDER BY f.orden ASC 

    ''';

      final sql = await db.rawQuery(query);

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
      SELECT fa.empresa, fa.nombrecomercial, la.descripcion, la.Indicativo, la.telefonovendedor,
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
      var query = '''
      SELECT f.empresa, f.ico, f.codIndirecto, cast((SELECT pedidominimo FROM CondicionesEntrega
      WHERE Fabricante = f.empresa ) as float) as pedidominimo,cast((SELECT topeminimo FROM CondicionesEntrega
      WHERE Fabricante = f.empresa ) as float) as topeMinimo, (SELECT restrictivo FROM CondicionesEntrega
      WHERE Fabricante = f.empresa ) as restrictivo, f.nombrecomercial, f.tipofabricante
      FROM Fabricante f
      GROUP BY f.empresa
      ORDER BY f.orden ASC
      ''';
      final sql = await db.rawQuery(query);

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
   from Producto where categoriacodigopideki=$codigoCategoria or categoriaId2 = $codigoCategoria
      
    ''');
      } else if (tipo == 2) {
        sql = await db.rawQuery('''
   select distinct marcapideki  as nombreMarca  from Producto where categoriacodigopideki=$codigoCategoria 
   or categoriaId2 = $codigoCategoria and subcategoriacodigopideki=$codigoSubcateegoria or subcategoriaId2=$codigoSubcateegoria
      
    ''');
      }
      if (tipo == 3) {
        sql = await db.rawQuery('''
   select distinct marcapideki  as nombreMarca  from Producto where subcategoriacodigopideki=$codigoSubcateegoria or subcategoriaId2=$codigoSubcateegoria
      
    ''');
      }
      return sql.isNotEmpty
          ? sql.map((e) => MarcaFiltro.fromJson(e)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> consultarDocumentoLegal(String buscar) async {
    final db = await baseAbierta;

    try {
      var sql = await db.rawQuery('''
      
        SELECT URL FROM DocumentosLegales WHERE TipoDocumento LIKE '%$buscar%'
       
    ''');
      return sql.isNotEmpty ? sql[0]['URL'] : '';
    } catch (e) {
      return [];
    }
  }
}
