import 'dart:convert';

import 'package:emart/_pideky/domain/authentication/login/interface/i_login.dart';
import 'package:emart/_pideky/domain/authentication/login/models/security_question_model.dart';
import 'package:emart/_pideky/presentation/confirmacion_pais/view_model/confirmacion_pais_view_model.dart';
import 'package:emart/src/modelos/validar.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:emart/src/utils/util.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginApi implements ILogin {
  @override
  Future<int> validationUserAndPassword(String user, String password) async {
    final prefs = Preferencias();
    final confirmacionViewModel = Get.find<ConfirmacionPaisViewModel>();

    try {
      final url;
      url = Uri.parse(Constantes().urlPrincipal + "LogIn/IniciarSesion");
      final response = await http.post(url, body: {
        "Usuario": user,
        "Password": password,
        "Pais": prefs.paisUsuario
      });
      var data = jsonDecode(response.body);
      print("data loguin  $data");
      if (response.statusCode == 200 &&
          data["Actualizar"] != null &&
          data['CCUP'] != "1" &&
          data['CCUP'] != "2") {
        prefs.codigoUnicoPideky = data["CCUP"];
        confirmacionViewModel.confirmarPais(prefs.paisUsuario, true);
        return toInt(data["Actualizar"]);
      } else {
        if (data['CCUP'] != "1" && data['CCUP'] != "2" && data['CCUP'] != "3") {
          return -1;
        } else {
          return toInt(data['CCUP']);
        }
      }
    } catch (e) {
      print("error consultando usuario y contraseña $e");
      return -1;
    }
  }

  @override
  Future<dynamic> changePassword(String user, String password) async {
    final prefs = Preferencias();
    var jsonRequest = {
      "Usuario": user,
      "Password": password,
      "Pais": prefs.paisUsuario
    };
    try {
      final url;
      url = Uri.parse(Constantes().urlPrincipal + "LogIn/ActualizarPassword");
      final response = await http.post(url, body: jsonRequest);
      var responseDecode = jsonDecode(response.body);
      if (response.statusCode == 200 &&
          responseDecode == prefs.codigoUnicoPideky) {
        return true;
      } else if (responseDecode == "Por favor validar con otro Nit") {
        return responseDecode;
      } else {
        return false;
      }
    } catch (e) {
      print("error cambiando password$e");
      return false;
    }
  }

  @override
  Future<List<String>> getPhoneNumbers() async {
    final prefs = Preferencias();
    var jsonRequest = {"CCUP": prefs.codigoUnicoPideky};

    try {
      final url;
      url = Uri.parse(Constantes().urlPrincipal + "LogIn/Telefonos");
      final response = await http.post(url, body: jsonRequest);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> phoneNumbersJson = jsonResponse["Telefonos"];
        return phoneNumbersJson.map((e) => e.toString()).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("error consultando telefonos $e");
      return [];
    }
  }

  @override
  Future<dynamic> validationCode(String code) async {
    final prefs = Preferencias();
    try {
      final url;

      url = Uri.parse(Constantes().urlPrincipal + 'LogIn/ValidarCodigo');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "CCUP": prefs.codigoUnicoPideky,
          "CodigoVerficacion": '$code',
        }),
      );

      if (response.statusCode == 200) {
        return Validar.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      print("error validando codigo $e");
      return null;
    }
  }

  @override
  Future<dynamic> getSecurityQuestionCodes() async {
    final prefs = Preferencias();
    try {
      final url;

      url = Uri.parse(Constantes().urlPrincipal + 'LogIn/PreguntaSeguridad');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "CCUP": prefs.codigoUnicoPideky,
        }),
      );
      var decodeData = jsonDecode(response.body);

      if (response.statusCode == 200 && decodeData["CodigoCorrecto"] != "") {
        return SecurityQuestionModel.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      print("error validando codigo de seguridad$e");
      return null;
    }
  }

  @override
  Future<dynamic> loginAsCollaborator(String user) async {
    final prefs = Preferencias();
    try {
      final url;

      url = Uri.parse(
          Constantes().urlPrincipal + 'LogIn/IniciarSesionColaboradores');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "Codigo": user,
        }),
      );
      if (response.statusCode == 200 &&
          jsonDecode(response.body) != "Código invalido") {
        prefs.typeCollaborator = jsonDecode(response.body);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("error validando el codigo de colaborador $e");
      return false;
    }
  }

  @override
  Future validationNit(String nit) async {
    final prefs = Preferencias();
    try {
      final url;

      url = Uri.parse(Constantes().urlPrincipal + 'LogIn/ValidarNit');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "Nit": nit,
          "Pais": prefs.paisUsuario,
        }),
      );
      var resDecode = jsonDecode(response.body);

      if (resDecode == "Nit invalido") {
        return resDecode;
      } else if (resDecode == "Por favor validar con otro Nit") {
        return resDecode;
      } else {
        prefs.codigoUnicoPideky = resDecode;
        return true;
      }
    } catch (e) {
      print("error validando el nit $e");
      return false;
    }
  }
}
