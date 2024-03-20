import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/_pideky/presentation/country_confirmation/view_model/country_confirmation_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/shared/widgets/custom_drop_down.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../src/pages/login/login.dart';

class CountryConfirmationPage extends StatefulWidget {
  @override
  State<CountryConfirmationPage> createState() => _CountryConfirmationPageState();
}

class _CountryConfirmationPageState extends State<CountryConfirmationPage> {
  CountryConfirmationViewModel confirmacionPaisViewModel =
      Get.put(CountryConfirmationViewModel());
  RxString itemSeleccionado = 'CO'.obs;

  @override
  void initState() {
    super.initState();
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('ConfirmCountryPage');
    confirmacionPaisViewModel.cargarDropDawn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#eeeeee'),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ConstantesColores.color_fondo_gris,
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        backgroundColor: HexColor('#f7f7f7'),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            S.current.country_confirmation,
            style: TextStyle(
                color: ConstantesColores.azul_precio,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Column(
                children: [
                  Image.asset(
                    'assets/icon/Icono_pais.png',
                    width: Get.width * 0.5,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: AutoSizeText(
                      S.current.confirm_country,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: ConstantesColores.azul_precio,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
            Obx(() => CustomDropDown(
                  lista: confirmacionPaisViewModel.listaItems,
                  selectItem: confirmacionPaisViewModel.selectItem,
                  value: itemSeleccionado.value,
                  onChanged: (String? value) => itemSeleccionado.value = value!,
                )),
            BotonAgregarCarrito(
                height: Get.height * 0.06,
                color: ConstantesColores.agua_marina,
                onTap: () {
                  prefs.isFirstTime = true;
                  confirmacionPaisViewModel.confirmarPais(
                      itemSeleccionado.value, false);
                },
                text: S.current.accept)
          ],
        ),
      ),
    );
  }
}
