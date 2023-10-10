abstract class ILogin {
  Future<int> validationUserAndPassword(String user, String password);
  Future<dynamic> changePassword(String user, String password);
  Future<List<String>> getPhoneNumbers();
  Future<dynamic> validationCode(String code);
  Future<dynamic> getSecurityQuestionCodes();
  Future<dynamic> validationNit(String nit);
  Future<dynamic> loginAsCollaborator(String user);
}
