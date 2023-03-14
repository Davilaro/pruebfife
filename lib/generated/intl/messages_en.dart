// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(direccion) => "Address: ${direccion}";

  static String m1(diasEntrega) =>
      "Remember that you can place your order: ${diasEntrega}";

  static String m2(destino) =>
      "Please enter the activation code, sent by ${destino} to your selected number:";

  static String m3(activate, destino) =>
      "Please enter the code from ${activate}, sent by ${destino}";

  static String m4(e) => "Unable to send text message ${e}";

  static String m5(e) =>
      "It was not possible to send the message, please try again ${e}";

  static String m6(telefono) => "WhatsApp Number:${telefono}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accept": MessageLookupByLibrary.simpleMessage("Accept"),
        "accept_terms_conditions": MessageLookupByLibrary.simpleMessage(
            "I accept terms and conditions"),
        "activate": MessageLookupByLibrary.simpleMessage("the activation"),
        "activate_user":
            MessageLookupByLibrary.simpleMessage("Account registration"),
        "activate_user_for_buy": MessageLookupByLibrary.simpleMessage(
            "to buy on Pideky and view your business data you must activate your account"),
        "activate_your_user":
            MessageLookupByLibrary.simpleMessage("Activate your account!"),
        "address": m0,
        "authorize_processing_personal_data":
            MessageLookupByLibrary.simpleMessage(
                "I authorize the processing of my personal data"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "catalog": MessageLookupByLibrary.simpleMessage("Catalog"),
        "categories_for_you": MessageLookupByLibrary.simpleMessage(
            "Featured categories for you "),
        "ccup_code_copied":
            MessageLookupByLibrary.simpleMessage("CCUP code copied"),
        "cell_phone_number":
            MessageLookupByLibrary.simpleMessage("cell phone number"),
        "confirm_country":
            MessageLookupByLibrary.simpleMessage("Confirm country"),
        "country_confirmation":
            MessageLookupByLibrary.simpleMessage("Country confirmation"),
        "delete_account":
            MessageLookupByLibrary.simpleMessage("Delete account"),
        "delivery_days": m1,
        "email_address": MessageLookupByLibrary.simpleMessage("email address"),
        "enter_your_master_code": MessageLookupByLibrary.simpleMessage(
            "Enter your master code for manual activation"),
        "error_code":
            MessageLookupByLibrary.simpleMessage("Error getting code"),
        "error_information":
            MessageLookupByLibrary.simpleMessage("Error obtaining information"),
        "get_active_with_your": MessageLookupByLibrary.simpleMessage(
            "You wish to activate yourself with your"),
        "history": MessageLookupByLibrary.simpleMessage("History"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "i_accept_privacy_policy":
            MessageLookupByLibrary.simpleMessage("I accept privacy policy"),
        "i_accept_processing_policy": MessageLookupByLibrary.simpleMessage(
            "I accept the data processing policy"),
        "imperdible":
            MessageLookupByLibrary.simpleMessage("Not to be missed by "),
        "loading_branches":
            MessageLookupByLibrary.simpleMessage("Loading branches"),
        "log_out": MessageLookupByLibrary.simpleMessage("Log out"),
        "login_placeholder": MessageLookupByLibrary.simpleMessage(
            "Nit without verification digit"),
        "manual_activation":
            MessageLookupByLibrary.simpleMessage("Manual registration"),
        "manual_activation_subtitle":
            MessageLookupByLibrary.simpleMessage("the manual registration"),
        "manual_registration":
            MessageLookupByLibrary.simpleMessage("manual registration"),
        "master_code": MessageLookupByLibrary.simpleMessage("Master code"),
        "my_account": MessageLookupByLibrary.simpleMessage("My account"),
        "my_business": MessageLookupByLibrary.simpleMessage("My Business"),
        "my_nequi_payments":
            MessageLookupByLibrary.simpleMessage("My Nequi Payments"),
        "my_statistics": MessageLookupByLibrary.simpleMessage("My Statistics"),
        "my_suppliers": MessageLookupByLibrary.simpleMessage("My suppliers"),
        "my_vendors": MessageLookupByLibrary.simpleMessage("My vendors"),
        "or_via_text_message": MessageLookupByLibrary.simpleMessage("or via "),
        "pideky_account_successfully_registered":
            MessageLookupByLibrary.simpleMessage(
                "Your Pideky account has been successfully registered, then select a branch to start placing orders."),
        "please_enter_activation_cod": m2,
        "please_enter_the_code": m3,
        "policies_accepted":
            MessageLookupByLibrary.simpleMessage("Policies must be accepted"),
        "policy_and_data_processing":
            MessageLookupByLibrary.simpleMessage("Policy and data processing"),
        "register": MessageLookupByLibrary.simpleMessage("Register"),
        "registration_successful":
            MessageLookupByLibrary.simpleMessage("Registration Successful!"),
        "secod_welcome_pideky": MessageLookupByLibrary.simpleMessage(
            "Before you can enjoy our shopping experience you must become active."),
        "suggested_order":
            MessageLookupByLibrary.simpleMessage("Suggested Order"),
        "terms_conditions":
            MessageLookupByLibrary.simpleMessage("Terms and conditions"),
        "terms_of_delivery": MessageLookupByLibrary.simpleMessage(
            "These products will be delivered according to the supplier\'s itinerary."),
        "text_message": MessageLookupByLibrary.simpleMessage("text message."),
        "text_sms": MessageLookupByLibrary.simpleMessage("SMS"),
        "text_your_email_address": MessageLookupByLibrary.simpleMessage(
            "Or sign up with your email address "),
        "the_email_does_not": MessageLookupByLibrary.simpleMessage(
            "The email does not comply with the format"),
        "the_verification_code_incorrect": MessageLookupByLibrary.simpleMessage(
            "The verification code is incorrect, \nplease check it and try again."),
        "unable_send_text_message": m4,
        "unable_send_text_message2": m5,
        "verification_code_cannot_empty": MessageLookupByLibrary.simpleMessage(
            "The verification code cannot be empty"),
        "version": MessageLookupByLibrary.simpleMessage("Version"),
        "we_validating_code_activate": MessageLookupByLibrary.simpleMessage(
            "We are validating the code to activate your account."),
        "welcome_pideky":
            MessageLookupByLibrary.simpleMessage("Welcome to Pideky!"),
        "whatsApp_number": m6,
        "you_want_to_go":
            MessageLookupByLibrary.simpleMessage("Or do you want to go to the ")
      };
}
