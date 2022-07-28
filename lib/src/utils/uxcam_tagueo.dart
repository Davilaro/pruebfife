import 'dart:convert';

import 'package:emart/src/modelos/pedido.dart';
import 'package:emart/src/modelos/productos.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';

class UxcamTagueo {
  void selectSeccion(String name) {
    FlutterUxcam.logEventWithProperties("clickHeader", {
      "name": name,
    });
  }

  void sendActivationCode(String metodo, String estado) {
    FlutterUxcam.logEventWithProperties("sendActivationCode", {
      "method_sent": metodo,
      "answer": estado,
    });
  }

  void manualActivation(String code, String estado) {
    FlutterUxcam.logEventWithProperties("manualActivation", {
      "code": code,
      "answer": estado,
    });
  }

  void activationCode(
      String code, String estado, bool privacyPolicy, bool dataPolicy) {
    FlutterUxcam.logEventWithProperties("activationCode", {
      "code": code,
      "answer": estado,
      "privacy_policy": privacyPolicy,
      "data_policy": dataPolicy
    });
  }

  void selectBanner(String name, String ubicacion) {
    FlutterUxcam.logEventWithProperties("clickBanner", {
      "name": name,
      "location": ubicacion,
    });
  }

  void search(String value) {
    FlutterUxcam.logEventWithProperties("search", {
      "search": value,
    });
  }

  void clickCarrito(provider, String ubicacion) {
    provider.agregarNumeroClickCarrito = 1;

    FlutterUxcam.logEventWithProperties("clickCarrito",
        {"times": provider.getNumeroClickCarrito, "location": ubicacion});
  }

  void seeMore(String name, provider) {
    try {
      if (name == 'Imperdibles') {
        provider.agregarNumeroClickVerImpedibles = 1;
      } else if (name == 'Promos') {
        provider.agregarNumeroClickVerPromos = 1;
      }

      FlutterUxcam.logEventWithProperties("clickSeeMore", {
        "name": name,
        "times": provider.getNumeroClickCarrito,
      });
    } catch (e) {
      print('Error tagueo clickCarrito $e');
    }
  }

  void seeDetailProduct(Productos element, int index, String? nameSeccion) {
    try {
      var descuento = nameSeccion == 'Promos'
          ? (element.descuento! * 100) / element.precio
          : 0;

      FlutterUxcam.logEventWithProperties("seeDetailProduct", {
        "name": element.nombrecomercial,
        "category": element.marca,
        "price": element.precio,
        "discount": "$descuento%",
        "position": index
      });
    } catch (e) {
      print('Error tagueo seeDetailProduct $e');
    }
  }

  void seeCategory(String name) {
    FlutterUxcam.logEventWithProperties("seeCategory", {
      "name": name,
    });
  }

  void selectFooter(String name) {
    FlutterUxcam.logEventWithProperties("selectFooter", {
      "name": name,
    });
  }

  void seeBrand(String name) {
    FlutterUxcam.logEventWithProperties("seeBrand", {
      "name": name,
    });
  }

  void seeProvider(String name) {
    FlutterUxcam.logEventWithProperties("seeProvider", {
      "name": name,
    });
  }

  void addToCart(Productos element, int cantidad) {
    try {
      // final total = element.precio * cantidad;
      FlutterUxcam.logEventWithProperties("addToCart", {
        "name": element.nombrecomercial,
        "category": element.marca,
        "provider": element.fabricante,
        "price": element.precio,
        "quantity": cantidad,
      });
    } catch (e) {
      print('Error tagueo addToCart $e');
    }
  }

  void removeToCart(
      Productos element, int cantidad, CarroModelo cartProvider, precioMinimo) {
    try {
      var isSufficientAmount = 'Si';
      var valorPedido = cartProvider.getListaFabricante[element.fabricante]
              ["precioFinal"] -
          element.precio;
      if (element.fabricante.toString().toUpperCase() != "MEALS") {
        if (valorPedido < precioMinimo) {
          isSufficientAmount = 'No';
        } else {
          isSufficientAmount = 'Si';
        }
      }

      FlutterUxcam.logEventWithProperties("removeToCart", {
        "name": element.nombrecomercial,
        "category": element.marca,
        "provider": element.fabricante,
        "price": element.precio,
        "quantity": cantidad,
        "sufficient_amount": isSufficientAmount
      });
    } catch (e) {
      print('Error tagueo removeToCart $e');
    }
  }

