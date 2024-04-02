import 'package:emart/_pideky/domain/suggested_order/interface/interface_suggested_order_gate_way.dart';
import 'package:emart/_pideky/domain/suggested_order/model/suggested_order_model.dart';
import 'package:emart/src/provider/db_provider.dart';

class PedidoSugeridoQuery implements IPedidoSugerido {
  final dataBase = DBProvider.db;

  @override
  Future<List<SuggestedOrderModel>> obtenerPedidoSugerido() async {
    final db = await dataBase.baseAbierta;

    try {
      var sql = await db.rawQuery('''
          SELECT DISTINCT
          S.negocio AS Negocio,
          S.Codigo,
          P.Nombre,
          CAST(
            ROUND(
                (p.precio + ((p.precio * p.iva) / 100) + (
                            CASE
                                WHEN p.ICUI = 0 THEN p.IBUA
                                ELSE ((p.precio * p.ICUI) / 100)
                            END
                        ) ), 0
            ) AS FLOAT
          ) AS precioinicial,
              IFNULL(tmp.descuento, 0.0) AS descuento, 
          ROUND(
              (
                  (p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)) + 
                  (
                      CASE
                          WHEN p.ICUI = 0 THEN p.IBUA
                          ELSE (((p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                      END
                  ) + 
                  ((p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)) * p.iva / 100)
              ), 0
          ) AS precio,
          S.Cantidad,
          F.BloqueoCartera
        FROM
          pedidoSugerido S
        INNER JOIN
          Producto P ON P.Codigo = S.Codigo AND P.fabricante = S.Negocio
        LEFT JOIN
          (
              SELECT
                  tmp.proveedor,
                  tmp.material AS codigo,
                  tmp.descuento
              FROM
                  (
                      SELECT
                          COUNT(P.codigo) AS identificador,
                          *
                      FROM
                          descuentos D
                      INNER JOIN
                          producto P ON P.codigo = D.material AND D.proveedor = P.fabricante
                      GROUP BY
                          material
                  ) tmp
              WHERE
                  tmp.identificador = 1
          ) tmp ON P.fabricante = tmp.proveedor AND P.codigo = tmp.codigo
        INNER JOIN
          Fabricante F ON F.empresa = P.Fabricante; ''');
      return sql.isNotEmpty
          ? sql.map((e) => SuggestedOrderModel.fromJson(e)).toList()
          : [];
    } catch (err) {
      print('----Error consulta obtenerPedidoSugerido $err');
      return [];
    }
  }
}
