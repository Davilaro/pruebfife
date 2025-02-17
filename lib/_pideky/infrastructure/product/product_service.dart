import 'dart:convert';

import 'package:emart/_pideky/domain/product/interface/interface_producto_gate_way.dart';
import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:http/http.dart' as http;

class ProductoRepositorySqlite extends IProductoRepository {
  Future<Product> consultarDatosProducto(String producto) async {
    final db = await DBProviderHelper.db.baseAbierta;

    final sql = await db.rawQuery('''
      SELECT p.*, p.Negocio as negocio ,f.codigo as codigoFabricante, f.nit as nitFabricante FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa where p.codigo like '%$producto%' limit 1
    ''');

    return Product.fromJson(sql.first);
  }

  Future<dynamic> consultarSugerido() async {
    final db = await DBProvider.db.baseAbierta;

    try {
      final sql = await db.rawQuery('''
       
        SELECT 
    p.codigo,
    p.nombre,
    f.codigo AS codigoFabricante,
    f.nit AS nitFabricante,
    ROUND(
        (
           (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS precio,
    p.marca,
    p.categoria,
    p.Negocio as negocio,
    p.iva,
    p.fabricante,
    p.marcapideki,
    p.tipofabricante,
    p.marcacodigopideki,
    p.categoriacodigopideki,
    p.subcategoriacodigopideki,
    p.nombrecomercial,
    p.codigocliente,
    p.orden,
    0.0 AS descuento,
    0.0 AS preciodescuento,
    CAST(ROUND((p.precio + ((p.precio * p.iva) / 100) + (
            CASE
                WHEN p.ICUI = 0 THEN p.IBUA
                ELSE ((p.precio * p.ICUI) / 100)
            END
        ) ), 0) AS FLOAT) AS precioinicial,
    SUBSTR(fechafinnuevo, 7, 4) || '-' || SUBSTR(fechafinnuevo, 4, 2) || '-' || (SUBSTR(fechafinnuevo, 1, 2)) AS fechafinnuevo_1,
    SUBSTR(fechafinpromocion, 7, 4) || '-' || SUBSTR(fechafinpromocion, 4, 2) || '-' || SUBSTR(fechafinpromocion, 1, 2) AS fechafinpromocion_1,
    activopromocion,
    activoprodnuevo,
    CASE WHEN pn.codigo IS NOT NULL THEN 1 ELSE 0 END AS isOferta
FROM 
    Producto p
JOIN 
    fabricante f ON p.fabricante = f.empresa
LEFT JOIN 
    Ofertas pn ON p.codigo = pn.codigo
LEFT JOIN 
    (
        SELECT 
            tmp.proveedor, 
            tmp.material codigo, 
            tmp.descuento 
        FROM 
            (
                SELECT 
                    (SELECT COUNT(*) FROM descuentos de WHERE de.rowid >= d.rowid AND de.material = d.material) identificador, * 
                FROM 
                    descuentos d
                INNER JOIN 
                    producto p ON p.codigo = d.material AND d.proveedor = p.fabricante
            ) tmp 
        WHERE tmp.identificador = 1
    ) tmp ON p.fabricante = tmp.proveedor AND p.codigo = tmp.codigo
GROUP BY 
    p.codigo 
ORDER BY 
    p.nombre ASC;


    ''');

      return sql.isNotEmpty
          ? sql.map((e) => Product.fromJson(e)).toList()
          : [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> cargarProductos(
      String? codigo,
      int tipo,
      String buscador,
      double precioMinimo,
      double precioMaximo,
      String? codigoMarca,
      String codigoProveedor) async {
    final db = await DBProvider.db.baseAbierta;
    try {
      var query = '';
      final sql;
      String? consulta;
      if (codigoMarca != "" && codigoMarca != null) {
        consulta = "   and  p.marcacodigopideki=$codigoMarca";
      } else {
        consulta = "";
      }

      if (tipo == 2) {
        query = '''
      SELECT 
    p.codigo, 
    p.nombre, 
    f.codigo as codigoFabricante, 
    f.nit as nitFabricante, 
    f.BloqueoCartera as bloqueoCartera, 
    p.OrdenMarca as ordenMarca, 
    p.Negocio as negocio,
    p.Combo as combo,
    p.OrdenSubcategoria as ordenSubcategoria,
    pn.CantidadMaxima,
    pn.CantidadSolicitada,
    ROUND(
        (
           (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS precio,
    p.marca, 
    p.categoria, 
    p.iva, 
    p.fabricante, 
    p.marcapideki, 
    p.tipofabricante, 
    p.marcacodigopideki, 
    p.categoriacodigopideki, 
    p.categoriaId2,
    p.subcategoriaId2, 
    p.subcategoriacodigopideki, 
    p.nombrecomercial, 
    p.codigocliente,  
    P.precio as precioBase,
    p.orden, 
    IFNULL(tmp.descuento, 0.0) AS descuento, 
    ROUND(
              (
                  (
                      p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                  )
              ), 0
          ) AS precioConDescuento,
    ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS preciodescuento,
    CAST(
        ROUND(
            (p.precio + ((p.precio * p.iva) / 100) + (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((p.precio * p.ICUI) / 100)
                END
            )), 0
        ) AS FLOAT
    ) AS precioinicial,
    SUBSTR(fechafinnuevo, 7, 4) || '-' || SUBSTR(fechafinnuevo, 4, 2) || '-' || SUBSTR(fechafinnuevo, 1, 2) AS fechafinnuevo_1,
    SUBSTR(fechafinpromocion, 7, 4) || '-' || SUBSTR(fechafinpromocion, 4, 2) || '-' || SUBSTR(fechafinpromocion, 1, 2) AS fechafinpromocion_1,
    activopromocion, 
    activoprodnuevo,
    CASE WHEN pn.codigo IS NOT NULL THEN 1 ELSE 0 END AS isOferta
FROM 
    Producto p
JOIN 
    fabricante f ON p.fabricante = f.empresa
LEFT JOIN Ofertas pn ON p.codigo = pn.codigo
      LEFT JOIN 
    (
        SELECT 
            tmp.proveedor, 
            tmp.material codigo, 
            tmp.descuento 
        FROM 
            (
                SELECT 
                    (SELECT COUNT(*) FROM descuentos de WHERE de.rowid >= d.rowid AND de.material = d.material) identificador, * 
                FROM 
                    descuentos d
                INNER JOIN 
                    producto p ON p.codigo = d.material AND d.proveedor = p.fabricante
            ) tmp 
        WHERE tmp.identificador = 1
    ) tmp ON p.fabricante = tmp.proveedor AND p.codigo = tmp.codigo
WHERE  
    (p.fabricante LIKE '%$codigoProveedor%') 
    AND 
    (
        (p.subcategoriacodigopideki = '$codigo' OR p.subcategoriaId2 = '$codigo') 
        AND 
        (p.codigo LIKE '%$buscador%' OR p.nombre LIKE '%$buscador%')
    )
    AND ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) >= $precioMinimo
    AND ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) <= $precioMaximo
    $consulta
ORDER BY p.orden ASC


        
    ''';
      } else if (tipo == 3) {
        query = '''
       SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante, f.BloqueoCartera as  bloqueoCartera,
       p.OrdenMarca as ordenMarca, p.OrdenSubcategoria as ordenSubcategoria,
       p.Negocio as negocio,
       p.precio as precioBase,
       pn.CantidadMaxima,
       pn.CantidadSolicitada,
        ROUND(
        (
           (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS precio,
         p.marca , p.categoria   , p.iva , p.fabricante  , p.marcapideki , p.tipofabricante , 
         p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.categoriaId2,
			  p.subcategoriaId2, 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente,  p.orden, IFNULL(tmp.descuento, 0.0) AS descuento, 
    ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS preciodescuento,
    ROUND(
              (
                  (
                      p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                  ) 
              ), 0
          ) AS precioConDescuento,
    CAST(
        ROUND(
            (p.precio + ((p.precio * p.iva) / 100) + (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((p.precio * p.ICUI) / 100)
                END
            )), 0
        ) AS FLOAT
    ) AS precioinicial, substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo,
         CASE WHEN pn.codigo IS NOT NULL THEN 1 ELSE 0 END AS isOferta
        FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join Ofertas pn ON p.codigo = pn.codigo
      LEFT JOIN (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  (p.fabricante like '%$codigoProveedor%') AND
        p.marcacodigopideki = $codigo  AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%' )
        AND p.Combo = 0 AND ROUND(
        (
           (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) >= $precioMinimo
    AND ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) <= $precioMaximo
        $consulta
        ORDER BY p.OrdenMarca ASC

         
       ''';
      } else if (tipo == 4) {
        query = '''
      SELECT 
    p.codigo, 
    p.nombre, 
    f.codigo as codigoFabricante, 
    f.nit as nitFabricante, 
    f.BloqueoCartera as bloqueoCartera, 
    p.Negocio as negocio,
    p.precio as precioBase,
    p.Combo as combo,
    pn.CantidadMaxima,
    pn.CantidadSolicitada,
    ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS precio, 
    p.marca, 
    p.categoria, 
    p.iva, 
    p.fabricante, 
    p.marcapideki, 
    p.tipofabricante, 
    p.marcacodigopideki, 
    p.categoriacodigopideki, 
    p.categoriaId2,
    p.subcategoriaId2, 
    p.subcategoriacodigopideki, 
    p.nombrecomercial, 
    p.codigocliente,  
    p.orden, 
    IFNULL(tmp.descuento, 0.0) AS descuento, 
    ROUND(
              (
                  (
                      p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                  ) 
              ), 0
          ) AS precioConDescuento,
    ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS preciodescuento,
    CAST(
        ROUND(
            (p.precio + ((p.precio * p.iva) / 100) + (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((p.precio * p.ICUI) / 100)
                END
            )), 0
        ) AS FLOAT
    ) AS precioinicial, 
    SUBSTR(fechafinnuevo, 7, 4) || '-' || SUBSTR(fechafinnuevo, 4, 2) || '-' || (SUBSTR(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
    SUBSTR(fechafinpromocion, 7, 4) || '-' || SUBSTR(fechafinpromocion, 4, 2) || '-' || SUBSTR(fechafinpromocion, 1, 2) as fechafinpromocion_1, 
    activopromocion, 
    activoprodnuevo,
    CASE WHEN pn.codigo IS NOT NULL THEN 1 ELSE 0 END AS isOferta
FROM 
    Producto p
JOIN 
    fabricante f ON p.fabricante = f.empresa
LEFT JOIN 
    Ofertas pn ON p.codigo = pn.codigo
LEFT JOIN 
    (
        SELECT 
            tmp.proveedor, 
            tmp.material codigo, 
            tmp.descuento 
        FROM 
            (
                SELECT 
                    (SELECT COUNT(*) FROM descuentos de WHERE de.rowid >= d.rowid AND de.material = d.material) identificador, * 
                FROM 
                    descuentos d
                INNER JOIN 
                    producto p ON p.codigo = d.material AND d.proveedor = p.fabricante
            ) tmp 
        WHERE tmp.identificador = 1
    ) tmp ON p.fabricante = tmp.proveedor AND p.codigo = tmp.codigo
WHERE  
    (p.fabricante LIKE '%$codigoProveedor%') 
    AND 
    (p.codigo LIKE '%$buscador%' OR p.nombre LIKE '%$buscador%') 
     AND ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) >= $precioMinimo
    AND ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) <= $precioMaximo
ORDER BY 
    p.OrdenProveedores ASC;

         
      ''';
      } else if (tipo == 5) {
        query = '''
      SELECT 
    p.codigo, 
    p.nombre, 
    f.codigo as codigoFabricante, 
    f.nit as nitFabricante, 
    p.Negocio as negocio,
    f.BloqueoCartera as bloqueoCartera, 
    p.Combo as combo,
    p.precio as precioBase,
    pn.CantidadMaxima,
    pn.CantidadSolicitada,
    ROUND(
        (
           (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS precio, 
    p.marca, 
    p.categoria, 
    p.iva, 
    p.fabricante, 
    p.marcapideki, 
    p.tipofabricante, 
    p.marcacodigopideki, 
    p.categoriacodigopideki, 
    p.categoriaId2,
    p.subcategoriaId2, 
    p.subcategoriacodigopideki, 
    p.nombrecomercial, 
    p.codigocliente,  
    p.orden, 
    IFNULL(tmp.descuento, 0.0) AS descuento, 
    ROUND(
              (
                  (
                      p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                  ) 
              ), 0
          ) AS precioConDescuento,
    ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS preciodescuento,
    CAST(
        ROUND(
            (p.precio + ((p.precio * p.iva) / 100) + (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((p.precio * p.ICUI) / 100)
                END
            )), 0
        ) AS FLOAT
    ) AS precioinicial, 
    SUBSTR(fechafinnuevo, 7, 4) || '-' || SUBSTR(fechafinnuevo, 4, 2) || '-' || (SUBSTR(fechafinnuevo, 1, 2)) as fechafinnuevo_1, 
    SUBSTR(fechafinpromocion, 7, 4) || '-' || SUBSTR(fechafinpromocion, 4, 2) || '-' || SUBSTR(fechafinpromocion, 1, 2) as fechafinpromocion_1, 
    activopromocion, 
    activoprodnuevo,
    CASE WHEN pn.codigo IS NOT NULL THEN 1 ELSE 0 END AS isOferta
FROM 
    Producto p
JOIN 
    fabricante f ON p.fabricante = f.empresa
LEFT JOIN 
    Ofertas pn ON p.codigo = pn.codigo
LEFT JOIN 
    (
        SELECT 
            tmp.proveedor, 
            tmp.material codigo, 
            tmp.descuento 
        FROM 
            (
                SELECT 
                    (SELECT COUNT(*) FROM descuentos de WHERE de.rowid >= d.rowid AND de.material = d.material) identificador, * 
                FROM 
                    descuentos d
                INNER JOIN 
                    producto p ON p.codigo = d.material AND d.proveedor = p.fabricante
            ) tmp 
        WHERE tmp.identificador = 1
    ) tmp ON p.fabricante = tmp.proveedor AND p.codigo = tmp.codigo
WHERE  
    (p.fabricante LIKE '%$codigoProveedor%') 
    AND 
    (
        (p.categoriacodigopideki = '$codigo' OR p.categoriaId2 = '$codigo') 
        AND 
        (p.codigo LIKE '%$buscador%' OR p.nombre LIKE '%$buscador%')
    )
     AND ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) >= $precioMinimo
    AND ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) <= $precioMaximo
ORDER BY 
    p.orden ASC;

         
      ''';
      } else if (tipo == 7) {
        //tipo para productos mas vendidos
        query = '''
       SELECT 
    p.codigo, 
    p.nombre, 
    f.codigo as codigoFabricante,
    p.Negocio as negocio, 
    f.nit as nitFabricante, 
    f.BloqueoCartera as bloqueoCartera, 
    p.Combo as combo,
    pn.CantidadMaxima,
    pn.CantidadSolicitada,
    ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS precio, 
    p.marca, 
    p.categoria, 
    p.iva, 
    p.fabricante, 
    p.marcapideki, 
    p.tipofabricante, 
    p.marcacodigopideki, 
    p.categoriacodigopideki, 
    p.categoriaId2,
    p.subcategoriaId2, 
    p.subcategoriacodigopideki, 
    p.nombrecomercial, 
    p.codigocliente,  
    p.orden, 
    p.precio as precioBase,
    IFNULL(tmp.descuento, 0.0) AS descuento, 
    ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS preciodescuento,
    ROUND(
              (
                  (
                      p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                  )
              ), 0
          ) AS precioConDescuento,
    CAST(
        ROUND(
            (p.precio + ((p.precio * p.iva) / 100) + (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((p.precio * p.ICUI) / 100)
                END
            )), 0
        ) AS FLOAT
    ) AS precioinicial, 
    SUBSTR(fechafinnuevo, 7, 4) || '-' || SUBSTR(fechafinnuevo, 4, 2) || '-' || (SUBSTR(fechafinnuevo, 1, 2)) as fechafinnuevo_1, 
    SUBSTR(fechafinpromocion, 7, 4) || '-' || SUBSTR(fechafinpromocion, 4, 2) || '-' || SUBSTR(fechafinpromocion, 1, 2) as fechafinpromocion_1, 
    activopromocion, 
    activoprodnuevo,
    CASE WHEN pn.codigo IS NOT NULL THEN 1 ELSE 0 END AS isOferta
FROM 
    Producto p
JOIN 
    fabricante f ON p.fabricante = f.empresa
LEFT JOIN 
    Ofertas pn ON p.codigo = pn.codigo
LEFT JOIN 
    (
        SELECT 
            tmp.proveedor, 
            tmp.material codigo, 
            tmp.descuento 
        FROM 
            (
                SELECT 
                    (SELECT COUNT(*) FROM descuentos de WHERE de.rowid >= d.rowid AND de.material = d.material) identificador, * 
                FROM 
                    descuentos d
                INNER JOIN 
                    producto p ON p.codigo = d.material AND d.proveedor = p.fabricante
            ) tmp 
        WHERE tmp.identificador = 1
    ) tmp ON p.fabricante = tmp.proveedor AND p.codigo = tmp.codigo
WHERE  
    (p.fabricante LIKE '%$codigoProveedor%') 
    AND 
    (
        (p.marcacodigopideki = $codigo) 
        AND 
        (p.codigo LIKE '%$buscador%' OR p.nombre LIKE '%$buscador%')
    )
    AND ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) >= $precioMinimo
    AND ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) <= $precioMaximo
    AND p.codigo IN (SELECT DISTINCT codigoref FROM Historico)
ORDER BY 
    p.orden ASC;

         
      ''';
      } else {
        query = '''
       SELECT 
    p.codigo, 
    p.nombre, 
    f.codigo as codigoFabricante, 
    f.nit as nitFabricante, 
    f.BloqueoCartera as bloqueoCartera,
    p.precio as precioBase,
    p.Combo as combo,
    pn.CantidadMaxima,
    pn.CantidadSolicitada,
    ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS precio,
    p.marca, 
    p.categoria, 
    p.Negocio as negocio,
    p.iva, 
    p.fabricante, 
    p.marcapideki, 
    p.tipofabricante, 
    p.marcacodigopideki, 
    p.categoriacodigopideki, 
    p.categoriaId2,
    p.subcategoriaId2,
    p.subcategoriacodigopideki, 
    p.nombrecomercial, 
    p.codigocliente, 
    p.orden, 
    p.precio as precioBase,
    IFNULL(tmp.descuento, 0.0) AS descuento, 
    ROUND(
              (
                  (
                      p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                  ) 
              ), 0
          ) AS precioConDescuento,
    ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS preciodescuento,
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
    SUBSTR(fechafinnuevo, 7, 4) || '-' || SUBSTR(fechafinnuevo, 4, 2) || '-' || SUBSTR(fechafinnuevo, 1, 2) AS fechafinnuevo_1,
    SUBSTR(fechafinpromocion, 7, 4) || '-' || SUBSTR(fechafinpromocion, 4, 2) || '-' || SUBSTR(fechafinpromocion, 1, 2) AS fechafinpromocion_1,
    activopromocion, 
    activoprodnuevo,
    CASE WHEN pn.codigo IS NOT NULL THEN 1 ELSE 0 END AS isOferta
FROM 
    Producto p
JOIN 
    fabricante f ON p.fabricante = f.empresa
LEFT JOIN 
    Ofertas pn ON p.codigo = pn.codigo
LEFT JOIN 
    (
        SELECT 
            tmp.proveedor, 
            tmp.material codigo, 
            tmp.descuento 
        FROM 
            (
                SELECT 
                    (SELECT COUNT(*) FROM descuentos de WHERE de.rowid >= d.rowid AND de.material = d.material) identificador, * 
                FROM 
                    descuentos d
                INNER JOIN 
                    producto p ON p.codigo = d.material AND d.proveedor = p.fabricante
            ) tmp 
        WHERE tmp.identificador = 1
    ) tmp ON p.fabricante = tmp.proveedor AND p.codigo = tmp.codigo
WHERE  
    (p.fabricante LIKE '%$codigoProveedor%') AND
    (p.codigo LIKE '%$buscador%' OR p.nombre LIKE '%$buscador%' )
    AND ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE (((p.precio * IFNULL(tmp.descuento, 0) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) >= $precioMinimo
    AND ROUND(
        (
           (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) <= $precioMaximo
$consulta
ORDER BY p.orden ASC;

         
        ''';
      }
      //log(query);
      // print("tipo $tipo");

      sql = await db.rawQuery(query);

      return sql.isNotEmpty
          ? sql.map((e) => Product.fromJson(e)).toList()
          : [];
    } catch (e) {
      print('Error consulta cargarProductos $e');
      return [];
    }
  }

  Future<List<dynamic>> cargarProductosInterno(
  int tipoProducto,
  String buscador,
  double precioMinimo,
  double precioMaximo,
  int limit,
  String? codigoMarca,
  String codigoProveedor,
) async {
  final db = await DBProvider.db.baseAbierta;

  try {
    final isLimit = limit != 0 ? "LIMIT $limit" : "";

    final query;
    final sql;
    String? consulta;
    if (codigoMarca != "" && codigoMarca != null) {
      consulta = "   and  p.marcacodigopideki=$codigoMarca";
    } else {
      consulta = "";
    }

    if (tipoProducto == 2) {
      query = '''
      SELECT p.codigo , p.nombre ,f.codigo as codigoFabricante, f.nit as nitFabricante, 
      p.Negocio as negocio,
      f.BloqueoCartera as  bloqueoCartera,  ROUND(
      (
          (
              p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
          ) + 
          (
              CASE
                  WHEN p.ICUI = 0 THEN p.IBUA
                  ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
              END
          ) + 
          (
              (
                  p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
              ) * p.iva / 100
          )
      ), 0
  ) AS precio,  
       p.marca , p.categoria   , p.iva , p.fabricante  , p.marcapideki , p.tipofabricante , 
       p.marcacodigopideki , 
      p.categoriacodigopideki , 
      p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente,  pn.orden_imperdible as orden, 0.0 as descuento, 
      0.0 as  preciodescuento,
      CAST(ROUND((p.precio + ((p.precio * p.iva) / 100) + (
                      CASE
                          WHEN p.ICUI = 0 THEN p.IBUA
                          ELSE ((p.precio * p.ICUI) / 100)
                      END
                  ) ), 0) AS FLOAT) AS precioinicial, substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
  substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
      ,activopromocion, activoprodnuevo
      FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa 
      left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
      select count(p.codigo) identificador,* 
      from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante group by material
      ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
      inner join ProductosNuevos pn ON p.codigo = pn.codigo 
      WHERE (p.fabricante like '%$codigoProveedor%') AND 
      (p.codigo LIKE '%$buscador%' OR p.nombre LIKE '%$buscador%')
        AND ROUND(
              (
                  (
              p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
          ) + 
          (
              CASE
                  WHEN p.ICUI = 0 THEN p.IBUA
                  ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
              END
          ) + 
          (
              (
                  p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
              ) * p.iva / 100
          )
              ), 0
          ) >= $precioMinimo
          AND ROUND(
              (
                 (
              p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
          ) + 
          (
              CASE
                  WHEN p.ICUI = 0 THEN p.IBUA
                  ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
              END
          ) + 
          (
              (
                  p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
              ) * p.iva / 100
          )
              ), 0
          ) <= $precioMaximo
      AND p.Combo = 0
      $consulta
      ORDER BY p.OrdenImperdibles ASC $isLimit 
       
  ''';
      //log(query);
      sql = await db.rawQuery(query);
    } else {
      query = '''
    SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante, f.BloqueoCartera as  bloqueoCartera,
    p.Negocio as negocio,
    ROUND(
      (
         (
              p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
          ) + 
          (
              CASE
                  WHEN p.ICUI = 0 THEN p.IBUA
                  ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
              END
          ) + 
          (
              (
                  p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
              ) * p.iva / 100
          )
      ), 0
  ) AS precio,   
     p.marca , p.categoria   , p.iva , p.fabricante  , p.marcapideki , p.tipofabricante , 
     p.marcacodigopideki , 
    p.categoriacodigopideki , 
    p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.OrdenPromos as orden, IFNULL(tmp.descuento, 0.0) AS descuento, 
  ROUND(
      (
          (
              p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
          ) + 
          (
              CASE
                  WHEN p.ICUI = 0 THEN p.IBUA
                  ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
              END
          ) + 
          (
              (
                  p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
              ) * p.iva / 100
          )
      ), 0
  ) AS preciodescuento,
  CAST(
      ROUND(
          (p.precio + ((p.precio * p.iva) / 100) + (
              CASE
                  WHEN p.ICUI = 0 THEN p.IBUA
                  ELSE ((p.precio * p.ICUI) / 100)
              END
          )), 0
      ) AS FLOAT
  ) AS precioinicial, substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
     ,activopromocion, activoprodnuevo
    FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa 
    left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
    select count(p.codigo) identificador,* 
    from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante group by material
    ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
    inner join Ofertas pn ON p.codigo = pn.codigo 
    WHERE  (p.fabricante like '%$codigoProveedor%') AND
    (p.codigo LIKE '%$buscador%' OR p.nombre LIKE '%$buscador%')
    AND ROUND(
              (
                  (
              p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
          ) + 
          (
              CASE
                  WHEN p.ICUI = 0 THEN p.IBUA
                  ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
              END
          ) + 
          (
              (
                  p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
              ) * p.iva / 100
          )
              ), 0
          ) >= $precioMinimo
          AND ROUND(
              (
                 (
              p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
          ) + 
          (
              CASE
                  WHEN p.ICUI = 0 THEN p.IBUA
                  ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
              END
          ) + 
          (
              (
                  p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
              ) * p.iva / 100
          )
              ), 0
          ) <= $precioMaximo
    AND p.Combo = 0
    $consulta
    UNION 
    SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante, f.BloqueoCartera as  bloqueoCartera, 
    p.Negocio as negocio,
    ROUND(
      (
          (
              p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
          ) + 
          (
              CASE
                  WHEN p.ICUI = 0 THEN p.IBUA
                  ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
              END
          ) + 
          (
              (
                  p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
              ) * p.iva / 100
          )
      ), 0
  ) AS precio, 
     p.marca , p.categoria   , p.iva , p.fabricante  , p.marcapideki , p.tipofabricante , 
     p.marcacodigopideki , 
    p.categoriacodigopideki , 
    p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente,  p.OrdenPromos as orden,  IFNULL(tmp.descuento, 0.0) AS descuento, 
  ROUND(
      (
          (
              p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
          ) + 
          (
              CASE
                  WHEN p.ICUI = 0 THEN p.IBUA
                  ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
              END
          ) + 
          (
              (
                  p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
              ) * p.iva / 100
          )
      ), 0
  ) AS preciodescuento,
  CAST(
      ROUND(
          (p.precio + ((p.precio * p.iva) / 100) + (
              CASE
                  WHEN p.ICUI = 0 THEN p.IBUA
                  ELSE ((p.precio * p.ICUI) / 100)
              END
          )), 0
      ) AS FLOAT
  ) AS precioinicial, substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
      ,activopromocion, activoprodnuevo
    FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join Ofertas pn ON p.codigo = pn.codigo left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
    select count(p.codigo) identificador,* 
    from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante group by material
    ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
    WHERE  (p.fabricante like '%$codigoProveedor%') AND
    (p.codigo like '%$buscador%' OR p.nombre like '%$buscador%') AND tmp.descuento > 0 
    AND ROUND(
              (
                  (
                      p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                  ) + 
                  (
                      CASE
                          WHEN p.ICUI = 0 THEN p.IBUA
                          ELSE ((p.precio * p.ICUI) / 100)
                      END
                  ) + 
                  (
                      (
                          p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                      ) * p.iva / 100
                  )
              ), 0
          ) >= $precioMinimo
          AND ROUND(
              (
                  (
              p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
          ) + 
          (
              CASE
                  WHEN p.ICUI = 0 THEN p.IBUA
                  ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
              END
          ) + 
          (
              (
                  p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
              ) * p.iva / 100
          )
              ), 0
          ) <= $precioMaximo
    AND p.Combo = 0
    ORDER BY p.OrdenPromos ASC
       
   ''';
      //log(query);

      sql = await db.rawQuery(query);
    }
    //log(sql);
    return sql.isNotEmpty
        ? sql.map((e) => Product.fromJson(e)).toList()
        : [];
  } catch (e) {
    print('Error consulta cargarProductosInterno $e');
    return [];
  }
}


  Future<List<Product>> cargarProductosFiltro(
      String? buscar, String codigoProveedor) async {
    final db = await DBProvider.db.baseAbierta;

    try {
      List<Product> lista = [];
      var condicion = buscar != '' ? ' AND p.codigo LIKE "%$buscar%" ' : ' ';
      String query = '''
       SELECT p.codigo , p.nombre ,f.codigo as codigoFabricante, f.nit as nitFabricante, f.BloqueoCartera as  bloqueoCartera, ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS precio,
         p.marca , p.categoria   , p.iva , p.fabricante  , p.marcapideki , p.tipofabricante , 
         p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.Negocio as negocio,
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente,  p.orden, 0.0 as descuento, 
        0.0 as  preciodescuento,
        CAST(ROUND((p.precio + ((p.precio * p.iva) / 100) + (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((p.precio -(p.precio * IFNULL(tmp.descuento, 0) / 100) * p.ICUI) / 100)
                END
            ) ), 0) AS FLOAT) AS precioinicial
        FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa 
        left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select count(p.codigo) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante group by material
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo 
        where p.Combo = 0
        $condicion
        ORDER BY p.orden ASC 
         
    ''';
      //log(query);
      List<Map> sql = await db.rawQuery(query);

      lista = List<Product>.from(sql.map((x) => Product.fromJson2(x)));

      return lista;
    } catch (e) {
      print('error consulta fitro');
      return [];
    }
  }

  Future<List<dynamic>> cargarProductosFiltroProveedores(
      String? codigo,
      int tipo,
      String buscador,
      double precioMinimo,
      double precioMaximo,
      String? codigoSubCategoria,
      String? codigoMarca,
      String codigoProveedor) async {
    final db = await DBProvider.db.baseAbierta;

    try {
      final sql;
      String? consulta;
      if (codigoMarca != "" && codigoMarca != null) {
        consulta = "   and  p.marcacodigopideki=$codigoMarca";
      } else {
        consulta = "";
      }
      String? consulta2;
      if (codigoSubCategoria != "" && codigoSubCategoria != null) {
        consulta2 =
            " and p.subcategoriacodigopideki = $codigoSubCategoria OR p.subcategoriaId2 = $codigoSubCategoria ";
      } else {
        consulta2 = "";
      }
      String? consulta3;
      if (codigo != "" && codigo != null) {
        consulta3 =
            " and p.categoriacodigopideki = $codigo or p.categoriaId2 = $codigo";
      } else {
        consulta3 = "";
      }

      if (tipo == 5) {
        sql = await db.rawQuery('''
      SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante,
        ROUND(
        (
           (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS precio, 
         p.marca , p.categoria   , p.iva , p.fabricante  , p.marcapideki , p.tipofabricante , 
         p.marcacodigopideki , 
         p.Negocio as negocio,
        p.categoriaId2,
			  p.subcategoriaId2,
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente,  p.orden, IFNULL(tmp.descuento, 0.0) AS descuento, 
    ROUND(
        (
           (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS preciodescuento,
    CAST(
        ROUND(
            (p.precio + ((p.precio * p.iva) / 100) + (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((p.precio * p.ICUI) / 100)
                END
            )), 0
        ) AS FLOAT
    ) AS precioinicial, substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo
        FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  (p.fabricante like '%$codigoProveedor%') 
        $consulta3
        $consulta2 
         AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%')
        AND ROUND(
                (
                   (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
                ), 0
            ) >= $precioMinimo
            AND ROUND(
                (
                    (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
                ), 0
            ) <= $precioMaximo

        $consulta
        ORDER BY p.orden ASC
        
    ''');
        return sql.isNotEmpty
            ? sql.map((e) => Product.fromJson(e)).toList()
            : [];
      }
      if (tipo == 1) {
        //tipo 1 para imperdibles
        sql = await db.rawQuery('''
  SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante,
         ROUND(
        (
           (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS precio,
         p.marca , p.categoria   , p.iva , p.fabricante  , p.marcapideki , p.tipofabricante , 
         p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.Negocio as negocio,
        p.categoriaId2,
			  p.subcategoriaId2,
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente,  p.orden,IFNULL(tmp.descuento, 0.0) AS descuento, 
    ROUND(
        (
           (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS preciodescuento,
    CAST(
        ROUND(
            (p.precio + ((p.precio * p.iva) / 100) + (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((p.precio * p.ICUI) / 100)
                END
            )), 0
        ) AS FLOAT
    ) AS precioinicial, substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo
        FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        inner join ProductosNuevos pn ON p.codigo = pn.codigo 
        WHERE  (p.fabricante like '%$codigoProveedor%') 
        $consulta3  
        $consulta2
        AND ROUND(
                (
                    (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
                ), 0
            ) >= $precioMinimo
            AND ROUND(
                (
                   (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
                ), 0
            ) <= $precioMaximo
        $consulta
        ORDER BY p.orden ASC
        
    ''');

        return sql.isNotEmpty
            ? sql.map((e) => Product.fromJson(e)).toList()
            : [];
      }
      if (tipo == 3) {
        //tipo 3 para marca e imperdible
        sql = await db.rawQuery('''
       SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante,
        ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS precio, 
         p.marca , p.categoria   , p.iva , p.fabricante  , p.marcapideki , p.tipofabricante , 
         p.marcacodigopideki ,
         p.Negocio as negocio, 
        p.categoriaId2,
			  p.subcategoriaId2,
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente,  p.orden, IFNULL(tmp.descuento, 0.0) AS descuento, 
    ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS preciodescuento,
    CAST(
        ROUND(
            (p.precio + ((p.precio * p.iva) / 100) + (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((p.precio * p.ICUI) / 100)
                END
            )), 0
        ) AS FLOAT
    ) AS precioinicial, substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo
        FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
           inner join ProductosNuevos pn ON p.codigo = pn.codigo 
        WHERE  (p.fabricante like '%$codigoProveedor%') 
        $consulta3
        $consulta2
        AND
        p.marcacodigopideki = '$codigo'
         AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%' )
        AND ROUND(
                (
                    (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
                ), 0
            ) >= $precioMinimo
            AND ROUND(
                (
                    (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
                ), 0
            ) <= $precioMaximo
        ORDER BY p.orden ASC
         
       ''');
        return sql.isNotEmpty
            ? sql.map((e) => Product.fromJson(e)).toList()
            : [];
      }
      if (tipo == 6) {
        //tipo 6 para productos del dia

        sql = await db.rawQuery('''
       SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante,
        ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS precio,  
         p.marca , p.categoria   , p.iva , p.fabricante  , p.marcapideki , p.tipofabricante , 
         p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.categoriaId2,
			  p.subcategoriaId2,
        p.Negocio as negocio,
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente,  p.orden, IFNULL(tmp.descuento, 0.0) AS descuento, 
    ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS preciodescuento,
    CAST(
        ROUND(
            (p.precio + ((p.precio * p.iva) / 100) + (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((p.precio * p.ICUI) / 100)
                END
            )), 0
        ) AS FLOAT
    ) AS precioinicial, substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
          ,activopromocion, activoprodnuevo
         FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  (p.fabricante like '%$codigoProveedor%') AND
        p.marcacodigopideki = '$codigo'  AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%' )
        AND ROUND(
                (
                    (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
                ), 0
            ) >= $precioMinimo
            AND ROUND(
                (
                    (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
                ), 0
            ) <= $precioMaximo
        ORDER BY p.orden ASC
         
       ''');
        return sql.isNotEmpty
            ? sql.map((e) => Product.fromJson(e)).toList()
            : [];
      }
      if (tipo == 4) {
        //tipo 4 para marca  y promo
        sql = await db.rawQuery('''
       SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante,
        ROUND(
        (
           (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS precio,   
         p.marca , p.categoria   , p.iva , p.fabricante  , p.marcapideki , p.tipofabricante , 
         p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.categoriaId2,
        p.Negocio as negocio,
			  p.subcategoriaId2,
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente,  p.orden, IFNULL(tmp.descuento, 0.0) AS descuento, 
    ROUND(
        (
           (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS preciodescuento,
    CAST(
        ROUND(
            (p.precio + ((p.precio * p.iva) / 100) + (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((p.precio * p.ICUI) / 100)
                END
            )), 0
        ) AS FLOAT
    ) AS precioinicial, substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
        ,activopromocion, activoprodnuevo
        FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
          inner join Ofertas pn ON p.codigo = pn.codigo 
        WHERE  (p.fabricante like '%$codigoProveedor%') AND
        p.marcacodigopideki = '$codigo' AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%' )
        AND ROUND(
                (
                    (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
                ), 0
            ) >= $precioMinimo
            AND ROUND(
                (
                    (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
                ), 0
            ) <= $precioMaximo
        $consulta
        ORDER BY p.orden ASC
         
       ''');
        return sql.isNotEmpty
            ? sql.map((e) => Product.fromJson(e)).toList()
            : [];
      } else {
        sql = await db.rawQuery('''
 SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante, 
        ROUND(
        (
           (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS precio, 
         p.marca , p.categoria   , p.iva , p.fabricante  , p.marcapideki , p.tipofabricante , 
         p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.categoriaId2,
        p.Negocio as negocio,
			  p.subcategoriaId2,
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente,  p.orden, IFNULL(tmp.descuento, 0.0) AS descuento, 
    ROUND(
        (
            (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
        ), 0
    ) AS preciodescuento,
    CAST(
        ROUND(
            (p.precio + ((p.precio * p.iva) / 100) + (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((p.precio * p.ICUI) / 100)
                END
            )), 0
        ) AS FLOAT
    ) AS precioinicial, substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
        ,activopromocion, activoprodnuevo
        FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
         inner join Ofertas pn ON p.codigo = pn.codigo 
        WHERE  (p.fabricante like '%$codigoProveedor%') 
        $consulta3
        $consulta2
        $consulta
        AND ROUND(
                (
                    (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
                ), 0
            ) >= $precioMinimo
            AND ROUND(
                (
                    (
                p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
            ) + 
            (
                CASE
                    WHEN p.ICUI = 0 THEN p.IBUA
                    ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
                END
            ) + 
            (
                (
                    p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
                ) * p.iva / 100
            )
                ), 0
            ) <= $precioMaximo
        
        
    ''');
        return sql.isNotEmpty
            ? sql.map((e) => Product.fromJson(e)).toList()
            : [];
      }
    } catch (e) {
      return [];
    }
  }

//   Future<List<dynamic>> cargarProductosFiltroCategoria(
//       String? codigoCategoria,
//       int tipo,
//       double precioMinimo,
//       double precioMaximo,
//       String? codigoSubCategoria,
//       String? codigoMarca) async {
//     final db = await DBProvider.db.baseAbierta;
//     try {
//       final sql;
//       String? consulta;
//       if (codigoMarca != "" && codigoMarca != null) {
//         consulta = "   and  p.marcacodigopideki=$codigoMarca";
//       } else {
//         consulta = "";
//       }

//       if (tipo == 1) {
//         //tipo 1 para filtrar solo por marca, categoria y subcategoria
//         sql = await db.rawQuery('''
//             SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante,
//          ROUND(
//         (
//             (
//                 p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//             ) +
//             (
//                 CASE
//                     WHEN p.ICUI = 0 THEN p.IBUA
//                     ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
//                 END
//             ) +
//             (
//                 (
//                     p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//                 ) * p.iva / 100
//             )
//         ), 0
//     ) AS precio,
//          p.marca , p.categoria   , p.iva , p.fabricante  , p.marcapideki , p.tipofabricante ,
//          p.marcacodigopideki ,
//         p.categoriaId2,
// 			  p.subcategoriaId2,
//         p.categoriacodigopideki ,
//         p.Negocio as negocio,
//         p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente,  p.orden, IFNULL(tmp.descuento, 0.0) AS descuento,
//     ROUND(
//         (
//             (
//                 p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//             ) +
//             (
//                 CASE
//                     WHEN p.ICUI = 0 THEN p.IBUA
//                     ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
//                 END
//             ) +
//             (
//                 (
//                     p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//                 ) * p.iva / 100
//             )
//         ), 0
//     ) AS preciodescuento,
//     CAST(
//         ROUND(
//             (p.precio + ((p.precio * p.iva) / 100) + (
//                 CASE
//                     WHEN p.ICUI = 0 THEN p.IBUA
//                     ELSE ((p.precio * p.ICUI) / 100)
//                 END
//             )), 0
//         ) AS FLOAT
//     ) AS precioinicial, substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 ,
// substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1
//          ,activopromocion, activoprodnuevo
//         FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
//         select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,*
//         from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
//         ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
//         WHERE

//         (p.categoriacodigopideki = $codigoCategoria or p.categoriaId2 = $codigoCategoria)
//        and (p.subcategoriacodigopideki = $codigoSubCategoria or p.subcategoriaId2 = $codigoSubCategoria)
//          $consulta
//         AND ROUND(
//                 (
//                     (
//                 p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//             ) +
//             (
//                 CASE
//                     WHEN p.ICUI = 0 THEN p.IBUA
//                     ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
//                 END
//             ) +
//             (
//                 (
//                     p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//                 ) * p.iva / 100
//             )
//                 ), 0
//             ) >= $precioMinimo
//             AND ROUND(
//                 (
//                     (
//                 p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//             ) +
//             (
//                 CASE
//                     WHEN p.ICUI = 0 THEN p.IBUA
//                     ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
//                 END
//             ) +
//             (
//                 (
//                     p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//                 ) * p.iva / 100
//             )
//                 ), 0
//             ) <= $precioMaximo
//         ORDER BY p.orden ASC

//        ''');
//         return sql.isNotEmpty
//             ? sql.map((e) => Producto.fromJson(e)).toList()
//             : [];
//         //tipo 2 para productos mas vendidos
//       } else if (tipo == 2) {
//         sql = await db.rawQuery('''
//          SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante,
//         ROUND(
//         (
//            (
//                 p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//             ) +
//             (
//                 CASE
//                     WHEN p.ICUI = 0 THEN p.IBUA
//                     ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
//                 END
//             ) +
//             (
//                 (
//                     p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//                 ) * p.iva / 100
//             )
//         ), 0
//     ) AS precio,
//     p.Negocio as negocio,
//          p.marca , p.categoria   , p.iva , p.fabricante  , p.marcapideki , p.tipofabricante ,
//          p.marcacodigopideki ,
//         p.categoriaId2,
// 			  p.subcategoriaId2,
//         p.categoriacodigopideki ,
//         p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente,  p.orden,IFNULL(tmp.descuento, 0.0) AS descuento,
//     ROUND(
//         (
//             (
//                 p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//             ) +
//             (
//                 CASE
//                     WHEN p.ICUI = 0 THEN p.IBUA
//                     ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
//                 END
//             ) +
//             (
//                 (
//                     p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//                 ) * p.iva / 100
//             )
//         ), 0
//     ) AS preciodescuento,
//     CAST(
//         ROUND(
//             (p.precio + ((p.precio * p.iva) / 100) + (
//                 CASE
//                     WHEN p.ICUI = 0 THEN p.IBUA
//                     ELSE ((p.precio * p.ICUI) / 100)
//                 END
//             )), 0
//         ) AS FLOAT
//     ) AS precioinicial, substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 ,
// substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1
//           ,activopromocion, activoprodnuevo
//         FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
//         select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,*
//         from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
//         ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
//         WHERE
//           (p.categoriacodigopideki = $codigoCategoria or p.categoriaId2 = $codigoCategoria )
//        and (p.subcategoriacodigopideki = $codigoSubCategoria or p.subcategoriaId2 = $codigoSubCategoria)
//              $consulta
//         AND ROUND(
//                 (
//                     (
//                 p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//             ) +
//             (
//                 CASE
//                     WHEN p.ICUI = 0 THEN p.IBUA
//                     ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
//                 END
//             ) +
//             (
//                 (
//                     p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//                 ) * p.iva / 100
//             )
//                 ), 0
//             ) >= $precioMinimo
//             AND ROUND(
//                 (
//                     (
//                 p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//             ) +
//             (
//                 CASE
//                     WHEN p.ICUI = 0 THEN p.IBUA
//                     ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
//                 END
//             ) +
//             (
//                 (
//                     p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//                 ) * p.iva / 100
//             )
//                 ), 0
//             ) <= $precioMaximo

//         and p.codigo in (select distinct codigoref from Historico  )
//         ORDER BY p.orden ASC

//        ''');
//         return sql.isNotEmpty
//             ? sql.map((e) => Producto.fromJson(e)).toList()
//             : [];
//       } else {
//         //tipo 3 para imperdibles marcas, categorias y subc
//         sql = await db.rawQuery('''
//       SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante,
//         ROUND(
//         (
//            (
//                 p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//             ) +
//             (
//                 CASE
//                     WHEN p.ICUI = 0 THEN p.IBUA
//                     ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
//                 END
//             ) +
//             (
//                 (
//                     p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//                 ) * p.iva / 100
//             )
//         ), 0
//     ) AS precio,
//          p.marca , p.categoria   , p.iva , p.fabricante  , p.marcapideki , p.tipofabricante ,
//          p.marcacodigopideki ,
//         p.categoriaId2,
//         p.Negocio as negocio,
// 			  p.subcategoriaId2,
//         p.categoriacodigopideki ,
//         p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente,  p.orden, IFNULL(tmp.descuento, 0.0) AS descuento,
//     ROUND(
//         (
//            (
//                 p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//             ) +
//             (
//                 CASE
//                     WHEN p.ICUI = 0 THEN p.IBUA
//                     ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
//                 END
//             ) +
//             (
//                 (
//                     p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//                 ) * p.iva / 100
//             )
//         ), 0
//     ) AS preciodescuento,
//     CAST(
//         ROUND(
//             (p.precio + ((p.precio * p.iva) / 100) + (
//                 CASE
//                     WHEN p.ICUI = 0 THEN p.IBUA
//                     ELSE ((p.precio * p.ICUI) / 100)
//                 END
//             )), 0
//         ) AS FLOAT
//     ) AS precioinicial, substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 ,
// substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1
//          ,activopromocion, activoprodnuevo
//         FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
//         select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,*
//         from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
//         ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
//            inner join ProductosNuevos pn ON p.codigo = pn.codigo
//         WHERE
//         (p.categoriacodigopideki = $codigoCategoria or p.categoriaId2 = $codigoCategoria)
//        and (p.subcategoriacodigopideki = $codigoSubCategoria or p.subcategoriaId2 = $codigoSubCategoria)
//              $consulta
//         AND
//         p.marcacodigopideki = '$codigoMarca'

//         AND ROUND(
//                 (
//                     (
//                 p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//             ) +
//             (
//                 CASE
//                     WHEN p.ICUI = 0 THEN p.IBUA
//                     ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
//                 END
//             ) +
//             (
//                 (
//                     p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//                 ) * p.iva / 100
//             )
//                 ), 0
//             ) >= $precioMinimo
//             AND ROUND(
//                 (
//                     (
//                 p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//             ) +
//             (
//                 CASE
//                     WHEN p.ICUI = 0 THEN p.IBUA
//                     ELSE ((( p.precio - (p.precio * IFNULL(tmp.descuento, 0)) / 100) * p.ICUI) / 100)
//                 END
//             ) +
//             (
//                 (
//                     p.precio - (p.precio * IFNULL(tmp.descuento, 0) / 100)
//                 ) * p.iva / 100
//             )
//                 ), 0
//             ) <= $precioMaximo
//         ORDER BY p.orden ASC
//         ''');
//         return sql.isNotEmpty
//             ? sql.map((e) => Producto.fromJson(e)).toList()
//             : [];
//       }
//     } catch (e) {
//       return [];
//     }
//   }

  Future<dynamic> insertPedidoTemp(String codPedido, int cantidad) async {
    final db = await DBProviderHelper.db.tempAbierta;
    try {
      await db.rawInsert('INSERT INTO pedido VALUES($codPedido,$cantidad)');

      return true;
    } catch (e) {
      print('fallo insertar en tabla pedido temporal $e');
      return false;
    }
  }

  Future<dynamic> modificarPedidoTemp(String codPedido, int cantidad) async {
    final db = await DBProviderHelper.db.tempAbierta;
    try {
      await db.rawUpdate(
          'UPDATE pedido SET cantidad = $cantidad WHERE codigo_producto = $codPedido');
      return true;
    } catch (e) {
      print('fallo modificar en tabla pedido temporal $e');
      return false;
    }
  }

  Future<dynamic> eliminarPedidoTemp(String codPedido) async {
    final db = await DBProviderHelper.db.tempAbierta;
    try {
      await db
          .rawDelete('DELETE FROM pedido WHERE codigo_producto = $codPedido');
      return true;
    } catch (e) {
      print('fallo eliminar en tabla pedido temporal $e');
      return false;
    }
  }

  Future<List<Product>> consultarPedidoTemporal() async {
    final db = await DBProviderHelper.db.tempAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT codigo_producto codigo, cantidad FROM pedido  
    ''');

      return sql.map((e) => Product.fromJson2(e)).toList();
    } catch (e) {
      print('fallo consulta en tabla pedido temporal $e');
      return [];
    }
  }

  @override
  Future<String> insertarProductoBusqueda(
      {required String codigoProducto}) async {
    final prefs = Preferencias();
    try {
      final url;

      url = Uri.parse(Constantes().urlPrincipal + 'Busqueda/Insertar');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "Busqueda": codigoProducto,
          "Pais": prefs.paisUsuario,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      print("error validando codigo $e");
      return '';
    }
  }

  @override
  Future<String> productoBusqueda({required String palabraProducto}) async {
    final prefs = Preferencias();
    try {
      final url;

      url = Uri.parse(Constantes().urlPrincipal + 'Busqueda/Consultar');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "Busqueda": palabraProducto,
          "CCUP": prefs.codigoUnicoPideky,
          "Sucursal": prefs.sucursal
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      print("error validando codigo $e");
      return '';
    }
  }

  @override
  Future<String> productoMasBuscado({required String codigoProducto}) async {
    final db = await DBProviderHelper.db.database;

    try {
      List sql = await db.rawQuery('''
      SELECT nombre from Producto where codigo = '$codigoProducto'  
    ''');

      return sql.isNotEmpty ? sql.first['nombre'] : '';
    } catch (e) {
      print('fallo consulta en tabla pedido temporal $e');
      return '';
    }
  }

  // Future<List<Producto>> productoMasBuscado() async {
  //   final db = await DBProviderHelper.db.tempAbierta;
  //   try {
  //     final sql = await db.rawQuery('''
  //     SELECT nombre from producto where codigo = result
  //   ''');

  //     return sql.map((e) => Producto.fromJson2(e)).toList();
  //   } catch (e) {
  //     print('fallo consulta en tabla pedido temporal $e');
  //     return [];
  //   }
  //}
}
