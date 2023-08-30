import 'package:emart/_pideky/presentation/buscador_general/view_model/search_fuzzy_view_model.dart';
import 'package:emart/_pideky/presentation/resultados_buscador_general/view_model/resultado_buscador_general_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class CampoTextoResultado extends StatelessWidget {
  CampoTextoResultado();

  final resultadoBuscadorGeneralVm = Get.put(ResultadoBuscadorGeneralVm());
  final searchFuzzyViewModel= Get.put(SearchFuzzyViewModel());

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: Get.width * 0.8,
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
                    // resultadoBuscadorGeneralVm
                    //     .runFilter(resultadoBuscadorGeneralVm.controllerUser.text);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ResultadoBuscadorGeneral(
                    //               nombreCategoria: 'cosito',
                    //             )));
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
            searchFuzzyViewModel.runFilter(value);
          },
        ));
  }
}
