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

  /// `Not to be missed by `
  String get imperdible {
    return Intl.message(
      'Not to be missed by ',
      name: 'imperdible',
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

  /// `Welcome to Pideky!`
  String get welcome_pideky {
    return Intl.message(
      'Welcome to Pideky!',
      name: 'welcome_pideky',
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

  /// `You wish to activate yourself with your`
  String get get_active_with_your {
    return Intl.message(
      'You wish to activate yourself with your',
      name: 'get_active_with_your',
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

  /// `or via `
  String get or_via_text_message {
    return Intl.message(
      'or via ',
      name: 'or_via_text_message',
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

  /// `Or sign up with your email address `
  String get text_your_email_address {
    return Intl.message(
      'Or sign up with your email address ',
      name: 'text_your_email_address',
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

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
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

  /// `Enter your master code for manual activation`
  String get enter_your_master_code {
    return Intl.message(
      'Enter your master code for manual activation',
      name: 'enter_your_master_code',
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

  /// `Error getting code`
  String get error_code {
    return Intl.message(
      'Error getting code',
      name: 'error_code',
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
  String get activate_user {
    return Intl.message(
      'Activate your account!',
      name: 'activate_user',
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
