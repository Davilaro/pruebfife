import 'package:emart/_pideky/domain/brand/interface/interface_gate_way.dart';
import 'package:emart/_pideky/domain/brand/model/brand.dart';
import 'package:emart/src/provider/db_provider_helper.dart';

class MarcaRepositorySqlite extends InterfaceBrandGateWay {
  @override
  Future<List<Brand>> getAllMarcas() async {
    final db = await DBProviderHelper.db.baseAbierta;
    List<Brand> marcas = [];

    try {
      final sql = await db.rawQuery('''
      SELECT codigo, descripcion, ico  
      FROM Marca
    ''');

      marcas = sql.map((e) => Brand.fromJson(e)).toList();

      return marcas;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<Brand>> consultarMarcas(String buscar) async {
    final db = await DBProviderHelper.db.baseAbierta;
    List<Brand> marcasConsultadas = [];

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
      marcasConsultadas = sql.map((e) => Brand.fromJson(e)).toList();

      return marcasConsultadas;
    } catch (e) {
      print("error consultando marca $e");
      return [];
    }
  }
}
