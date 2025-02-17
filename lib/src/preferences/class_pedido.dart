import 'package:emart/shared/widgets/modal_cerrar_sesion.dart';
import 'package:emart/src/modelos/asignado.dart';
import 'package:emart/_pideky/domain/product/model/product_model.dart';
import 'package:flutter/material.dart';
import "package:collection/collection.Dart";
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PedidoEmart {
  static RxString cantItems = "0".obs;
  static Map<String, TextEditingController>? listaControllersPedido;
  static Map<String, String>? listaValoresPedido;
  static Map<String, bool>? listaValoresPedidoAgregados;
  static Map<String, bool>? listSugeridosAgregados;
  static Map<String, Product>? listaProductos;
  static Map<String, dynamic>? listaSugeridos;
  static RxMap<String, dynamic>? listaProductosPorFabricante = RxMap();
  static List<dynamic>? listaFabricante = [];
  static Map<String, dynamic>? listaPrecioPorFabricante;
  static RxInt cambioVista = 1.obs;

  static registrarValoresPedido(Product producto, dynamic valor, bool estado) {
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

  static iniciarProductosPorFabricante({bool? isExpanded}) {
    listaProductosPorFabricante = new RxMap();
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
      }
      if (int.parse(obtenerValor(elemet)!) > 0) {
        if (listaValoresPedidoAgregados![key] == true) {
          ProductoAsignado productoAsignado = new ProductoAsignado(
              isOferta: elemet.isOferta,
              cantidadMaxima: elemet.cantidadMaxima,
              cantidadSolicitada: elemet.cantidadSolicitada,
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
      int diasEntregaExtraRuta = 0;
      double precio = 0;
      double topeMinimo = 0;
      int montoMinimoFrecuencia = 0;
      int montoMinimoNoFrecuencia = 0;
      int restrictivoNoFrecuencia = 0;
      int restrictivoFrecuencia = 0;
      int diasEntrega = 0;
      bool isFrecuencia = false;
      double precioProductos = 0;
      String icon = '';
      String horaFabricante = '';
      String diasFrecuencia = "";
      String texto1 = "";
      String texto2 = "";
      int itinerario = 0;
      List<String> listaDiasFrecuencia = [];
      List diasAgrupadosPorFabricante = [];
      DateTime now = new DateTime.now();
      String hora = now.hour.toString();
      String minuto = now.minute.toString();
      String segundo = now.second.toString();

      for (int i = 0; i < value.length; i++) {
        precioProductos =
            precioProductos + (value[i].cantidad! * value[i].precio!);
      }

      for (int j = 0; j < listaFabricante!.length; j++) {
        if (listaFabricante![j].empresa == key) {
          diasEntregaExtraRuta = listaFabricante![j].diasEntregaExtraRuta ?? 0;
          icon = listaFabricante![j].icono ?? "";
          horaFabricante = listaFabricante![j].hora ?? "";
          diasEntrega = listaFabricante![j].diasEntrega ?? 0;
          texto1 = listaFabricante![j].texto1 ?? "";
          texto2 = listaFabricante![j].texto2 ?? "";
          itinerario = listaFabricante![j].itinerario ?? 0;
          diasFrecuencia = listaFabricante![j].diaVisita ?? [];
          topeMinimo = listaFabricante![j].topeMinimo ?? 0;
          montoMinimoFrecuencia =
              listaFabricante![j].montoMinimoFrecuencia ?? 0;
          montoMinimoNoFrecuencia =
              listaFabricante![j].montoMinimoNoFrecuencia ?? 0;
          restrictivoFrecuencia =
              listaFabricante![j].restrictivoFrecuencia ?? 0;
          restrictivoNoFrecuencia =
              listaFabricante![j].restrictivoNoFrecuencia ?? 0;
        }
      }

      DateTime hourRes = new DateFormat("HH:mm:ss").parse(horaFabricante);
      DateTime horaActual = new DateFormat("HH:mm:ss")
          .parse(hora + ":" + minuto.toString() + ":" + segundo.toString());

      listaDiasFrecuencia = diasFrecuencia.split("-");
      listaDiasFrecuencia.forEach((e) {
        switch (e) {
          case "L":
            diasAgrupadosPorFabricante.add("lunes");
            break;
          case "M":
            diasAgrupadosPorFabricante.add("martes");
            break;
          case "W":
            diasAgrupadosPorFabricante.add("miércoles");
            break;
          case "J":
            diasAgrupadosPorFabricante.add("jueves");
            break;
          case "V":
            diasAgrupadosPorFabricante.add("viernes");
            break;
          case "S":
            diasAgrupadosPorFabricante.add("sábado");
            break;
        }
      });
      if (diasAgrupadosPorFabricante.contains(prefs.diaActual) &&
          horaActual.isAfter(hourRes)) {
        prefs.diaActual = prefs.nextDay;
      } else {
        prefs.diaActual = DateFormat.EEEE().format(DateTime.now());
      }
      if ((diasAgrupadosPorFabricante.contains(prefs.diaActual) &&
              horaActual.isBefore(hourRes)) ||
          (diasAgrupadosPorFabricante.contains(prefs.diaActual) &&
              horaActual.isAfter(hourRes) &&
              diasAgrupadosPorFabricante.contains(prefs.nextDay)) ||
          (horaActual.isAfter(hourRes) &&
              diasAgrupadosPorFabricante.contains(prefs.nextDay))) {
        isFrecuencia = true;
        precio = montoMinimoFrecuencia.toDouble();
      } else {
        isFrecuencia = false;
        precio = montoMinimoNoFrecuencia.toDouble();
      }

      listaProductosPorFabricante!.putIfAbsent(
          key!,
          () => {
                'expanded': false,
                'items': value,
                'imagen': icon,
                'preciominimo': precio,
                'precioProducto': precioProductos,
                "diasVisita": diasAgrupadosPorFabricante,
                'topeMinimo': topeMinimo,
                'isFrecuencia': isFrecuencia,
                'restrictivofrecuencia': restrictivoFrecuencia,
                'restrictivonofrecuencia': restrictivoNoFrecuencia,
                'texto1': texto1,
                'texto2': texto2,
                "itinerario": itinerario,
                'diasEntrega': diasEntrega,
                'diasEntregaExtraRuta': diasEntregaExtraRuta,
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
      }
      if (int.parse(obtenerValor(elemet)!) > 0) {
        if (listaValoresPedidoAgregados![key] == true) {
          ProductoAsignado productoAsignado = new ProductoAsignado(
            codigo: elemet.codigo,
            nombre: elemet.nombre,
            fabricante: elemet.fabricante,
            precio:
                elemet.descuento == 0 ? elemet.precio : elemet.preciodescuento,
            cantidad: int.parse(obtenerValor(elemet)!),
            descuento: ((elemet.descuento! *
                    (elemet.precioinicial! *
                        int.parse(obtenerValor(elemet)!))) /
                100),
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
      var descuento = 0.0;
      for (int i = 0; i < value.length; i++) {
        precio = precio + (value[i].cantidad! * value[i].precio!);
        descuento += value[i].descuento ?? 0.0;
      }

      for (int j = 0; j < listaFabricante!.length; j++) {
        if (listaFabricante![j].empresa == key) {}
      }

      listaPrecioPorFabricante!.putIfAbsent(
          key!,
          () => {
                'precioFinal': precio,
                'descuento': descuento,
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
      }
      if (int.parse(obtenerValor(elemet)!) == 0) {
        ProductoAsignado productoAsignado = new ProductoAsignado(
          codigo: elemet.codigo,
          nombre: elemet.nombre,
          fabricante: elemet.fabricante,
          precio: elemet.precio,
          cantidad: 0,
        );

        listaAgrupar.add(productoAsignado);
      }
      if (int.parse(obtenerValor(elemet)!) > 0) {
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
      for (int i = 0; i < value.length; i++) {
        precio = precio + (value[i].cantidad! * value[i].precio!);
      }

      for (int j = 0; j < listaFabricante!.length; j++) {
        if (listaFabricante![j].empresa == key) {}
      }

      listaPrecioPorFabricante!.putIfAbsent(
          key!,
          () => {
                'precioFinal': precio,
              });
    });
  }

  static String? obtenerValor(Product productos) {
    return listaValoresPedido![productos.codigo] == null || listaValoresPedido![productos.codigo] == ""
        ? "0"
        : listaValoresPedido![productos.codigo];
  }

  static bool? obtenerValorController(Product productos) {
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
