// ignore_for_file: deprecated_member_use, unnecessary_null_comparison, invalid_use_of_protected_member, unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:emart/_pideky/domain/authentication/login/models/security_question_model.dart';
import 'package:emart/_pideky/domain/authentication/register/service/register_use_cases.dart';
import 'package:emart/_pideky/infrastructure/authentication/login/login_service.dart';
import 'package:emart/_pideky/presentation/authentication/view/biometric_id/face_id_page.dart';
import 'package:emart/_pideky/presentation/authentication/view/biometric_id/touch_id_page.dart';
import 'package:emart/_pideky/presentation/authentication/view/confirm_identity_send_sms_page.dart';
import 'package:emart/_pideky/presentation/authentication/view/create_password_page.dart';
import 'package:emart/_pideky/presentation/authentication/view/select_sucursal_as_collaborator.dart';
import 'package:emart/_pideky/presentation/my_payments/view_model/my_payments_view_model.dart';
import 'package:emart/_pideky/presentation/suggested_order/view_model/suggested_order_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/shared/widgets/popups.dart';
import 'package:emart/src/controllers/notifiactions_controllers.dart';
import 'package:emart/src/modelos/screen_arguments.dart';
import 'package:emart/src/modelos/validar.dart';
import 'package:emart/src/pages/login/widgets/lista_sucursales.dart';
import 'package:emart/src/pages/principal_page/tab_opciones.dart';
import 'package:emart/src/preferences/class_pedido.dart';
import 'package:emart/src/preferences/cont_colores.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/provider/crear_file.dart';
import 'package:emart/src/provider/datos_listas_provider.dart';
import 'package:emart/src/provider/db_provider_helper.dart';
import 'package:emart/src/provider/opciones_app_bart.dart';
import 'package:emart/src/provider/servicios.dart';
import 'package:emart/src/utils/alertas.dart';
import 'package:emart/src/utils/colores.dart';
import 'package:emart/src/utils/uxcam_tagueo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:local_auth/local_auth.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:emart/_pideky/infrastructure/authentication/register/register_service.dart';

import '../../_pideky/domain/authentication/login/use_cases/login_use_cases.dart';

class ValidationForms extends GetxController {
  String plataforma = Platform.isAndroid ? 'Android' : 'Ios';
  final prefs = Preferencias();
  RxBool supportState = false.obs;
  RxBool userInteracted = false.obs;
  RxBool userInteracted2 = false.obs;
  RxBool passwordsMatch = false.obs;
  RxBool isClosePopup = false.obs;
  RxBool preguntaBloqueada = false.obs;
  RxBool ccupValid = false.obs;
  RxInt numIntentos = 0.obs;
  RxString userName = ''.obs;
  RxString password = ''.obs;
  RxString bussinesName = ''.obs;
  RxString customerName = ''.obs;
  RxString businessAddress = ''.obs;
  RxString nit = ''.obs;
  RxString cellPhoneNumber = ''.obs;
  RxString confirmPassword = ''.obs;
  RxString confirmationCode = ''.obs;
  RxString correctCode = ''.obs;
  RxString providerQuestion = ''.obs;
  RxString selectedCode = ''.obs;
  RxString createPassword = ''.obs;
  RxString displayText = ''.obs;
  RxString codeCollaborator = ''.obs;
  RxString ccupSucursal = ''.obs;
  RxString seleccionSucursal = "".obs;
  RxList incorrectCodes = [].obs;
  RxList phoneNumbers = [].obs;
  RxDouble strength = 0.0.obs;
  RxList listProviders = [].obs;
  RxList listSucursales = [].obs;
  RxList<Map<String, String>> sendProvidersList = RxList();
  final loginService = LoginUseCases(LoginService());
  final registerService = RegisterUseCases(RegisterService());
  final LocalAuthentication auth = LocalAuthentication();

  final passwordError = 'No es una contraseña válida'.obs;
  final emailError = ''.obs;

