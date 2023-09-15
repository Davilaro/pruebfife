import 'package:emart/_pideky/presentation/authentication/view/confirm_identity_send_sms_page.dart';
import 'package:emart/shared/widgets/custom_textFormField.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../shared/widgets/boton_agregar_carrito.dart';
import '../../../../src/preferences/cont_colores.dart';

class ConfirmIdentitySelectMethodPage extends StatelessWidget {
  const ConfirmIdentitySelectMethodPage();

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 15.0),
                Text(
                    "Te ayudaremos a configurar una \n nueva contraseña, pero primero \n debemos verificar tu identidad",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ConstantesColores.gris_sku,
                      fontSize: 15,
                    )),
                SizedBox(height: 15.0),
                CustomTextFormField(
                    textAlign: TextAlign.center,
                    hintText: 'Ingresa el usuario o Nit',
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
                BotonAgregarCarrito(
                    width: Get.width * 0.9,
                    borderRadio: 35,
                    height: Get.height * 0.06,
                    color: ConstantesColores.empodio_verde,
                    onTap: () async {
                      final isValid = formkey.currentState!.validate();
                      if(isValid == true) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        await _validationForms.validationNit(context);
                      }
                    },
                    text: "Aceptar"),
              ]),
            )));
  }
}
