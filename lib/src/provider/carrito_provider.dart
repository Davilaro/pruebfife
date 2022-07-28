import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CarroModelo extends ChangeNotifier {
  double precioTotal = 0;
  int cantidadItems = 0;
  Map<String, dynamic> _listaValorFabricante = new Map();
  int _cambioVista = 0;
  double _precioAhorro = 0;
  final controladorPedidos = Get.find<PedidoEmart>();

  double get getTotal {
    return precioTotal;
  }

  set guardarValorCompra(double precio) {
    precioTotal = precio;
    controladorPedidos.setprecioTotal(precio);
    notifyListeners();
  }

  int get getCantidadItems {
    return cantidadItems;
  }

  set actualizarItems(int cantidad) {
    cantidadItems = cantidad;
    notifyListeners();
  }

  Map get getListaFabricante {
    return _listaValorFabricante;
  }

  set actualizarListaFabricante(Map<String, dynamic> fabricantes) {
    _listaValorFabricante = fabricantes;
    notifyListeners();
  }

  int get getCambiodevista {
    return _cambioVista;
  }

  set guardarCambiodevista(int vista) {
    _cambioVista = vista;
    notifyListeners();
  }

  double get getTotalAhorro {
    return _precioAhorro;
  }

  set guardarValorAhorro(double precio) {
    _precioAhorro = precio;
    notifyListeners();
  }
}
