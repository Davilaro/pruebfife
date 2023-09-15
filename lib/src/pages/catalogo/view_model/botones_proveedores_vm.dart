import 'package:emart/src/modelos/fabricante.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:get/get.dart';

class BotonesProveedoresVm extends GetxController {
  final RxList<dynamic> listaCategoria = <dynamic>[].obs;
  List<dynamic> listaAllCategorias = [];

  final RxList<Fabricante> listaFabricante = <Fabricante>[].obs;

  RxList<dynamic> listaMarca = <dynamic>[].obs;
  List<dynamic> listaAllMarcas = [];

  RxString proveedor = "".obs;
  RxString proveedor2 = "".obs;

  RxBool esBuscadoTodos = false.obs;

  RxInt contadorSeleccionados = 0.obs;

  RxList<bool> seleccionados = <bool>[].obs;

  void cargarLista(int idTab) async {
    if (idTab == 1) {
      listaAllCategorias = await DBProvider.db
          .consultarCategoriasPorFabricante(proveedor.value, proveedor2.value);

      listaCategoria.value = listaAllCategorias;
    }

    if (idTab == 2) {
      listaAllMarcas = await  DBProvider.db
          .consultarMarcasPorFabricante(proveedor.value, proveedor2.value);
      listaMarca.value = listaAllMarcas;
    }
  }

  void cargarListaProovedor() async {
    listaFabricante.value = await DBProvider.db.consultarFricante("");

    listaFabricante.forEach((element) {
      if (element.empresa == "NUTRESA") {
        listaFabricante.remove(element);
        listaFabricante.insert(0, element);
      }
      if (element.empresa == "ZENU") {
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
}
