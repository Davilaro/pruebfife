import 'package:emart/_pideky/infrastructure/customers_prospection/customer_prospection_service.dart';

class CustomerProspectionsUseCases {
  final _interfaceCustomersProspectionsGateWay = CustomerProspectionsService();

  Future sendProspectionRequest(
      {required String nombreCliente,
      required String cedula,
      required String celular,
      required bool nevera}) async {
    return await _interfaceCustomersProspectionsGateWay
        .sendProspectionRequest(cedula: cedula, celular: celular, nevera: nevera, nombreCliente: nombreCliente);
  }
}
