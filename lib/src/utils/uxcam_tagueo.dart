import 'package:emart/src/modelos/pedido.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';

class UxcamTagueo {
  Preferencias prefs = Preferencias();

  void validarTipoUsuario() async {
    DateTime now = DateTime.now();
    String typeUser = 'Inactivo';

    String fechaInicial = '';
    String fechaFinal = '';

    var datosCliente = await DBProviderHelper.db.consultarDatosCliente();
    //se define el nombre del usuarios nit + nombre
    var userUxCam =
        (datosCliente[0].nit + datosCliente[0].nombre).replaceAll(' ', '');

    //se descartan usuarios que no se va ser seguimiento de uxcam en PRD
    if (Constantes().titulo != 'QA') {
      if (datosCliente[0].nit == '4415415' ||
          datosCliente[0].nit == '4415416' ||
          datosCliente[0].nit == '123123123') {
        FlutterUxcam.optOutOverall();
      }
    } else {
      FlutterUxcam.optInOverall();
    }
    // se capturan las fechas para validar compras
    if (now.month == 1) {
      fechaInicial = '${now.year - 1}-12-01';
      fechaFinal = '${now.year}-01-01';
    }
    if (now.month != 1) {
      fechaInicial =
          '${now.year}-${now.month.toString().length > 1 ? now.month == 10 ? '0${now.month - 1}' : now.month - 1 : '0${now.month - 1}'}-01';
      fechaFinal =
          '${now.year}-${now.month.toString().length > 1 ? now.month : '0${now.month}'}-01';
    }

    dynamic resQuery = await DBProviderHelper.db
        .consultarHistoricos("-1", fechaInicial, fechaFinal);

    // se define el tipo de usuarios, de acuerdo a la cantidad de compras en el mes anterior
    if (resQuery.length == 1) {
      typeUser = "Begginer";
    }
    if (resQuery.length >= 4) {
      typeUser = "Digitalizado";
    }
    if (resQuery.length > 1 && resQuery.length <= 3) {
      typeUser = "Progreso";
    }

    //UXCam: se asigna el nombre de usuario y se asigna el tipo de usuario
    FlutterUxcam.setUserIdentity('$userUxCam');
    FlutterUxcam.setUserProperty("subscription_type", typeUser);
    FlutterUxcam.logEventWithProperties(
        "sendLocation", {"City": prefs.ciudad, "Country": prefs.paisUsuario});
  }

