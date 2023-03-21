import 'package:emart/_pideky/domain/producto/interface/i_producto_repository.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';

class ProductoRepositorySqlite extends IProductoRepository {
  Future<Producto> consultarDatosProducto(String producto) async {
    final db = await DBProviderHelper.db.baseAbierta;

    final sql = await db.rawQuery('''
      SELECT p.*, f.codigo as codigoFabricante, f.nit as nitFabricante FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa where p.codigo like '%$producto%' limit 1
    ''');

    return Producto.fromJson(sql.first);
  }

  Future<List<Producto>> consultarProductos() async {
    final db = await DBProviderHelper.db.baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT p.*, f.codigo as codigoFabricante, f.nit as nitFabricante FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa 
    ''');

      return sql.map((e) => Producto.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> consultarSugerido() async {
    final db = await DBProvider.db.baseAbierta;

    try {
      final sql = await db.rawQuery('''
       
        SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante, 
         round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, 0.0 as descuento, 
        0.0 as preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
        ,activopromocion, activoprodnuevo
        FROM Producto p 
       JOIN fabricante f ON p.fabricante = f.empresa 
        inner join Ofertas pn ON p.codigo = pn.codigo
        left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        GROUP BY p.codigo 
        ORDER BY p.nombre ASC

    ''');

      return sql.isNotEmpty
          ? sql.map((e) => Producto.fromJson(e)).toList()
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
      SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante, 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.categoriaId2,
			  p.subcategoriaId2, 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, cast(ifnull(tmp.descuento,0.0) as float) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo
        FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  (p.fabricante like '%$codigoProveedor%') AND
         p.subcategoriacodigopideki = '$codigo' OR p.subcategoriaId2 = '$codigo' AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%')
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo

        $consulta
        ORDER BY p.orden ASC
        
    ''';
      } else if (tipo == 3) {
        query = '''
       SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante, 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.categoriaId2,
			  p.subcategoriaId2, 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, ifnull(tmp.descuento,0.0) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo
        FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  (p.fabricante like '%$codigoProveedor%') AND
        p.marcacodigopideki = $codigo  AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%' )
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo 
        $consulta
        ORDER BY p.orden ASC
         
       ''';
      } else if (tipo == 4) {
        query = '''
      SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante, 
       round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.categoriaId2,
			  p.subcategoriaId2, 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, ifnull(tmp.descuento,0.0) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float)  precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
        ,activopromocion, activoprodnuevo
        FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  (p.fabricante like '%$codigoProveedor%') 
         AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%' ) 
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
       
        ORDER BY p.orden ASC
         
      ''';
      } else if (tipo == 5) {
        query = '''
      SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante, 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.categoriaId2,
			  p.subcategoriaId2, 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, cast(ifnull(tmp.descuento,0.0) as float) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo
        FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  (p.fabricante like '%$codigoProveedor%') AND
         p.categoriacodigopideki = '$codigo' OR p.categoriaId2 = '$codigo'  AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%')
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
        $consulta
        ORDER BY p.orden ASC
         
      ''';
      } else if (tipo == 7) {
        //tipo para productos mas vendidos
        query = '''
       SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante, 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.categoriaId2,
			  p.subcategoriaId2,
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, ifnull(tmp.descuento,0.0) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
          ,activopromocion, activoprodnuevo
        FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  (p.fabricante like '%$codigoProveedor%') AND
        p.marcacodigopideki = $codigo  AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%' )
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo 
        $consulta
        
        and p.codigo in (select distinct codigoref from Historico  )
        ORDER BY p.orden ASC
         
      ''';
      } else {
        query = '''
       SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante, 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.categoriaId2,
			  p.subcategoriaId2,
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, ifnull(tmp.descuento,0.0) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float)  precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo
        FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  (p.fabricante like '%$codigoProveedor%') AND
        (p.codigo like '%$buscador%' OR p.nombre like '%$buscador%' )
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
        $consulta
        ORDER BY p.orden ASC
         
        ''';
      }

