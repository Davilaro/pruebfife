import 'package:emart/generated/l10n.dart';
import 'package:emart/src/controllers/controller_db.dart';
import 'package:emart/src/pages/principal_page/tab_opciones.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustonNavigatorBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OpcionesBard>(context);
    final cargoConfirmar = Get.find<ControlBaseDatos>();

    return BottomNavigationBar(
        backgroundColor: colorItems(),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        elevation: 0,
        currentIndex: provider.selectOptionMenu,
        onTap: (int i) {
          if (i == 1) {
            cargoConfirmar.tabController.index = 0;
            cargoConfirmar.cargoBaseDatos(0);
            provider.selectOptionMenu = 1;
          } else if (i != provider.selectOptionMenu) {
            provider.setIsLocal = 1;
            provider.selectOptionMenu = i;
          }
          Get.offAll(() => TabOpciones());
        },
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: provider.selectOptionMenu == 0
                ? SvgPicture.asset('assets/image/home_img.svg')
                : SvgPicture.asset('assets/image/home_img_norm.svg'),
            label: S.current.home,
          ),
          BottomNavigationBarItem(
            icon: provider.selectOptionMenu == 1
                ? SvgPicture.asset('assets/image/catalogo_img.svg')
                : SvgPicture.asset('assets/image/catalogo_img_norm.svg'),
            label: S.current.catalog,
          ),
          BottomNavigationBarItem(
            icon: provider.selectOptionMenu == 2
                ? SvgPicture.asset('assets/image/pedido_rapido_img.svg')
                : SvgPicture.asset('assets/image/pedido_rapido_img_norm.svg'),
            label: S.current.suggested_order,
          ),
          BottomNavigationBarItem(
            icon: provider.selectOptionMenu == 3
                ? SvgPicture.asset('assets/image/historico_img.svg')
                : SvgPicture.asset('assets/image/historico_img_norm.svg'),
            label: S.current.my_orders,
          ),
          BottomNavigationBarItem(
            icon: provider.selectOptionMenu == 4
                ? SvgPicture.asset('assets/image/mi_negocio_img.svg')
                : SvgPicture.asset('assets/image/mi_negocio_norm.svg'),
            label: S.current.my_business,
          ),
        ]);
  }

  TextStyle diseno_letra() =>
      TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold);

  HexColor colorItems() => HexColor("#43398E");
}
