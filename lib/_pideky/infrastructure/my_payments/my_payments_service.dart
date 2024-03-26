import 'package:emart/_pideky/domain/my_payments/interface/interface_my_payments_gate_way.dart';
import 'package:emart/_pideky/domain/my_payments/model/pagos_nequi_model.dart';

import '../../../src/provider/db_provider_helper.dart';

class MisPagosNequiSqlite extends InterfaceMyPaymentsGateWay {
  @override
  Future<List<MyPaymentsModel>> consultarPagosNequi() async {
    final db = await DBProviderHelper.db.baseAbierta;

    try {
      final sql = await db.rawQuery('''
        SELECT CCUP, celular, fechaPago, valorPago, tipoPago FROM PagosNequi ORDER BY fechaPago ASC
      ''');

      return sql.map((e) => MyPaymentsModel.fromJson(e)).toList();
    } catch (e) {
      print('---algo salio mal al consultar mis pagos nequi $e');
      return [];
    }
  }
}
