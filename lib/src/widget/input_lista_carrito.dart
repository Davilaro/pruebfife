import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:emart/_pideky/presentation/product/view_model/product_view_model.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CarritoDisenoLista extends StatefulWidget {
  final int numTienda;
  final Product productos;

  const CarritoDisenoLista(
      {Key? key, required this.numTienda, required this.productos})
      : super(key: key);

  @override
  State<CarritoDisenoLista> createState() => _CarritoDisenoListaState();
}

class _CarritoDisenoListaState extends State<CarritoDisenoLista> {
  ProductViewModel productoViewModel = Get.find();
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartViewModel>(context);
    return Card(
      shape: RoundedRectangleBorder(
          side: new BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8.0)),
      child: _cargarDisenoInterno(widget.productos, context, cartProvider),
    );
  }

  _cargarDisenoInterno(
      element, BuildContext context, CartViewModel cartProvider) {
    Product productos = element;

    final size = MediaQuery.of(context).size;
    return Row(
      children: [
        Card(
          shape: RoundedRectangleBorder(
              side: new BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(15.0)),
          child: Container(
            height: 100,
            width: size.width * 0.3,
            child: CachedNetworkImage(
              imageUrl: Constantes().urlImgProductos + '${element.codigo}.png',
              placeholder: (context, url) =>
                  Image.asset('assets/image/jar-loading.gif'),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Container(
                width: size.width * 0.4,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 2.0),
                        margin: EdgeInsets.all(2),
                        child: Text(
                          '${element.nombre}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 2.0),
                        margin: EdgeInsets.all(2),
                        child: Text(
                          '${element.codigo}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 10.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 2.0, bottom: 5.0),
                        child: Text(
                          '' +
                              productoViewModel
                                  .getCurrency(int.parse(element.precio)),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, //Center Row contents horizontally,
                  crossAxisAlignment: CrossAxisAlignment
                      .center, //Center Row contents vertically,
                  children: [
                    SizedBox(
                      height: 40.0,
                      width: 40.0,
                      child: IconButton(
                        icon: Image.asset('assets/image/delete.png'),
                        onPressed: () => eliminar(productos, cartProvider),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                      width: 40.0,
                      child: IconButton(
                        icon: Image.asset('assets/image/menos.png'),
                        onPressed: () => menos(productos, cartProvider),
                      ),
                    ),
                    Container(
                      width: size.width * 0.15,
                      alignment: Alignment.center,
                      child: ConstrainedBox(
                        constraints: new BoxConstraints(
                          minWidth: 20,
                          maxWidth: 100,
                          minHeight: 10,
                          maxHeight: 70.0,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          reverse: true,
                          child: TextField(
                            maxLines: 1,
                            controller: PedidoEmart
                                .listaControllersPedido![productos.codigo],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                            onChanged: (value) {
                              setState(() {
                                if (value != "")
                                  PedidoEmart.registrarValoresPedido(
                                      productos, value, true);
                                else
                                  PedidoEmart.registrarValoresPedido(
                                      productos, "0", false);
                              });

                              calcularValorTotal(cartProvider);
                            },
                            decoration: InputDecoration(
                              fillColor: Colors.black,
                              hintText: '0',
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                      width: 40.0,
                      child: IconButton(
                        icon: Image.asset('assets/image/mas.png'),
                        onPressed: () => mas(productos, cartProvider),
                      ),
                    ),
                  ]),
            ],
          ),
        ),
      ],
    );
  }

  mas(Product producto, CartViewModel cartProvider) {
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

    calcularValorTotal(cartProvider);
  }

  menos(Product producto, CartViewModel cartProvider) {
    String valorInicial = PedidoEmart.obtenerValor(producto)!;

    if (valorInicial != "") {
      int valorResta = int.parse(valorInicial) - 1;
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
        });
      }
    }

    calcularValorTotal(cartProvider);
  }

  void calcularValorTotal(CartViewModel cartProvider) {
    double valorTotal = 0;
    int cantidad = 0;

    PedidoEmart.listaValoresPedido!.forEach((key, value) {
      if (value != "0") {
        double precio = PedidoEmart.listaProductos![key]!.precio;
        valorTotal = valorTotal + precio * int.parse(value);
        cantidad++;
      }
    });

    cartProvider.actualizarItems = cantidad;
    cartProvider.guardarValorCompra = valorTotal;
  }

  eliminar(Product producto, CartViewModel cartProvider) {
    setState(() {
      PedidoEmart.listaControllersPedido![producto.codigo]!.text = "0";
      PedidoEmart.registrarValoresPedido(producto, '0', false);
    });

    calcularValorTotal(cartProvider);
  }
}
