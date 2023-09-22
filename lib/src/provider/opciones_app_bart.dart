import 'package:flutter/material.dart';

class OpcionesBard extends ChangeNotifier {
  int _selectMenuOption = 0;
  int _selectMenuOptionCategoria = 0;
  int _cambiarTamanoPantalla = 0;
  int _cambiarOpcioCatalogo = 0;
  int _opcionSubCategoria = 0;
  int _isLocal = 0;
  int _numeroClickCarrito = 0;
  int _numeroClickVerImpedibles = 0;
  int _numeroClickVerPromos = 0;
  final PageController _pageController = PageController();

  int get getNumeroClickVerImpedibles {
    return _numeroClickVerImpedibles;
  }

  set agregarNumeroClickVerImpedibles(int valor) {
    _numeroClickVerImpedibles += valor;
    notifyListeners();
  }

  set setNumeroClickVerImpedibles(int valor) {
    _numeroClickVerImpedibles = valor;
    notifyListeners();
  }

  int get getNumeroClickVerPromos {
    return _numeroClickVerPromos;
  }

  set agregarNumeroClickVerPromos(int valor) {
    _numeroClickVerPromos += valor;
    notifyListeners();
  }

  set setNumeroClickVerPromos(int valor) {
    _numeroClickVerPromos = valor;
    notifyListeners();
  }

  int get getNumeroClickCarrito {
    return _numeroClickCarrito;
  }

  set agregarNumeroClickCarrito(int valor) {
    _numeroClickCarrito += valor;
    notifyListeners();
  }

  set setNumeroClickCarrito(int valor) {
    _numeroClickCarrito = valor;
    notifyListeners();
  }

  int get getIisLocal {
    return _isLocal;
  }

  set setIsLocal(int valor) {
    _isLocal = valor;
    notifyListeners();
  }

  int get selectOptionMenu {
    return _selectMenuOption;
  }

  set selectOptionMenu(int valor) {
    _pageController.animateToPage(valor,
        duration: Duration(milliseconds: 250), curve: Curves.easeOut);
    //_pageController.jumpToPage(valor);
    this._selectMenuOption = valor;

    notifyListeners();
  }

  get pageController => _pageController;

  int get selectOptionMenuCategoria {
    return _selectMenuOptionCategoria;
  }

  set selectOptionMenuCategoria(int valor) {
    _selectMenuOptionCategoria = valor;
    notifyListeners();
  }

  int get selectCambiarTamanoPantalla {
    return _cambiarTamanoPantalla;
  }

  set selectCambiarTamanoPantalla(int valor) {
    _cambiarTamanoPantalla = valor;
    notifyListeners();
  }

  int get selectCambiarOpcionCatalogo {
    return _cambiarOpcioCatalogo;
  }

  set selectCambiarOpcionCatalogo(int valor) {
    _cambiarOpcioCatalogo = valor;
    notifyListeners();
  }

  int get selectSubCategoria {
    return _opcionSubCategoria;
  }

  set selectSubCategoria(int valor) {
    _opcionSubCategoria = valor;
    notifyListeners();
  }
}
