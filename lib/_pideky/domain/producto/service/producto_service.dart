import 'package:emart/_pideky/domain/producto/interface/i_producto_repository.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';

class ProductoService {
  final IProductoRepository productoRepository;

  ProductoService(this.productoRepository);

  Future<Producto> consultarDatosProducto(String producto) async =>
      await productoRepository.consultarDatosProducto(producto);

  Future<dynamic> consultarSugerido() async =>
      await productoRepository.consultarSugerido();

  Future<List<dynamic>> cargarProductos(
          String? codigo,
          int tipo,
          String buscador,
          double precioMinimo,
          double precioMaximo,
          String? codigoMarca,
          String codigoProveedor) async =>
      await productoRepository.cargarProductos(codigo, tipo, buscador,
          precioMinimo, precioMaximo, codigoMarca, codigoProveedor);

  Future<List<dynamic>> cargarProductosInterno(
          int tipoProducto,
          String buscador,
          double precioMinimo,
          double precioMaximo,
          int limit,
          String? codigoMarca,
          String codigoProveedor) async =>
      await productoRepository.cargarProductosInterno(tipoProducto, buscador,
          precioMinimo, precioMaximo, limit, codigoMarca, codigoProveedor);

  Future<List<Producto>> cargarProductosFiltro(
          String? buscar, String codigoProveedor) async =>
      await productoRepository.cargarProductosFiltro(buscar, codigoProveedor);

  Future<List<dynamic>> cargarProductosFiltroProveedores(
          String? codigo,
          int tipo,
          String buscador,
          double precioMinimo,
          double precioMaximo,
          String? codigoSubCategoria,
          String? codigoMarca,
          String codigoProveedor) async =>
      await productoRepository.cargarProductosFiltroProveedores(
          codigo,
          tipo,
          buscador,
          precioMinimo,
          precioMaximo,
          codigoSubCategoria,
          codigoMarca,
          codigoProveedor);

  // Future<List<dynamic>> cargarProductosFiltroCategoria(
  //         String? codigoCategoria,
  //         int tipo,
  //         double precioMinimo,
  //         double precioMaximo,
  //         String? codigoSubCategoria,
  //         String? codigoMarca) async =>
  //     await productoRepository.cargarProductosFiltroCategoria(codigoCategoria,
  //         tipo, precioMinimo, precioMaximo, codigoSubCategoria, codigoMarca);

  Future<dynamic> insertPedidoTemp(String codPedido, int cantidad) async =>
      await productoRepository.insertPedidoTemp(codPedido, cantidad);

  Future<dynamic> modificarPedidoTemp(String codPedido, int cantidad) async =>
      await productoRepository.modificarPedidoTemp(codPedido, cantidad);

  Future<dynamic> eliminarPedidoTemp(String codPedido) async =>
      await productoRepository.eliminarPedidoTemp(codPedido);

  Future<List<Producto>> consultarPedidoTemporal() async =>
      await productoRepository.consultarPedidoTemporal();

  Future<String> insertarProductoBusqueda({required String codigoProducto}) {
    return productoRepository.insertarProductoBusqueda(
        codigoProducto: codigoProducto);
  }

  Future<String> productoBusqueda({required String palabraProducto}) {
    return productoRepository.productoBusqueda(
        palabraProducto: palabraProducto);
  }

  Future<String> productoMasBuscado(codigoProducto) async =>
      await productoRepository.productoMasBuscado(codigoProducto: codigoProducto);
}
