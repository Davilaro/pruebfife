abstract class IRegister {
  Future<bool> register(String name, String bussinesName, String bussinesAdress,
      String telefono, List<Map<String,String>> infoProveedores);
}
