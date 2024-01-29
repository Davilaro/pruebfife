import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/presentation/productos/view_model/producto_view_model.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/metodo_ingresados.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CarroModelo extends ChangeNotifier {
  double _precioTotal = 0;
  int cantidadItems = 0;
  Map<String, dynamic> _listaValorFabricante = new Map();
  int _cambioVista = 0;
  double _precioAhorro = 0;
  double _nuevoPrecioAhorro = 0;
  Map<String, dynamic> _frecuanciaFabricantes = new Map();

  double get getTotal {
    return _precioTotal;
  }

  Map get getFrecuenciaFabricante => _frecuanciaFabricantes;

  void actualizarFrecuenciaFabricante(String fabricante, bool isFrecuancia) {
    _frecuanciaFabricantes[fabricante] = isFrecuancia;
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

  double get getNuevoTotalAhorro {
    return _nuevoPrecioAhorro;
  }

  set guardarValorAhorro(double precio) {
    _precioAhorro = precio;
    notifyListeners();
  }

  set setNuevoValorAhorro(double precio) {
    _nuevoPrecioAhorro = precio;
    notifyListeners();
  }

  llenarCarrito(Producto producto, int cantidad, context) async {
    final cartProvider = Provider.of<CarroModelo>(context, listen: false);
    ProductoViewModel productViewModel = Get.find();
    if (producto.codigo != "") {
      PedidoEmart.listaControllersPedido![producto.codigo]!.text = "$cantidad";
      PedidoEmart.registrarValoresPedido(producto, '$cantidad', true);
      MetodosLLenarValores().calcularValorTotal(cartProvider);
      productViewModel.insertarPedidoTemporal(producto.codigo);
    }
  }
}
