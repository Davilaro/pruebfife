import 'package:get/get.dart';

class ValidationForms extends GetxController {
  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxString userName         = ''.obs;
  RxString password         = ''.obs;
  RxString bussinesName     = ''.obs;
  RxString customerName     = ''.obs;
  RxString businessAddress  = ''.obs;
  RxString nit              = ''.obs;
  RxString cellPhoneNumber  = ''.obs;
 // RxString createPassword   = ''.obs;
  RxString confirmPassword  = ''.obs;
 
  RxBool userInteracted     = false.obs;
  RxBool userInteracted2     = false.obs;

  final passwordError = 'No es una contraseña válida'.obs;
  
   //Variables para linea de progreso de contraseña
      // late String _password;
      // double _strength = 0;
      RegExp passwordRegExp = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[A-Z])[a-zA-Z\d]{8,}$');
     // String _displayText = '';
  
  RxString createPassword = ''.obs;
  RxDouble strength = 0.0.obs;
  RxString displayText = ''.obs;
  RxBool passwordsMatch = false.obs;

  late String _password;
  
  

  //Variable para comparar las contraseñas
  // bool _passwordsMatch = false;

   
  



  //Maneja la barra indicadora de contraseña de la vista de creación de contraseña
      // void tagCheckPassword(String value) {
      //   _password = value.trim();

      //   if (_password.isEmpty) {
      //     _strength = 0;
      //     _displayText = '';
      //   } else if (_password.length < 6) {
      //     _strength = 1 / 4;
      //     _displayText = 'débil';
      //   } else if (_password.length < 8) {
      //     _strength = 2 / 4;
      //     _displayText = 'Medio';
      //   } else {
      //     if (!passwordRegExp.hasMatch(_password)) {
      //       _strength = 3 / 4;
      //       _displayText = 'Fuerte';
      //     } else {
      //       _strength = 1;
      //       _displayText = 'Fuerte';
      //     }
      //   }
      // }

  //     void tagCheckPassword(String password) {
  //   if (password.isEmpty) {
  //     strength.value = 0;
  //     displayText.value = '';
  //   } else if (password.length < 6) {
  //     strength.value = 1 / 4;
  //     displayText.value = 'débil';
  //   } else if (password.length < 8) {
  //     strength.value = 2 / 4;
  //     displayText.value = 'Medio';
  //   } else {
  //     if (!passwordRegExp.hasMatch(password)) {
  //       strength.value = 3 / 4;
  //       displayText.value = 'Fuerte';
  //     } else {
  //       strength.value = 1;
  //       displayText.value = 'Fuerte';
  //     }
  //   }
  // }

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

  //  void comparePasswords(String confirmPassword) {
  //   passwordsMatch.value = confirmPassword == createPassword.value;
  // }


    // double get strength =>  _strength;
    // String get displayText => _displayText;
    // bool get passwordsMatch => _passwordsMatch;


   //Validación básica para verificar si un campo cualquiera está vacío o es null 
  String? validateTextFieldNullorEmpty(String? value) {
    if (value == null || value.isEmpty || value.trim().isEmpty)
      return 'Campo requerido';
    //if (value.trim().isEmpty) return 'Campo requerido';
    if (value.length < 6) return 'Información incorrecta';

    return null;
  }

  //Validación principal para campos de contraseña válida que el campo no este vacío y tampoco sea null y cumpla las reglas de contraseña según el  requerimiento.
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
}
