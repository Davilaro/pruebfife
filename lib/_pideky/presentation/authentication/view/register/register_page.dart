import 'package:cached_network_image/cached_network_image.dart';
import 'package:emart/src/controllers/controller_selector_providers.dart';
import 'package:emart/src/controllers/validations_forms.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/_pideky/presentation/cart/view_model/cart_view_model.dart';
import 'package:emart/src/provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/widgets/boton_agregar_carrito.dart';
import '../../../../../shared/widgets/custom_textFormField.dart';
import '../../../../../shared/widgets/popups.dart';
import '../../../../../src/preferences/cont_colores.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //UXCAM: Se define el nombre de la interfaz
    FlutterUxcam.tagScreenName('RegisterPage');
    final ValidationForms _validationForms = Get.put(ValidationForms());
    final ControllerSelectorProviders _controllerSelectorProviders =
        Get.put(ControllerSelectorProviders());
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
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.only(top: 10, left: 19, right: 19),
          child: Form(
            // autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    '¡Gracias por tu interes en Pideky!\n Déjanos tus datos para ponernos en contacto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: ConstantesColores.gris_textos,
                        fontSize: 17.5,
                        fontWeight: FontWeight.w400)),
                SizedBox(height: 35.0),
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
                    hintText: 'Ingrese su nombre completo',
                    hintStyle: TextStyle(color: ConstantesColores.gris_sku),
                    backgroundColor: HexColor("#E4E3EC"),
                    textColor: HexColor("#41398D"),
                    borderRadius: 35,
                    prefixIcon: SvgPicture.asset(
                      'assets/icon/cliente.svg',
                      fit: BoxFit.scaleDown,
                    ),
                    onChanged: (value) {
                      _validationForms.bussinesName.value = value;
                      _validationForms.userInteracted.value = true;
                    },
                    validator: _validationForms.validateTextFieldNullorEmpty),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.only(left: 15.0),
                  width: double.infinity,
                  child: Text('Nombre negocio',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: HexColor("#41398D"),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700)),
                ),
                SizedBox(height: 10.0),
                CustomTextFormField(
                    hintText: 'Ingrese el nombre de su negocio',
                    hintStyle: TextStyle(color: ConstantesColores.gris_sku),
                    backgroundColor: HexColor("#E4E3EC"),
                    textColor: HexColor("#41398D"),
                    borderRadius: 35,
                    prefixIcon: SvgPicture.asset(
                      'assets/icon/Icon_negocio.svg',
                      fit: BoxFit.scaleDown,
                    ),
                    onChanged: (value) {
                      _validationForms.customerName.value = value;
                      _validationForms.userInteracted.value = true;
                    },
                    validator: _validationForms.validateTextFieldNullorEmpty),
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
                    hintText: 'Ingrese dirección de su negocio',
                    hintStyle: TextStyle(color: ConstantesColores.gris_sku),
                    backgroundColor: HexColor("#E4E3EC"),
                    textColor: HexColor("#41398D"),
                    borderRadius: 35,
                    prefixIcon: SvgPicture.asset(
                      'assets/icon/ubicación_negocio.svg',
                      fit: BoxFit.scaleDown,
                    ),
                    onChanged: (value) {
                      _validationForms.businessAddress.value = value;
                      _validationForms.userInteracted.value = true;
                    },
                    validator: _validationForms.validateTextFieldNullorEmpty),
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
                Container(
                  padding: EdgeInsets.only(left: 15.0),
                  width: double.infinity,
                  child: Text('Selecciona los proveedores que te atienden',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: ConstantesColores.gris_sku,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w700)),
                ),
                //Slider Proveedores
                Container(
                    // color: Colors.amber,
                    width: Get.width * 0.89,
                    // height: 170,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 1),
                    child: Container(
                        height: Get.height * 0.1, child: _CategoriasCard())),

                SizedBox(height: 20.0),
                Obx(
                  () => _controllerSelectorProviders
                          .nitControllers.keys.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.only(left: 15.0),
                          width: double.infinity,
                          child: Text('Nit',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: HexColor("#41398D"),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700)),
                        )
                      : SizedBox.shrink(),
                ),

                Obx(() => _controllerSelectorProviders
                        .nitControllers.keys.isNotEmpty
                    ? Column(
                        children: _controllerSelectorProviders
                            .nitControllers.keys
                            .map((providerName) {
                          // final providerName = controllers.keyOf(controller);
                          return Visibility(
                            visible: _controllerSelectorProviders
                                .selectedProviders
                                .contains(providerName),
                            //visible: ControllerSelectorProviders.to.selectedProviders.contains(prividerName),
                            child: Column(
                              children: [
                                SizedBox(height: 10.0),
                                CustomTextFormField(
                                  keyboardType: TextInputType.number,
                                  hintText: 'Ingrese su nit para $providerName',
                                  hintStyle: TextStyle(
                                      color: ConstantesColores.gris_sku),
                                  backgroundColor: HexColor("#E4E3EC"),
                                  textColor: HexColor("#41398D"),
                                  borderRadius: 35,
                                  onChanged: (value) {
                                    if (value != '') {
                                      _validationForms.nit.value = value;
                                      for (var fabricante
                                          in _controllerSelectorProviders
                                              .selectedFabricantes) {
                                        if (fabricante.nombrecomercial ==
                                            providerName) {
                                          _validationForms.fillMap(
                                              value, fabricante.empresa!);
                                        }
                                      }
                                    }

                                    _validationForms.userInteracted.value =
                                        true;
                                  },
                                  validator: _validationForms
                                      .validateTextFieldNullorEmpty,
                                ),
                                SizedBox(height: 20.0),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    : SizedBox()),

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
                    prefixIcon: SvgPicture.asset(
                      'assets/icon/telefono.svg',
                      fit: BoxFit.scaleDown,
                    ),
                    onChanged: (value) {
                      _validationForms.cellPhoneNumber.value = value;
                      _validationForms.userInteracted.value = true;
                    },
                    validator: _validationForms.validateTextFieldNullorEmpty),
                SizedBox(height: 20.0),
                BotonAgregarCarrito(
                    borderRadio: 35,
                    width: Get.width * 0.9,
                    height: Get.height * 0.06,
                    color: ConstantesColores.empodio_verde,
                    onTap: () async {
                      var isValid = formkey.currentState!.validate();
                      if (isValid == true &&
                          _validationForms.sendProvidersList.isNotEmpty) {
                        bool isRegister =
                            await _validationForms.sendRegisterUser();
                        if (isRegister == true) {
                          _validationForms.sendProvidersList.clear();
                          Get.back();
                          _validationForms.isClosePopup.value = false;
                          showPopupSuccessfulregistration(context);
                          await Future.delayed(Duration(seconds: 6))
                              .then((value) async {
                            if (_validationForms.isClosePopup.value == false) {
                              Get.back();
                            }
                          });
                        } else {
                          await _validationForms.backClosePopup(context,
                              texto:
                                  'Algo salio mal, por favor intentalo de nuevo');
                        }
                      } else {
                        await _validationForms.backClosePopup(context,
                            texto:
                                'Por favor completa el formulario');
                      }
                    },
                    text: "Comenzar"),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        )));
  }
}

