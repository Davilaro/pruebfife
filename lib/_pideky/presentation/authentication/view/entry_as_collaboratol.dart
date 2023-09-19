import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/shared/widgets/custom_textFormField.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class EntryAsCollaboratorPage extends StatelessWidget {
  const EntryAsCollaboratorPage({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('EntryAsCollaboratorPage');
    final ValidationForms _validationForms = Get.find<ValidationForms>();

    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    return Scaffold(
        backgroundColor: ConstantesColores.color_fondo_gris,
        appBar: AppBar(
          title: Text('Volver', style: TextStyle(color: HexColor("#41398D"))),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
              onPressed: () => Get.back()),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: Get.height * 0.8,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Image(
                    image: AssetImage('assets/image/user_collaborator.png'),
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  "Confirmar identidad",
                  style: TextStyle(
                    color: ConstantesColores.azul_precio,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  "Escribe tu codigo de colaborador",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ConstantesColores.gris_sku,
                    fontSize: 14,
                    // fontWeight: FontWeight.w800
                  ),
                ),
                SizedBox(height: 35.0),
                Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: formkey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                            textAlign: TextAlign.center,
                            hintText: 'Ingresa tu codigo',
                            hintStyle:
                                TextStyle(color: ConstantesColores.gris_sku),
                            backgroundColor: Colors.white,
                            textColor: HexColor("#41398D"),
                            borderRadius: 35,
                            icon: Icons.perm_identity,
                            onChanged: (value) {
                              _validationForms.codeCollaborator.value = value;
                              _validationForms.userInteracted2.value =
                                  true; // Marca como interactuado
                            },
                            validator:
                                _validationForms.validateTextFieldNullorEmpty),
                        SizedBox(height: 25.0),
                        BotonAgregarCarrito(
                            width: Get.width * 0.9,
                            borderRadio: 35,
                            height: Get.height * 0.06,
                            color: ConstantesColores.empodio_verde,
                            onTap: () async {
                              final isValid = formkey.currentState!.validate();
                              if (isValid == true) {
                                await _validationForms
                                    .loginAsCollaborator(context);
                              }
                            },
                            text: "Aceptar"),
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
