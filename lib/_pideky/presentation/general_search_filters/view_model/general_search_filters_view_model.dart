import 'package:emart/_pideky/domain/brand/use_cases/brand_use_cases.dart';
import 'package:emart/_pideky/domain/product/use_cases/producto_use_cases.dart';
import 'package:emart/_pideky/infrastructure/brand/brand_service.dart';
import 'package:emart/_pideky/infrastructure/product/product_service.dart';
import 'package:emart/_pideky/presentation/general_search/view_model/search_fuzzy_view_model.dart';
import 'package:get/get.dart';

class FiltrosResultadoGeneralVm extends GetxController {
  ProductoService productService = ProductoService(ProductoRepositorySqlite());
  BrandUseCases marcaService = BrandUseCases(MarcaRepositorySqlite());

  final searchFuzzyViewModel = Get.find<SearchFuzzyViewModel>();

  Future cargarProductosFiltrados({
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
            await productService.cargarProductosInterno(
                1,
                searchFuzzyViewModel.controllerUser.text,
                precioMinimo,
                precioMaximo,
                0,
                "",
                "")
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
