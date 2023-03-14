import 'package:auto_size_text/auto_size_text.dart';
import 'package:emart/_pideky/presentation/confirmacion_pais/view_model/confirmacion_pais_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/shared/widgets/custom_drop_down.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class ConfirmacionPais extends StatefulWidget {
  @override
  State<ConfirmacionPais> createState() => _ConfirmacionPaisState();
}

class _ConfirmacionPaisState extends State<ConfirmacionPais> {
  ConfirmacionPaisViewModel confirmacionPaisViewModel =
      Get.put(ConfirmacionPaisViewModel());
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
                    margin: EdgeInsets.only(top: 15),
                    child: AutoSizeText(
                      S.current.confirm_country,
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
                onTap: () => confirmacionPaisViewModel
                    .confirmarPais(itemSeleccionado.value),
                text: S.current.accept)
          ],
        ),
      ),
    );
  }
}
