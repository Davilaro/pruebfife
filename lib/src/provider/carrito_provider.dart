import 'package:flutter/material.dart';

class CarroModelo extends ChangeNotifier {
  double _precioTotal = 0;
  int cantidadItems = 0;
  Map<String, dynamic> _listaValorFabricante = new Map();
  int _cambioVista = 0;
  double _precioAhorro = 0;

  double get getTotal {
    return _precioTotal;
  }

  set guardarValorCompra(double precio) {
    _precioTotal = precio;
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
