// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es_CO locale. All the
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
  String get localeName => 'es_CO';

  static String m0(direccion) => "Dirección: ${direccion}";

  static String m1(diasEntrega) =>
      "Recuerda que puedes realizar el pedido: ${diasEntrega}";

  static String m2(cantidad) =>
      "El número está incompleto o supera los ${cantidad} caracteres.";

  static String m3(destino) =>
      "Por favor ingresa el código de activación, enviado por ${destino} a tu número seleccionado:";

  static String m4(activate, destino) =>
      "Por favor ingresa el código de ${activate}, enviado por ${destino}";

  static String m5(e) => "No fue posible enviar el mensaje de texto ${e}";

  static String m6(e) =>
      "No fue posible enviar el mensaje, por favor intente nuevamente ${e}";

  static String m7(telefono) => "Número WhatsApp:${telefono}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accept": MessageLookupByLibrary.simpleMessage("Aceptar"),
        "accept_terms_conditions": MessageLookupByLibrary.simpleMessage(
            "Acepto términos y condiciones"),
        "activate": MessageLookupByLibrary.simpleMessage("la activación"),
        "activate_user": MessageLookupByLibrary.simpleMessage("Activar Cuenta"),
        "activate_user_for_buy": MessageLookupByLibrary.simpleMessage(
            "para comprar en Pideky y ver los datos de tu negocio debes activar tu cuenta"),
        "activate_your_user":
            MessageLookupByLibrary.simpleMessage("Activa tu cuenta!"),
        "address": m0,
        "authorize_processing_personal_data":
            MessageLookupByLibrary.simpleMessage(
                "Autorizo el tratamiento de mis datos personales"),
        "bottom_alert_drawer": MessageLookupByLibrary.simpleMessage(
            "¡Recuerda!, si tienes productos agregados al carrito y eliges una nueva sucursal deberás volver a realizar las compras."),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
        "catalog": MessageLookupByLibrary.simpleMessage("Catálogo"),
        "categories_for_you": MessageLookupByLibrary.simpleMessage(
            "Categorias destacadas para tí "),
        "ccup_code_copied":
            MessageLookupByLibrary.simpleMessage("Código CCUP copiado"),
        "cell_phone_number":
            MessageLookupByLibrary.simpleMessage("número de celular"),
        "choose_the_period_to_filter_your_orders":
            MessageLookupByLibrary.simpleMessage(
                "Elige el periodo para filtrar tus pedidos"),
        "code_could_not_be_generated": MessageLookupByLibrary.simpleMessage(
            "No se pudo generar el código"),
        "confirm_country": MessageLookupByLibrary.simpleMessage(
            "Confírmanos el país donde está ubicado tu negocio."),
        "country_confirmation":
            MessageLookupByLibrary.simpleMessage("Confirmación país"),
        "delete_account":
            MessageLookupByLibrary.simpleMessage("Eliminar cuenta"),
        "delivery_days": m1,
        "email_address":
            MessageLookupByLibrary.simpleMessage("correo electrónico"),
        "enter_your_master_code": MessageLookupByLibrary.simpleMessage(
            "Ingresa tu código maestro para realizar la activación manual"),
        "enter_your_nit":
            MessageLookupByLibrary.simpleMessage("Ingresa tu Nit"),
        "error_code":
            MessageLookupByLibrary.simpleMessage("Error obteniendo código"),
        "error_information": MessageLookupByLibrary.simpleMessage(
            "Error al obtener información"),
        "error_validating_the_user":
            MessageLookupByLibrary.simpleMessage("Error al validar el usuario"),
        "filter": MessageLookupByLibrary.simpleMessage("Filtro"),
        "get_active_with_your":
            MessageLookupByLibrary.simpleMessage("Deseas activarte con tu"),
        "history": MessageLookupByLibrary.simpleMessage("Histórico"),
        "home": MessageLookupByLibrary.simpleMessage("Inicio"),
        "i_accept_privacy_policy": MessageLookupByLibrary.simpleMessage(
            "Acepto política de privacidad"),
        "i_accept_processing_policy": MessageLookupByLibrary.simpleMessage(
            "Acepto política de tratamiento de datos"),
        "imperdible": MessageLookupByLibrary.simpleMessage("Imperdibles para "),
        "in_this_section_the_status": MessageLookupByLibrary.simpleMessage(
            "En esta sección encontrarás el estado de tus pedidos pendientes por entregar y podrás hacer seguimiento."),
        "in_this_section_you_will": MessageLookupByLibrary.simpleMessage(
            "En esta sección encontrarás el historial de tus compras en Pideky."),
        "loading_branches":
            MessageLookupByLibrary.simpleMessage("Cargando sucursales"),
        "log_out": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
        "logging_in": MessageLookupByLibrary.simpleMessage("Iniciando sesión"),
        "login_placeholder": MessageLookupByLibrary.simpleMessage(
            "Nit sin dígito de verificación"),
        "manual_activation":
            MessageLookupByLibrary.simpleMessage("Activación manual"),
        "manual_activation_subtitle":
            MessageLookupByLibrary.simpleMessage("la activacion manual"),
        "manual_registration":
            MessageLookupByLibrary.simpleMessage("registro manual"),
        "master_code": MessageLookupByLibrary.simpleMessage("Código maestro"),
        "my_account": MessageLookupByLibrary.simpleMessage("Mi cuenta"),
        "my_business": MessageLookupByLibrary.simpleMessage("Mi Negocio"),
        "my_nequi_payments":
            MessageLookupByLibrary.simpleMessage("Mis Pagos Nequi"),
        "my_orders": MessageLookupByLibrary.simpleMessage("Mis pedidos"),
        "my_statistics":
            MessageLookupByLibrary.simpleMessage("Mis estadísticas"),
        "my_suppliers": MessageLookupByLibrary.simpleMessage("Mis proveedores"),
        "my_vendors": MessageLookupByLibrary.simpleMessage("Mis vendedores"),
        "no_information_to_display": MessageLookupByLibrary.simpleMessage(
            "No hay información para mostrar"),
        "number_incomplete_or_exceeds": m2,
        "or_via_text_message":
            MessageLookupByLibrary.simpleMessage(" o a través de un "),
        "order": MessageLookupByLibrary.simpleMessage("Pedido"),
        "order_detail":
            MessageLookupByLibrary.simpleMessage("Detalle del pedido"),
        "order_pideky": MessageLookupByLibrary.simpleMessage("Orden Pideky"),
        "our_system_has_received": MessageLookupByLibrary.simpleMessage(
            "Nuestro sistema ha recibido tu solicitud."),
        "pideky_account_successfully_registered":
            MessageLookupByLibrary.simpleMessage(
                "Se ha realizado correctamente el registro de tu cuenta Pideky, a continuación selecciona una sucursal para comenzar a realizar pedidos."),
        "please_enter_activation_cod": m3,
        "please_enter_the_code": m4,
        "policies_accepted": MessageLookupByLibrary.simpleMessage(
            "Se debe aceptar las políticas"),
        "policy_and_data_processing": MessageLookupByLibrary.simpleMessage(
            "Política y tratamiento de datos"),
        "price": MessageLookupByLibrary.simpleMessage("Precio"),
        "price_per_sales_unit":
            MessageLookupByLibrary.simpleMessage("Precio por unidad de venta"),
        "product": MessageLookupByLibrary.simpleMessage("Producto"),
        "quantity": MessageLookupByLibrary.simpleMessage("Cantidad"),
        "register": MessageLookupByLibrary.simpleMessage("Registrarse"),
        "registration_successful":
            MessageLookupByLibrary.simpleMessage("¡Registro Exitoso!"),
        "secod_welcome_pideky": MessageLookupByLibrary.simpleMessage(
            "Antes de disfrutar nuestra experiencia de compra debes activarte."),
        "start_date": MessageLookupByLibrary.simpleMessage("Fecha de inicio"),
        "suggested_order":
            MessageLookupByLibrary.simpleMessage("Pedido Sugerido"),
        "terms_conditions":
            MessageLookupByLibrary.simpleMessage("Términos y condiciones"),
        "terms_of_delivery": MessageLookupByLibrary.simpleMessage(
            "Estos productos serán entregados según el itinerario del proveedor"),
        "text_change_of_branch": MessageLookupByLibrary.simpleMessage(
            "¡Has cambiado con éxito la sucursal para la cual realizarás tus compras!"),
        "text_message":
            MessageLookupByLibrary.simpleMessage("mensaje de texto."),
        "text_sms": MessageLookupByLibrary.simpleMessage("SMS"),
        "text_your_email_address":
            MessageLookupByLibrary.simpleMessage("O actívate con tu "),
        "the_email_does_not": MessageLookupByLibrary.simpleMessage(
            "El email no cumple con el formato"),
        "the_nit_entered_is_not_registered": MessageLookupByLibrary.simpleMessage(
            "El NIT ingresado no se encuentra registrado en nuestra base de datos. Por favor revisa que esté bien escrito o contáctanos en "),
        "the_number_is_incorrect": MessageLookupByLibrary.simpleMessage(
            "El número ingresado no corresponde a un número celular."),
        "the_verification_code_incorrect": MessageLookupByLibrary.simpleMessage(
            "El código de verificación es incorrecto,\npor favor compruébelo e intente nuevamente."),
        "unable_send_text_message": m5,
        "unable_send_text_message2": m6,
        "upper_text_drawer": MessageLookupByLibrary.simpleMessage(
            "Elige la sucursal o punto de venta para la cual deseas ver los productos disponibles y realizar tus pedidos."),
        "validating_information":
            MessageLookupByLibrary.simpleMessage("Validando información"),
        "verification_code_cannot_empty": MessageLookupByLibrary.simpleMessage(
            "El código de verificación no puede estar vacío"),
        "version": MessageLookupByLibrary.simpleMessage("Versión"),
        "we_have_a_suggested": MessageLookupByLibrary.simpleMessage(
            "Tenemos un pedido sugerido para ti, para que no olvides ningún producto para tu negocio."),
        "we_validating_code_activate": MessageLookupByLibrary.simpleMessage(
            "Estamos validando el código para activar tu cuenta."),
        "welcome_pideky":
            MessageLookupByLibrary.simpleMessage("¡Bienvenido a Pideky!"),
        "whatsApp": MessageLookupByLibrary.simpleMessage("WhatsApp"),
        "whatsApp_not_installed":
            MessageLookupByLibrary.simpleMessage("WhatsApp no instalado"),
        "whatsApp_number": m7,
        "winners_club":
            MessageLookupByLibrary.simpleMessage("Club de ganadores Pideky"),
        "you_want_to_go":
            MessageLookupByLibrary.simpleMessage("O deseas ir al "),
        "your_order_checked": MessageLookupByLibrary.simpleMessage(
            "Tu pedido está facturado y listo para salir en ruta."),
        "your_order_is_ready": MessageLookupByLibrary.simpleMessage(
            "Tu pedido está en camino, prepárate pare recibirlo.")
      };
}