      sql = await db.rawQuery(query);

      return sql.isNotEmpty
          ? sql.map((e) => Producto.fromJson(e)).toList()
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
      String codigoProveedor) async {
    final db = await DBProvider.db.baseAbierta;

    try {
      final isLimit = limit != 0 ? "LIMIT $limit" : "";

      final sql;
      String? consulta;
      if (codigoMarca != "" && codigoMarca != null) {
        consulta = "   and  p.marcacodigopideki=$codigoMarca";
      } else {
        consulta = "";
      }

      if (tipoProducto == 2) {
        sql = await db.rawQuery('''
        SELECT p.codigo , p.nombre ,f.codigo as codigoFabricante, f.nit as nitFabricante, round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio  , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, pn.orden_imperdible as orden, 0.0 as descuento, 
        0.0 as  preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) as precioinicial
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
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
          and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
        $consulta
        ORDER BY pn.orden_imperdible ASC $isLimit 
         
    ''');
      } else {
        sql = await db.rawQuery('''
      SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante, 
     round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
      p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
      p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
      p.codIndirecto , p.marcacodigopideki , 
      p.categoriacodigopideki , 
      p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, pn.orden_oferta as orden, cast(ifnull(tmp.descuento,0) as float) descuento, 
      round((p.precio - p.precio * ifnull(tmp.descuento,0) /100),0) preciodescuento,
      cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial
      , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
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
      and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
      $consulta
      UNION 
      SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante, 
     round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
      p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
      p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
      p.codIndirecto , p.marcacodigopideki , 
      p.categoriacodigopideki , 
      p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, pn.orden_oferta as orden, cast(ifnull(tmp.descuento,0) as float) descuento, 
      round((p.precio - p.precio * ifnull(tmp.descuento,0) /100),0) preciodescuento,
      cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
, substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
        ,activopromocion, activoprodnuevo
      FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join Ofertas pn ON p.codigo = pn.codigo left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
      select count(p.codigo) identificador,* 
      from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante group by material
      ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
      WHERE  (p.fabricante like '%$codigoProveedor%') AND
      (p.codigo like '%$buscador%' OR p.nombre like '%$buscador%') AND tmp.descuento > 0 
      and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
      
      ORDER BY pn.orden_oferta ASC
         
     ''');
      }

      return sql.isNotEmpty
          ? sql.map((e) => Producto.fromJson(e)).toList()
          : [];
    } catch (e) {
      print('Error consulta cargarProductosInterno $e');
      return [];
    }
  }

  Future<List<Producto>> cargarProductosFiltro(
      String? buscar, String codigoProveedor) async {
    final db = await DBProvider.db.baseAbierta;

    try {
      List<Producto> lista = [];
      var condicion = buscar != '' ? ' WHERE p.codigo LIKE "%$buscar%" ' : ' ';

      List<Map> sql = await db.rawQuery('''
       SELECT p.codigo , p.nombre ,f.codigo as codigoFabricante, f.nit as nitFabricante, round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio  , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, 0.0 as descuento, 
        0.0 as  preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) as precioinicial
        FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa 
        left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select count(p.codigo) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante group by material
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo 
        $condicion 
        ORDER BY p.orden ASC 
         
    ''');

      lista = List<Producto>.from(sql.map((x) => Producto.fromJson2(x)));

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
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriaId2,
			  p.subcategoriaId2,
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, cast(ifnull(tmp.descuento,0.0) as float) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
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
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo

        $consulta
        ORDER BY p.orden ASC
        
    ''');
        return sql.isNotEmpty
            ? sql.map((e) => Producto.fromJson(e)).toList()
            : [];
      }
      if (tipo == 1) {
        //tipo 1 para imperdibles
        sql = await db.rawQuery('''
  SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante,
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.categoriaId2,
			  p.subcategoriaId2,
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, cast(ifnull(tmp.descuento,0.0) as float) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
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
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
        $consulta
        ORDER BY p.orden ASC
        
    ''');

        return sql.isNotEmpty
            ? sql.map((e) => Producto.fromJson(e)).toList()
            : [];
      }
      if (tipo == 3) {
        //tipo 3 para marca e imperdible
        sql = await db.rawQuery('''
       SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante,
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriaId2,
			  p.subcategoriaId2,
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, ifnull(tmp.descuento,0.0) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
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
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
        ORDER BY p.orden ASC
         
       ''');
        return sql.isNotEmpty
            ? sql.map((e) => Producto.fromJson(e)).toList()
            : [];
      }
      if (tipo == 6) {
        //tipo 6 para productos del dia
        String date = DateTime.now().toString();

        sql = await db.rawQuery('''
       SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante,
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.categoriaId2,
			  p.subcategoriaId2,
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, ifnull(tmp.descuento,0.0) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
          ,activopromocion, activoprodnuevo
         FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  (p.fabricante like '%$codigoProveedor%') AND
        p.marcacodigopideki = '$codigo'  AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%' )
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo 
        and CAST(p.fechatrans AS date) = CAST('$date' AS date)
        ORDER BY p.orden ASC
         
       ''');
        return sql.isNotEmpty
            ? sql.map((e) => Producto.fromJson(e)).toList()
            : [];
      }
      if (tipo == 4) {
        //tipo 4 para marca  y promo
        sql = await db.rawQuery('''
       SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante,
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.categoriaId2,
			  p.subcategoriaId2,
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, ifnull(tmp.descuento,0.0) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
        ,activopromocion, activoprodnuevo
        FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
          inner join Ofertas pn ON p.codigo = pn.codigo 
        WHERE  (p.fabricante like '%$codigoProveedor%') AND
        p.marcacodigopideki = '$codigo' AND ( p.codigo like '%$buscador%' OR p.nombre like '%$buscador%' )
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo 
        $consulta
        ORDER BY p.orden ASC
         
       ''');
        return sql.isNotEmpty
            ? sql.map((e) => Producto.fromJson(e)).toList()
            : [];
      } else {
        sql = await db.rawQuery('''
 SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante, 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriacodigopideki , 
        p.categoriaId2,
			  p.subcategoriaId2,
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, cast(ifnull(tmp.descuento,0.0) as float) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
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
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
        
        
    ''');
        return sql.isNotEmpty
            ? sql.map((e) => Producto.fromJson(e)).toList()
            : [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> cargarProductosFiltroCategoria(
      String? codigoCategoria,
      int tipo,
      double precioMinimo,
      double precioMaximo,
      String? codigoSubCategoria,
      String? codigoMarca) async {
    final db = await DBProvider.db.baseAbierta;
    try {
      final sql;
      String? consulta;
      if (codigoMarca != "" && codigoMarca != null) {
        consulta = "   and  p.marcacodigopideki=$codigoMarca";
      } else {
        consulta = "";
      }

      if (tipo == 1) {
        //tipo 1 para filtrar solo por marca, categoria y subcategoria
        sql = await db.rawQuery('''
            SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante, 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriaId2,
			  p.subcategoriaId2,
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, cast(ifnull(tmp.descuento,0.0) as float) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo
        FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  
      
        (p.categoriacodigopideki = $codigoCategoria or p.categoriaId2 = $codigoCategoria) 
       and (p.subcategoriacodigopideki = $codigoSubCategoria or p.subcategoriaId2 = $codigoSubCategoria)
         $consulta
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
        ORDER BY p.orden ASC
         
       ''');
        return sql.isNotEmpty
            ? sql.map((e) => Producto.fromJson(e)).toList()
            : [];
        //tipo 2 para productos mas vendidos
      } else if (tipo == 2) {
        sql = await db.rawQuery('''
         SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante, 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriaId2,
			  p.subcategoriaId2,
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, ifnull(tmp.descuento,0.0) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
          ,activopromocion, activoprodnuevo
        FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
        WHERE  
          (p.categoriacodigopideki = $codigoCategoria or p.categoriaId2 = $codigoCategoria )
       and (p.subcategoriacodigopideki = $codigoSubCategoria or p.subcategoriaId2 = $codigoSubCategoria)
             $consulta
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo 
    
        
        and p.codigo in (select distinct codigoref from Historico  )
        ORDER BY p.orden ASC
         
       ''');
        return sql.isNotEmpty
            ? sql.map((e) => Producto.fromJson(e)).toList()
            : [];
      } else {
        //tipo 3 para imperdibles marcas, categorias y subc
        sql = await db.rawQuery('''
      SELECT p.codigo , p.nombre , f.codigo as codigoFabricante, f.nit as nitFabricante, 
        round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
      (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)  precio , 
        p.unidad , p.linea , p.marca , p.categoria , p.ean , p.peso , p.longitud , p.altura , 
        p.ancho , p.volumen , p.iva , p.fabricante , p.categoriapideki , p.marcapideki , p.tipofabricante , 
        p.codIndirecto , p.marcacodigopideki , 
        p.categoriaId2,
			  p.subcategoriaId2,
        p.categoriacodigopideki , 
        p.subcategoriacodigopideki , p.nombrecomercial, p.codigocliente, p.fechatrans, p.orden, ifnull(tmp.descuento,0.0) descuento, 
           round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0) preciodescuento,
        cast(round((p.precio +  ((p.precio*p.iva) /100)),0) as float) precioinicial 
        , substr(fechafinnuevo, 7, 4) || '-' || substr(fechafinnuevo, 4, 2) || '-' ||  (substr(fechafinnuevo, 1, 2)) as fechafinnuevo_1 , 
substr(fechafinpromocion, 7, 4) || '-' || substr(fechafinpromocion, 4, 2) || '-' ||substr(fechafinpromocion, 1, 2)as fechafinpromocion_1 
         ,activopromocion, activoprodnuevo
        FROM Producto p JOIN fabricante f ON p.fabricante = f.empresa left join (select tmp.proveedor, tmp.material codigo, tmp.descuento from (
        select (select count(*) from descuentos de where de.rowid>=d.rowid and de.material=d.material) identificador,* 
        from descuentos d inner join producto p on p.codigo = d.material and d.proveedor = p.fabricante
        ) tmp where tmp.identificador = 1) tmp on p.fabricante = tmp.proveedor and p.codigo = tmp.codigo
           inner join ProductosNuevos pn ON p.codigo = pn.codigo 
        WHERE  
        (p.categoriacodigopideki = $codigoCategoria or p.categoriaId2 = $codigoCategoria)
       and (p.subcategoriacodigopideki = $codigoSubCategoria or p.subcategoriaId2 = $codigoSubCategoria)
             $consulta
        AND
        p.marcacodigopideki = '$codigoMarca'
      
        and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)>=$precioMinimo and round(((p.precio - (p.precio * ifnull(tmp.descuento,0) / 100))) + 
        (p.precio - (p.precio * ifnull(tmp.descuento,0) / 100)) * p.iva /100,0)<=$precioMaximo
        ORDER BY p.orden ASC
        ''');
        return sql.isNotEmpty
            ? sql.map((e) => Producto.fromJson(e)).toList()
            : [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<dynamic> insertPedidoTemp(String codPedido, int cantidad) async {
    final db = await DBProviderHelper.db.tempAbierta;
    print('este es el cod $codPedido');
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

  Future<List<Producto>> consultarPedidoTemporal() async {
    final db = await DBProviderHelper.db.tempAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT codigo_producto codigo, cantidad FROM pedido  
    ''');

      return sql.map((e) => Producto.fromJson2(e)).toList();
    } catch (e) {
      print('fallo consulta en tabla pedido temporal $e');
      return [];
    }
  }
}
