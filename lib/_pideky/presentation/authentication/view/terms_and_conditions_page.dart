import 'package:emart/_pideky/presentation/authentication/view/confirm_identity_page_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../shared/widgets/boton_agregar_carrito.dart';
import '../../../../shared/widgets/popups.dart';
import '../../../../shared/widgets/text_button_with_underline.dart';
import '../../../../src/preferences/cont_colores.dart';
import 'touch_id_page.dart';

// class TermsAndConditionsPage extends StatelessWidget {
//   const TermsAndConditionsPage();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: ConstantesColores.color_fondo_gris,
//         body: Container(
//             padding: EdgeInsets.only(top: 120, left: 30, right: 30),
//             child: Column(

//               children: [
//               Image(
//                 image:
//                     AssetImage('assets/image/Icon_Terminos_y_condiciones.png'),
//                 fit: BoxFit.contain,
//               ),
//               SizedBox(height: 50),
//               Text('Términos y condiciones ',
//                   style: TextStyle(
//                       color: HexColor("#41398D"),
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold)),
//               TextButtonWithUnderline(
//                 text: "Acepto Términos y condiciones?",
//                 onPressed: () {},
//                 textColor: HexColor("#41398D"),
//                 textSize: 16.0,
//               ),
//               TextButtonWithUnderline(
//                 text: "Autorizo tratamiento de mis datos \n personales",
//                 onPressed: () {},
//                 textColor: HexColor("#41398D"),
//                 textSize: 16.0,
//               ),
//               BotonAgregarCarrito(
//                   borderRadio: 35,
//                   height: Get.height * 0.06,
//                   color: ConstantesColores.empodio_verde,
//                   onTap: () {},
//                   text: "Aceptar"),
//             ])));
//   }
// }

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage();

  @override
  _TermsAndConditionsPageState createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool acceptTerms = false;
  bool authorizeDataTreatment = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      body: Container( 
        padding: EdgeInsets.only(top: 140, left: 30, right: 30),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Image(
                image: AssetImage('assets/image/Icon_Terminos_y_condiciones.png'),
                fit: BoxFit.contain,
              ),
              SizedBox(height: 30),
              Text(
                'Términos y condiciones',
                style: TextStyle(
                  color: HexColor("#41398D"),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    shape: CircleBorder(),
                    activeColor: HexColor("#41398D"),
                    value: acceptTerms,
                    onChanged: (newValue) {
                      setState(() {
                        acceptTerms = newValue ?? false;
                      });
                    },
                  ),
                  TextButtonWithUnderline(
                    text: "Acepto Términos y condiciones",
                    onPressed: () {},
                    textColor: HexColor("#41398D"),
                    textSize: 15.0,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    shape: CircleBorder(),
                    activeColor: HexColor("#41398D"),
                    value: authorizeDataTreatment,
                    onChanged: (newValue) {
                      setState(() {
                        authorizeDataTreatment = newValue ?? false;
                      });
                    },
                  ),
                  //SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    alignment: Alignment.bottomLeft,
                    child: TextButtonWithUnderline(
                      text: "Autorizo tratamiento de mis datos \n personales",
                      onPressed: () {},
                      textColor: HexColor("#41398D"),
                      textSize: 15.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              BotonAgregarCarrito(
                borderRadio: 35,
                height: Get.height * 0.06,
                color: ConstantesColores.empodio_verde,
                onTap: () {

                  if (_formkey.currentState!.validate()) {
                    // Validar que ambos checkboxes estén seleccionados
                    if (!acceptTerms) {
                      showPopup(
                    context,
                    'Debes aceptar términos y condiciones',
                    SvgPicture.asset(
                      'assets/image/Icon_incorrecto.svg',
                    ));
                      return;
                    }
                    if (!authorizeDataTreatment) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Debes autorizar el tratamiento de tus datos personales.'),
                      ));
                      return;
                    }
                    
                    // Si todo está validado, navegar a la siguiente pantalla
                    Get.to(ConfirmIdentityPageOne());
                    showPopup(
                      context,
                      'Has aceptado los términos y condiciones',
                      SvgPicture.asset('assets/image/Icon_correcto.svg'),
                    );
                  }
                

                  // Get.to(ConfirmIdentityPageOne());
          
                  // showPopup(
                  //     context,
                  //     'Has aceptado los términos y condiciones',
                  //     SvgPicture.asset('assets/image/Icon_correcto.svg'));
                },
                text: "Aceptar",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
