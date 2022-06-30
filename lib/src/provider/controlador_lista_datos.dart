import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ControllerBanners extends GetxController {
  final storage = GetStorage();
  List<dynamic>? _listaBanner = GetStorage().read('data');
  List<dynamic>? _listaSugueridoHelper = GetStorage().read('Helper');

  List get listaBanners => _listaBanner!;

  set guardarBanners(dynamic datos) {
    storage.write('data', datos);
    this._listaBanner = GetStorage().read('data');
  }

  List get listaSugeridoHelp => _listaSugueridoHelper!;

  set guardarListaSugeridoHelp(dynamic datos) {
    storage.write('Helper', datos);
    this._listaSugueridoHelper = GetStorage().read('Helper');
  }
}
