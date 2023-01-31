import 'package:emart/_pideky/domain/estadistica/interface/i_estadistica_repository.dart';
import 'package:emart/_pideky/domain/estadistica/model/estadistica.dart';
import 'package:emart/src/provider/db_provider_helper.dart';

class EstadisticasRepositorySqlite extends IEstadisticaRepository {
  Future<List<Estadistica>> consultarTopMarcas() async {
    final db = await DBProviderHelper.db.baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT t.nit codigo, t.marca descripcion, t.cantidad cantidad, t.CantidadP posicion, m.ico imagen
FROM TopMarcas t INNER JOIN marca m ON t.marca = m.descripcion order by posicion DESC, cantidad DESC
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
      SELECT nit codigo, subcategoria descripcion, cantidad cantidad, CantidadP posicion
FROM TopSubcategorias order by posicion DESC, cantidad DESC
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
      SELECT t.codigosku codigo, p.nombre descripcion, t.cantidad cantidad, t.cantidadP posicion  
      FROM TopProductos t INNER JOIN Producto p ON t.codigosku = p.codigo order by posicion ASC
    ''');
      return sql.map((e) => Estadistica.fromJson(e)).toList();
    } catch (e) {
      print('----Error en top de productos $e');
      return [];
    }
  }
}