  void selectSeccion(String name) {
    FlutterUxcam.logEventWithProperties("clickHeader",
        {"name": name, "City": prefs.ciudad, "Country": prefs.paisUsuario});
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
      "City": prefs.ciudad,
      "Country": prefs.paisUsuario
    });
  }

  void search(String value) {
    FlutterUxcam.logEventWithProperties("search",
        {"search": value, "City": prefs.ciudad, "Country": prefs.paisUsuario});
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
      }
      if (name == 'Promos') {
        provider.agregarNumeroClickVerPromos = 1;
      }

      FlutterUxcam.logEventWithProperties("clickSeeMore", {
        "name": name,
        "times": provider.getNumeroClickCarrito,
        "City": prefs.ciudad,
        "Country": prefs.paisUsuario
      });
    } catch (e) {
      print('Error tagueo clickCarrito $e');
    }
  }

  void seeDetailProduct(Producto element, int index, String? nameSeccion,
      bool isAgotadoLabel, bool isNewProduct, bool isPromoProduct) {
    try {
      var descuento = nameSeccion == 'Promos'
          ? (element.descuento! * 100) / element.precio
          : 0;
      var label = '';

      if (isNewProduct) label = 'Nuevo';
      if (isPromoProduct) label = 'Promo';
      if (isAgotadoLabel) label = 'Agotado';

      FlutterUxcam.logEventWithProperties("seeDetailProduct", {
        "name": element.nombrecomercial,
        "label": label,
        "category": element.marca,
        "price": element.precio,
        "discount": "$descuento%",
        "position": index,
        "City": prefs.ciudad,
        "Country": prefs.paisUsuario
      });
    } catch (e) {
      print('Error tagueo seeDetailProduct $e');
    }
  }

  void seeCategory(String name) {
    FlutterUxcam.logEventWithProperties("seeCategory",
        {"name": name, "City": prefs.ciudad, "Country": prefs.paisUsuario});
  }

  void selectFooter(String name) {
    FlutterUxcam.logEventWithProperties("selectFooter",
        {"name": name, "City": prefs.ciudad, "Country": prefs.paisUsuario});
  }

  void seeBrand(String name) {
    FlutterUxcam.logEventWithProperties("seeBrand",
        {"name": name, "City": prefs.ciudad, "Country": prefs.paisUsuario});
  }

  void seeProvider(String name) {
    FlutterUxcam.logEventWithProperties("seeProvider",
        {"name": name, "City": prefs.ciudad, "Country": prefs.paisUsuario});
  }

  void addToCart(Producto element, int cantidad) {
    try {
      // final total = element.precio * cantidad;
      FlutterUxcam.logEventWithProperties("addToCart", {
        "name": element.nombrecomercial,
        "category": element.marca,
        "provider": element.fabricante,
        "price": element.precio,
        "quantity": cantidad,
        "City": prefs.ciudad,
        "Country": prefs.paisUsuario
      });
    } catch (e) {
      print('Error tagueo addToCart $e');
    }
  }

  void removeToCart(
      Producto element, int cantidad, CarroModelo cartProvider, precioMinimo) {
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
        "sufficient_amount": isSufficientAmount,
        "City": prefs.ciudad,
        "Country": prefs.paisUsuario
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
            "sufficient_amount": isSufficientAmount,
          });
        }
      });

      FlutterUxcam.logEventWithProperties("emptyToCart", {
        "products": productos,
        "City": prefs.ciudad,
        "Country": prefs.paisUsuario
      });
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
        "City": prefs.ciudad,
        "Country": prefs.paisUsuario
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
        var precio = double.parse(producto.cantidad.toString()) *
            double.parse(producto.precio.toString());

        var productIndividual = {
          "product": producto.nombreProducto,
          "quantity": producto.cantidad,
          "provider": producto.fabricante,
          "price": precio,
          "City": prefs.ciudad,
          "Country": prefs.paisUsuario
        };
        clickPlaceIndividualOrder(productIndividual);
        return {
          "Subtotal": subTotal,
          "description": producto.nombreProducto,
          "provider": producto.fabricante,
          "quantity": producto.cantidad,
          "price": producto.precio,
        };
      }).toList();

      FlutterUxcam.logEventWithProperties("confirmOrder", {
        "screen": "Check out 2",
        "products": [...listProductos],
        "total": cartProvider.getTotal,
        "City": prefs.ciudad,
        "Country": prefs.paisUsuario
      });
    } catch (e) {
      print('Error tagueo confirmOrder $e');
    }
  }

  void clickSoport() {
    FlutterUxcam.logEvent("clickSoport");
  }

  void selectSoport(String tipo) {
    FlutterUxcam.logEventWithProperties("selectSoport",
        {"type": tipo, "City": prefs.ciudad, "Country": prefs.paisUsuario});
  }

  void clickPlaceOrder(CarroModelo cartProvider) {
    try {
      List<Object> listaProductos = [];

      PedidoEmart.listaValoresPedido!.forEach((key, value) {
        if (int.parse(value) > 0) {
          if (PedidoEmart.listaValoresPedidoAgregados![key] == true) {
            Producto producto = PedidoEmart.listaProductos![key]!;
            dynamic cantidad = PedidoEmart.obtenerValor(producto).toString();
            int quantity = int.parse(cantidad);

            var objeto = {
              "provider": producto.fabricante,
              "Subtotal": cartProvider.getListaFabricante[producto.fabricante]
                  ["precioFinal"],
              "description": producto.nombrecomercial,
              "quantity": quantity,
              "price": producto.precio,
            };

            listaProductos.add(objeto);
          }
        }
      });

      FlutterUxcam.logEventWithProperties("clickPlaceOrder", {
        "screen": 'Check out 1',
        "items": listaProductos,
        "City": prefs.ciudad,
        "Country": prefs.paisUsuario
      });
    } catch (e) {
      print('Error tagueo clickPlaceOrder $e');
    }
  }

  void clickPlaceIndividualOrder(Map<String, Object?> productIndividual) {
    try {
      FlutterUxcam.logEventWithProperties(
        "clickPlaceIndividualOrder",
        productIndividual,
      );
    } catch (e) {
      print('Error tagueo clickPlaceIndividualOrder $e');
    }
  }
}
