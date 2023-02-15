import 'package:emart/_pideky/domain/condicion_entrega/interface/I_condicion_entrega_repository.dart';
import 'package:emart/_pideky/domain/condicion_entrega/model/condicionEntrega.dart';
import 'package:emart/src/provider/db_provider_helper.dart';

class CondicionEntregaRepositorySqlite extends ICondicionEntregaRepository {
  Future<List<CondicionEntrega>> consultarCondicionEntrega() async {
    final db = await DBProviderHelper.db.baseAbierta;
    try {
      final sql = await db.rawQuery('''
      SELECT fabricante, tipo, hora, mensaje1, mensaje2, pedidominimo, nombrecomercial, topeminimo, restrictivo, 
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
