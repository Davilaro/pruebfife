import 'dart:developer';
import 'package:emart/_pideky/domain/customer_prospection_sura/interface/interface_customer_prospection_sura.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/utils/util.dart';
import 'package:http/http.dart' as http;

class CustomerProspectionsSuraService implements InterfaceCustomerProspectionSuraGateWay {
  final prefs = Preferencias();
  @override
  Future sendProspectionRequest(
      {required String cedula,
      required String celular,
      //required bool nevera,
      required String nombreCliente}) async {
    try {
      final url;
      final requestBody = {
            "NombreCliente": nombreCliente,
            "Cedula": cedula,
            "Celular": celular,
        //  "Nevera": '${nevera == true ? 1 : 0}',
            "CCUP": prefs.codigoUnicoPideky,
            "Sucursal": '${toInt(prefs.sucursal)}'
          };
      url = Uri.parse(
          Constantes().urlPrincipal + "Encuestas/clienteProspectoSura");
      final response = await http.post(url,
          body: requestBody);
          log('response ${response.body}');
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Error al enviar la solicitud de prospección');
      }
    } catch (e) {
      log('Error al enviar la solicitud de prospección $e');
      return false;
    }
  }
}
