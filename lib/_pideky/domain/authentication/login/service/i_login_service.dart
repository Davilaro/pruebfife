import 'package:emart/_pideky/domain/authentication/login/interface/i_login.dart';

class LoginService {
  final ILogin loginRepository;

  LoginService(this.loginRepository);

  Future<bool> validationUserAndPassword(String user, String password ) {
    return loginRepository.validationUserAndPassword(user, password);
  }
}