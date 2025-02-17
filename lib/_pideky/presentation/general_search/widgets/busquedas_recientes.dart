import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/_pideky/presentation/general_search/view_model/search_fuzzy_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusquedasRecientes extends StatelessWidget {
  BusquedasRecientes();

  final searchFuzzyViewModel = Get.find<SearchFuzzyViewModel>();

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
                      searchFuzzyViewModel.nombreSugeridos(
                          palabrabuscada:
                              searchFuzzyViewModel.listaRecientes[index],
                          conDistintivo: false)!;

                  searchFuzzyViewModel
                      .runFilter(searchFuzzyViewModel.searchInput.value);

                  searchFuzzyViewModel.controllerUser.text =
                      searchFuzzyViewModel.nombreSugeridos(
                          palabrabuscada:
                              searchFuzzyViewModel.listaRecientes[index],
                          conDistintivo: false)!;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            height: Get.height * 0.07,
                            width: Get.width * 0.1,
                            imageUrl: searchFuzzyViewModel.iconoSugeridos(
                                palabrabuscada: searchFuzzyViewModel
                                    .listaRecientes[index])!,
                            placeholder: (context, url) =>
                                Image.asset('assets/image/jar-loading.gif'),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/image/logo_login.png',
                              width: Get.width * 0.05,
                            ),
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            width: Get.width * 0.05,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Get.width * 0.65,
                                child: AutoSizeText(
                                  searchFuzzyViewModel.nombreSugeridos(
                                      palabrabuscada: searchFuzzyViewModel
                                          .listaRecientes[index],
                                      conDistintivo: true)!, //
                                  minFontSize: 12,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(.4),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              AutoSizeText(
                                searchFuzzyViewModel.skuSugeridos(
                                    palabrabuscada: searchFuzzyViewModel
                                        .listaRecientes[index],
                                    conDistintivo: true)!,
                                minFontSize: 10,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(.4),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ),
    );
  }
}
