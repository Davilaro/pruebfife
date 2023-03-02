import 'package:emart/_pideky/domain/condicion_entrega/interface/I_condicion_entrega_repository.dart';
import 'package:emart/_pideky/domain/condicion_entrega/model/condicionEntrega.dart';

class CondicionEntregaService {
  final ICondicionEntregaRepository condicionEntregaRepository;

  CondicionEntregaService(this.condicionEntregaRepository);

  Future<List<CondicionEntrega>> consultarCondicionEntrega() {
    return condicionEntregaRepository.consultarCondicionEntrega();
  }
}
