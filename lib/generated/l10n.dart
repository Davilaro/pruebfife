// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `I accept terms and conditions`
  String get accept_terms_conditions {
    return Intl.message(
      'I accept terms and conditions',
      name: 'accept_terms_conditions',
      desc: '',
      args: [],
    );
  }

  /// `the activation`
  String get activate {
    return Intl.message(
      'the activation',
      name: 'activate',
      desc: '',
      args: [],
    );
  }

  /// `Account registration`
  String get activate_user {
    return Intl.message(
      'Account registration',
      name: 'activate_user',
      desc: '',
      args: [],
    );
  }

  /// `to buy on Pideky and view your business data you must activate your account`
  String get activate_user_for_buy {
    return Intl.message(
      'to buy on Pideky and view your business data you must activate your account',
      name: 'activate_user_for_buy',
      desc: '',
      args: [],
    );
  }

  /// `Activate your account!`
  String get activate_your_user {
    return Intl.message(
      'Activate your account!',
      name: 'activate_your_user',
      desc: '',
      args: [],
    );
  }

  /// `I authorize the processing of my personal data`
  String get authorize_processing_personal_data {
    return Intl.message(
      'I authorize the processing of my personal data',
      name: 'authorize_processing_personal_data',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `Address: {direccion}`
  String address(Object direccion) {
    return Intl.message(
      'Address: $direccion',
      name: 'address',
      desc: '',
      args: [direccion],
    );
  }

  /// `Remember! if you have products added to your cart and you choose a new branch, you will have to shop again.`
  String get bottom_alert_drawer {
    return Intl.message(
      'Remember! if you have products added to your cart and you choose a new branch, you will have to shop again.',
      name: 'bottom_alert_drawer',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm the country where your business is located.`
  String get confirm_country {
    return Intl.message(
      'Please confirm the country where your business is located.',
      name: 'confirm_country',
      desc: '',
      args: [],
    );
  }

  /// `Country confirmation`
  String get country_confirmation {
    return Intl.message(
      'Country confirmation',
      name: 'country_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Catalog`
  String get catalog {
    return Intl.message(
      'Catalog',
      name: 'catalog',
      desc: '',
      args: [],
    );
  }

  /// `Featured categories for you `
  String get categories_for_you {
    return Intl.message(
      'Featured categories for you ',
      name: 'categories_for_you',
      desc: '',
      args: [],
    );
  }

  /// `cell phone number`
  String get cell_phone_number {
    return Intl.message(
      'cell phone number',
      name: 'cell_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `CCUP code copied`
  String get ccup_code_copied {
    return Intl.message(
      'CCUP code copied',
      name: 'ccup_code_copied',
      desc: '',
      args: [],
    );
  }

  /// `Code could not be generated`
  String get code_could_not_be_generated {
    return Intl.message(
      'Code could not be generated',
      name: 'code_could_not_be_generated',
      desc: '',
      args: [],
    );
  }

  /// `Remember that you can place your order: {diasEntrega}`
  String delivery_days(Object diasEntrega) {
    return Intl.message(
      'Remember that you can place your order: $diasEntrega',
      name: 'delivery_days',
      desc: '',
      args: [diasEntrega],
    );
  }

  /// `Delete account`
  String get delete_account {
    return Intl.message(
      'Delete account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `email address`
  String get email_address {
    return Intl.message(
      'email address',
      name: 'email_address',
      desc: '',
      args: [],
    );
  }

  /// `Enter your master code for manual activation`
  String get enter_your_master_code {
    return Intl.message(
      'Enter your master code for manual activation',
      name: 'enter_your_master_code',
      desc: '',
      args: [],
    );
  }

  /// `Error getting code`
  String get error_code {
    return Intl.message(
      'Error getting code',
      name: 'error_code',
      desc: '',
      args: [],
    );
  }

  /// `Error obtaining information`
  String get error_information {
    return Intl.message(
      'Error obtaining information',
      name: 'error_information',
      desc: '',
      args: [],
    );
  }

  /// `Error validating the user`
  String get error_validating_the_user {
    return Intl.message(
      'Error validating the user',
      name: 'error_validating_the_user',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Nit`
  String get enter_your_nit {
    return Intl.message(
      'Enter your Nit',
      name: 'enter_your_nit',
      desc: '',
      args: [],
    );
  }

  /// `You wish to activate yourself with your`
  String get get_active_with_your {
    return Intl.message(
      'You wish to activate yourself with your',
      name: 'get_active_with_your',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `I accept privacy policy`
  String get i_accept_privacy_policy {
    return Intl.message(
      'I accept privacy policy',
      name: 'i_accept_privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `I accept the data processing policy`
  String get i_accept_processing_policy {
    return Intl.message(
      'I accept the data processing policy',
      name: 'i_accept_processing_policy',
      desc: '',
      args: [],
    );
  }

  /// `Not to be missed by `
  String get imperdible {
    return Intl.message(
      'Not to be missed by ',
      name: 'imperdible',
      desc: '',
      args: [],
    );
  }

  /// `In this section you will find the history of your purchases in Pideky.`
  String get in_this_section_you_will {
    return Intl.message(
      'In this section you will find the history of your purchases in Pideky.',
      name: 'in_this_section_you_will',
      desc: '',
      args: [],
    );
  }

  /// `In this section you will find the status of your pending orders, and you will be able to track them.`
  String get in_this_section_the_status {
    return Intl.message(
      'In this section you will find the status of your pending orders, and you will be able to track them.',
      name: 'in_this_section_the_status',
      desc: '',
      args: [],
    );
  }

  /// `Loading branches`
  String get loading_branches {
    return Intl.message(
      'Loading branches',
      name: 'loading_branches',
      desc: '',
      args: [],
    );
  }

  /// `Nit without verification digit`
  String get login_placeholder {
    return Intl.message(
      'Nit without verification digit',
      name: 'login_placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get log_out {
    return Intl.message(
      'Log out',
      name: 'log_out',
      desc: '',
      args: [],
    );
  }

  /// `Logging in`
  String get logging_in {
    return Intl.message(
      'Logging in',
      name: 'logging_in',
      desc: '',
      args: [],
    );
  }

  /// `Manual registration`
  String get manual_activation {
    return Intl.message(
      'Manual registration',
      name: 'manual_activation',
      desc: '',
      args: [],
    );
  }

  /// `the manual registration`
  String get manual_activation_subtitle {
    return Intl.message(
      'the manual registration',
      name: 'manual_activation_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `manual registration`
  String get manual_registration {
    return Intl.message(
      'manual registration',
      name: 'manual_registration',
      desc: '',
      args: [],
    );
  }

  /// `Master code`
  String get master_code {
    return Intl.message(
      'Master code',
      name: 'master_code',
      desc: '',
      args: [],
    );
  }

  /// `My Business`
  String get my_business {
    return Intl.message(
      'My Business',
      name: 'my_business',
      desc: '',
      args: [],
    );
  }

  /// `My account`
  String get my_account {
    return Intl.message(
      'My account',
      name: 'my_account',
      desc: '',
      args: [],
    );
  }

  /// `My suppliers`
  String get my_suppliers {
    return Intl.message(
      'My suppliers',
      name: 'my_suppliers',
      desc: '',
      args: [],
    );
  }

  /// `My vendors`
  String get my_vendors {
    return Intl.message(
      'My vendors',
      name: 'my_vendors',
      desc: '',
      args: [],
    );
  }

  /// `My Statistics`
  String get my_statistics {
    return Intl.message(
      'My Statistics',
      name: 'my_statistics',
      desc: '',
      args: [],
    );
  }

  /// `My Nequi Payments`
  String get my_nequi_payments {
    return Intl.message(
      'My Nequi Payments',
      name: 'my_nequi_payments',
      desc: '',
      args: [],
    );
  }

  /// `My orders`
  String get my_orders {
    return Intl.message(
      'My orders',
      name: 'my_orders',
      desc: '',
      args: [],
    );
  }

  /// `or via `
  String get or_via_text_message {
    return Intl.message(
      'or via ',
      name: 'or_via_text_message',
      desc: '',
      args: [],
    );
  }

  /// `Your Pideky account has been successfully registered, then select a branch to start placing orders.`
  String get pideky_account_successfully_registered {
    return Intl.message(
      'Your Pideky account has been successfully registered, then select a branch to start placing orders.',
      name: 'pideky_account_successfully_registered',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the activation code, sent by {destino} to your selected number:`
  String please_enter_activation_cod(Object destino) {
    return Intl.message(
      'Please enter the activation code, sent by $destino to your selected number:',
      name: 'please_enter_activation_cod',
      desc: '',
      args: [destino],
    );
  }

  /// `Please enter the code from {activate}, sent by {destino}`
  String please_enter_the_code(Object activate, Object destino) {
    return Intl.message(
      'Please enter the code from $activate, sent by $destino',
      name: 'please_enter_the_code',
      desc: '',
      args: [activate, destino],
    );
  }

  /// `Policies must be accepted`
  String get policies_accepted {
    return Intl.message(
      'Policies must be accepted',
      name: 'policies_accepted',
      desc: '',
      args: [],
    );
  }

  /// `Policy and data processing`
  String get policy_and_data_processing {
    return Intl.message(
      'Policy and data processing',
      name: 'policy_and_data_processing',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Registration Successful!`
  String get registration_successful {
    return Intl.message(
      'Registration Successful!',
      name: 'registration_successful',
      desc: '',
      args: [],
    );
  }

  /// `Before you can enjoy our shopping experience you must become active.`
  String get secod_welcome_pideky {
    return Intl.message(
      'Before you can enjoy our shopping experience you must become active.',
      name: 'secod_welcome_pideky',
      desc: '',
      args: [],
    );
  }

  /// `Suggested Order`
  String get suggested_order {
    return Intl.message(
      'Suggested Order',
      name: 'suggested_order',
      desc: '',
      args: [],
    );
  }

  /// `These products will be delivered according to the supplier's itinerary.`
  String get terms_of_delivery {
    return Intl.message(
      'These products will be delivered according to the supplier\'s itinerary.',
      name: 'terms_of_delivery',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully changed the branch for which you will place your orders!`
  String get text_change_of_branch {
    return Intl.message(
      'You have successfully changed the branch for which you will place your orders!',
      name: 'text_change_of_branch',
      desc: '',
      args: [],
    );
  }

  /// `text message.`
  String get text_message {
    return Intl.message(
      'text message.',
      name: 'text_message',
      desc: '',
      args: [],
    );
  }

  /// `SMS`
  String get text_sms {
    return Intl.message(
      'SMS',
      name: 'text_sms',
      desc: '',
      args: [],
    );
  }

  /// `Or sign up with your email address `
  String get text_your_email_address {
    return Intl.message(
      'Or sign up with your email address ',
      name: 'text_your_email_address',
      desc: '',
      args: [],
    );
  }

  /// `The email does not comply with the format`
  String get the_email_does_not {
    return Intl.message(
      'The email does not comply with the format',
      name: 'the_email_does_not',
      desc: '',
      args: [],
    );
  }

  /// `The verification code is incorrect, \nplease check it and try again.`
  String get the_verification_code_incorrect {
    return Intl.message(
      'The verification code is incorrect, \nplease check it and try again.',
      name: 'the_verification_code_incorrect',
      desc: '',
      args: [],
    );
  }

  /// `Terms and conditions`
  String get terms_conditions {
    return Intl.message(
      'Terms and conditions',
      name: 'terms_conditions',
      desc: '',
      args: [],
    );
  }

  /// `The NIT entered is not registered in our database. Please check that it is spelled correctly or contact us on `
  String get the_nit_entered_is_not_registered {
    return Intl.message(
      'The NIT entered is not registered in our database. Please check that it is spelled correctly or contact us on ',
      name: 'the_nit_entered_is_not_registered',
      desc: '',
      args: [],
    );
  }

  /// `Unable to send text message {e}`
  String unable_send_text_message(Object e) {
    return Intl.message(
      'Unable to send text message $e',
      name: 'unable_send_text_message',
      desc: '',
      args: [e],
    );
  }

  /// `It was not possible to send the message, please try again {e}`
  String unable_send_text_message2(Object e) {
    return Intl.message(
      'It was not possible to send the message, please try again $e',
      name: 'unable_send_text_message2',
      desc: '',
      args: [e],
    );
  }

  /// `Choose the branch or point of sale for which you wish to see the products available and place your orders.`
  String get upper_text_drawer {
    return Intl.message(
      'Choose the branch or point of sale for which you wish to see the products available and place your orders.',
      name: 'upper_text_drawer',
      desc: '',
      args: [],
    );
  }

  /// `The verification code cannot be empty`
  String get verification_code_cannot_empty {
    return Intl.message(
      'The verification code cannot be empty',
      name: 'verification_code_cannot_empty',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Validating information`
  String get validating_information {
    return Intl.message(
      'Validating information',
      name: 'validating_information',
      desc: '',
      args: [],
    );
  }

  /// `We are validating the code to activate your account.`
  String get we_validating_code_activate {
    return Intl.message(
      'We are validating the code to activate your account.',
      name: 'we_validating_code_activate',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Pideky!`
  String get welcome_pideky {
    return Intl.message(
      'Welcome to Pideky!',
      name: 'welcome_pideky',
      desc: '',
      args: [],
    );
  }

  /// `WhatsApp Number:{telefono}`
  String whatsApp_number(Object telefono) {
    return Intl.message(
      'WhatsApp Number:$telefono',
      name: 'whatsApp_number',
      desc: '',
      args: [telefono],
    );
  }

  /// `WhatsApp`
  String get whatsApp {
    return Intl.message(
      'WhatsApp',
      name: 'whatsApp',
      desc: '',
      args: [],
    );
  }

  /// `WhatsApp not installed`
  String get whatsApp_not_installed {
    return Intl.message(
      'WhatsApp not installed',
      name: 'whatsApp_not_installed',
      desc: '',
      args: [],
    );
  }

  /// `We have a suggested order for you, so that you don't forget any product for your business.`
  String get we_have_a_suggested {
    return Intl.message(
      'We have a suggested order for you, so that you don\'t forget any product for your business.',
      name: 'we_have_a_suggested',
      desc: '',
      args: [],
    );
  }

  /// `Or do you want to go to the `
  String get you_want_to_go {
    return Intl.message(
      'Or do you want to go to the ',
      name: 'you_want_to_go',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es', countryCode: 'CO'),
      Locale.fromSubtags(languageCode: 'es', countryCode: 'CR'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
