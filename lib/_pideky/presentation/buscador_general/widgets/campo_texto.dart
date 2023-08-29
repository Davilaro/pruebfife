import 'package:emart/_pideky/presentation/buscador_general/view_model/search_fuzzy_view_model.dart';
import 'package:emart/src/utils/firebase_tagueo.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class CampoTexto extends StatelessWidget {

  CampoTexto();

  SearchFuzzyViewModel searchFuzzyViewModel = Get.put(SearchFuzzyViewModel());

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
                    searchFuzzyViewModel.runFilter(searchFuzzyViewModel.controllerUser.text);
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
          },
        ));
  }
}
