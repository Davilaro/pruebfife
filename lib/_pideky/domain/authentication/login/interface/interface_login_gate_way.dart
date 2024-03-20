abstract class InterfaceLoginGateWay {
  Future<int> validationUserAndPassword(String user, String password);
  Future<dynamic> changePassword(String user, String password);
  Future<List<String>> getPhoneNumbers();
  Future<dynamic> validationCode(String code);
  Future<dynamic> getSecurityQuestionCodes();
  Future<dynamic> validationCCUP(String ccup);
  Future<dynamic> loginAsCollaborator(String user);
}
