import 'package:emart/_pideky/domain/condicion_entrega/model/condicionEntrega.dart';

abstract class ICondicionEntregaRepository {
  Future<List<CondicionEntrega>> consultarCondicionEntrega();
}
