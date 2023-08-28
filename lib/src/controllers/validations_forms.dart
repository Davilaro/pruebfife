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
  RxBool userInteracted     = false.obs;

  final passwordError = 'No es una contraseña válida'.obs;

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
}
