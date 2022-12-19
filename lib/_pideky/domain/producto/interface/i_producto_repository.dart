import 'package:emart/_pideky/domain/producto/model/producto.dart';

abstract class IProductoRepository {
  Future<Producto> consultarDatosProducto(String producto);

  Future<dynamic> consultarSugerido();

  Future<List<dynamic>> cargarProductos(
      String? codigo,
      int tipo,
      String buscador,
      double precioMinimo,
      double precioMaximo,
      String? codigoMarca,
      String codigoProveedor);

  Future<List<dynamic>> cargarProductosInterno(
      int tipoProducto,
      String buscador,
      double precioMinimo,
      double precioMaximo,
      int limit,
      String? codigoMarca,
      String codigoProveedor);

  Future<List<Producto>> cargarProductosFiltro(
      String? buscar, String codigoProveedor);

  Future<List<dynamic>> cargarProductosFiltroProveedores(
      String? codigo,
      int tipo,
      String buscador,
      double precioMinimo,
      double precioMaximo,
      String? codigoSubCategoria,
      String? codigoMarca,
      String codigoProveedor);

  Future<List<dynamic>> cargarProductosFiltroCategoria(
      String? codigoCategoria,
      int tipo,
      double precioMinimo,
      double precioMaximo,
      String? codigoSubCategoria,
      String? codigoMarca);
}
