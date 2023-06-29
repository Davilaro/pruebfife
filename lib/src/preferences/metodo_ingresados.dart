import 'package:emart/src/provider/carrito_provider.dart';

import 'class_pedido.dart';

class MetodosLLenarValores {
  void calcularValorTotal(CarroModelo cartProvider) {
    double valorTotal = 0;
    double valorAhorro = 0;
    double valorTotalAhorro = 0;
    int cantidad = 0;

    PedidoEmart.listaValoresPedido!.forEach((key, value) {
      if (value != "0") {
        if (PedidoEmart.listaValoresPedidoAgregados![key] == true) {
          double? precio = PedidoEmart.listaProductos![key]!.descuento == 0
              ? PedidoEmart.listaProductos![key]!.precio
              : PedidoEmart.listaProductos![key]!.preciodescuento;
          valorTotal = valorTotal + precio! * int.parse(value);
          valorTotalAhorro += (PedidoEmart.listaProductos![key]!.descuento! *
              (PedidoEmart.listaProductos![key]!.precioinicial! *
                  int.parse(PedidoEmart.obtenerValor(
                      PedidoEmart.listaProductos![key]!)!)) /
              100);

          valorAhorro = valorAhorro +
              PedidoEmart.listaProductos![key]!.preciodescuento! *
                  int.parse(value);
          cantidad++;
        }
      }
    });

    cartProvider.actualizarItems = cantidad;
    cartProvider.guardarValorCompra = valorTotal;
    cartProvider.guardarValorAhorro = valorAhorro;
    cartProvider.setNuevoValorAhorro = valorTotalAhorro;
    PedidoEmart.calcularPrecioPorFabricante();
    cartProvider.actualizarListaFabricante =
        PedidoEmart.listaPrecioPorFabricante!;
  }
}
