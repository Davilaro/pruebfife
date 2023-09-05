import 'package:emart/_pideky/domain/authentication/login/interface/i_login.dart';
import 'package:emart/src/preferences/const.dart';
import 'package:emart/src/preferences/preferencias.dart';
import 'package:http/http.dart' as http;

class LoginApi extends ILogin {
  @override
  Future<bool> validationUserAndPassword(String user, String password) async {
    final prefs = Preferencias();
    try {
      final url;
      url = Uri.parse(Constantes().urlPrincipal + "LogIn/IniciarSesion");
      final response = await http.post(url, body: {
        "Usuario": user,
        "Password": password,
        "Pais": prefs.paisUsuario
      });
      if (response.statusCode == 200) {
        prefs.codigoUnicoPideky = response.body;
        prefs.usurioLogin = 1;
        return true;
      }
    } catch (e) {
      print("error consultando usuario y contraseña $e");
    }
    return false;
  }
}
