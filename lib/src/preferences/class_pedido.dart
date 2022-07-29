import 'package:emart/src/controllers/cambio_estado_pedido.dart';
import 'package:emart/src/modelos/Sugerido.dart';
import 'package:emart/src/modelos/asignado.dart';
import 'package:emart/src/modelos/productos.dart';
import 'package:flutter/material.dart';
import "package:collection/collection.Dart";
import 'package:get/get.dart';

class PedidoEmart {
  static RxString cantItems = "0".obs;
  static Map<String, TextEditingController>? listaControllersPedido;
  static Map<String, String>? listaValoresPedido;
  static Map<String, bool>? listaValoresPedidoAgregados;
  static Map<String, bool>? listSugeridosAgregados;
  static Map<String, Productos>? listaProductos;
  static Map<String, dynamic>? listaSugeridos;
  static Map<String, dynamic>? listaProductosPorFabricante;
  static List<dynamic>? listaFabricante = [];
  static Map<String, dynamic>? listaPrecioPorFabricante;
  static RxInt cambioVista = 1.obs;

  static registrarValoresPedido(
      Productos producto, dynamic valor, bool estado) {
    listaValoresPedido!.update(producto.codigo, (value) => valor);
    listaControllersPedido!.update(producto.codigo, (value) => value);
    listaValoresPedidoAgregados!.update(producto.codigo, (value) => estado);

    cantItems.value = "0";
    int items = 0;

    listaValoresPedidoAgregados!.forEach((key, value) {
      String valor1 = listaControllersPedido![key]!.text;
      if (valor1 != "") {
        items += int.parse(valor1);
      }
    });

    cantItems.value = "$items";
  }

  static iniciarProductosPorFabricante() {
    listaProductosPorFabricante = new Map();
    final listaAgrupar = <ProductoAsignado>[];

    listaProductos!.forEach((key, elemet) {
      if (listaValoresPedidoAgregados![key] == false) {
        ProductoAsignado productoAsignado = new ProductoAsignado(
            codigo: elemet.codigo,
            nombre: elemet.nombre,
            fabricante: elemet.fabricante,
            precio: elemet.precio,
            cantidad: 0,
            productos: elemet);

        listaAgrupar.add(productoAsignado);
      } else if (int.parse(obtenerValor(elemet)!) > 0) {
        if (listaValoresPedidoAgregados![key] == true) {
          ProductoAsignado productoAsignado = new ProductoAsignado(
              codigo: elemet.codigo,
              nombre: elemet.nombre,
              fabricante: elemet.fabricante,
              precio: elemet.descuento == 0
                  ? elemet.precioinicial
                  : elemet.preciodescuento,
              cantidad: int.parse(obtenerValor(elemet)!),
              productos: elemet);

          listaAgrupar.add(productoAsignado);
        }
      }
    });

    final groups = groupBy(listaAgrupar, (ProductoAsignado p) {
      return p.fabricante;
    });

    groups.forEach((key, value) {
      double precio = 0;
      double topeMinimo = 0;
      double precioProductos = 0;
      String icon = "";
      for (int i = 0; i < value.length; i++) {
        precioProductos =
            precioProductos + (value[i].cantidad! * value[i].precio!);
      }

      for (int j = 0; j < listaFabricante!.length; j++) {
        if (listaFabricante![j].empresa == key) {
          icon = listaFabricante![j].icono;
          precio = listaFabricante![j].pedidominimo;
          topeMinimo = listaFabricante![j].topeMinimo;
        }
      }

      listaProductosPorFabricante!.putIfAbsent(
          key!,
          () => {
                'expanded': false,
                'items': value,
                'imagen': icon,
                'preciominimo': precio,
                'precioProducto': precioProductos,
                'topeMinimo': topeMinimo,
              });
    });
  }

