import 'package:get/get.dart';

class Messages extends Translations {
  static final appText = _AppText._();

  @override
  Map<String, Map<String, String>> get keys => {
        /**
     * Diccionario intenacionalizacion
     */
        'en': {
          'welcome': 'Welcome',
          'user_text_field_hint': 'User',
          'password_text_field_hint': 'Password',
          'restore_password_text': 'Restore password',
          'login_button_text': 'Login',
          'login_logging_in': 'Logging In',
          'login_dowload_data': 'Downloading information',
          'Text_test': 'Tests',
          'Text_production': 'Production',
          'app_version': 'Version',
          'Text_EnterUser': 'Please enter the user', // Please enter the user
          'Text_EnterPassword': 'Please enter the password',
          'Text_NoSpecialCharacters':
              'No special characters are allowed in the user', // No special characters are allowed in the user
          'Text_ShortUserName':
              'The user name is too short', // The user name is too short'.
          'Text_EnterPassword':
              'Please enter the passwodr', // Please enter the user
          'Text_NoSpecialCharactersPasswors':
              'No special characters are allowed in the password', // No special characters are allowed in the user
          'Text_ShorPassword':
              'The password is too short', // The user name is too short'.
          'Text_CheckCode':
              'Error, check the code', // The user name is too short'.
          'Text_EnterCode': 'Error, enter the code', // Enter code
          'Text_EmptyCode': 'Error, field code is empty', // Enter code
          'alert_title': 'Alert!',
          'not_user_error_message': 'Incorrect user, try again',
          'generic_error_message':
              'An error has ocurred, check your internet network and try again.',
          'save_survey_error': 'An error has occurred. Try again',
          'sync_error_message': 'An error has ocurred.',
          'sync_limited_time_message': 'An error has occurred\nTry again',
          'sync_information': 'Synchronizing\nInformation...',
          'already_registered': "I'm already registered",
          'register': 'Register',
          'haven_not_registered_yet': "You haven't registered yet?",
          'continue_without_registering': 'Continue without registering',
          'add': 'Add',
        },
        'es': {
          'welcome': 'Bienvenido',
          'user_text_field_hint': 'Usuario',
          'password_text_field_hint': 'Contraseña',
          'restore_password_text': 'Recuperar Contraseña',
          'login_button_text': 'Iniciar Sesión',
          'login_logging_in': 'Iniciando Sesión',
          'login_dowload_data': 'Descargando información',
          'Text_test': 'Pruebas',
          'Text_production': 'Produccion',
          'app_version': 'Version',
          'Text_EnterUser':
              'Por favor ingrese el usuario', // Please enter the user
          'Text_EnterPassword': 'Por favor ingrese el password',
          'Text_NoSpecialCharacters':
              'No se permiten caracteres especiales en el usuario', // No special characters are allowed in the user
          'Text_ShortUserName':
              'El nombre de usuario es demasiado corto', // The user name is too short'.
          'Text_EnterPassword':
              'Por favor ingrese la contraseña', // Please enter the user
          'Text_NoSpecialCharactersPasswors':
              'No se permiten caracteres especiales en la cntraseña', // No special characters are allowed in the user
          'Text_ShorPassword':
              'La contraseña es demasiado corta', // The user name is too short'.
          'Text_CheckCode': 'Error, verifíque el cóigo',
          'Text_EnterCode': 'Error, ingrese el codigo', // Enter code
          'Text_EmptyCode': 'Error, el campo codigo esta vacio', // Enter co
          'alert_title': '¡Alerta!',
          'not_user_error_message': 'Usuario incorrecto, intente de nuevo',
          'generic_error_message':
              'Ha ocurrido un error. Revise su conexión de internet e intente nuevamente',
          'save_survey_error': 'Ha ocurrido un error. Intente nuevamente',
          'sync_error_message': 'Ha ocurrido un error.',
          'sync_limited_time_message':
              'Ha ocurrido un error\nVuelva intentarlo',
          'sync_information': 'Sincronizando\nInformación...',
          'already_registered': 'Ya estoy registrado',
          'register': 'Registrarme',
          'haven_not_registered_yet': '¿Aún no te has registrado?',
          'continue_without_registering': 'Continuar sin registrarme',
          'add': 'Agregar',
        }
      };
}

class _AppText {
  _AppText._();
  //action variables
  final addText = 'add'.tr;

  //login text
  final userTextHint = 'user_text_field_hint'.tr;
  final passwordTextHint = 'password_text_field_hint'.tr;
  final restorePasswordText = 'restore_password_text'.tr;
  final loginButtonText = 'login_button_text'.tr;
  final loginDowloadData = 'login_dowload_data'.tr;
  final loginLoggingIn = 'login_logging_in'.tr;
  final textEnterUser = 'Text_EnterUser'.tr;

  final textNoSpecialCharacters = 'Text_NoSpecialCharacters'.tr;
  final textShortUserName = 'Text_ShortUserName'.tr;

  final textEnterPassword = 'Text_EnterPassword'.tr;
  final textNoSpecialCharactersPasswrd = 'Text_NoSpecialCharacters'.tr;
  final textShortPassword = 'Text_ShorPassword'.tr;

  final textCheckCode = 'Text_CheckCode'.tr;
  final textEnterCode = 'Text_EnterCode'.tr;
  final textEmptyCode = 'Text_EmptyCode'.tr;

  final textTest = 'Text_test'.tr;
  final txtProduction = 'Text_production'.tr;
  final appVersion = 'app_version'.tr;

  final alertTitleLbl = 'alert_title'.tr;
  final alertSuccessTitleLbl = 'text_success'.tr;
  final notUserRrrorMessage = 'not_user_error_message'.tr;
  final genericErrorMessage = 'generic_error_message'.tr;
  final saveSurveyError = 'save_survey_error'.tr;
  final syncErrorMessage = 'sync_error_message'.tr;
  final syncLimitedTimeMessage = 'sync_limited_time_message'.tr;
  final syncInformation = 'sync_information'.tr;

  //Welcome text
  final welcomeText = 'welcome'.tr;
  final alreadyRegistered = 'already_registered'.tr;
  final register = 'register'.tr;
  final havenNotRegisteredYet = 'haven_not_registered_yet'.tr;
  final continueWithoutRegistering = 'continue_without_registering'.tr;
}
