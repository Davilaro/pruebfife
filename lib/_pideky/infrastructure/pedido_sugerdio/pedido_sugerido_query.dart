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
        SELECT  CASE S.negocio WHEN 'AGCO' THEN 'NUTRESA' WHEN 'ADML' THEN 'MEALS' WHEN 'AANN' THEN 'ZENU' WHEN 'AFPZ' THEN 'POZUELO' END Negocio, S.Codigo, P.Nombre,
        round(((P.precio - (P.precio * ifnull(tmp.descuento,0) / 100))) +
        (P.precio - (P.precio * ifnull(tmp.descuento,0) / 100)) * P.iva /100,0) precio, S.Cantidad FROM pedidoSugerido S INNER JOIN Producto P
        ON P.Codigo = S.Codigo AND ((P.fabricante = 'NUTRESA' AND S.negocio = 'AGCO') OR (P.fabricante = 'ZENU' AND S.negocio = 'AANN') OR (P.fabricante = 'MEALS' AND S.negocio = 'ADML') OR
        (P.fabricante = 'POZUELO' AND S.negocio = 'AFPZ'))
        left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select count(P.codigo) identificador,*
        from descuentos D inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante group by material
        ) tmp where tmp.identificador = 1) tmp on P.fabricante = tmp.proveedor and P.codigo = tmp.codigo''');

      return sql.isNotEmpty
          ? sql.map((e) => PedidoSugeridoModel.fromJson(e)).toList()
          : [];
    } catch (err) {
      print('----Error consulta obtenerPedidoSugerido');
      return [];
    }
  }
}
