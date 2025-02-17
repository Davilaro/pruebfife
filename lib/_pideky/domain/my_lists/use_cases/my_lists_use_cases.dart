import 'package:emart/_pideky/domain/my_lists/interface/interface_my_lists_gate_way.dart';

class MyListsUseCases {
  final InterfaceMyListsGateWay misListasInterface;

  MyListsUseCases({required this.misListasInterface});

  Future getMisListas() async {
    return await misListasInterface.getMisListas();
  }

  Future addLista(
      {required String nombreLista,
      required String sucursal,
      required String ccup}) async {
    return await misListasInterface.addLista(
        nombreLista: nombreLista, sucursal: sucursal, ccup: ccup);
  }

  Future updateLista(
      {required String nombreLista,
      required String sucursal,
      required String ccup,
      required int idLista}) async {
    return await misListasInterface.updateLista(
        nombreLista: nombreLista,
        sucursal: sucursal,
        ccup: ccup,
        idLista: idLista);
  }

  Future deleteLista(
      {required String ccup,
      required String nombre,
      required String sucursal,
      required int idLista,
      required context
      }) async {
    return await misListasInterface.deleteLista(
        ccup: ccup, nombre: nombre, sucursal: sucursal, idLista: idLista, context: context);
  }

  Future addProducto(
      {required int id,
      required String codigoProducto,
      required int cantidad,
      required String proveedor}) async {
    return await misListasInterface.addProducto(
        idLista: id,
        codigoProducto: codigoProducto,
        cantidad: cantidad,
        proveedor: proveedor);
  }

  Future updateProducto(
      {required int id,
      required String codigoProducto,
      required int cantidad,
      required String proveedor}) async {
    return await misListasInterface.updateProducto(
        idLista: id,
        codigoProducto: codigoProducto,
        cantidad: cantidad,
        proveedor: proveedor);
  }

  Future deleteProducto({required List productos}) async {
    return await misListasInterface.deleteProducto(productos: productos);
  }

  Future getProductos({ int? idLista}) async {
    return await misListasInterface.getProductos(idLista: idLista);
  }
}
