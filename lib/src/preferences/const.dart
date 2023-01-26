import 'package:intl/intl.dart';

const int PRUEBAS = 1;
const int PRODUCCION = 2;

//VARIABLE QUE IDENTIFICA EL TIPO DE AMBIENTE EN EL QUE SE VA A LANZAR
const int APP = PRODUCCION;

String dominioPrincipal = APP == PRUEBAS
    ? 'http://186.147.143.44/'
    : 'https://sfa.grupochocolates.com/';

class Constantes {
  String titulo = APP == PRUEBAS ? "QA" : "PRD";
  String urlPrincipal =
      '$dominioPrincipal${APP == PRUEBAS ? 'ApiPideky/api/' : 'ApiPidekiPrd/api/'}';
  String urlBase = '${dominioPrincipal}SyncPidekySqlitePrd/';
  String urlBaseGenerico = APP == PRUEBAS
      ? 'http://186.147.143.44/SyncPidekySqlitePrd/'
      : 'https://sfa.grupochocolates.com/SyncPidekySqlitePrd/';
  String urlPrincipalToken =
      '$dominioPrincipal${APP == PRUEBAS ? 'ApiPideky/api/' : 'ApiPidekiPRD/api/'}';
  String urlImg = 'http://emartwebapi.celuwebdev.com/logo/';
  // String urlImgProductos =
  //     'https://sfa.grupochocolates.com/WsCatalogo_Pibox/Pideky/';
  String urlImgProductos = '$dominioPrincipal/WsCatalogo_Pibox/Pideky/';
  String contencion = 'https://emartwebapi.celuwebdev.com/ApiPideki/api/';
  String apiPedidodos =
      'https://emartwebapi.celuwebdev.com/WebApiEmartPruebas/api/Pedido';
  String carpeta = '/';
  String nombreApp = 'PIDEKY';

  dynamic formatearFechas(String fecha) {
    DateTime dateTime;
    try {
      DateFormat inputFormat = DateFormat("dd/MM/yyyy");
      dateTime = inputFormat.parse(fecha);
      return dateTime;
    } catch (e) {
      print(e);
    }
  }

  dynamic formatearToDatetime(String fechaT, String tipo) {
    try {
      DateTime fecha = DateTime.parse(fechaT);
      DateTime returnDate = DateTime(
          fecha.year, fecha.month, tipo == 'I' ? fecha.day - 1 : fecha.day + 1);
      return returnDate;
    } catch (e) {
      print(e);
    }
  }
}
