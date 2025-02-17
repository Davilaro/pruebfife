import 'package:emart/_pideky/domain/authentication/register/interface/interface_register_gate_way.dart';

class RegisterUseCases {
  final InterfaceRegisterGateWay _iRegister;

  RegisterUseCases(this._iRegister);

  Future<bool> register(String name, String bussinesName, String bussinesAdress,
      String telefono, List<Map<String, String>> infoProveedores) {
    return _iRegister.register(
        name, bussinesName, bussinesAdress, telefono, infoProveedores);
  }
}