  RegExp passwordRegExp =
      RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[A-Z])[a-zA-Z\d]{8,}$');

  late String _password;

  late Timer _temporizador;
  RxInt tiempoFaltante = 10.obs;

  void restarTemporizador() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      if (tiempoFaltante.value < 1) {
        timer.cancel();
      }
      tiempoFaltante.value--;
    });
  }

  void iniciarTemporizador() {
    const tiempoEspera = Duration(minutes: 10);
    _temporizador = Timer(tiempoEspera, () {
      print("inicio");
      preguntaBloqueada.value = false;
      numIntentos.value = 0;
      cancelarTemporizador();
    });
  }

  void cancelarTemporizador() {
    if (_temporizador != null && _temporizador.isActive) {
      _temporizador.cancel();
    }
  }

  Future<void> closePopUp(
      Widget navegation, BuildContext context, String? texto) async {
    int timeIteration = 0;
    isClosePopup.value = false;
    showPopup(context, texto ?? 'Usuario correcto',
        SvgPicture.asset('assets/image/Icon_correcto.svg'));
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (timeIteration >= 5) {
        timer.cancel();
        Get.back();
        Get.off(() => navegation);
      }
      if (isClosePopup.value == true) {
        timer.cancel();
        Get.off(() => navegation);
      }
      timeIteration++;
    });
  }

  Future<void> backClosePopup(context,
      {String? texto = "Usuario y/o contraseña incorrecto"}) async {
    int timeIteration = 0;
    isClosePopup.value = false;
    showPopup(
        context, texto!, SvgPicture.asset('assets/image/Icon_incorrecto.svg'));
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (timeIteration >= 5) {
        timer.cancel();
        Get.back();
      }
      if (isClosePopup.value == true) {
        timer.cancel();
      }
      timeIteration++;
    });
  }

  Future validationNit(context) async {
    final progress = ProgressDialog(context, isDismissible: false);
    progress.style(
        message: "Validando usuario",
        progressWidget: Image(
          image: AssetImage('assets/image/jar-loading.gif'),
          fit: BoxFit.cover,
          height: 20,
        ));
    await progress.show();
    var response = await loginService.validationCCUP(userName.value);
    await progress.hide();
    if (response == true) {
      await getPhoneNumbers();
      await closePopUp(
          ConfirmIdentitySendSMSPage(
            isChangePassword: true,
          ),
          context,
          null);
    } else if (response == "CCUP invalido") {
      isClosePopup.value = false;
      await backClosePopup(context, texto: response);
    } else {
      isClosePopup.value = false;
      await backClosePopup(context, texto: "Por favor intenta con otro CCUP");
    }
  }

  Future getSucursalesAsCollaborator(context) async {
    prefs.codigoUnicoPideky = ccupSucursal.value;
    List<dynamic> sucursales = await Servicies().getListaSucursales(false);
    if (sucursales.isNotEmpty) {
      listSucursales.value = sucursales;
    } else {
      await backClosePopup(context, texto: "CCUP incorrecto");
    }
  }

  Future loginAsCollaborator(context) async {
    final progress = ProgressDialog(context, isDismissible: false);
    progress.style(
        message: S.current.logging_in,
        progressWidget: Image(
          image: AssetImage('assets/image/jar-loading.gif'),
          fit: BoxFit.cover,
          height: 20,
        ));
    await progress.show();
    var response = await loginService
        .loginAsCollaborator(encryptedPaswword(codeCollaborator.value));
    await progress.hide();
    if (response == true) {
      await getPhoneNumbers();
      await closePopUp(SelectSucursalAsCollaboratorPage(), context, null);
    } else {
      await backClosePopup(context, texto: 'Codigo incorrecto');
    }
  }

  Future loginWithBiometricData(context) async {
    final progress = ProgressDialog(context, isDismissible: false);
    progress.style(
        message: S.current.logging_in,
        progressWidget: Image(
          image: AssetImage('assets/image/jar-loading.gif'),
          fit: BoxFit.cover,
          height: 20,
        ));
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: plataforma == "Android"
            ? 'Por favor pon tu huella para ingresar a la aplicación.'
            : 'Por favor acerca tu rostro para ingresar a la aplicación.',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (authenticated == true) {
        prefs.isDataBiometricActive = true;
        await progress.show();
        await login(context, progress, true);
        return;
      }
    } on PlatformException catch (e) {
      final textoPopUp = plataforma == "Android"
          ? "Huella no reconocida"
          : "Rostro no reconocido";
      final iconPopUp = plataforma == "Android"
          ? AssetImage('assets/image/Icon_touch_ID.png')
          : AssetImage('assets/image/Image_face_ID.png');
      int timeIteration = 0;
      isClosePopup.value = false;
      isClosePopup.value = false;
      showPopupUnrecognizedfingerprint(
          context,
          textoPopUp,
          Image(
            image: iconPopUp,
            fit: BoxFit.contain,
          ));
      Timer.periodic(Duration(milliseconds: 500), (timer) {
        if (timeIteration >= 5) {
          timer.cancel();
          Get.back();
        }
        if (isClosePopup.value == true) {
          timer.cancel();
        }
        timeIteration++;
      });
      print(e);
      return;
    }
  }

  Future<void> getDataSecurityQuestion() async {
    final SecurityQuestionModel answer =
        await loginService.getSecurityQuestionCodes();
    if (answer != null) {
      correctCode.value = answer.codigoCorrecto!;
      incorrectCodes.value.assignAll(answer.codigoIncorrecto!);
      incorrectCodes.addIf(
          !incorrectCodes.contains(correctCode.value), correctCode.value);
      providerQuestion.value = answer.negocio!;
      final random = Random();
      for (int i = incorrectCodes.length - 1; i > 0; i--) {
        int j = random.nextInt(i + 1);

        // Intercambiar elementos en las posiciones i y j
        String temp = incorrectCodes[i];
        incorrectCodes[i] = incorrectCodes[j];
        incorrectCodes[j] = temp;
      }
    }
  }

  Future<bool> validationCodePhone(context) async {
    final progress = ProgressDialog(context, isDismissible: false);
    progress.style(
        message: "Validando código",
        progressWidget: Image(
          image: AssetImage('assets/image/jar-loading.gif'),
          fit: BoxFit.cover,
          height: 20,
        ));
    await progress.show();
    final Validar isValid =
        await loginService.validationCode(confirmationCode.value);
    progress.hide();
    if (isValid != null && isValid.activado == "OK") {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getPhoneNumbers() async {
    List responde = await loginService.getPhoneNumbers();

    phoneNumbers.assignAll(responde);
  }

  void fillMap(String nit, String proveedor) {
    bool found =
        false; // Variable para verificar si se encontró el proveedor en la lista

    for (var element in sendProvidersList) {
      if (element['Proveedor'] == proveedor) {
        // Si el proveedor ya existe en la lista, actualiza el 'nit'
        element['Nit'] = nit;
        found = true; // Indica que se encontró el proveedor en la lista
        break; // Sal del bucle ya que ya se actualizó el 'nit'
      }
    }

    if (!found) {
      // Si el proveedor no se encontró en la lista, agrégalo
      if (nit != null) {
        sendProvidersList.add({'Proveedor': proveedor, 'Nit': nit});
      }
    }

    // Elimina elementos de la lista que tienen 'nit' nulo
    sendProvidersList.removeWhere((element) => element['Nit'] == null);

    print("data $sendProvidersList");
  }

  void deleteProviderByList(String proveedor) {
    sendProvidersList
        .removeWhere((element) => element['Proveedor'] == proveedor);
  }

  Future<bool> sendRegisterUser() async {
    return await registerService.register(
        bussinesName.value,
        customerName.value,
        businessAddress.value,
        cellPhoneNumber.value,
        sendProvidersList.value);
  }

  Future changePassword() async {
    if (passwordsMatch.value == true) {
      String encriptedPassword = encryptedPaswword(createPassword.value);
      return await loginService.changePassword(
          userName.value, encriptedPassword);
    }
    return false;
  }

  Future<int> sendUserAndPassword(String user, String password) async {
    final isValid = await loginService.validationUserAndPassword(
        user, encryptedPaswword(password));

    if (isValid != -1) return isValid;
    return -1;
  }

  Future<dynamic> validationLoginNewUser(context) async {
    try {
      final progress = ProgressDialog(context, isDismissible: false);
      progress.style(
          message: S.current.logging_in,
          progressWidget: Image(
            image: AssetImage('assets/image/jar-loading.gif'),
            fit: BoxFit.cover,
            height: 20,
          ));
      await progress.show();
      var validation =
          await sendUserAndPassword(userName.value, password.value);
      if (validation != -1 && validation != -2) {
        if (validation == 0) {
          if (prefs.isDataBiometricActive == null) {
            plataforma == "Android"
                ? Get.offAll(() => TouchIdPage())
                : Get.offAll(() => FaceIdPage());
          } else {
            if (await login(context, progress, false) == true) {
              print('logueo');
              return true;
            } else {
              throw 'error en login';
            }
          }
        } else {
          await progress.hide();
          int timeIteration = 0;
          isClosePopup.value = false;
          showPopup(context, 'Usuario correcto',
              SvgPicture.asset('assets/image/Icon_correcto.svg'));
          Timer.periodic(Duration(milliseconds: 500), (timer) {
            if (timeIteration >= 5) {
              timer.cancel();
              Get.back();
              Get.offAll(
                () => CreatePasswordPage(
                  isChangePassword: false,
                ),
              );
            }
            if (isClosePopup.value == true) {
              timer.cancel();
              Get.offAll(
                () => CreatePasswordPage(
                  isChangePassword: false,
                ),
              );
            }
            timeIteration++;
          });

          return true;
        }
      } else {
        await progress.hide();
        if (validation == -1) {
          mostrarAlertCustomWidgetOld(
              context,
              Text(
                "La contraseña no coincide con este usuario. Por favor, revisa que esté bien escrito, o si la olvidaste, cambia tu contraseña. Si aún presentas problemas, contacta a soporte",
                textAlign: TextAlign.center,
              ),
              SvgPicture.asset(
                'assets/image/Icon_incorrecto.svg',
                color: ConstantesColores.azul_aguamarina_botones,
              ),
              null);
        } else if (validation == -2) {
          //Uxcam tagueo usuario no encontrado en base de datos
          UxcamTagueo().userNotFoundLogin();
          mostrarAlertCustomWidgetOld(
              context,
              Text(
                "El CCUP ingresado tiene novedades, no podemos activarte en este momento por favor comunícate  con soporte.",
                textAlign: TextAlign.center,
              ),
              SvgPicture.asset(
                'assets/image/Icon_incorrecto.svg',
                color: ConstantesColores.azul_aguamarina_botones,
              ),
              null);
        }

        return false;
      }
    } catch (e, stackTrace) {
      print('error en login $e - $stackTrace');
    }
  }

  String encryptedPaswword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha512.convert(bytes);
    return digest.toString();
  }

  Future<void> lanzarWhatssap(context) async {
    var lineaSoporte = await DBProviderHelper.db.cargarTelefotosSoporte(3);
    var whatappurlIos =
        "https://wa.me/+${lineaSoporte[1].telefono}?text=${Uri.parse("Hola")}";

    //UXCam: Llamamos el evento selectSoport
    UxcamTagueo().selectSoport('Soporte Whatssap');
    try {
      if (Platform.isIOS) {
        // for iOS phone only
        if (await canLaunch(whatappurlIos)) {
          await launch(whatappurlIos, forceSafariVC: false);
        } else {
          //message: whatsapp no instalado
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: new Text(S.current.whatsApp_not_installed)));
        }
      } else {
        // android , web
        await launch(
            'https://api.whatsapp.com/send?phone=+${lineaSoporte[1].telefono}');
      }
    } catch (e) {
      print(e);
    }
  }

  Widget cargarLinkWhatssap(context) {
    return Column(
      children: [
        //message: El NIT ingresado no se encuentra registrado en nuestra base de datos. Por favor revisa que esté bien escrito o contáctanos en
        Text(
          S.current.the_nit_entered_is_not_registered,
          textAlign: TextAlign.left,
        ),
        GestureDetector(
          onTap: () => lanzarWhatssap(context),
          child: Text(
            S.current.whatsApp, //message: WhatsApp
            textAlign: TextAlign.center,
            style: TextStyle(
              color: HexColor(Colores().color_azul_letra),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> login(
      BuildContext context, progress, bool isLoginBiometric) async {
    try {
      List<dynamic> respuesta =
          await Servicies().getListaSucursales(isLoginBiometric);

      // respuesta.forEach((element) {
      //   if (element.bloqueado == "1") {
      //     progress.hide();
      //     providerOptions.selectOptionMenu = 0;
      //     Get.off(() => TabOpciones());
      //     return mostrarAlertCustomWidget(
      //         context, cargarLinkWhatssap(context), null);
      //   }
      // });

      if (respuesta.length > 0) {
        if (respuesta.first.bloqueado == "1") {
          progress.hide();
          prefs.usurioLogin = -1;
          mostrarAlertCustomWidgetOld(
              context, cargarLinkWhatssap(context), null, null);

          return false;
        }
        SuggestedOrderViewModel.userLog.value = 1;
        prefs.isFirstTime = false;
        progress.hide();
        int timeIteration = 0;
        isClosePopup.value = false;
        showPopup(context, 'Usuario correcto',
            SvgPicture.asset('assets/image/Icon_correcto.svg'));
        //providerOptions.selectOptionMenu = 0;
        Timer.periodic(Duration(milliseconds: 500), (timer) {
          if (timeIteration >= 5) {
            timer.cancel();
            Get.back();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => ListaSucursales(),
                settings: RouteSettings(
                  arguments: ScreenArguments(respuesta),
                ),
              ),
              (route) => false, // Elimina todas las rutas anteriores
            );
          }
          if (isClosePopup.value == true) {
            timer.cancel();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => ListaSucursales(),
                settings: RouteSettings(
                  arguments: ScreenArguments(respuesta),
                ),
              ),
              (route) => false, // Elimina todas las rutas anteriores
            );
          }
          timeIteration++;
        });

        return true;
      } else {
        await progress.hide();
        await backClosePopup(context, texto: "Usuario incorrecto");

        return false;
      }
    } catch (e) {
      print('Error retorno login $e');
      await progress.hide();
      await backClosePopup(context,
          texto: "Algo salió mal, intentalo de nuevo");

      return false;
    }
  }

  void tagCheckPassword(String value) {
    _password = value.trim();

    if (_password.isEmpty) {
      strength.value = 0;
      displayText.value = '';
    } else if (_password.length < 6) {
      strength.value = 1 / 4;
      displayText.value = 'Débil';
    } else if (_password.length < 8) {
      strength.value = 2 / 4;
      displayText.value = 'Medio';
    } else {
      if (!passwordRegExp.hasMatch(_password)) {
        strength.value = 3 / 4;
        displayText.value = 'Fuerte';
      } else {
        strength.value = 1;
        displayText.value = 'Fuerte';
      }
    }
  }

  // Válida que las contraseñas sean iguales
  void comparePasswords(String value) {
    passwordsMatch.value = value == _password;
  }

  //Validación básica para verificar si un campo cualquiera está vacío o es null
  String? validateTextFieldNullorEmpty(String? value) {
    if (value == null || value.isEmpty || value.trim().isEmpty)
      return 'Campo requerido';
    //if (value.trim().isEmpty) return 'Campo requerido';
    if (value.length < 6) return 'Información incorrecta';

    return null;
  }

  //Validación básica para verificar si un campo cualquiera está vacío o es null en el ccup
  String? validateTextFieldCCUP(String? value) {
    ccupValid.value = false;
    var numberList = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];

    if (value == null || value.isEmpty || value.trim().isEmpty)
      return 'Campo requerido';
    //if (value.trim().isEmpty) return 'Campo requerido';
    if (prefs.paisUsuario == "CO") {
      if (value.length < 11 ||
          value[0].toLowerCase() != "c" ||
          numberList.contains(value[1].toLowerCase())) return 'CCUP incorrecto';

      for (int i = 2; i < value.length; i++) {
        if (numberList.contains(value[i]) == false) return 'CCUP incorrecto';
      }
    } else if (prefs.paisUsuario == "CR") {
      if (value.length < 11) {
        if (value.length > 4 && value.substring(0, 4).toLowerCase() != "crcr") {
          return 'CCUP incorrecto';
        }
        return 'CCUP incorrecto';
      } else {
        if (value.substring(0, 4).toLowerCase() != "crcr") {
          return 'CCUP incorrecto';
        }
      }

      for (int i = 4; i < value.length; i++) {
        if (numberList.contains(value[i]) == false) return 'CCUP incorrecto';
      }
    }

    ccupValid.value = true;
    return null;
  }

  String? validatePassword(String? value) {
    passwordError.value = 'No es una contraseña válida';
    if (value == null || value.isEmpty) {
      return 'Campo requerido';
    }
    if (value.trim().isEmpty) {
      return passwordError.value;
    }
    final passwordRegExp =
        RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[A-Z])[a-zA-Z\d]{8,}$');
    if (!passwordRegExp.hasMatch(value)) {
      return passwordError.value;
    }
    return null;
  }

  //Validación para email encuesta homePage
  String? validateEmail(String? value) {
    emailError.value = 'No es un email válido ';
    if (value == null || value.isEmpty) {
      return 'Campo requerido';
    }
    if (value.trim().isEmpty) {
      return passwordError.value;
    }

    final emailRegExp = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    if (!emailRegExp.hasMatch(value)) {
      return emailError.value;
    }
    return null;
  }

  // Validación de números de celular, Colombia, Costa Rica  encuesta homePage
  String? validateTelephone(String? value) {
    final colombiaRegExp = RegExp(r'^3\d{9}$');
    final costaRicaRegExp = RegExp(r'^[678]\d{7}$');

    emailError.value = 'No es un telefono válido';
    if (value == null || value.isEmpty) {
      return 'Campo requerido';
    }
    if (value.trim().isEmpty) {
      return passwordError.value;
    }
    if (prefs.paisUsuario == "CO") {
      if (!colombiaRegExp.hasMatch(value)) {
        return 'No es un número de teléfono válido para Colombia';
      }
    } else if (prefs.paisUsuario == "CR") {
      if (!costaRicaRegExp.hasMatch(value)) {
        return 'No es un número de teléfono válido para Costa Rica';
      }
    }

    return null;
  }

  mostrarCategorias(
      BuildContext context, dynamic elemento, DatosListas provider) async {
    final opcionesAppBard = Provider.of<OpcionesBard>(context, listen: false);
    final progress = ProgressDialog(context, isDismissible: false);
    progress.style(
        message: S.current.logging_in,
        progressWidget: Image(
          image: AssetImage('assets/image/jar-loading.gif'),
          fit: BoxFit.cover,
          height: 20,
        ));
    await progress.show();
    await cargarInformacion(provider, elemento);
    await cargarDataUsuario(elemento.sucursal);
    if (prefs.usurioLogin == 1) {
      UxcamTagueo().validarTipoUsuario();
    }
    await progress.hide();
    listSucursales.clear();
    seleccionSucursal.value = "";
    opcionesAppBard.selectOptionMenu = 0;
    Get.offAll(() => TabOpciones());
    // Navigator.of(context).pushNamedAndRemoveUntil(
    //     'tab_opciones', (Route<dynamic> route) => false);
  }

  Future<void> cargarInformacion(DatosListas provider, dynamic elemento) async {
    final notificationController =
        Get.find<NotificationsSlideUpAndPushInUpControllers>();
    final controllerPedidoSugerido = Get.find<SuggestedOrderViewModel>();
    final controllerNequi = Get.find<MyPaymentsViewModel>();
    notificationController.resetMaps();
    prefs.usurioLogin = 1;
    //prefs.usurioLoginCedula = usuariLogin;

    PedidoEmart.listaControllersPedido = new Map();
    PedidoEmart.listaValoresPedido = new Map();
    PedidoEmart.listaProductos = new Map();
    PedidoEmart.listaValoresPedidoAgregados = new Map();

    await AppUtil.appUtil
        .downloadZip(prefs.codigoUnicoPideky!, elemento.sucursal, false);
    // var cargo = await AppUtil.appUtil.downloadZip(
    //     usuariLogin!,
    //     prefs.codCliente,
    //     prefs.sucursal,
    //     prefs.codigonutresa,
    //     prefs.codigozenu,
    //     prefs.codigomeals,
    //     prefs.codigopadrepideky,
    //     false);
    await AppUtil.appUtil.abrirBases();
    controllerPedidoSugerido.initController();
    controllerNequi.initData();
  }

  cargarDataUsuario(sucursal) async {
    List datosCliente = await DBProviderHelper.db.consultarDatosCliente();

    prefs.usuarioRazonSocial = datosCliente[0].razonsocial;
    prefs.codCliente = datosCliente[0].codigo;
    prefs.codTienda = 'nutresa';
    prefs.codigonutresa = datosCliente[0].codigonutresa;
    prefs.codigozenu = datosCliente[0].codigozenu;
    prefs.codigomeals = datosCliente[0].codigomeals;
    prefs.codigopozuelo = datosCliente[0].codigopozuelo;
    prefs.codigoalpina = datosCliente[0].codigoalpina;
    prefs.paisUsuario = datosCliente[0].pais;
    prefs.sucursal = sucursal;
    prefs.ciudad = datosCliente[0].ciudad;
    prefs.direccionSucursal = datosCliente[0].direccion;
    prefs.codClienteLogueado = datosCliente[0].nit;

    S.load(datosCliente[0].pais == 'CR'
        ? Locale('es', datosCliente[0].pais)
        : datosCliente[0].pais == 'CO'
            ? Locale('es', 'CO')
            : Locale('es', 'CO'));
  }

  static ValidationForms get findOrInitialize {
    try {
      return Get.find<ValidationForms>();
    } catch (e) {
      Get.put(ValidationForms());
      return Get.find<ValidationForms>();
    }
  }
}
