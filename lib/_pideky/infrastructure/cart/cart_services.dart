
import 'dart:convert';

import 'package:emart/_pideky/domain/cart/interface/interface_cart_gate_way.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/_pideky/presentation/my_orders/view_model/mis_pedidos_view_model.dart';
import 'package:emart/src/modelos/pedido.dart';
import 'package:emart/src/modelos/validar_pedido.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

final prefs = new Preferencias();
class CartServices implements InterfaceCartGateWay {
  @override
  Future sendOrder(List<Pedido> listaPedido, String usuarioLogin,
      String fechaPedido, String numDoc, CartViewModel cartProvider) async {
        String datos = "{\"ListaDetalle\" :[";
    final misPedidosViewModel = Get.find<MyOrdersViewModel>();

    for (var i = 0; i < listaPedido.length; i++) {
      print('new datos ${listaPedido[i].isFrecuencia} ');
      datos += jsonEncode(<String, dynamic>{
        "NumeroDoc": numDoc,
        "Cantidad": listaPedido[i].cantidad,
        "CodigoCliente": prefs.codCliente,
        "CodigoProducto": listaPedido[i].codigoProducto,
        "CodigoProveedor": 123,
        "DescripcionParam1": listaPedido[i].fabricante,
        "DescripcionParam2": listaPedido[i].codigocliente,
        "DescripcionParam3": listaPedido[i].nitFabricante,
        "descripcionparam5": listaPedido[i]
            .codigoFabricante, // colocar el codigo del fabricante de sucursales
        "FechaMovil": '$fechaPedido',
        "Iva": listaPedido[i].iva,
        "Observacion": 'Prueba',
        "Posicion": i,
        "Pais": prefs.paisUsuario,
        "Precio": listaPedido[i].precio,
        "ValorDescuento":
            listaPedido[i].precioInicial! * (listaPedido[i].descuento! / 100),
        "Param1": listaPedido[i].descuento!,
        "Param2": listaPedido[i].isOferta!,
        "Param3": listaPedido[i].precioDescuento!,
        "Param4": "${listaPedido[i].isFrecuencia}",
      });
      await misPedidosViewModel.misPedidosService
          .guardarSeguimientoPedido(listaPedido[i], numDoc);
      // await DBProviderHelper.db.guardarHistorico(listaPedido[i], numDoc);
      if (i < listaPedido.length - 1) {
        datos += ",";
      }
    }

    datos += "]}";

    try {
      final url;

      url = Uri.parse(
          '${Constantes().urlPrincipal}Pedido?codigo=nutresa&codUsuario=$usuarioLogin');
      print("url pedido $url");
      print("datos pedido $datos");

      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: datos);

      if (response.statusCode == 200) {
        print("restorno pedido ${response.body}");
        var res = ValidarPedido.fromJson(jsonDecode(response.body));

        return res;
      } else {
        print("restorno pedido ${response.body}");
        throw Exception('Failed');
      }
    } catch (e) {
      print('pedido res error ${e.toString()}');
      return null;
    }
  }
  
  

}