  static calcularPrecioPorFabricante() {
    listaPrecioPorFabricante = new Map();
    final listaAgrupar = <ProductoAsignado>[];

    listaProductos!.forEach((key, elemet) {
      if (listaValoresPedidoAgregados![key] == false) {
        ProductoAsignado productoAsignado = new ProductoAsignado(
            codigo: elemet.codigo,
            nombre: elemet.nombre,
            fabricante: elemet.fabricante,
            precio: elemet.precio,
            cantidad: 0,
            productos: elemet);

        listaAgrupar.add(productoAsignado);
      } else if (int.parse(obtenerValor(elemet)!) > 0) {
        if (listaValoresPedidoAgregados![key] == true) {
          ProductoAsignado productoAsignado = new ProductoAsignado(
            codigo: elemet.codigo,
            nombre: elemet.nombre,
            fabricante: elemet.fabricante,
            precio:
                elemet.descuento == 0 ? elemet.precio : elemet.preciodescuento,
            cantidad: int.parse(obtenerValor(elemet)!),
          );

          listaAgrupar.add(productoAsignado);
        }
      }
    });

    final groups = groupBy(listaAgrupar, (ProductoAsignado p) {
      return p.fabricante;
    });

    groups.forEach((key, value) {
      var precio = 0.0;
      String icon = "";
      for (int i = 0; i < value.length; i++) {
        precio = precio + (value[i].cantidad! * value[i].precio!);
      }

      for (int j = 0; j < listaFabricante!.length; j++) {
        if (listaFabricante![j].empresa == key) {
          icon = listaFabricante![j].icono;
        }
      }

      listaPrecioPorFabricante!.putIfAbsent(
          key!,
          () => {
                'precioFinal': precio,
              });
    });
  }

  static inicializarValoresFabricante() {
    listaPrecioPorFabricante = new Map();
    final listaAgrupar = <ProductoAsignado>[];

    listaProductos!.forEach((key, elemet) {
      if (obtenerValor(elemet) == "") {
        ProductoAsignado productoAsignado = new ProductoAsignado(
          codigo: elemet.codigo,
          nombre: elemet.nombre,
          fabricante: elemet.fabricante,
          precio: elemet.precio,
          cantidad: 0,
        );

        listaAgrupar.add(productoAsignado);
      } else if (int.parse(obtenerValor(elemet)!) == 0) {
        ProductoAsignado productoAsignado = new ProductoAsignado(
          codigo: elemet.codigo,
          nombre: elemet.nombre,
          fabricante: elemet.fabricante,
          precio: elemet.precio,
          cantidad: 0,
        );

        listaAgrupar.add(productoAsignado);
      } else if (int.parse(obtenerValor(elemet)!) > 0) {
        if (listaValoresPedidoAgregados![key] == true) {
          ProductoAsignado productoAsignado = new ProductoAsignado(
            codigo: elemet.codigo,
            nombre: elemet.nombre,
            fabricante: elemet.fabricante,
            precio: elemet.descuento == 0
                ? elemet.precioinicial
                : elemet.preciodescuento,
            cantidad: int.parse(obtenerValor(elemet)!),
          );

          listaAgrupar.add(productoAsignado);
        }
      }
    });

    final groups = groupBy(listaAgrupar, (ProductoAsignado p) {
      return p.fabricante;
    });

    groups.forEach((key, value) {
      var precio = 0.0;
      String icon = "";
      for (int i = 0; i < value.length; i++) {
        precio = precio + (value[i].cantidad! * value[i].precio!);
      }

      for (int j = 0; j < listaFabricante!.length; j++) {
        if (listaFabricante![j].empresa == key) {
          icon = listaFabricante![j].icono;
        }
      }

      listaPrecioPorFabricante!.putIfAbsent(
          key!,
          () => {
                'precioFinal': precio,
              });
    });
  }

  static String? obtenerValor(Productos productos) {
    return listaValoresPedido![productos.codigo] == null
        ? "0"
        : listaValoresPedido![productos.codigo];
  }

  static bool? obtenerValorController(Productos productos) {
    return listaControllersPedido![productos.codigo] == null ? false : true;
  }

  static void eliminarRegistros() {
    listaValoresPedido!.clear();
    listaControllersPedido!.clear();
    listaProductosPorFabricante!.clear();
    listaPrecioPorFabricante!.clear();
    listaSugeridos!.clear();
  }
}
