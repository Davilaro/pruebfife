import 'package:emart/_pideky/domain/delivery_conditions/interface/interface_delivery_conditions_gate_way.dart';
import 'package:emart/_pideky/domain/delivery_conditions/model/condicionEntrega.dart';
import 'package:emart/src/provider/db_provider_helper.dart';

class CondicionEntregaRepositorySqlite extends InterfaceDeliveryConditionsGateWay {
  Future<List<CondicionEntrega>> consultarCondicionEntrega() async {
    final db = await DBProviderHelper.db.baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT fabricante, tipo, hora, nombrecomercial, topeminimo,
      montominimofrecuencia, montominimonoFrecuencia, restrictivofrecuencia, restrictivonofrecuencia, DiaVisita, 
      diasentrega, texto1, texto2, Semana FROM condicionesentrega 
    ''');
      return sql.map((e) => CondicionEntrega.fromJson(e)).toList();
    } catch (e) {
      print('-----Error en consultarCondicionEntrega $e');
      return [];
    }
  }
}
