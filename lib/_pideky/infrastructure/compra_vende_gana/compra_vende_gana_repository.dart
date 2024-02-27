import 'package:emart/_pideky/domain/compra_vende_gana/interface/i_compra_vende_gana.dart';
import 'package:emart/_pideky/domain/compra_vende_gana/model/compra_vende_gana_model.dart';
import 'package:emart/src/provider/db_provider.dart';

class ComprarVendeGanaRespository implements InterfaceCompraVendeGana {
  @override
  Future getCupons() async {
    final db = await DBProvider.db.baseAbierta;
    var sqlQuery = """
      SELECT DISTINCT
      cvg.Nombre as nombre,
      cvg.Codigo as codigo,
      cvg.Vende as vende,
      cvg.Gana as gana,
      cvg.Chispa as chispa,
      cvg.ValorChispa as valorChispa,
      cvg.ColorCupon as colorCupon,
      cvg.proveedor as proveedor,
      cvg.Link as link,
      cvg.ColorLetra1 as colorLetra1,
      cvg.ColorLetra2 as colorLetra2,
      cvg.ColorChispa as colorChispa,
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
          ) AS precio
      FROM CompraVendeGana cvg
      INNER JOIN
                Producto P ON P.Codigo = cvg.Codigo AND P.fabricante = cvg.proveedor
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
                Fabricante F ON F.empresa = P.Fabricante;
    """;
    try {
      var response = await db.rawQuery(sqlQuery);
      return response.isNotEmpty
          ? response.map((e) => CompraVendeGanaModel.fromJson(e)).toList()
          : [];
    } catch (e) {
      print("Error en getCupons compra vende gana $e");
      return [];
    }
  }
}
