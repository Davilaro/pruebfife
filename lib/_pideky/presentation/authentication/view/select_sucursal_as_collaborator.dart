// ignore_for_file: invalid_use_of_protected_member

import 'package:emart/_pideky/presentation/authentication/widget/custom_card_sucursal.dart';
import 'package:emart/shared/widgets/boton_agregar_carrito.dart';
import 'package:emart/shared/widgets/custom_textFormField.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

class SelectSucursalAsCollaboratorPage extends StatelessWidget {
  const SelectSucursalAsCollaboratorPage({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatosListas>(context);
    final ValidationForms _validationForms = Get.find<ValidationForms>();
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: ConstantesColores.color_fondo_gris,
      appBar: AppBar(
        title: Text('Volver', style: TextStyle(color: HexColor("#41398D"))),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: HexColor("#30C3A3")),
            onPressed: () {
              _validationForms.listSucursales.clear();
              Get.back();
            }),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: Get.width,
        height: Get.height,
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formkey,
          child: Column(
            children: [
              CustomTextFormField(
                  hintText: 'Ingresa el CCUP del cliente',
                  hintStyle: TextStyle(color: ConstantesColores.gris_sku),
                  backgroundColor: HexColor("#E4E3EC"),
                  textColor: HexColor("#41398D"),
                  borderRadius: 35,
                  icon: Icons.perm_identity,
                  prefixIcon: SvgPicture.asset(
                    'assets/icon/cliente.svg',
                    fit: BoxFit.scaleDown,
                  ),
                  onChanged: (value) {
                    _validationForms.ccupSucursal.value = value;
                    _validationForms.userInteracted2.value =
                        true; // Marca como interactuado
                  },
                  validator: _validationForms.validateTextFieldNullorEmpty),
              Expanded(
                child: Obx(
                  () => Container(
                      margin: EdgeInsets.only(top: 20),
                      width: Get.width,
                      child: ListView.builder(
                        itemCount: _validationForms.listSucursales.value.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          if (_validationForms.listSucursales.isNotEmpty) {
                            var itemSucursal =
                                _validationForms.listSucursales.value[index];
                            return CustomCardSucursales(
                              ciudad: itemSucursal.ciudad,
                              direccion: itemSucursal.direccion,
                              nombre: itemSucursal.nombre,
                              onTap: () async {
                                _validationForms.seleccionSucursal.value =
                                    itemSucursal.razonsocial;
                                await _validationForms.mostrarCategorias(
                                    context, itemSucursal, provider);
                              },
                              razonSocial: itemSucursal.razonsocial,
                              telefono: itemSucursal.telefono,
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      )),
                ),
              ),
              BotonAgregarCarrito(
                  width: Get.width * 0.9,
                  borderRadio: 35,
                  height: Get.height * 0.06,
                  color: ConstantesColores.empodio_verde,
                  onTap: () async {
                    final isValid = formkey.currentState!.validate();
                    if (isValid == true) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      _validationForms.getSucursalesAsCollaborator(context);
                    }
                  },
                  text: "Aceptar"),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
