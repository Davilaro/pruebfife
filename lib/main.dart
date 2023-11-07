import 'package:emart/_pideky/presentation/confirmacion_pais/view_model/confirmacion_pais_view_model.dart';
import 'package:emart/generated/l10n.dart';
import 'package:emart/initial_bindings.dart';
import 'package:emart/src/notificaciones/push_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'src/preferences/preferencias.dart';
import 'src/provider/carrito_provider.dart';
import 'src/provider/datos_listas_provider.dart';
import 'src/provider/opciones_app_bart.dart';
import 'src/provider/permisos_handler.dart';
import 'src/routes/rutas.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  InitialBindings();
  
  final prefs = new Preferencias();
  await prefs.initPrefs();
  final viewModelConfirmarPais = Get.put(ConfirmacionPaisViewModel());
  //injectDependencies();
  //_validarKeyUXCam();
  viewModelConfirmarPais.confirmarPais(prefs.paisUsuario, false);
  await PushNotificationServer.initializeApp();
  Permisos.permisos.solicitarPermisos();
  await firebase_core.Firebase.initializeApp();
  runApp(MyApp());
}

// _validarKeyUXCam() async {
//   FlutterUxcam.optIntoSchematicRecordings();
//   if (Constantes().titulo == 'QA') {
//     FlutterUxcam.startWithKey("s7xvg23hmx7ttcv");
//   } else {
//     FlutterUxcam.startWithKey("l0uak7nx63mtp1i");
//   }
//   FlutterUxcam.setAutomaticScreenNameTagging(false);
//   await PushNotificationServer.initializeApp();
// }

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  
  MaterialColor white = const MaterialColor(
    0xFFEEEEEE,
    const <int, Color>{
      50: const Color(0xFFEEEEEE),
      100: const Color(0xFFEEEEEE),
      200: const Color(0xFFEEEEEE),
      300: const Color(0xFFEEEEEE),
      400: const Color(0xFFEEEEEE),
      500: const Color(0xFFEEEEEE),
      600: const Color(0xFFEEEEEE),
      700: const Color(0xFFEEEEEE),
      800: const Color(0xFFEEEEEE),
      900: const Color(0xFFEEEEEE),
    },
  );

  @override
  void initState() {
    
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => CarroModelo(),
          ),
          ChangeNotifierProvider(create: (_) => OpcionesBard()),
          ChangeNotifierProvider(create: (_) => DatosListas()),
        ],
        child: OverlaySupport.global(
          child: GetMaterialApp(
            initialBinding: InitialBindings(),
            locale: Locale('es', 'CO'),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              S.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'RoundedMplus1c',
              brightness: Brightness.light,
              primarySwatch: white,
              textSelectionTheme:
                  TextSelectionThemeData(cursorColor: Colors.black),
            ),
            title: 'Pideky',
            initialRoute: 'splash',
            routes: getRutas(),
          ),
        ));
  }
}
