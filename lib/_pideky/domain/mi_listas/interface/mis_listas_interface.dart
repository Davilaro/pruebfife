abstract class MisListasInterface {
  Future getMisListas();
  Future addLista(
      {required String nombreLista,
      required String sucursal,
      required String ccup});
  Future updateLista(
      {required String nombreLista,
      required String sucursal,
      required String ccup,
      required int idLista});
  Future deleteLista(
      {required String ccup,
      required String nombre,
      required String sucursal,
      required int idLista});
  Future addProducto(
      {required int idLista,
      required String codigoProducto,
      required int cantidad,
      required String proveedor});
  Future updateProducto(
      {required int idLista,
      required String codigoProducto,
      required int cantidad,
      required String proveedor});
  Future deleteProducto({required List productos});
  Future getProductos({int? idLista});
}
