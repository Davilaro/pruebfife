import 'package:emart/_pideky/domain/authentication/register/interface/i_register.dart';

class RegisterService {
  final IRegister _iRegister;

  RegisterService(this._iRegister);

  Future<bool> register(String name, String bussinesName, String bussinesAdress,
      String telefono, List<Map<String, String>> infoProveedores) {
    return _iRegister.register(
        name, bussinesName, bussinesAdress, telefono, infoProveedores);
  }
}
