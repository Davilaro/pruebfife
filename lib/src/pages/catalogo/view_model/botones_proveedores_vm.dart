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

  Future<void> cargarListaProovedor() async {
    listaFabricante.value = prefs.usurioLogin != -1
        ? await DBProvider.db.consultarFabricanteBloqueo()
        : await DBProvider.db.consultarFricante("");

    listaFabricante.forEach((element) {
      if (element.bloqueoCartera == 1) {
        listaFabricantesBloqueados.addIf(
            !listaFabricantesBloqueados.contains(element.empresa),
            element.empresa);
      }
      if (element.empresa == "NUTRESA") {
        listaFabricante.remove(element);
        listaFabricante.insert(0, element);
      }
      if (element.empresa == "ZENU" && listaFabricante.length > 1) {
        listaFabricante.remove(element);
        listaFabricante.insert(1, element);
      }
    });
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
