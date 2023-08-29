import 'package:emart/_pideky/domain/marca/model/marca.dart';
import 'package:emart/_pideky/domain/marca/service/marca_service.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/domain/producto/service/producto_service.dart';
import 'package:emart/_pideky/infrastructure/marcas/marca_repository_sqlite.dart';
import 'package:emart/_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import 'package:emart/_pideky/presentation/productos/view/detalle_producto_search.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/src/classes/producto_cambiante.dart';
import 'package:emart/src/modelos/categorias.dart';
import 'package:emart/src/modelos/fabricantes.dart';
import 'package:emart/src/pages/catalogo/widgets/tab_categorias_opciones.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/pages/principal_page/widgets/custom_buscador_fuzzy.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/db_provider.dart';

import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:fuzzywuzzy/model/extracted_result.dart';
import 'package:get/get.dart';

class SearchFuzzyViewModel extends GetxController {
  final prefs = new Preferencias();
  final TextEditingController controllerUser = TextEditingController();

  RxList allResultados = [].obs;

  RxString searchInput = "".obs;

  List<Producto> listaAllProducts = [];
  List<Marca> listaAllMarcas = [];
  List<Categorias> listaAllcategorias = [];
  List<Fabricantes> listaAllproveedor = [];

  //mapa para guardar las listas
  RxMap mapListas = {}.obs;

  //mapa para mostrar luego los objetos
  RxList mapListasMostrar = [].obs;

  RxList listaRecientes = [].obs;

  ProductoService productService = ProductoService(ProductoRepositorySqlite());
  MarcaService marcaService = MarcaService(MarcaRepositorySqlite());

  List<ExtractedResult<String>> result = [];

  void initState() {
    cargarSugerencias();
    allResultados.value = [];
    controllerUser.text = "";
    searchInput.value = "";
  }

  void cargarSugerencias() async {
    listaAllProducts = await productService.cargarProductosFiltro("", "");
    listaAllMarcas = await marcaService.getAllMarcas();
    listaAllcategorias = await DBProvider.db.consultarCategorias("", 0);
    listaAllproveedor = await DBProvider.db.consultarFricante("");
  }

  void runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      allResultados.value = [];
      result = [];
    } else {
      allResultados.value = [];
      result = [];

      mapListas.addAll({"producto": listaAllProducts});

      mapListas.addAll({"marca": listaAllMarcas});

      mapListas.addAll({"categoria": listaAllcategorias});

      mapListas.addAll({"proveedor": listaAllproveedor});

      result = extractTop(
        limit: 10,
        query: enteredKeyword,
        choices: llenarLista(),
        cutoff: 10,
      );

      result.forEach((element) {
        mapListas.forEach((key, value) {
          for (var i = 0; i < value.length; i++) {
            if (value[i] is Producto) {
              if ((value[i] as Producto).nombre == element.choice) {
                allResultados.add(value[i]);
              }
            }
            if (value[i] is Marca) {
              if ((value[i] as Marca).nombre == element.choice && !allResultados.contains(value[i])) {
                allResultados.add(value[i]);
              }
            }
            if (value[i] is Categorias) {
              if ((value[i] as Categorias).descripcion == element.choice ) {
                allResultados.add(value[i]);
              }
            }
            if (value[i] is Fabricantes) {
              if ((value[i] as Fabricantes).nombrecomercial == element.choice && !allResultados.contains(value[i])) {
                allResultados.add(value[i]);
              }
            }
          }
        });
      });

    }
  }


  //funcion para llenar un lista de strings con los nombres de lista en el value de mapListas
  List<String> llenarLista() {
    List<String> lista = [];
    mapListas.forEach((key, value) {
      for (var i = 0; i < value.length; i++) {
        if (value[i] is Producto) lista.add((value[i] as Producto).nombre);
        if (value[i] is Marca) lista.add((value[i] as Marca).nombre);
        if (value[i] is Categorias)
          lista.add((value[i] as Categorias).descripcion);
        if (value[i] is Fabricantes)
          lista.add((value[i] as Fabricantes).nombrecomercial.toString());
      }
    });
    return lista;
  }

  Future<void> logicaSeleccion(
      Object object, cargoConfirmar, cartProvider, context) async {
    if (controllerUser.text != '') {
      listaRecientes.add(object);
      listaRecientes = listaRecientes.reversed.toList().obs;
    }
    if (prefs.usurioLogin == -1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
    if (object is Marca) {
   
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomBuscardorFuzzy(
                  codCategoria: object.codigo,
                  numEmpresa: 'nutresa',
                  tipoCategoria: 3,
                  nombreCategoria: object.nombre,
                  isActiveBanner: false,
                  locacionFiltro: "marca",
                  codigoProveedor: "",
                )));
    }
    if (object is Categorias) {

      final List<dynamic> listaSubCategorias =
          await DBProvider.db.consultarCategoriasSubCategorias(object.codigo);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TabOpcionesCategorias(
                    listaCategorias: listaSubCategorias,
                    nombreCategoria: object.descripcion,
                  )));
    }
    if (object is Fabricantes) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomBuscardorFuzzy(
                  codCategoria: object.empresa,
                  numEmpresa: 'nutresa',
                  tipoCategoria: 4,
                  nombreCategoria: object.nombrecomercial,
                  img: object.icono,
                  locacionFiltro: "proveedor",
                  codigoProveedor: object.empresa.toString(),
                )));
    } 
    if(object is Producto ){
      PedidoEmart.inicializarValoresFabricante();
      cartProvider.actualizarListaFabricante =
          PedidoEmart.listaPrecioPorFabricante!;
      //validar que este en la lista de productos
      cargoConfirmar
          .cambiarValoresEditex(PedidoEmart.obtenerValor(object));
      cargoConfirmar.cargarProductoNuevo(
          ProductoCambiante.m(object.nombre, object.codigo), 1);
      cartProvider.guardarCambiodevista = 1;
      PedidoEmart.cambioVista.value = 1;
      String title = searchInput.value;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetalleProductoSearch(
                    producto: object,
                    tamano: Get.height * .8,
                    title: title == '' ? S.current.product : title,
                  )));

    }
    controllerUser.text = "";
    searchInput.value = "";
    allResultados.value = [];
    searchInput.value = "";
  }
}
