import 'package:emart/_pideky/domain/authentication/login/interface/i_login.dart';

class LoginService {
  final ILogin loginRepository;

  LoginService(this.loginRepository);

  Future<int> validationUserAndPassword(String user, String password) {
    return loginRepository.validationUserAndPassword(user, password);
  }

  Future<dynamic> changePassword(String user, String password) {
    return loginRepository.changePassword(user, password);
  }

  Future<List> getPhoneNumbers() {
    return loginRepository.getPhoneNumbers();
  }

  Future<dynamic> validationCode(String code) {
    return loginRepository.validationCode(code);
  }

  Future<dynamic> getSecurityQuestionCodes() {
    return loginRepository.getSecurityQuestionCodes();
  }

  Future<dynamic> loginAsCollaborator(String user) {
    return loginRepository.loginAsCollaborator(user);
  }

  Future<dynamic> validationCCUP(String nit) {
    return loginRepository.validationCCUP(nit);
  }
}
