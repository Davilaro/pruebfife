import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustonNavigatorBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OpcionesBard>(context);

    return BottomNavigationBar(
        backgroundColor: colorItems(),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        elevation: 0,
        currentIndex: provider.selectOptionMenu,
        onTap: (int i) {
          if (i != provider.selectOptionMenu) {
            provider.setIsLocal = 1;
            provider.selectOptionMenu = i;
            Navigator.pushReplacementNamed(
              context,
              'tab_opciones',
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: provider.selectOptionMenu == 0
                ? SvgPicture.asset('assets/image/home_img.svg')
                : SvgPicture.asset('assets/image/home_img_norm.svg'),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: provider.selectOptionMenu == 1
                ? SvgPicture.asset('assets/image/catalogo_img.svg')
                : SvgPicture.asset('assets/image/catalogo_img_norm.svg'),
            label: 'Catálogo',
          ),
          BottomNavigationBarItem(
            icon: provider.selectOptionMenu == 2
                ? SvgPicture.asset('assets/image/pedido_rapido_img.svg')
                : SvgPicture.asset('assets/image/pedido_rapido_img_norm.svg'),
            label: 'Pedido Sugerido',
          ),
          BottomNavigationBarItem(
            icon: provider.selectOptionMenu == 3
                ? SvgPicture.asset('assets/image/historico_img.svg')
                : SvgPicture.asset('assets/image/historico_img_norm.svg'),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            icon: provider.selectOptionMenu == 4
                ? SvgPicture.asset('assets/image/mi_negocio_img.svg')
                : SvgPicture.asset('assets/image/mi_negocio_norm.svg'),
            label: 'Mi negocio',
          ),
        ]);
  }

  TextStyle diseno_letra() =>
      TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold);

  HexColor colorItems() => HexColor("#43398E");
}
