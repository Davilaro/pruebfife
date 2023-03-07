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

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Confirm country`
  String get confirm_country {
    return Intl.message(
      'Confirm country',
      name: 'confirm_country',
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

  /// `Remember that you can place your order: {diasEntrega}`
  String delivery_days(Object diasEntrega) {
    return Intl.message(
      'Remember that you can place your order: $diasEntrega',
      name: 'delivery_days',
      desc: '',
      args: [diasEntrega],
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

  /// `The verification code cannot be empty`
  String get verification_code_cannot_empty {
    return Intl.message(
      'The verification code cannot be empty',
      name: 'verification_code_cannot_empty',
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
