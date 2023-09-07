import 'package:emart/_pideky/domain/marca/service/marca_service.dart';
import 'package:emart/_pideky/domain/producto/service/producto_service.dart';
import 'package:emart/_pideky/infrastructure/marcas/marca_repository_sqlite.dart';
import 'package:emart/_pideky/infrastructure/productos/producto_repository_sqlite.dart';
import 'package:emart/_pideky/presentation/buscador_general/view_model/search_fuzzy_view_model.dart';
import 'package:get/get.dart';

class FiltrosResultadoGeneralVm extends GetxController {

  ProductoService productService = ProductoService(ProductoRepositorySqlite());
  MarcaService marcaService = MarcaService(MarcaRepositorySqlite());
  
  final searchFuzzyViewModel = Get.put(SearchFuzzyViewModel());

  void cargarProductosFiltrados({
    required String codigoCategoria,
    required String codMarca,
    required String codProveedor,
    required String codigoSubCategoria,
    required double precioMinimo,
    required double precioMaximo,
    required int valorRound,
  }) async {
    valorRound == 1
        ? searchFuzzyViewModel.allResultados.value =
                await productService.cargarProductosFiltroProveedores(
                    codigoCategoria,
                    2,
                    searchFuzzyViewModel.controllerUser.text,
                    precioMinimo,
                    precioMaximo,
                    codigoSubCategoria,
                    codMarca,
                    codProveedor)
        : valorRound == 2
            ? searchFuzzyViewModel.allResultados.value =
                await productService.cargarProductosFiltroProveedores(
                    codigoCategoria,
                    1,
                    searchFuzzyViewModel.controllerUser.text,
                    precioMinimo,
                    precioMaximo,
                    codigoSubCategoria,
                    codMarca,
                    codProveedor)
            : searchFuzzyViewModel.allResultados.value =
                await productService.cargarProductosFiltroProveedores(
                    codigoCategoria,
                    5,
                    searchFuzzyViewModel.controllerUser.text,
                    precioMinimo,
                    precioMaximo,
                    codigoSubCategoria,
                    codMarca,
                    codProveedor);
  }

}