final prefs = new Preferencias();

class _CategoriasCard extends StatelessWidget {
  final TextEditingController controllerSearch = TextEditingController();
  final ControllerSelectorProviders _controllerSelectorProviders =
      Get.find<ControllerSelectorProviders>();
  final ValidationForms _validationForms = Get.find<ValidationForms>();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartViewModel>(context);

    return FutureBuilder(
      initialData: [],
      future: DBProvider.db.consultarFabricante(controllerSearch.text),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            scrollDirection: Axis.horizontal,
            children: _cargarDatos(context, snapshot.data, provider),
          );
        }
      },
    );
  }

  List<Widget> _cargarDatos(BuildContext context, List<dynamic> listaCategorias,
      CartViewModel provider) {
    final List<Widget> opciones = [];
    // var onTapCard = false.obs;

    listaCategorias.forEach((element) {
      final templete = GestureDetector(
        onTap: () {
          _controllerSelectorProviders.toggleProvider(element.nombrecomercial);
          _controllerSelectorProviders.toggleFabricantes(element);
          _validationForms.deleteProviderByList(element.empresa);

          // onTapCard.value = !onTapCard.value;
        },
        child: Obx(() {
          final isSelected = _controllerSelectorProviders.selectedProviders
              .contains(element.nombrecomercial);

          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: isSelected
                        ? ConstantesColores.azul_precio
                        : Colors.white),
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: Get.height * 0.15,
              width: Get.width * 0.23,
              // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
              alignment: Alignment.center,
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CachedNetworkImage(
                      imageUrl: element.icono,
                      height: Get.height * 0.07,
                      placeholder: (context, url) =>
                          Image.asset('assets/image/jar-loading.gif'),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/image/logo_login.png'),
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );

      opciones.add(templete);
    });

    return opciones;
  }
}
