import 'package:emart/_pideky/domain/pedido_sugerdio/interface/i_pedido_sugerido_repositorio.dart';
import 'package:emart/_pideky/domain/pedido_sugerdio/model/pedido_sugerido.dart';
import 'package:emart/src/provider/db_provider.dart';

class PedidoSugeridoQuery implements IPedidoSugerido {
  final dataBase = DBProvider.db;

  @override
  Future<List<PedidoSugeridoModel>> obtenerPedidoSugerido() async {
    final db = await dataBase.baseAbierta;

    try {
      var sql = await db.rawQuery('''
    SELECT CASE S.negocio WHEN 'AGCO' THEN 'NUTRESA' WHEN 'ADML' THEN 'MEALS' WHEN 'AANN' THEN 'ZENU' END Negocio,
  S.Codigo, P.Nombre, P.Precio, S.Cantidad
  FROM pedidoSugerido S INNER JOIN Producto P ON P.Codigo = S.Codigo
''');
      print("$sql-------------");
      return sql.isNotEmpty
          ? sql.map((e) => PedidoSugeridoModel.fromJson(e)).toList()
          : [];
    } catch (err) {
      return [];
    }
  }
}
