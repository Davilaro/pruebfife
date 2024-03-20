import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/_pideky/domain/product/use_cases/producto_use_cases.dart';
import 'package:emart/_pideky/infrastructure/product/product_service.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/metodo_ingresados.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ColumnTableCar extends StatefulWidget {
  final CartViewModel cartProvider;
  final Product producto;
  final int cantidad;
  final DatosListas providerDatos;
  ColumnTableCar(
      {Key? key,
      required this.producto,
      required this.cartProvider,
      required this.cantidad,
      required this.providerDatos})
      : super(key: key);

  @override
  _ColumnTableCarState createState() => _ColumnTableCarState();
}

class _ColumnTableCarState extends State<ColumnTableCar> {
  ProductoService productService = ProductoService(ProductoRepositorySqlite());
  @override
  Widget build(BuildContext context) {
    return Table(columnWidths: {
      0: FlexColumnWidth(2),
      1: FlexColumnWidth(5),
      2: FlexColumnWidth(3),
    }, children: [
      TableRow(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 25,
            ),
            child: GestureDetector(
              onTap: () {
                eliminarProductoCarrito(
                    widget.producto.codigo, widget.providerDatos);
              },
              child: Icon(
                Icons.delete_forever_outlined,
                color: HexColor("#43398E"),
                size: 32,
              ),
            ),
            alignment: Alignment.center,
          ),
          Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(top: 14),
              child: Column(
                children: [
                  Text(
                    widget.producto.nombre,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: HexColor("#30C3A3")),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Cantidad: ${widget.cantidad.toString()}",
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 22,
                ),
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () =>
                      menos(widget.producto.codigo, widget.providerDatos),
                  child: Container(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.do_disturb_on_outlined,
                      color: HexColor("#9F9F9F"),
                      size: 30,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 22,
                ),
                child: Text(
                  widget.cantidad.toString(),
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 22,
                ),
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.add_circle_outline,
                      color: HexColor("#30C3A3"),
                      size: 30,
                    ),
                  ),
                  onTap: () => mas(widget.producto.codigo),
                ),
              )
            ],
          ),
        ],
      )
    ]);
  }

  mas(String prod) async {
    Product producto = await productService.consultarDatosProducto(prod);

    String valorInicial = PedidoEmart.obtenerValor(producto)!;

    if (valorInicial == "") {
      PedidoEmart.listaControllersPedido![producto.codigo]!.text = "1";
      PedidoEmart.registrarValoresPedido(producto, '1', true);
    } else {
      int valoSuma = int.parse(valorInicial) + 1;
      setState(() {
        PedidoEmart.listaControllersPedido![producto.codigo]!.text =
            "$valoSuma";
        PedidoEmart.registrarValoresPedido(producto, '$valoSuma', true);
      });
    }

    MetodosLLenarValores().calcularValorTotal(widget.cartProvider);
  }

  menos(String prop, providerDatos) async {
    Product producto = await productService.consultarDatosProducto(prop);
    String valorInicial = PedidoEmart.obtenerValor(producto)!;

    if (valorInicial != "") {
      int valorResta = int.parse(valorInicial) - 1;
      if (valorResta <= 0) {
        setState(() {
          PedidoEmart.listaControllersPedido![producto.codigo]!.text = "0";
          PedidoEmart.registrarValoresPedido(producto, '0', false);
          providerDatos.regresarSugeridoCarrtio(prop);
        });
      } else {
        setState(() {
          PedidoEmart.listaControllersPedido![producto.codigo]!.text =
              "$valorResta";
          PedidoEmart.registrarValoresPedido(producto, '$valorResta', true);
        });
      }
    }

    MetodosLLenarValores().calcularValorTotal(widget.cartProvider);
  }

  void calcularValorTotal(CartViewModel cartProvider) {
    double valorTotal = 0;
    double valorAhorro = 0;
    int cantidad = 0;

    PedidoEmart.listaValoresPedido!.forEach((key, value) {
      if (value != "0") {
        if (PedidoEmart.listaValoresPedidoAgregados![key] == true) {
          double precio = PedidoEmart.listaProductos![key]!.precio;
          valorTotal = valorTotal + precio * int.parse(value);
          valorAhorro = valorAhorro +
              PedidoEmart.listaProductos![key]!.precio * int.parse(value);
          cantidad++;
        }
      }
    });

    cartProvider.guardarValorAhorro = valorAhorro;
    cartProvider.actualizarItems = cantidad;
    cartProvider.guardarValorCompra = valorTotal;
    PedidoEmart.calcularPrecioPorFabricante();
    cartProvider.actualizarListaFabricante =
        PedidoEmart.listaPrecioPorFabricante!;
  }

  eliminarProductoCarrito(String prop, providerDatos) async {
    Product producto = await productService.consultarDatosProducto(prop);
    String valorInicial = PedidoEmart.obtenerValor(producto)!;

    if (valorInicial != "") {
      int valorResta = 0;
      if (valorResta <= 0) {
        setState(() {
          PedidoEmart.listaControllersPedido![producto.codigo]!.text = "0";
          PedidoEmart.registrarValoresPedido(producto, '0', false);
        });
      } else {
        setState(() {
          PedidoEmart.listaControllersPedido![producto.codigo]!.text =
              "$valorResta";
          PedidoEmart.registrarValoresPedido(producto, '$valorResta', true);
          providerDatos.regresarSugeridoCarrtio(prop);
        });
      }
    }

    MetodosLLenarValores().calcularValorTotal(widget.cartProvider);
  }
}
