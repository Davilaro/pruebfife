import 'package:emart/_pideky/domain/compra_vende_gana/interface/compra_vende_gana_interface.dart';
import 'package:emart/_pideky/domain/compra_vende_gana/model/compra_vende_gana_model.dart';
import 'package:emart/src/provider/db_provider_helper.dart';

class CompraVendeGanaRepository implements CompraVendeGanaInterface {
  @override
  Future<List<CompraVendeGanaModel?>> getCompraVendeGana() async {
    final db = await DBProviderHelper.db.baseAbierta;
    try {
      String query = """
        SELECT
          nombre,
          compra,
          vende,
          gana,
          chispa,
          valorChispa,
          codProducto1,
          codProducto2,
          colorCupon,
          proveedor,
          link,
          colorLetraGran,
          colorLetraPequ,
          colorChispa,
          cantidadProd1,
          cantidadProd2
        FROM
          CompraVendeGana
      """;
      final sql = await db.rawQuery(query);
      return sql.isNotEmpty
          ? sql.map((e) => CompraVendeGanaModel.fromJson(e)).toList()
          : [];
    } catch (e) {
      print('-----Error en getCompraVendeGana $e');
      return [];
    }
  }
}
