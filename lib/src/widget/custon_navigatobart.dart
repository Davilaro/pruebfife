import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustonNavigatorBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OpcionesBard>(context, listen: false);

    return BottomNavigationBar(
        backgroundColor: colorItems(),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        elevation: 0,
        currentIndex: provider.selectOptionMenu,
        onTap: (int i) {
          provider.setIsLocal = 1;
          provider.selectOptionMenu = i;
        },
        //showSelectedLabels: false,   // <-- HERE
        //showUnselectedLabels: false, // <-- AND HERE
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: provider.selectOptionMenu == 0
                ? SvgPicture.asset('assets/home_img.svg')
                : SvgPicture.asset('assets/home_img_norm.svg'),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: provider.selectOptionMenu == 1
                ? SvgPicture.asset('assets/catalogo_img.svg')
                : SvgPicture.asset('assets/catalogo_img_norm.svg'),
            label: 'Catálogo',
          ),
          BottomNavigationBarItem(
            icon: provider.selectOptionMenu == 2
                ? SvgPicture.asset('assets/pedido_rapido_img.svg')
                : SvgPicture.asset('assets/pedido_rapido_img_norm.svg'),
            label: 'Pedido rápido',
          ),
          BottomNavigationBarItem(
            icon: provider.selectOptionMenu == 3
                ? SvgPicture.asset('assets/historico_img.svg')
                : SvgPicture.asset('assets/historico_img_norm.svg'),
            label: 'Histórico',
          ),
          // BottomNavigationBarItem(
          //   icon: provider.selectOptionMenu == 4
          //       ? SvgPicture.asset('assets/mi_negocio_img.svg')
          //       : SvgPicture.asset('assets/mi_negocio_norm.svg'),
          //   label: 'Mi negocio',
          // ),
        ]);
  }

  TextStyle diseno_letra() =>
      TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold);

  HexColor colorItems() => HexColor("#43398E");
}
