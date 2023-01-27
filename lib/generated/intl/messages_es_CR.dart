// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es_CR locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es_CR';

  static String m0(destino) =>
      "Por favor ingresa el código de registro, enviado por ${destino} a tu número seleccionado:";

  static String m1(activate, destino) =>
      "Por favor ingresa el código de ${activate}, enviado por ${destino}";

  static String m2(e) => "No fue posible enviar el mensaje de texto ${e}";

  static String m3(e) =>
      "No fue posible enviar el mensaje, por favor intente nuevamente ${e}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accept_terms_conditions": MessageLookupByLibrary.simpleMessage(
            "Acepto términos y condiciones"),
        "activate": MessageLookupByLibrary.simpleMessage("el registro"),
        "activate_user":
            MessageLookupByLibrary.simpleMessage("Registro de cuenta"),
        "activate_user_for_buy": MessageLookupByLibrary.simpleMessage(
            "para comprar en Pideky y ver los datos de tu negocio debes tener una cuenta activa"),
        "activate_your_user":
            MessageLookupByLibrary.simpleMessage("Registrate!"),
        "authorize_processing_personal_data":
            MessageLookupByLibrary.simpleMessage(
                "Autorizo el tratamiento de mis datos personales"),
        "catalog": MessageLookupByLibrary.simpleMessage("Categorías"),
        "categories_for_you":
            MessageLookupByLibrary.simpleMessage("categorias destacadas "),
        "cell_phone_number":
            MessageLookupByLibrary.simpleMessage("número de celular"),
        "email_address":
            MessageLookupByLibrary.simpleMessage("correo electrónico."),
        "enter_your_master_code": MessageLookupByLibrary.simpleMessage(
            "Ingresa tu código maestro para realizar el registro manual"),
        "error_code":
            MessageLookupByLibrary.simpleMessage("Error obteniendo código"),
        "error_information": MessageLookupByLibrary.simpleMessage(
            "Error al obtener información"),
        "get_active_with_your":
            MessageLookupByLibrary.simpleMessage("Deseas registrarte con tu"),
        "history": MessageLookupByLibrary.simpleMessage("Histórico"),
        "home": MessageLookupByLibrary.simpleMessage("Inicio"),
        "i_accept_privacy_policy": MessageLookupByLibrary.simpleMessage(
            "Acepto política de privacidad"),
        "i_accept_processing_policy": MessageLookupByLibrary.simpleMessage(
            "Acepto política de tratamiento de datos"),
        "imperdible": MessageLookupByLibrary.simpleMessage("Imperdibles para "),
        "loading_branches":
            MessageLookupByLibrary.simpleMessage("Cargando sucursales"),
        "login_placeholder":
            MessageLookupByLibrary.simpleMessage("Número de identificación"),
        "manual_activation":
            MessageLookupByLibrary.simpleMessage("Registro manual"),
        "manual_activation_subtitle":
            MessageLookupByLibrary.simpleMessage("el registro manual"),
        "manual_registration":
            MessageLookupByLibrary.simpleMessage("registro manual"),
        "master_code": MessageLookupByLibrary.simpleMessage("Código maestro"),
        "my_business": MessageLookupByLibrary.simpleMessage("Mi Negocio"),
        "or_via_text_message":
            MessageLookupByLibrary.simpleMessage(" o a través de un "),
        "pideky_account_successfully_registered":
            MessageLookupByLibrary.simpleMessage(
                "Se ha realizado correctamente el registro de tu cuenta Pideky, a continuación selecciona una sucursal para comenzar a realizar pedidos."),
        "please_enter_activation_cod": m0,
        "please_enter_the_code": m1,
        "policies_accepted": MessageLookupByLibrary.simpleMessage(
            "Se debe aceptar las políticas"),
        "register": MessageLookupByLibrary.simpleMessage("Registrarse"),
        "registration_successful":
            MessageLookupByLibrary.simpleMessage("¡Registro Exitoso!"),
        "secod_welcome_pideky": MessageLookupByLibrary.simpleMessage(
            "Antes de disfrutar nuestra experiencia de compra debes registrarte."),
        "suggested_order":
            MessageLookupByLibrary.simpleMessage("Pedido Sugerido"),
        "terms_of_delivery": MessageLookupByLibrary.simpleMessage(
            "Tu pedido sera entregado en tu día normal de entrega"),
        "text_message":
            MessageLookupByLibrary.simpleMessage("mensaje de texto."),
        "text_sms": MessageLookupByLibrary.simpleMessage("SMS"),
        "text_your_email_address":
            MessageLookupByLibrary.simpleMessage("O actívate con tu "),
        "the_email_does_not": MessageLookupByLibrary.simpleMessage(
            "El email no cumple con el formato"),
        "the_verification_code_incorrect": MessageLookupByLibrary.simpleMessage(
            "El código de verificación es incorrecto,\npor favor compruébelo e intente nuevamente."),
        "unable_send_text_message": m2,
        "unable_send_text_message2": m3,
        "verification_code_cannot_empty": MessageLookupByLibrary.simpleMessage(
            "El código de verificación no puede estar vacío"),
        "we_validating_code_activate": MessageLookupByLibrary.simpleMessage(
            "Estamos validando el código para registrar tu cuenta."),
        "welcome_pideky":
            MessageLookupByLibrary.simpleMessage("¡Bienvenido a Pideky!"),
        "you_want_to_go":
            MessageLookupByLibrary.simpleMessage("O deseas ir al ")
      };
}
