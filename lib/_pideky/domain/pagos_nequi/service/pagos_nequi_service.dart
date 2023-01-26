import 'package:emart/_pideky/domain/pagos_nequi/interface/i_mis_pagos_nequi.dart';
import 'package:emart/_pideky/domain/pagos_nequi/model/pagos_nequi_model.dart';

class PagosNequiService {
  final IMisPagosNequi pagosNequiRepository;

  PagosNequiService(this.pagosNequiRepository);

  Future<List<PagosNequiModel>> consultarPagosNequi() async =>
      await pagosNequiRepository.consultarPagosNequi();
}
