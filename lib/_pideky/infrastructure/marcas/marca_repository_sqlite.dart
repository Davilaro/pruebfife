

import 'package:emart/_pideky/domain/marca/interface/i_marca_repository.dart';
import 'package:emart/_pideky/domain/marca/model/marca.dart';
import 'package:emart/src/provider/db_provider_helper.dart';

class MarcaRepositorySqlite extends IMarcaResporsitory {
  @override
  Future<List<Marca>> getAllMarcas() async {

    final db = await DBProviderHelper.db.baseAbierta;

    try {
      final sql = await db.rawQuery('''
      SELECT codigo, descripcion, ico  
      FROM Marca
    ''');

      return sql.isEmpty ? sql.map((e) => Marca.fromJson(e)).toList() : [];
    } catch (e) {
      return [];
    }
  }
  }
  