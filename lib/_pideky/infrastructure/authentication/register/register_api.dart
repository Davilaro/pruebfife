import 'dart:convert';
import 'package:emart/_pideky/domain/authentication/register/interface/i_register.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:http/http.dart' as http;

class RegisterApi extends IRegister {
  @override
  Future<bool> register(String name, String bussinesName, String bussinesAdress,
      String telefono, List<Map<String, String>> infoProveedores) async {
    try {
      final url =
          Uri.parse(Constantes().urlPrincipal + "Encuestas/clienteProspecto");
      final requestJson = {
        "RazonSocial": bussinesName,
        "Nombre": name,
        "Direccion": bussinesAdress,
        "Proveedores": infoProveedores,
        "Telefono": telefono
      };
      final requestBody = jsonEncode(requestJson);

      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: requestBody);

      if (response.statusCode == 200) {
        print("Se registró el usuario");
        return true;
      } else {
        print(
            "No se pudo registrar el usuario. Código de estado: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error al registrar el usuario $e");
      return false;
    }
  }
}
