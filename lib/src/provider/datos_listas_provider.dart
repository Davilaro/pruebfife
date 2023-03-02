import 'package:emart/src/preferences/const.dart';
import 'package:flutter/material.dart';

class DatosListas extends ChangeNotifier {
  List<dynamic> _listaMarcas = [];
  List<dynamic> _listaCategorias = [];
  List<dynamic> _listaBanner = [];
  List<dynamic> _listaSugueridos = [];
  List<dynamic> _listaSugueridosHelper = [];
  List<dynamic> _listafabricantes = [];
  List<dynamic> _listaAccesosRapido = [];
  List<dynamic> _listaHistoricos = [];
  List<dynamic> _listaBannerInternos = [];
  double _precioMinimo = 0;
  double _precioMaximo = 1000000;
  bool _validarDescaraga = false;

  double get getPrecioMinimo {
    return _precioMinimo;
  }

  double get getPrecioMaximo {
    return _precioMaximo;
  }

  guardarPrecioMinimo(double precioMinimo) {
    _precioMinimo = precioMinimo;
    notifyListeners();
  }

  guardarPrecioMaximo(double precioMaximo) {
    _precioMaximo = precioMaximo;
    notifyListeners();
  }

  List<dynamic> get getListaMarcas {
    return _listaMarcas;
  }

  set guardarListaMarcas(List<dynamic> lista) {
    _listaMarcas = lista;
    notifyListeners();
  }

  List<dynamic> get getListaCategorias {
    return _listaCategorias;
  }

  set guardarCategorias(List<dynamic> lista) {
    _listaCategorias = lista;
    notifyListeners();
  }

  List<dynamic> get getListaBanners {
    return _listaBanner;
  }

  set guardarListaBanners(List<dynamic> lista) {
    _listaBanner = lista;
    notifyListeners();
  }

  List<dynamic> get getListaSuguerido {
    return _listaSugueridos;
  }

  set guardarListaSuguerido(List<dynamic> lista) {
    _listaSugueridos = lista;
    notifyListeners();
  }

  List<dynamic> get getListaSugueridoHelper {
    return _listaSugueridosHelper;
  }

  set guardarListaSugueridoHelper(List<dynamic> lista) {
    _listaSugueridosHelper = lista;
    notifyListeners();
  }

  pasarSugeridoCarrito(String codigoProducto) {
    for (int i = 0; i < _listaSugueridosHelper.length; i++) {
      if (_listaSugueridosHelper[i].codigo == codigoProducto) {
        _listaSugueridosHelper[i].estado = false;
        notifyListeners();
      }
    }
  }

  regresarSugeridoCarrtio(String codigoProducto) {
    for (int i = 0; i < _listaSugueridosHelper.length; i++) {
      if (_listaSugueridosHelper[i].codigo == codigoProducto) {
        _listaSugueridosHelper[i].estado = true;
        notifyListeners();
      }
    }
  }

  Future<List<dynamic>> getListaHistoricosHelper(
      String ordenCompra, String fechaInicial, String fechaFinal) async {
    List<dynamic> _listaHistoricosTemp = [];

    if (ordenCompra == "-1") {
      if (fechaInicial == '-1' || fechaFinal == '-1') {
        return _listaHistoricos;
      } else {
        var fechaInicialF = Constantes().formatearToDatetime(fechaInicial, 'I');

        var fechaFinalF = Constantes().formatearToDatetime(fechaFinal, 'F');
        for (int i = 0; i < _listaHistoricos.length; i++) {
          var fechaTransF = Constantes()
              .formatearFechas(_listaHistoricos[i].fechaTrans.toString());
          if (fechaTransF.isBefore(fechaFinalF) &&
              fechaTransF.isAfter(fechaInicialF)) {
            _listaHistoricosTemp.add(_listaHistoricos[i]);
          }
        }
        return _listaHistoricosTemp;
      }
    } else {
      for (int i = 0; i < _listaHistoricos.length; i++) {
        try {
          if (_listaHistoricos[i]
              .numeroDoc
              .toString()
              .contains(ordenCompra.toString())) {
            _listaHistoricosTemp.add(_listaHistoricos[i]);
          }
        } catch (e) {
          print('-----Error datos lista provider $e');
        }
      }
      return _listaHistoricosTemp;
    }
  }

  set guardarListaHistoricosHelper(List<dynamic> lista) {
    _listaHistoricos = lista;
    notifyListeners();
  }

  actualizarHistoricoPedido(String numeroDoc) {
    for (int i = 0; i < _listaHistoricos.length; i++) {
      if (_listaHistoricos[i].numeroDoc == numeroDoc) {
        _listaHistoricos[i].estado = !_listaHistoricos[i].estado;
        notifyListeners();
      }
    }
  }

  List<dynamic> get getListafabricantes {
    return _listafabricantes;
  }

  set guardarListafabricantes(List<dynamic> lista) {
    _listafabricantes = lista;
    notifyListeners();
  }

  List<dynamic> get getListaAccesoRapido {
    return _listaAccesosRapido;
  }

  set guardarAccesoRapido(List<dynamic> lista) {
    _listaAccesosRapido = lista;
    notifyListeners();
  }

  List<dynamic> get getListaBannersInternos {
    return _listaBannerInternos;
  }

  set guardarListaBnnerInternos(List<dynamic> lista) {
    _listaBannerInternos = lista;
    notifyListeners();
  }

  bool get getValidarDescarga {
    return _validarDescaraga;
  }

  set guardarDescarga(bool estado) {
    _validarDescaraga = estado;
    notifyListeners();
  }
}
