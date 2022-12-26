import 'package:emart/lang/messages.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => allKeys();

  Map<String, Map<String, String>> allKeys() {
    Iterable<Map<String, String>> mapFv =
        Messages().keys.values.where((element) => element.isNotEmpty);

    Map<String, String> enMap = {};
    enMap.addAll(mapFv.first);

    Map<String, String> esMap = {};
    esMap.addAll(mapFv.last);

    var map = {'en': enMap, 'es': esMap};
    return map;
  }
}
