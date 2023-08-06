
import 'package:emart/src/controllers/controller_db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OpcionesBard extends ChangeNotifier {
  final cargoConfirmar = Get.find<ControlBaseDatos>();
  int _selectMenuOption = 0;
  int _selectMenuOptionCategoria = 0;
  int _cambiarTamanoPantalla = 0;
  int _cambiarOpcioCatalogo = 0;
  int _opcionSubCategoria = 0;
  int _isLocal = 0;
  int _numeroClickCarrito = 0;
  int _numeroClickVerImpedibles = 0;
  int _numeroClickVerPromos = 0;
  final PageController pageController = PageController();

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

  int get selectOptionMenu => _selectMenuOption;

  set selectOptionMenu(int valor) {
    //esta parte es para que se cambien las paginas dependiendo del boton que se oprima
    pageController.animateToPage(valor,
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    _selectMenuOption = valor;
    notifyListeners();
  }

  opcionesTabBar(context, provider, index) {
    if (index == 1) {
      cargoConfirmar.tabController.index = 0;
      cargoConfirmar.cargoBaseDatos(0);
      provider.selectOptionMenu = 1;
    } else if (index != provider.selectOptionMenu) {
      provider.setIsLocal = 1;
      provider.selectOptionMenu = index;
    }
  }
}
