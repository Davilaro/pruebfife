import 'package:emart/_pideky/presentation/authentication/view/touch_id_page.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../../shared/widgets/boton_agregar_carrito.dart';
import '../../../../shared/widgets/cust_drop_down_register.dart';
import '../../../../shared/widgets/custom_textFormField.dart';
import '../../../../shared/widgets/popups.dart';
import '../../../../src/preferences/cont_colores.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage();

  // final TextEditingController _controllerBusinessName = TextEditingController();
  // final TextEditingController _controllerUserName = TextEditingController();
  // final TextEditingController _controllerNit = TextEditingController();
  // final TextEditingController _controllerTelephone = TextEditingController();
  // final TextEditingController _controllerAdress = TextEditingController();
  final ValidationForms _validationForms = Get.put(ValidationForms());
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>>? items;
  String? value;
  //final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // String bussinesName = '';
  // String customerName = '';
  // String businessAddress = '';
  // String nit = '';
  // String cellPhoneNumber = '';

  @override
  Widget build(BuildContext context) {
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
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 10, left: 19, right: 19),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formkey,
              child: Column(
                children: [
                  Text('Quiero ser cliente Pideky',
                      style: TextStyle(
                          color: HexColor("#41398D"),
                          fontSize: 24.0,
                          fontWeight: FontWeight.w900)),
                  SizedBox(height: 15.0),
                  Text(
                      '¡Gracias por tu interes en Pideky!\n Dejanos tus datos para ponernos en contacto',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.5,
                          fontWeight: FontWeight.w100)),
                  SizedBox(height: 35.0),
                  Container(
                    padding: EdgeInsets.only(left: 15.0),
                    width: double.infinity,
                    child: Text('Nombre Negocio',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: HexColor("#41398D"),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(height: 10.0),
                  CustomTextFormField(
                      // errorMessage: 'errer',
                      // controller: _controllerBusinessName,
                      hintText: 'Ingrese el nombre de su negocio',
                      hintStyle: TextStyle(color: HexColor("#41398D")),
                      backgroundColor: HexColor("#E4E3EC"),
                      textColor: HexColor("#41398D"),
                      borderRadius: 35,
                      prefixIcon: Image.asset('assets/icon/Icon_negocio.png'),
                      // icon: Icons.business_rounded,
                      onChanged: (value) {
                        _validationForms.bussinesName.value = value;
                        _validationForms.userInteracted.value = true;
                      },
                      validator: _validationForms.validateTextFieldNullorEmpty
                      // validator: (value) {
                      //   if (value == null || value.isEmpty)
                      //     return 'Campo requerido';
                      //   if (value.trim().isEmpty) return 'Campo requerido';
                      // }
                      ),
                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.only(left: 15.0),
                    width: double.infinity,
                    child: Text('Nombre cliente',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: HexColor("#41398D"),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(height: 10.0),
                  CustomTextFormField(
                      //  controller: _controllerUserName,
                      hintText: 'Ingrese el nombre completo',
                      hintStyle: TextStyle(color: ConstantesColores.gris_sku),
                      backgroundColor: HexColor("#E4E3EC"),
                      textColor: HexColor("#41398D"),
                      borderRadius: 35,
                      prefixIcon: Image.asset('assets/icon/Icon_cliente.png'),
                      onChanged: (value) {
                        _validationForms.bussinesName.value = value;
                        _validationForms.userInteracted.value = true;
                      },
                      validator: _validationForms.validateTextFieldNullorEmpty
                      ),
                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.only(left: 15.0),
                    width: double.infinity,
                    child: Text('Dirección negocio',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: HexColor("#41398D"),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(height: 10.0),
                  CustomTextFormField(
                      //  controller: _controllerAdress,
                      hintText: 'Ingrese dirección de su negocio',
                      hintStyle: TextStyle(color: ConstantesColores.gris_sku),
                      backgroundColor: HexColor("#E4E3EC"),
                      textColor: HexColor("#41398D"),
                      borderRadius: 35,
                      prefixIcon:
                          Image.asset('assets/icon/Icon_ubicación_negocio.png'),
                      onChanged: (value) {
                        _validationForms.bussinesName.value = value;
                        _validationForms.userInteracted.value = true;
                      },
                      validator: _validationForms.validateTextFieldNullorEmpty
                      ),
                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.only(left: 15.0),
                    width: double.infinity,
                    child: Text('Proveedor',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: HexColor("#41398D"),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(height: 10.0),
                  CustomDropdownReg(
                    backgroundColor: HexColor("#E4E3EC"),
                    items: [],
                    value: '',
                    hintText: 'Ingresa el nombre del provedor',
                    hintStyle: TextStyle(color: ConstantesColores.gris_sku),
                    onChanged: (p0) => Container(),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.only(left: 15.0),
                    width: double.infinity,
                    child: Text('Nit',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: HexColor("#41398D"),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(height: 10.0),
                  CustomTextFormField(
                    keyboardType: TextInputType.number,
                    //   controller: _controllerNit,
                    hintText: 'Nit',
                    hintStyle: TextStyle(color: ConstantesColores.gris_sku),
                    backgroundColor: HexColor("#E4E3EC"),
                    textColor: HexColor("#41398D"),
                    borderRadius: 35,
                    onChanged: (value) {
                        _validationForms.bussinesName.value = value;
                        _validationForms.userInteracted.value = true;
                      },
                      validator: _validationForms.validateTextFieldNullorEmpty
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.only(left: 15.0),
                    width: double.infinity,
                    child: Text('Celular de contacto',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: HexColor("#41398D"),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(height: 10.0),
                  CustomTextFormField(
                      keyboardType: TextInputType.number,
                      //   controller: _controllerTelephone,
                      hintText: 'Ingrese su número de celular',
                      hintStyle: TextStyle(color: ConstantesColores.gris_sku),
                      backgroundColor: HexColor("#E4E3EC"),
                      textColor: HexColor("#41398D"),
                      borderRadius: 35,
                      prefixIcon: Image.asset('assets/icon/Icon_telefono.png'),
                      onChanged: (value) {
                        _validationForms.bussinesName.value = value;
                        _validationForms.userInteracted.value = true;
                      },
                      validator: _validationForms.validateTextFieldNullorEmpty
                      ),
                  SizedBox(height: 20.0),
                  BotonAgregarCarrito(
                      borderRadio: 35,
                      height: Get.height * 0.06,
                      color: ConstantesColores.empodio_verde,
                      onTap: () {
                        final isValid = formkey.currentState!.validate();
                        if (!isValid)
                          showPopupSuccessfulregistration(context);
                        else
                          Get.to(TouchIdPage());
                      },
                      text: "Comenzar"),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ));
  }
}
