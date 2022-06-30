import 'package:flutter/material.dart';

class OpcionesBard extends ChangeNotifier {
  int _selectMenuOption = 0;
  int _selectMenuOptionCategoria = 0;
  int _cambiarTamanoPantalla = 0;
  int _cambiarOpcioCatalogo = 0;
  int _opcionSubCategoria = 0;
  int _isLocal = 0;

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
    this._selectMenuOption = valor;
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
}
