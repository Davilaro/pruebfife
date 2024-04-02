import 'package:emart/_pideky/presentation/country_confirmation/view/country_confirmation_page.dart';
import 'package:emart/_pideky/presentation/suggested_order/view/suggested_order_page.dart';
import 'package:emart/_pideky/presentation/product/view/detalle_producto_compra.dart';
import 'package:emart/src/pages/login/widgets/comprobar_sesion.dart';
import 'package:emart/src/pages/principal_page/widgets/lista_empresas_emart.dart';
import 'package:emart/src/pages/login/widgets/lista_sucursales.dart';
import 'package:emart/src/pages/login/login.dart';
import 'package:emart/src/pages/principal_page/principal_page.dart';
import 'package:emart/src/pages/principal_page/tab_opciones.dart';
import 'package:emart/src/splash/splash_principal.dart';
import 'package:flutter/cupertino.dart';

Map<String, WidgetBuilder> getRutas() {
  return <String, WidgetBuilder>{
    'inicio': (_) => ComprobarSesion(),
    'login': (_) => Login(),
    'listaEmpresas': (_) => ListaEmpresasEmart(),
    'listaSucursale': (_) => ListaSucursales(),
    'tab_opciones': (_) => TabOpciones(),
    'splash': (_) => Splash(),
    'confirmar_pais': (_) => CountryConfirmationPage(),
    'detalle_compra_producto': (_) => CambiarDetalleCompra(cambioVista: 1,),
    'inicio_compra': (_) => PrincipalPage(),
    'pedido_sugerido': (_) => SuggestedOrderPage(),
  };
}
