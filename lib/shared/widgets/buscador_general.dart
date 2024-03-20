import 'package:emart/_pideky/presentation/general_search/view_model/search_fuzzy_view_model.dart';
import 'package:emart/_pideky/presentation/general_search_reponse/view/resultado_buscador_general.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:hexcolor/hexcolor.dart';

class BuscadorGeneral extends StatelessWidget {
  BuscadorGeneral();

  final searchFuzzyViewModel = Get.find<SearchFuzzyViewModel>();
   final Debouncer debouncer =
      Debouncer(delay: const Duration(milliseconds: 800));

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: Get.width * 0.86,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: BoxDecoration(
          color: HexColor("#E4E3EC"),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: searchFuzzyViewModel.controllerUser,
          style: TextStyle(color: HexColor("#41398D"), fontSize: 13),
          decoration: InputDecoration(
            fillColor: HexColor("#41398D"),
            hintText: 'Encuentra lo que necesitas',
            hintStyle: TextStyle(
              color: HexColor("#41398D"),
            ),
            suffixIcon: Padding(
                padding: EdgeInsets.only(
                  right: Get.width * 0.003,
                  bottom: Get.height * 0.001,
                ),
                child: IconButton(
                  onPressed: () {
                    print(searchFuzzyViewModel.listaAllMarcas);
                    searchFuzzyViewModel
                        .runFilter(searchFuzzyViewModel.controllerUser.text);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GeneralSearchResponse(
                                  allresultados:
                                      searchFuzzyViewModel.allResultados,
                                )));
                  },
                  icon: Icon(
                    Icons.search,
                    color: HexColor("#41398D"),
                  ),
                )),
            border: InputBorder.none,
            contentPadding: EdgeInsets.fromLTRB(10.0, 15, 10.0, 0),
          ),
          onChanged: (value) {
            searchFuzzyViewModel.searchInput.value = value;
            //FIREBASE: Llamamos el evento search
            TagueoFirebase().sendAnalityticsSearch(value);
            //UXCam: Llamamos el evento search
            UxcamTagueo().search(value);
            searchFuzzyViewModel.runFilter(value);
            debouncer(() => searchFuzzyViewModel.productoBusqueda(value));
            
          },
        ));
  }
}
