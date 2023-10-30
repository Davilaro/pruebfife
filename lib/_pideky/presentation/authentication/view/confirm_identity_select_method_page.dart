import 'package:emart/shared/widgets/custom_textFormField.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../shared/widgets/boton_agregar_carrito.dart';
import '../../../../src/preferences/cont_colores.dart';

class ConfirmIdentitySelectMethodPage extends StatelessWidget {
  const ConfirmIdentitySelectMethodPage();

  @override
  Widget build(BuildContext context) {
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('ValidateChangePasswordPage');
    final ValidationForms _validationForms = Get.find<ValidationForms>();

    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    return Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        appBar: AppBar(
          title: Text('Inicio de  sesión',
              style: TextStyle(color: HexColor("#41398D"))),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
              onPressed: () => {Navigator.of(context).pop()}),
          elevation: 0,
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formkey,
              child: Column(children: [
                SizedBox(height: Get.height * 0.02),
                Text(
                    "Te ayudaremos a configurar una nueva contraseña, pero primero debemos verificar tu identidad",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: ConstantesColores.gris_sku,
                      fontSize: 14,
                    )),
                SizedBox(height: Get.height * 0.05),
                CustomTextFormField(
                    textAlign: TextAlign.center,
                    hintText: 'Ingresa tu CCUP',
                    hintStyle: TextStyle(color: ConstantesColores.gris_sku),
                    backgroundColor: Colors.white,
                    textColor: HexColor("#41398D"),
                    borderRadius: 35,
                    icon: Icons.perm_identity,
                    onChanged: (value) {
                      _validationForms.userName.value = value;
                      _validationForms.userInteracted2.value =
                          true; // Marca como interactuado
                    },
                    validator: _validationForms.validateTextFieldNullorEmpty),
                Expanded(child: Container()),
                BotonAgregarCarrito(
                    width: Get.width * 0.9,
                    borderRadio: 35,
                    height: Get.height * 0.06,
                    color: ConstantesColores.empodio_verde,
                    onTap: () async {
                      final isValid = formkey.currentState!.validate();
                      if (isValid == true) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        await _validationForms.validationNit(context);
                      }
                    },
                    text: "Aceptar"),
                SizedBox(height: Get.height * 0.03),
              ]),
            )));
  }
}
