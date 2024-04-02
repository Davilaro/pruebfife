import 'package:emart/_pideky/domain/statistics/interface/interface_statistics_gate_way.dart';
import 'package:emart/_pideky/domain/statistics/model/estadistica.dart';
import 'package:emart/src/provider/db_provider_helper.dart';

class EstadisticasRepositorySqlite extends InterfaceStatisticsGateWay {
  Future<List<Estadistica>> consultarTopMarcas() async {
    final db = await DBProviderHelper.db.baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT t.nit codigo, t.marca descripcion, t.cantidad cantidad, m.ico imagen
FROM TopMarcas t INNER JOIN marca m ON t.marca = m.descripcion order by cantidad DESC 
    ''');
      return sql.map((e) => Estadistica.fromJson(e)).toList();
    } catch (e) {
      print('-----Error en top de marcas $e');
      return [];
    }
  }

  Future<List<Estadistica>> consultarTopSubCategorias() async {
    final db = await DBProviderHelper.db.baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT nit codigo, subcategoria descripcion, cantidad cantidad 
FROM TopSubcategorias order by cantidad DESC 
    ''');
      return sql.map((e) => Estadistica.fromJson(e)).toList();
    } catch (e) {
      print('----Error en top de subcategorias $e');
      return [];
    }
  }

  Future<List<Estadistica>> consultarTopProductos() async {
    final db = await DBProviderHelper.db.baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT t.codigosku codigo, p.nombre descripcion, t.cantidad cantidad  
      FROM TopProductos t INNER JOIN Producto p ON t.codigosku = p.codigo order by cantidad DESC
    ''');
      return sql.map((e) => Estadistica.fromJson(e)).toList();
    } catch (e) {
      print('----Error en top de productos $e');
      return [];
    }
  }
}