  void emptyToCart(String fabricante, CarroModelo cartProvider,
      List<dynamic> listProductos, precioMinimo) {
    try {
      List<Object> productos = [];
      listProductos.forEach((product) {
        var isSufficientAmount = 'Si';
        var valorPedido =
            cartProvider.getListaFabricante[fabricante]["precioFinal"];
        if (product.fabricante == fabricante && product.cantidad! > 0) {
          if (product.fabricante.toString().toUpperCase() != "MEALS") {
            if (valorPedido < precioMinimo) {
              isSufficientAmount = 'No';
            } else {
              isSufficientAmount = 'Si';
            }
          }
          productos.add({
            "name": product.nombre,
            "provider": fabricante,
            "price": product.precio,
            "quantity": product.cantidad,
            "sufficient_amount": isSufficientAmount
          });
        }
      });
      print('se me ejecute $productos');
      FlutterUxcam.logEventWithProperties(
          "emptyToCart", {"products": productos});
    } catch (e) {
      print('Error tagueo emptyToCart $e');
    }
  }

  void clickAction(String accion, fabricantes) {
    try {
      // final total = element.precio * cantidad;
      FlutterUxcam.logEventWithProperties("clickAction", {
        "action": accion,
        "providers": fabricantes,
      });
    } catch (e) {
      print('Error tagueo clickAction $e');
    }
  }

  void confirmOrder(
      List<Pedido> listaProductosPedidos, CarroModelo cartProvider) {
    try {
      final listProductos = listaProductosPedidos.map((producto) {
        var subTotal =
            cartProvider.getListaFabricante[producto.fabricante]["precioFinal"];
        return {
          "Subtotal": subTotal,
          "description": producto.nombreProducto,
          "provider": producto.fabricante,
          "quantity": producto.cantidad,
          "price": producto.precio,
        };
      }).toList();
      print(
          'resultado final ${cartProvider.getTotal} - ${listProductos.toList()}');
      FlutterUxcam.logEventWithProperties("confirmOrder", {
        "screen": "Check out 2",
        "products": [...listProductos],
        "total": cartProvider.getTotal
      });
    } catch (e) {
      print('Error tagueo confirmOrder $e');
    }
  }

  void clickSoport() {
    FlutterUxcam.logEvent("clickSoport");
  }

  void selectSoport(String tipo) {
    FlutterUxcam.logEventWithProperties("selectSoport", {
      "type": tipo,
    });
  }

// quedo pendiente implemetar este evento en realizar pedido en el carrito
  void clickPlaceOrder(CarroModelo cartProvider) {
    try {
      List<Object> listaProductos = [];
      PedidoEmart.listaValoresPedido!.forEach((key, value) {
        if (int.parse(value) > 0) {
          if (PedidoEmart.listaValoresPedidoAgregados![key] == true) {
            Productos producto = PedidoEmart.listaProductos![key]!;
            dynamic cantidad = PedidoEmart.obtenerValor(producto).toString();
            int quantity = int.parse(cantidad);
            // var subTotal = producto.precio * quantity;
            listaProductos.add({
              "provider": producto.fabricante,
              "Subtotal": cartProvider.getListaFabricante[producto.fabricante]
                  ["precioFinal"],
              "description": producto.nombrecomercial,
              "quantity": quantity,
              "price": producto.precio,
            });
          }
        }
      });
      FlutterUxcam.logEventWithProperties("clickPlaceOrder", {
        "screen": 'Check out 1',
        "items": listaProductos,
      });
    } catch (e) {
      print('Error tagueo clickPlaceOrder $e');
    }
  }
}
