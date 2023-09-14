import 'package:get/get.dart';
import 'package:emart/src/preferences/preferencias.dart';

class ValidationForms extends GetxController {
  RxString userName = ''.obs;
  RxString password = ''.obs;
  RxString bussinesName = ''.obs;
  RxString customerName = ''.obs;
  RxString businessAddress = ''.obs;
  RxString nit = ''.obs;
  RxString cellPhoneNumber = ''.obs;
  RxString confirmPassword = ''.obs;
  RxString confirmationCode = ''.obs;
  RxBool userInteracted = false.obs;
  RxBool userInteracted2 = false.obs;

  final passwordError = 'No es una contraseña válida'.obs;
  final emailError = ''.obs;

    RegExp passwordRegExp = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[A-Z])[a-zA-Z\d]{8,}$');


  RxString createPassword = ''.obs;
  RxDouble strength = 0.0.obs;
  RxString displayText = ''.obs;
  RxBool passwordsMatch = false.obs;

  late String _password;
  final prefs = Preferencias();

  

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
    final colombiaRegExp =  RegExp(r'^3\d{9}$'); 
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
}
