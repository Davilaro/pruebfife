abstract class InterfaceCustomerProspectionGateWay {
  Future<dynamic> sendProspectionRequest(
      {required String nombreCliente,
      required String cedula,
      required String celular,
      required bool nevera});
}
