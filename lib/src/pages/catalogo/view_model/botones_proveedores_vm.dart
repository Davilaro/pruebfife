import 'package:emart/src/provider/db_provider.dart';
import 'package:get/get.dart';

class BotonesProveedoresVm extends GetxController {
  final RxList<dynamic> listaCategoria = <dynamic>[].obs;
  List<dynamic> listaAllCategorias = [];

  final RxList<dynamic> listaFabricante = <dynamic>[].obs;

  RxList<dynamic> listaMarca = <dynamic>[].obs;
  List<dynamic> listaAllMarcas = [];
  RxList listaFabricantesBloqueados = [].obs;
  RxList listaProveedores = [].obs;
  RxList listaProveedoresInactivos = [].obs;

  RxString proveedor = "".obs;
  RxString proveedor2 = "".obs;

  RxBool esBuscadoTodos = true.obs;

  RxInt contadorSeleccionados = 0.obs;

  RxList<bool> seleccionados = <bool>[].obs;

  void cargarLista(int idTab) async {
    if (idTab == 1) {
      listaAllCategorias = await DBProvider.db
          .consultarCategoriasPorFabricanteCatalogo(listaProveedores);

      listaCategoria.value = listaAllCategorias;
    }

    if (idTab == 2) {
      listaAllMarcas = await DBProvider.db
          .consultarMarcasPorFabricanteCatalogo(listaProveedores);
      listaMarca.value = listaAllMarcas;
    }
  }

  Future<void> cargarListaProovedor(String kind) async {
  listaProveedoresInactivos.clear();
  listaFabricante.value = prefs.usurioLogin != -1
      ? kind == 'Categoria'
          ? await DBProvider.db.consultarFabricantesCategorias()
          : await DBProvider.db.consultarFabricanteBloqueo()
      : await DBProvider.db.consultarFabricante("");

  for (int i = listaFabricante.length - 1; i >= 0; i--) {
    var element = listaFabricante[i];
    // se valida que este inactivo y que sea un prospecto de helados
    if (element.prospectoHelados == 1 && element.estado == 'Inactivo') {
      listaProveedoresInactivos.addIf(
          !listaProveedoresInactivos.contains(element.empresa),
          element.empresa);
    // se valida si es un prospecto de helados así este inactivo se elimina de la lista
    // de fabricantes ya que no se debe mostrar
    } else if (element.prospectoHelados == 0 && element.estado == 'Inactivo'){
      listaFabricante.removeAt(i);
    // si no es prospecto de helados y está inactivo se elimina de la lista de inactivos
    } else {
      listaProveedoresInactivos.remove(element.empresa);
    }
    if (element.bloqueoCartera == 1) {
      listaFabricantesBloqueados.addIf(
          !listaFabricantesBloqueados.contains(element.empresa),
          element.empresa);
    }

    if (element.empresa == "NUTRESA") {
      listaFabricante.removeAt(i);
      listaFabricante.insert(0, element);
    }
    if (element.empresa == "ZENU" && listaFabricante.length > 1) {
      listaFabricante.removeAt(i);
      listaFabricante.insert(1, element);
    }
  }
}


  void cargarSeleccionados() {
    while (seleccionados.length < listaFabricante.length) {
      seleccionados.add(false);
    }
  }

  static BotonesProveedoresVm get findOrInitialize {
    try {
      return Get.find<BotonesProveedoresVm>();
    } catch (e) {
      Get.put(BotonesProveedoresVm());
      return Get.find<BotonesProveedoresVm>();
    }
  }

  // Mantener el boton todos seleccionado por defecto cada que se ingrese en categorias o marcas
  void resetSeleccionados(int idTab) {
    for (int i = 0; i < seleccionados.length; i++) {
      seleccionados[i] = false;
    }
    // esBuscadoTodos.value = true;
    //  listaProveedores.clear();
    if (idTab != 1) {
      // seleccionados.assignAll(List.filled(listaFabricante.length, true));
      esBuscadoTodos.value = true;
      // listaProveedores.assignAll(listaFabricante.map((fabricante) => fabricante.empresa));
      listaProveedores.clear();
    }
    cargarLista(idTab);
  }
}
