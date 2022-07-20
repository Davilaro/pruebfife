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
    if (name == 'Imperdibles') {
      provider.agregarNumeroClickVerImpedibles = 1;
    } else if (name == 'Promos') {
      provider.agregarNumeroClickVerPromos = 1;
    }

    FlutterUxcam.logEventWithProperties("clickSeeMore", {
      "name": name,
      "times": provider.getNumeroClickCarrito,
    });
  }

  void seeDetailProduct(Productos element, int index, String? nameSeccion) {
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
    final total = element.precio * cantidad;
    FlutterUxcam.logEventWithProperties("addToCart", {
      "name": element.nombrecomercial,
      "category": element.marca,
      "provider": element.fabricante,
      "price": total,
      "quantity": cantidad,
    });
  }

// quedo pendiente implemetar este evento en realizar pedido en el carrito
  void clickPlaceOrder(
    CarroModelo cartProvider,
    List<Productos> listProducts,
  ) {
    List<Object> productos = [];
    if (cartProvider.getCantidadItems != 0) {
      listProducts.forEach((product) {
        dynamic cantidad = PedidoEmart.obtenerValor(product).toString();

        int quantity = int.parse(cantidad);
        var subTotal = product.precio * quantity;

        productos.add({
          "Subtotal": subTotal,
          "description": product.nombrecomercial,
          "quantity": quantity,
          "price": product.precio,
        });
      });
      FlutterUxcam.logEventWithProperties("addToCart", {
        "Pantalla": 'Check out 1',
        "items": productos,
      });
    }
  }
}
