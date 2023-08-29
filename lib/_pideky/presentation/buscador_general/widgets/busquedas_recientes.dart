import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/_pideky/domain/marca/model/marca.dart';
import 'package:emart/_pideky/domain/producto/model/producto.dart';
import 'package:emart/_pideky/presentation/buscador_general/view_model/search_fuzzy_view_model.dart';
import 'package:emart/src/modelos/categorias.dart';
import 'package:emart/src/modelos/fabricantes.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusquedasRecientes extends StatelessWidget {
  BusquedasRecientes();

  final searchFuzzyViewModel = Get.put(SearchFuzzyViewModel());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => searchFuzzyViewModel.listaRecientes.isEmpty
          ? Text(
              'No hay busquedas recientes',
              style: TextStyle(
                  color: Colors.black.withOpacity(.4),
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            )
          : ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => Divider(),
              shrinkWrap: true,
              itemCount: searchFuzzyViewModel.listaRecientes.length < 3
                  ? searchFuzzyViewModel.listaRecientes.length
                  : 3,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  searchFuzzyViewModel.searchInput.value =
                      searchFuzzyViewModel.listaRecientes[index].nombre!;
                  searchFuzzyViewModel.runFilter(
                      searchFuzzyViewModel.listaRecientes[index].nombre!);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Container(
                            width: Get.width * 0.15,
                            height: Get.height * 0.1,
                            child: Image.network(
                              searchFuzzyViewModel.listaRecientes[index]
                                      is Producto
                                  ? Constantes().urlImgProductos +
                                      '${searchFuzzyViewModel.listaRecientes[index].codigo}.png'
                                  : searchFuzzyViewModel.listaRecientes[index]
                                          is Marca
                                      ? searchFuzzyViewModel
                                          .listaRecientes[index].ico
                                      : searchFuzzyViewModel
                                                  .listaRecientes[index]
                                              is Categorias
                                          ? searchFuzzyViewModel
                                              .listaRecientes[index].ico
                                          : searchFuzzyViewModel
                                                      .listaRecientes[index]
                                                  is Fabricantes
                                              ? searchFuzzyViewModel
                                                  .listaRecientes[index].icono
                                              : 'Error',
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.05,
                          ),
                          SizedBox(
                            width: Get.width * 0.5,
                            child: AutoSizeText(
                              searchFuzzyViewModel.listaRecientes[index]
                                      is Producto
                                  ? searchFuzzyViewModel
                                      .listaRecientes[index].nombre
                                  : searchFuzzyViewModel.listaRecientes[index]
                                          is Marca
                                      ? '${searchFuzzyViewModel
                                          .listaRecientes[index].nombre}/marca'
                                      : searchFuzzyViewModel
                                                  .listaRecientes[index]
                                              is Categorias
                                          ? searchFuzzyViewModel
                                              .listaRecientes[index].descripcion
                                          : searchFuzzyViewModel
                                                      .listaRecientes[index]
                                                  is Fabricantes
                                              ? '${searchFuzzyViewModel
                                                  .listaRecientes[index]
                                                  .nombrecomercial}/proveedor'
                                              : 'Error',
                              minFontSize: 12,
                              style: TextStyle(
                                color: Colors.black.withOpacity(.4),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 20),
                      child: Icon(
                        Icons.search,
                        color: Colors.black.withOpacity(.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
