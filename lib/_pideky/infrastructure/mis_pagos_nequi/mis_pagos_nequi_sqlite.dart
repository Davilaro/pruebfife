import 'package:emart/_pideky/domain/pagos_nequi/interface/i_mis_pagos_nequi.dart';
import 'package:emart/_pideky/domain/pagos_nequi/model/pagos_nequi_model.dart';

import '../../../src/provider/db_provider_helper.dart';

class MisPagosNequiSqlite extends IMisPagosNequi {
  @override
  Future<List<PagosNequiModel>> consultarPagosNequi() async {
    final db = await DBProviderHelper.db.baseAbierta;

    try {
      final sql = await db.rawQuery("""
  SELECT * from PagosNequi
""");
      print(sql);
      return sql.map((e) => PagosNequiModel.fromJson(e)).toList();
    } catch (e) {
      print("algo salio mal al consultar mis pagos nequi");
      print(e);
      return [];
    }
  }
}
