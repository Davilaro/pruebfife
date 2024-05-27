import 'package:emart/_pideky/infrastructure/customers_prospections_sura/customer_prospections_sura_service.dart';

class CustomerProspectionsSuraUseCases {
  final _interfaceCustomersProspectionsSuraGateWay = CustomerProspectionsSuraService();

  Future sendProspectionRequest(
      {required String nombreCliente,
      required String cedula,
      required String celular}) async {
    return await _interfaceCustomersProspectionsSuraGateWay
        .sendProspectionRequest(cedula: cedula, celular: celular, nombreCliente: nombreCliente);
  }
}