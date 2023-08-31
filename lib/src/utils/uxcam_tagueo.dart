import 'package:emart/_pideky/presentation/mis_pedidos/view_model/mis_pedidos_view_model.dart';
import 'package:emart/_pideky/presentation/pedido_sugerido/view_model/pedido_sugerido_view_model.dart';
import 'package:emart/src/modelos/pedido.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';

class UxcamTagueo {
  Preferencias prefs = Preferencias();

  void validarTipoUsuario() async {
    final misPedidosViewModel = Get.find<MisPedidosViewModel>();
    DateTime now = DateTime.now();
    String typeUser = 'Inactivo';

    String fechaInicial = '';
    String fechaFinal = '';
    var numeroOrdenes = 0;

    var datosCliente = await DBProviderHelper.db.consultarDatosCliente();
    //se define el nombre del usuarios nit + nombre
    var userUxCam =
        (datosCliente[0].nit + datosCliente[0].nombre).replaceAll(' ', '');

    //se descartan usuarios que no se va ser seguimiento de uxcam en PRD
    if (Constantes().titulo != 'QA') {
      if (datosCliente[0].nit == '4415415' ||
          datosCliente[0].nit == '4415416' ||
          datosCliente[0].nit == '4415417' ||
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
    } else {
      fechaInicial =
          '${now.year}-${now.month.toString().length > 1 ? now.month == 10 ? '0${now.month - 1}' : now.month - 1 : '0${now.month - 1}'}-01';
      fechaFinal =
          '${now.year}-${now.month.toString().length > 1 ? now.month : '0${now.month}'}-01';
    }
    try {
      // dynamic resQuery = await misPedidosViewModel.misPedidosService
      //     .consultarHistoricos("-1", fechaInicial, fechaFinal);
      dynamic resQuery = await misPedidosViewModel.misPedidosService
          .consultarHistoricos("-1", fechaInicial, fechaFinal);
      List auxiliar = [];
      for (var i = 0; i < resQuery.length; i++) {
        if (!auxiliar.contains(resQuery[i].fechaTrans)) {
          auxiliar.add(resQuery[i].fechaTrans);
        }
      }

      // se define el tipo de usuarios, de acuerdo a la cantidad de compras en el mes anterior
      if (auxiliar.length == 1) {
        typeUser = "Begginer";
      } else if (auxiliar.length >= 4) {
        typeUser = "Digitalizado";
      } else if (auxiliar.length > 1 && auxiliar.length <= 3) {
        typeUser = "Progreso";
      }
      numeroOrdenes = auxiliar.length;
    } catch (e) {
      print('Evento validarTipoUsuario fallo peticion historico $e');
    }

    //UXCam: se asigna el nombre de usuario y se asigna el tipo de usuario
    FlutterUxcam.setUserIdentity('$userUxCam');
    FlutterUxcam.setUserProperty("subscription_type", typeUser);
    FlutterUxcam.setUserProperty("number_of_orders", numeroOrdenes.toString());
    FlutterUxcam.setUserProperty("nit_client", datosCliente[0].nit);
    FlutterUxcam.setUserProperty("City", prefs.ciudad);
    FlutterUxcam.setUserProperty("Country", prefs.paisUsuario);
    FlutterUxcam.logEventWithProperties(
        "sendLocation", {"City": prefs.ciudad, "Country": prefs.paisUsuario});
  }

  void selectSeccion(String name) {
    if (prefs.usurioLogin == 1)
      FlutterUxcam.logEventWithProperties("clickHeader", {
        "name": name,
        "City": prefs.ciudad ?? "",
        "Country": prefs.paisUsuario ?? "CO"
      });
  }

  void selectDropDown(String sectionName, String section) {
    if (prefs.usurioLogin == 1)
      FlutterUxcam.logEventWithProperties("selectDropDown", {
        "sectionName": sectionName,
        "section": section,
        "City": prefs.ciudad ?? "",
        "Country": prefs.paisUsuario ?? "CO"
      });
  }

  void selectSectionPedidoSugerido(String section) {
    if (prefs.usurioLogin == 1)
      FlutterUxcam.logEventWithProperties("selectSectionPedidoSugerido", {
        "section": section,
        "City": prefs.ciudad ?? "",
        "Country": prefs.paisUsuario ?? "CO"
      });
  }

  void selectSectionMisPedidos(String section) {
    if (prefs.usurioLogin == 1)
      FlutterUxcam.logEventWithProperties("selectSectionMisPedidos", {
        "section": section,
        "City": prefs.ciudad ?? "",
        "Country": prefs.paisUsuario ?? "CO"
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
    if (prefs.usurioLogin == 1)
      FlutterUxcam.logEventWithProperties("clickBanner", {
        "name": name,
        "location": ubicacion,
        "City": prefs.ciudad ?? "",
        "Country": prefs.paisUsuario ?? "CO"
      });
  }

  void search(String value) {
    if (prefs.usurioLogin == 1)
      FlutterUxcam.logEventWithProperties("search", {
        "search": value,
        "City": prefs.ciudad ?? "",
        "Country": prefs.paisUsuario ?? "CO"
      });
  }

  void clickCarrito(provider, String ubicacion) {
    provider.agregarNumeroClickCarrito = 1;
// FALTA AGREGAR CIUDAD Y PAIS
    if (prefs.usurioLogin == 1)
      FlutterUxcam.logEventWithProperties("clickCarrito", {
        "times": provider.getNumeroClickCarrito,
        "location": ubicacion,
        "City": prefs.ciudad ?? "",
        "Country": prefs.paisUsuario ?? "CO"
      });
  }

  void seeMore(String name, provider) {
    try {
      if (name == 'Imperdibles') {
        provider.agregarNumeroClickVerImpedibles = 1;
      }
      if (name == 'Promos') {
        provider.agregarNumeroClickVerPromos = 1;
      }
      if (prefs.usurioLogin == 1)
        FlutterUxcam.logEventWithProperties("clickSeeMore", {
          "name": name,
          "times": provider.getNumeroClickCarrito,
          "City": prefs.ciudad ?? "",
          "Country": prefs.paisUsuario ?? "CO"
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
      print('TAGUEO ADD SEEDETAULPRODUCTO');
      if (prefs.usurioLogin == 1)
        FlutterUxcam.logEventWithProperties("seeDetailProduct", {
          "name": element.nombrecomercial,
          "label": label,
          "category": element.marca,
          "provider": element.fabricante,
          "price": element.precio,
          "discount": "$descuento%",
          "position": index,
          "City": prefs.ciudad ?? "",
          "Country": prefs.paisUsuario ?? "CO"
        });
    } catch (e) {
      print('Error tagueo seeDetailProduct $e');
    }
  }

  void seeCategory(String name) {
    if (prefs.usurioLogin == 1)
      FlutterUxcam.logEventWithProperties("seeCategory", {
        "name": name,
        "City": prefs.ciudad ?? "",
        "Country": prefs.paisUsuario ?? "CO"
      });
  }

  void selectFooter(String name) {
    if (prefs.usurioLogin == 1)
      FlutterUxcam.logEventWithProperties("selectFooter", {
        "name": name,
        "City": prefs.ciudad ?? "",
        "Country": prefs.paisUsuario ?? "CO"
      });
  }

  void seeBrand(String name) {
    if (prefs.usurioLogin == 1)
      FlutterUxcam.logEventWithProperties("seeBrand", {
        "name": name,
        "City": prefs.ciudad ?? "",
        "Country": prefs.paisUsuario ?? "CO"
      });
  }

  void seeProvider(String name) {
    if (prefs.usurioLogin == 1)
      FlutterUxcam.logEventWithProperties("seeProvider", {
        "name": name,
        "City": prefs.ciudad ?? "",
        "Country": prefs.paisUsuario ?? "CO"
      });
  }

  void addToCart(Producto element, int cantidad) {
    try {
      print('TAGUEO ADD TO CART');
      if (prefs.usurioLogin == 1)
        FlutterUxcam.logEventWithProperties("addToCart", {
          "name": element.nombrecomercial,
          "category": element.marca,
          "provider": element.fabricante,
          "price": element.precio,
          "quantity": cantidad,
          "City": prefs.ciudad ?? "",
          "Country": prefs.paisUsuario ?? "CO"
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
      if (prefs.usurioLogin == 1)
        FlutterUxcam.logEventWithProperties("removeToCart", {
          "name": element.nombrecomercial,
          "category": element.marca,
          "provider": element.fabricante,
          "price": element.precio,
          "quantity": cantidad,
          "sufficient_amount": isSufficientAmount,
          "City": prefs.ciudad ?? "",
          "Country": prefs.paisUsuario ?? "CO"
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
      if (prefs.usurioLogin == 1)
        FlutterUxcam.logEventWithProperties("emptyToCart", {
          "products": productos,
          "City": prefs.ciudad ?? "",
          "Country": prefs.paisUsuario ?? "CO"
        });
    } catch (e) {
      print('Error tagueo emptyToCart $e');
    }
  }

  void clickAction(String accion, fabricantes) {
    try {
      if (prefs.usurioLogin == 1)
        FlutterUxcam.logEventWithProperties("clickAction", {
          "action": accion,
          "providers": fabricantes,
          "City": prefs.ciudad ?? "",
          "Country": prefs.paisUsuario ?? "CO"
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
          "City": prefs.ciudad ?? "",
          "Country": prefs.paisUsuario ?? "CO"
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
      if (prefs.usurioLogin == 1)
        FlutterUxcam.logEventWithProperties("confirmOrder", {
          "screen": "Check out 2",
          "products": [...listProductos],
          "total": cartProvider.getTotal,
          "City": prefs.ciudad ?? "",
          "Country": prefs.paisUsuario ?? "CO"
        });
    } catch (e) {
      print('Error tagueo confirmOrder $e');
    }
  }

  void addToCartSuggestedOrder(listaProductosPedidos, fabricante) {
    final viewModel = Get.find<PedidoSugeridoViewModel>();

    try {
      final listProductos = listaProductosPedidos.map((producto) {
        var subTotal = viewModel.listaProductosPorFabricante[fabricante]
            ["precioProductos"];

        var productIndividual = {
          "product": "${producto.nombre}",
          "quantity": "${producto.cantidad}",
          "provider": "$fabricante",
          "price": "$subTotal",
          "City": prefs.ciudad ?? "",
          "Country": prefs.paisUsuario ?? "CO"
        };

        print("productos $productIndividual");
        return productIndividual;
      }).toList();
      print(
        "productosss  $listProductos",
      );
      if (prefs.usurioLogin == 1)
        FlutterUxcam.logEventWithProperties("addToCartSuggestedOrder", {
          "City": prefs.ciudad ?? "",
          "Country": prefs.paisUsuario ?? "CO",
          "products": "${[...listProductos]}",
        });
    } catch (e) {
      print('Error tagueo confirmOrder $e');
    }
  }

  void addToCartRepeatdOrder(listaProductosPedidos) {
    try {
      final listProductos = listaProductosPedidos.map((producto) {
        var productIndividual = {
          "product": "${producto.nombreProducto}",
          "quantity": "${producto.cantidad}",
          "provider": "${producto.fabricante}",
          "City": prefs.ciudad ?? "",
          "Country": prefs.paisUsuario ?? "CO"
        };

        print("repetir orden $productIndividual");
        return productIndividual;
      }).toList();
      print(
        "productosss  $listProductos",
      );
      if (prefs.usurioLogin == 1)
        FlutterUxcam.logEventWithProperties("addToCartRepeatOrder", {
          "City": prefs.ciudad ?? "",
          "Country": prefs.paisUsuario ?? "CO",
          "products": "${[...listProductos]}",
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
      "City": prefs.ciudad ?? "",
      "Country": prefs.paisUsuario ?? "CO"
    });
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
      if (prefs.usurioLogin == 1)
        FlutterUxcam.logEventWithProperties("clickPlaceOrder", {
          "screen": 'Check out 1',
          "items": listaProductos,
          "City": prefs.ciudad ?? "",
          "Country": prefs.paisUsuario ?? "CO"
        });
    } catch (e) {
      print('Error tagueo clickPlaceOrder $e');
    }
  }

  void clickPlaceIndividualOrder(Map<String, Object?> productIndividual) {
    try {
      if (prefs.usurioLogin == 1)
        FlutterUxcam.logEventWithProperties(
          "clickPlaceIndividualOrder",
          productIndividual,
        );
    } catch (e) {
      print('Error tagueo clickPlaceIndividualOrder $e');
    }
  }

  void onTapSlideUp(close) {
    try {
      if (prefs.usurioLogin == 1) {
        FlutterUxcam.logEventWithProperties("onTapSlideUp", {
          "close" : close,
          "navegation" : true,
          "City": prefs.ciudad ?? "",
          "Country": prefs.paisUsuario ?? "CO"
        });
      }
    } catch (e) {
      print('Error tagueo onTapSlideUp $e');
    }
  }
  void onTapPushInUp(close) {
    try {
      if (prefs.usurioLogin == 1) {
        FlutterUxcam.logEventWithProperties("onTapPushInUp", {
          "close" : close,
          "navegation" : close == true? false : true,
          "City": prefs.ciudad ?? "",
          "Country": prefs.paisUsuario ?? "CO"
        });
      }
    } catch (e) {
      print('Error tagueo onTapPushInUp $e');
    }
  }
}
