

import 'package:emart/_pideky/domain/marca/interface/i_marca_repository.dart';
import 'package:emart/_pideky/domain/marca/model/marca.dart';
import 'package:emart/src/provider/db_provider_helper.dart';

class MarcaRepositorySqlite extends IMarcaResporsitory {
  @override
  Future<List<Marca>> getAllMarcas() async {

    final db = await DBProviderHelper.db.baseAbierta;
    List<Marca> marcas = [];

    try {
      final sql = await db.rawQuery('''
      SELECT codigo, descripcion, ico  
      FROM Marca
    ''');


      marcas = sql.map((e) => Marca.fromJson(e)).toList();

      return marcas;
      
    } catch (e) {
      return [];
    }
  }
  
  @override
  Future<List<Marca>> consultarMarcas(String buscar) async {

    final db = await DBProviderHelper.db.baseAbierta;
    List<Marca> marcasConsultadas = [];

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

      marcasConsultadas = sql.map((e) => Marca.fromJson(e)).toList();

      return marcasConsultadas;
    } catch (e) {
      return [];
    }
  }
  }
  