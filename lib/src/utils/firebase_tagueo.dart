import 'dart:convert';

import 'package:emart/src/modelos/pedido.dart';
import 'package:emart/src/modelos/productos.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/provider/carrito_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class TagueoFirebase {
  static FirebaseAnalytics _analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> sendAnalitytics(String user) async {
    await _analytics.logEvent(name: 'login', parameters: {"user_id": user});
    await _analytics.setUserId(user);
  }

  Future<void> sendAnalityticSelectContent(
      String location,
      String contentType,
      String? itemBrand,
      String itemCategoria,
      String itemId,
      String? view) async {
    try {
      await _analytics.logEvent(name: 'select_content', parameters: {
        "content_location": location,
        "content_type": contentType,
        "item_brand": itemBrand,
        "item_category": itemCategoria,
        "item_id": itemId,
      });
    } catch (e) {
      print('ERROR SELECT_CONTENT $e');
    }
  }

  Future<void> sendAnalityticsActivationCodeSubmission(String nit) async {
    try {
      await _analytics
          .logEvent(name: 'activation_code_submission', parameters: {
        "value": nit,
      });
    } catch (e) {
      print('ERROR ACTIVATION_CODE_SUBMISSION $e');
    }
  }

  Future<void> sendAnalityticsActivationCodeReceived(String nit) async {
    try {
      await _analytics.logEvent(name: 'activation_code_received', parameters: {
        "value": nit,
      });
    } catch (e) {
      print('ERROR ACTIVATION_CODE_RECEIVED $e');
    }
  }

  Future<void> sendAnalityticsActivationCodeSucces(String nit) async {
    try {
      await _analytics.logEvent(name: 'activation_code_succes', parameters: {
        "value": nit,
      });
    } catch (e) {
      print('ERROR ACTIVATION_CODE_SUCCES $e');
    }
  }

  Future<void> sendAnalityticsActivationCodeError(String nit) async {
    try {
      await _analytics.logEvent(name: 'activation_code_error', parameters: {
        "value": nit,
      });
    } catch (e) {
      print('ERROR ACTIVATION_CODE_ERROR $e');
    }
  }

  Future<void> sendAnalityticsSearch(String value) async {
    try {
      await _analytics.logEvent(name: 'search', parameters: {
        "search_term": value,
      });
    } catch (e) {
      print('ERROR SEARCH $e');
    }
  }

  Future<void> sendAnalityticDeleteCart(
      String categoria, String nombreComercial) async {
    try {
      await _analytics.logEvent(name: 'delete_cart', parameters: {
        "content_type": "Item",
        "itemBrand": categoria,
        "itemCategory": nombreComercial,
        "itemId": categoria
      });
    } catch (e) {
      print('ERROR DELETE_CART $e');
    }
  }

  Future<void> sendAnalityticSelectQuickAccess(
      String descripcion, String codAccessTable) async {
    try {
      await _analytics.logEvent(name: 'select_quick_access', parameters: {
        "content_type": "button",
        "creative_name": descripcion,
        "creative_slot": codAccessTable,
        "location_id": "",
        "promotion_id": "",
        "promotion_name": descripcion,
      });
    } catch (e) {
      print('ERROR SELECT_QUICK_ACCESS $e');
    }
  }

  Future<void> sendAnalityticViewPromotion(String location, banner) async {
    try {
      await _analytics.logEvent(name: 'view_promotion', parameters: {
        "content_location": location,
        "content_type": banner.fabricante,
        "item_brand": banner.empresa,
        "item_category": banner.fabricante,
        "promotion_name": banner.nombreBanner,
        "creative_name": banner.nombreBanner,
        "creative_slot": location,
        "item_id": banner.idBanner
      });
    } catch (e) {
      print('ERROR VIEW_PROMOTION $e');
    }
  }

  Future<void> sendAnalityticSelectItem(
      Productos producto, int cantidad) async {
    try {
      var resPrice = producto.precio / 1000000;
      var data = {
        "item_id": producto.codigo,
        "item_name": producto.nombre,
        "coupon": "",
        "currency": "COP",
        "discount": producto.descuento,
        "index": 0,
        "item_brand": producto.categoria,
        "item_category": producto.marca,
        "item_category2": producto.marca,
        "item_list_id": producto.marca,
        "item_list_name": producto.marca,
        "item_variant": "",
        "location_id": "",
        "price": resPrice,
        "quantity": cantidad,
      };

      await _analytics.logEvent(name: 'select_item', parameters: {
        "item_list_id": producto.marca,
        "item_list_name": producto.marca,
        "items": [data],
      });
    } catch (e) {
      print('ERROR SELECT_ITEM $e');
    }
  }

  Future<void> sendAnalityticAddToCart(Productos producto, int cantidad) async {
    try {
      final total = producto.precio * cantidad;
      var resPrice = producto.precio / 1000000;

      var data = {
        "item_id": producto.codigo,
        "item_name": producto.nombre,
        "coupon": "",
        "discount": producto.descuento,
        "index": 0,
        "item_brand": producto.categoria,
        "item_category": producto.marca,
        "item_list_id": producto.marca,
        "item_list_name": producto.marca,
        "item_variant": producto.volumen,
        "location_id": "",
        "price": resPrice,
        "quantity": cantidad,
      };

      await _analytics.logEvent(name: 'add_to_cart', parameters: {
        "currency": "COP",
        "value": total,
        "items": [data],
      });
    } catch (e) {
      print('ERROR ADD_TO_CART $e');
    }
  }

  Future<void> sendAnalityticRemoveFromCart(
      Productos producto, String? cantidad) async {
    try {
      final totalOrden = producto.precio * int.parse(cantidad!);
      var resPrice = producto.precio / 1000000;
      var data = {
        "item_id": producto.codigo,
        "item_name": producto.nombre,
        "coupon": "",
        "currency": "COP",
        "discount": producto.descuento,
        "index": 0,
        "item_brand": producto.categoria,
        "item_category": producto.marca,
        "item_category2": producto.marca,
        "item_list_id": producto.marca,
        "item_list_name": producto.marca,
        "item_variant": producto.volumen,
        "location_id": "",
        "price": resPrice,
        "quantity": int.parse(cantidad),
      };

      await _analytics.logEvent(name: 'remove_from_cart', parameters: {
        "currency": "COP",
        "value": totalOrden,
        "items": [data],
      });
    } catch (e) {
      print('ERROR REMOVE_FROM_CART $e');
    }
  }

  Future<void> sendAnalityticSelectPromotion(
      String location,
      String nombreBanner,
      String categoria,
      String fabricante,
      int idBanner) async {
    try {
      await _analytics.logEvent(name: 'select_promotion', parameters: {
        "content_location": location,
        "content_type": fabricante,
        "item_brand": fabricante,
        "item_category": categoria,
        // "promotion_name": listString[listString.length - 1],
        "promotion_name": nombreBanner,
        "creative_name": nombreBanner,
        "creative_slot": "",
        "item_id": idBanner
      });
    } catch (e) {
      print('ERROR SELECT_PROMOTION $e');
    }
  }

  Future<void> sendAnalityticViewItem(
      Productos producto, int totalOrden) async {
    try {
      var resPrice = producto.precio / 1000000;
      var data = {
        "item_id": producto.codigo,
        "item_name": producto.nombre,
        "coupon": "",
        "discount": producto.descuento,
        "item_brand": producto.categoria,
        "item_category": producto.marca,
        "item_variant": producto.volumen,
        "price": resPrice,
        "currency": "COP",
        "quantity": totalOrden,
      };
      await _analytics.logEvent(name: 'view_item', parameters: {
        "currency": "COP",
        "items": [data],
        "value": producto.precio * totalOrden
      });
    } catch (e) {
      print('ERROR VIEW_ITEM $e');
    }
  }

  Future<void> sendAnalityticViewCart(CarroModelo cartProvider,
      List<Productos> listProducts, String? view) async {
    try {
      List<Object> productos = [];
      var contador = 1;
      if (cartProvider.getCantidadItems != 0) {
        listProducts.forEach((product) {
          var resPrice = product.precio / 1000000;
          dynamic cantidad = PedidoEmart.obtenerValor(product).toString();

          int quantity = int.parse(cantidad);
          productos.add({
            "item_id": product.codigo,
            "item_name": product.nombre,
            "coupon": "",
            "currency": "COP",
            "discount": product.descuento,
            "index": contador,
            "item_brand": product.categoria,
            "item_category": product.marca,
            "item_category2": product.marca,
            "item_list_id": product.marca,
            "item_list_name": product.marca,
            "item_variant": product.volumen,
            "location_id": "",
            "price": resPrice,
            "quantity": quantity,
          });
          contador++;
        });

        await _analytics.logEvent(name: 'view_cart', parameters: {
          "currency": "COP",
          "value": cartProvider.getTotal,
          "items": productos,
        });
      }
    } catch (e) {
      print('ERROR VIEW_CART $e');
    }
  }

  Future<void> sendAnalityticsPurchase(
      double totalOrden, List<Pedido> productos, codOrden) async {
    try {
      var contador = -1;
      var iva = 0.0;
      final listProductos = productos.map((item) {
        contador += 1;
        iva = (item.iva! / 100) * totalOrden;
        var resPrice = item.precio! / 1000000;
        return {
          "item_id": item.codigoProducto,
          "item_name": item.nombreProducto,
          "coupon": "",
          "currency": "COP",
          "discount": item.descuento,
          "index": contador,
          "item_brand": item.tipoFabricante,
          "item_category": item.fabricante,
          "item_category2": item.fabricante,
          "item_list_id": item.fabricante,
          "item_list_name": item.fabricante,
          "item_variant": "",
          "location_id": "",
          "price": resPrice,
          "quantity": item.cantidad,
        };
      }).toList();

      await _analytics.logEvent(name: 'purchase', parameters: {
        "currency": "COP",
        "transaction_id": codOrden,
        "value": totalOrden,
        "coupon": "",
        "shipping": 0,
        "tax": iva,
        "items": [...listProductos],
      });
    } catch (e) {
      print('ERROR PURCHARSE $e');
    }
  }

  Future<void> sendAnalityticViewItemList(
      List<dynamic> list, String location) async {
    try {
      var contador = -1;
      var data = list.map((item) {
        Productos productos = item;
        var resPrice = productos.precio / 1000000;
        contador++;
        return {
          "item_id": productos.codigo,
          "item_name": productos.nombre,
          "coupon": "",
          "currency": "COP",
          "discount": productos.descuento,
          "index": contador,
          "item_brand": productos.fabricante,
          "item_category": productos.categoria,
          "item_category2": productos.categoria,
          "item_list_id": productos.fabricante,
          "item_list_name": productos.nombrecomercial,
          "item_variant": "",
          "location_id": "",
          "price": resPrice,
          "quantity": 1,
        };
      });

      await _analytics.logEvent(name: 'view_item_list', parameters: {
        "item_list_id": location,
        "item_list_name": location,
        "items": data.toList(),
      });
    } catch (e) {
      print('ERROR VIEW_ITEM_LIST $e');
    }
  }

  Future<void> sendAnalityticViewMultimedia() async {
    try {
      await _analytics.logEvent(name: 'view_multi_media', parameters: {
        "content_location": "Home",
        "item_name": "multi-media",
        "content_type": "video"
      });
    } catch (e) {
      print('ERROR VIEW_MULTI_MEDIA $e');
    }
  }
}
